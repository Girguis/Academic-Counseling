using ClosedXML.Excel;
using FOS.App.Helpers;
using FOS.App.Students.DTOs;
using FOS.Core.Enums;
using FOS.Core.IRepositories;
using FOS.Core.Models;
using FOS.Core.Models.ParametersModels;
using FOS.Core.Models.StoredProcedureOutputModels;
using FOS.Core.StudentDTOs;
using FOS.DB.Models;
using Microsoft.AspNetCore.Http;
using System.IO.Compression;

namespace FOS.App.ExcelReader
{
    public static class AcademicReportReader
    {
        public static (string name, string ssn, int seatNumber,
            List<StudentCourse> studentCourses, List<StudentProgramModel> studentPrograms
            , int studentID, byte semesterCounter)
            Read
            (IFormFile file,
            IStudentRepo studentRepo,
            List<AcademicYear> academicYearsLst,
            List<ProgramBasicDataDTO> programsLst,
            List<Course> coursesLst)
        {
            MemoryStream ms = new MemoryStream();
            file.OpenReadStream().CopyTo(ms);
            var wb = new XLWorkbook(ms);
            ms.Close();
            var ws = wb.Worksheet(1);
            List<StudentCourse> studentCourses = new List<StudentCourse>();
            List<StudentProgramModel> studentPrograms = new List<StudentProgramModel>();
            int rowsCount = ws.Rows().Count();
            var name = ws.Cell("Q9").Value.ToString();
            var ssn = ws.Cell("E12").Value.ToString();
            var seatparsed = int.TryParse(ws.Cell("E9").Value.ToString(), out int seatNumber);
            if (!seatparsed) seatNumber = 0;
            short currentYearID = 1;
            int currentProgramID;
            byte semesterCounter = 0;
            string currentAcademicYearStr = "";
            var std = studentRepo.GetBySSN(ssn);
            int studentID = -1;
            if (std != null)
                studentID = std.Id;
            for (int i = 21; i <= rowsCount; i++)
            {
                if (!ws.Cell("C" + i).IsEmpty()
                    && ws.Cell("C" + i).Value.ToString().Trim().Length > 1
                    && ws.Cell("U" + i).IsEmpty())
                {
                    string cellVal = ws.Cell("C" + i).Value.ToString();
                    var cellValues = cellVal.Split('-');
                    int count = cellValues.Count();
                    if (count == 4)
                    {
                        currentAcademicYearStr = cellValues[1].Trim() + "/" + cellValues[2].Trim();
                        var ProgramNameStr = cellValues[3].Trim();
                        var semesterStr = ws.Cell("C" + (i + 2)).Value.ToString().Split('-')[0].Trim();
                        byte semesterNo = Helper.GetSemesterNumber(semesterStr);
                        if (semesterNo != (int)SemesterEnum.Summer)
                            semesterCounter++;
                        currentYearID = academicYearsLst.FirstOrDefault(x => x.AcademicYear1 == currentAcademicYearStr && x.Semester == semesterNo).Id;
                        currentProgramID = programsLst.Where(x => x.ArabicName == ProgramNameStr && x.Semester <= semesterCounter)
                                            .OrderByDescending(x => x.Semester).FirstOrDefault().Id;
                        if (!studentPrograms.Any(x => x.ProgramId == currentProgramID))
                            studentPrograms.Add(new StudentProgramModel
                            {
                                StudentId = -1,
                                ProgramId = currentProgramID,
                                AcademicYear = currentYearID,
                                AcademicYearName = academicYearsLst.FirstOrDefault(x => x.Id == currentYearID)?.AcademicYear1,
                                ProgramName = programsLst.FirstOrDefault(x => x.Id == currentProgramID)?.Name
                            });
                        i += 4;
                    }
                    else if (count == 2)
                    {
                        var semesterStr = ws.Cell("C" + i).Value.ToString().Split('-')[0].Trim();
                        var semesterNo = Helper.GetSemesterNumber(semesterStr);
                        if (semesterNo != (int)SemesterEnum.Summer)
                            semesterCounter++;
                        currentYearID = academicYearsLst.FirstOrDefault(x => x.AcademicYear1 == currentAcademicYearStr && x.Semester == semesterNo).Id;
                        i += 2;
                    }
                }
                else if (!ws.Cell("U" + i).IsEmpty())
                {
                    StudentCourse course = new StudentCourse();
                    course.AcademicYearId = currentYearID;
                    course.StudentId = studentID;
                    var courseCode = ws.Cell("U" + i).Value.ToString();
                    var courseObj = coursesLst.FirstOrDefault(x => x.CourseCode.Replace(" ", "") == courseCode.Replace(" ", ""));
                    course.CourseId = courseObj.Id;
                    if (ws.Cell("O" + i).IsEmpty())
                    {
                        course.HasExcuse = true;
                        course.Mark = null;
                        course.IsGpaincluded = false;
                    }
                    else
                    {
                        course.HasExcuse = false;
                        if (ws.Cell("S" + i).Value.ToString().Contains("-**"))
                        {
                            course.IsGpaincluded = false;
                            course.Grade = ws.Cell("R" + i).Value.ToString().Trim();
                            course.Mark = null;
                        }
                        else if (ws.Cell("S" + i).Value.ToString().Contains("-"))
                        {
                            course.IsGpaincluded = false;
                            course.Grade = ws.Cell("R" + i).Value.ToString().Trim();
                            course.Mark = (byte)Math.Ceiling(ws.Cell("O" + i).Value.GetNumber());
                        }
                        else
                        {
                            course.IsGpaincluded = true;
                            course.Mark = (byte)Math.Ceiling(ws.Cell("O" + i).Value.GetNumber());
                        }
                    }
                    course.Course = courseObj;
                    course.IsApproved = true;
                    studentCourses.Add(course);
                }
            }
            return (name, ssn, seatNumber, studentCourses, studentPrograms, studentID, semesterCounter);
        }
        public static Stream Create(AcademicReportOutModel model)
        {
            var student = model.Student;
            var academicYears = model.AcademicYears;
            var courses = model.Courses;
            var wb = new XLWorkbook() { RightToLeft = true, PageOptions = { PageOrientation = XLPageOrientation.Landscape, PaperSize = XLPaperSize.A3Paper } };
            var ws = wb.InitSheet("Report");
            ws.Range("G1:H1").Merge();
            ws.AddPicture(ExcelCommon.GetFacultyLogoAsStream()).MoveTo(ws.Cell("A1")).WithSize(85, 85);
            ws.AddPicture(ExcelCommon.GetUnivLogoAsStream()).MoveTo(ws.Cell("G1")).WithSize(85, 85);
            ws.Range("B1:F1").Merge().Value = "كلية العلوم" + Environment.NewLine +
                                              "جامعة عين شمس" + Environment.NewLine + "بيان درجات";
            ws.Row(1).Height = 66;
            ws.HorizontalLine("A1:H1");
            ws.Cell("A2").Value = "الطالب";
            ws.Range("B2:C2").Merge().Value = student.Name;
            ws.Cell("E2").Value = "الكود الأكاديمى";
            ws.Range("F2:G2").Merge().Value = student.AcademicCode;
            ws.Cell("A3").Value = "البرنامج";
            ws.Range("B3:C3").Merge().Value = academicYears.LastOrDefault()?.ProgramName;
            ws.Cell("E3").Value = "الرقم القومى";
            ws.Range("F3:G3").Merge().Value = student.SSN;
            ws.Range("A1:F3").Style.Font.SetFontSize(16).Alignment.Vertical = XLAlignmentVerticalValues.Center;
            ws.Range("A1:F3").Style.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;
            ws.HorizontalLine("A3:H3");
            ws.SheetView.FreezeRows(3);
            var groupedCourses = courses.GroupBy(x => x.AcademicYearID).OrderBy(x => x.Key);
            int rowNo = 4;
            for (int counter = 0; counter < academicYears.Count(); counter++)
            {
                var semesterCourses = groupedCourses.ElementAt(counter);
                ws.Range("A" + rowNo + ":H" + rowNo).Merge();
                ws.Cell("A" + rowNo).Value = Helper.GetDescription((SemesterEnum)academicYears.ElementAt(counter).Semester) + " - " +
                academicYears.ElementAt(counter).AcademicYear + " - " + academicYears.ElementAt(counter).ProgramName;
                ws.Cell("A" + rowNo).Style.Font.SetFontSize(16).Fill.SetBackgroundColor(XLColor.BlueGray);
                rowNo++;
                var startRow = rowNo;
                ws.Cell("A" + rowNo).Value = "كود المقرر";
                ws.Cell("B" + rowNo).Value = "اسم المقرر";
                ws.Cell("C" + rowNo).Value = "التقدير";
                ws.Cell("D" + rowNo).Value = "الدرجة";
                ws.Cell("E" + rowNo).Value = "عدد الساعات";
                ws.Cell("F" + rowNo).Value = "معدل النقاط";
                ws.Cell("G" + rowNo).Value = "إعادة؟";
                ws.Cell("H" + rowNo).Value = "عذر";
                for (var j = 0; j < semesterCourses.Count(); j++)
                {
                    rowNo++;
                    ws.Cell("A" + rowNo).Value = semesterCourses.ElementAt(j).CourseCode;
                    ws.Cell("B" + rowNo).Value = (semesterCourses.ElementAt(j).IsGpaIncluded ? "" : "-") + semesterCourses.ElementAt(j).CourseName;
                    ws.Cell("C" + rowNo).Value = semesterCourses.ElementAt(j).Grade;
                    ws.Cell("D" + rowNo).Value = semesterCourses.ElementAt(j).Mark;
                    ws.Cell("E" + rowNo).Value = semesterCourses.ElementAt(j).CreditHours;
                    ws.Cell("F" + rowNo).Value = semesterCourses.ElementAt(j).Points;
                    ws.Cell("F" + rowNo).Style.NumberFormat.Format = "#,##0.00";
                    ws.Cell("G" + rowNo).Value = semesterCourses.ElementAt(j).CourseEntringNumber > 1 ? "نعم" : "لا";
                    ws.Cell("H" + rowNo).Value = semesterCourses.ElementAt(j).HasExcuse ? "نعم" : "لا";
                }
                rowNo++;
                ExcelCommon.CreateTable(ws, ws.Range("A" + startRow + ":H" + (rowNo - 1)), false);
                ws.Range("A" + rowNo + ":H" + rowNo)
                    .Style.Font.SetFontSize(16)
                    .Fill.SetBackgroundColor(XLColor.BlueGray);
                ws.Range("A" + rowNo + ":B" + rowNo).Merge().Value = "المعدل الفصلى";
                ws.Cell("C" + rowNo).Value = academicYears.ElementAt(counter).SGPA;
                ws.Range("D" + rowNo + ":E" + rowNo).Merge().Value = "المعدل التراكمى";
                ws.Cell("F" + rowNo).Value = academicYears.ElementAt(counter).CGPA;
                ws.HorizontalLine("A" + rowNo + ":H" + rowNo);
                rowNo++;
            }
            return ExcelCommon.SaveAsStream(wb);
        }

