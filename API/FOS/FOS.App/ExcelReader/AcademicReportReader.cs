using ClosedXML.Excel;
using FOS.App.Helpers;
using FOS.Core.Enums;
using FOS.Core.IRepositories;
using FOS.Core.Models;
using FOS.Core.Models.ParametersModels;
using FOS.DB.Models;
using Microsoft.AspNetCore.Http;

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
    }
}