        public static (byte[] bytes,string fileName) CreateMultiple(string ProgramName,IEnumerable<AcademicReportOutModel> models)
        {
            var folderName = "AcademicReprotsExcels_" + ProgramName + "_" + DateTime.Now.Ticks;
            var path = Directory.GetCurrentDirectory();
            path = path.Replace("\\", "/");
            path = path + "/ExcelFiles/" + folderName;
            if (!Directory.Exists(path))
            {
                Directory.CreateDirectory(path);
            }
            Parallel.For(0, models.Count(), i =>
            {
                var stream = Create(models.ElementAt(i));
                var filePath = path + "/" + models.ElementAt(i).Student.Name + "_"
                    + models.ElementAt(i).Student.AcademicCode + ".xlsx";
                using FileStream file = new(filePath, FileMode.Create, FileAccess.Write);
                byte[] bytes = new byte[stream.Length];
                stream.Read(bytes, 0, (int)stream.Length);
                file.Write(bytes, 0, bytes.Length);
                stream.Close();
                file.Close();
            });
            var zipFileName = folderName + ".zip";
            ZipFile.CreateFromDirectory(path, "ExcelFiles/" + zipFileName, CompressionLevel.Optimal, true);
            Directory.Delete(path, true);
            byte[] fileContent = File.ReadAllBytes("ExcelFiles/" + zipFileName);
            return (fileContent, folderName);
        }
    }
}