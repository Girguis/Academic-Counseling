using ClosedXML.Excel;
using FOS.App.Helpers;
using FOS.Core.Enums;
using FOS.Core.Models;
using FOS.Core.Models.ParametersModels;
using FOS.Core.Models.StoredProcedureOutputModels;
using FOS.DB.Models;

namespace FOS.App.ExcelReader
{
    public static class CourseGradesSheet
    {
        public static Stream CreateSheet(CourseGradesSheetOutModel model, bool isFinalExam)
        {
            var wb = new XLWorkbook();
            wb.Properties.Author = "Girguis";
            var oralMark = GetMark((int)ExamTypeEnum.Oral, model);
            var finalMark = GetMark((int)ExamTypeEnum.Final, model);
            var yearWorkMark = GetMark((int)ExamTypeEnum.YearWork, model);
            var practicalMark = GetMark((int)ExamTypeEnum.Practical, model);
            var groupedStudents = model.Students.GroupBy(x => x.ProgramName);
            for (int groupNo = 0; groupNo < groupedStudents.Count(); groupNo++)
            {
                var students = groupedStudents.ElementAt(groupNo);
                var stdsCount = students.Count();
                var sheetName = students.Key.Length >= 31 ? students.Key.Substring(0, 30) : students.Key;
                wb.Worksheets.Add(sheetName);
                wb.TryGetWorksheet(sheetName, out var ws);
                ws.SetRightToLeft();
                ws.Cell("A1").Value = "الكود الأكاديمى";
                ws.Cell("B1").Value = "الاسم";
                ws.Cell("C1").Value = "المستوى";
                if (isFinalExam)
                    ws.Cell("D1").Value = "الدرجة(" + finalMark + ")";
                else
                {
                    ws.Cell("D1").Value = "الشفهي(" + oralMark + ")";
                    ws.Cell("E1").Value = "الأعمال الفصلية(" + yearWorkMark + ")";
                    ws.Cell("F1").Value = "العملى(" + practicalMark + ")";
                    ws.Cell("G1").Value = "المجموع";
                }
                for (int i = 0; i < stdsCount; i++)
                {
                    var index = i + 2;
                    var student = students.ElementAt(i);
                    ws.Cell("A" + index).Value = student.AcademicCode;
                    ws.Cell("B" + index).Value = student.Name;
                    ws.Cell("C" + index).Value = student.Level;
                    if (isFinalExam)
                        ws.Cell("D" + (i + 2)).Value = student.Final;
                    else
                    {
                        ws.Cell("D" + index).Value = student.Oral;
                        ws.Cell("E" + index).Value = student.YearWork;
                        ws.Cell("F" + index).Value = student.Practical;
                        ws.Cell("G" + index).FormulaA1 = "=SUM(D" + index + ":F" + index + ")";
                    }
                }
                IXLRange range;
                if (stdsCount < 1)
                {
                    ws.Range("A2:E2").Merge();
                    ws.Cell("A2").Value = "لا يوجد طلاب مسجلين فى هذا المقرر";
                    ws.Style.Font.SetBold(true);
                    ws.Style.Font.FontSize = 16;
                    ws.Style.Font.FontName = "Calibri";
                    range = ws.Range(1, 1, 1, 5);
                }
                else
                {
                    range = ws.Range(1, 1, students.Count() + 1, isFinalExam ? 4 : 7);
                    if (isFinalExam)
                    {
                        ws.Range("D2:D" + (stdsCount + 1)).Style.Protection.SetLocked(false);
                        ws.Range("D2:D" + stdsCount + 1).CreateDataValidation().WholeNumber.Between(0, finalMark);
                        ws.CheckAndHideCol(ExamTypeEnum.Final, "D", model);
                    }
                    else
                    {
                        ws.Range("D2:F" + (stdsCount + 1)).Style.Protection.SetLocked(false);
                        ws.Range("D2:D" + stdsCount + 1).CreateDataValidation().WholeNumber.Between(0, oralMark);
                        ws.Range("E2:E" + stdsCount + 1).CreateDataValidation().WholeNumber.Between(0, yearWorkMark);
                        ws.Range("F2:F" + stdsCount + 1).CreateDataValidation().WholeNumber.Between(0, practicalMark);
                        ws.CheckAndHideCol(ExamTypeEnum.Oral, "D", model);
                        ws.CheckAndHideCol(ExamTypeEnum.YearWork, "E", model);
                        ws.CheckAndHideCol(ExamTypeEnum.Practical, "F", model);
                    }
                }
                ws.Range("H2", "N17").Merge();
                ws.Cell("H2").Value = model.Course.CourseName + Environment.NewLine +
                    "(" + model.Course.CourseCode + ")" + Environment.NewLine +
                    string.Concat(model.YearModel.Year, " - ", Helper.GetDescription((SemesterEnum)model.YearModel.Semester))
                    + Environment.NewLine + "كشف : " + Helper.GetDescription(isFinalExam ? ExamTypeEnum.Final : ExamTypeEnum.YearWork)
                    + Environment.NewLine + groupedStudents.ElementAt(groupNo).Key;
                ws.Cell("H2").Style.Font.FontSize = 26;
                ws.Cell("H2").Style.Font.FontName = "Calibri";
                ws.Cell("H2").Style.Font.SetBold();
                ws.Cell("H2").Style.Fill.BackgroundColor = XLColor.AntiFlashWhite;
                ExcelCommon.CreateTable(ws, range);
            }
            return ExcelCommon.SaveAsStream(wb);
        }
        public static (byte[] fileContent, string fileName)
            CreateMultipleSheets(List<CourseGradesSheetOutModel> courses, bool isFinalExam)
        {
            var examType = isFinalExam ? "FinalGrades" : "YearWorkGrades";
            var (path, folderName, subFolderName) =
                Helper.CreateDirectory("ExcelFiles", "CoursesSheets_" + examType);
            Parallel.For(0, courses.Count, i =>
            {
                var stream = CreateSheet(courses.ElementAt(i), isFinalExam);
                var filePath = path + "/" + courses.ElementAt(i).Course.CourseCode + "_" + examType + ".xlsx";
                Helper.SaveStreamAsFile(stream, filePath);
            });
            var fileContent = Helper.CreateZipFile(path, folderName, subFolderName);
            return (fileContent, subFolderName);
        }
        private static void CheckAndHideCol
            (this IXLWorksheet ws, ExamTypeEnum examType,
            string colChar, CourseGradesSheetOutModel model)
        {
            if (GetMark((int)examType, model) < 1)
                ws.Column(colChar).Hide();
        }
        private static byte GetMark(int examType, CourseGradesSheetOutModel model)
        {
            if (examType == (int)ExamTypeEnum.Final)
                return model.Course.Final;
            if (examType == (int)ExamTypeEnum.Practical)
                return model.Course.Practical;
            if (examType == (int)ExamTypeEnum.YearWork)
                return model.Course.YearWork;
            return model.Course.Oral;
        }
        public static List<GradesSheetUpdateModel> ReadGradesSheet
            (IXLWorkbook wb, short yearID, int courseID, bool isFinalExam)
        {
            List<GradesSheetUpdateModel> model = new();
            for (int wsIndex = 0; wsIndex < wb.Worksheets.Count; wsIndex++)
            {
                var ws = wb.Worksheets.ElementAt(wsIndex);
                int rowsCount = ws.Rows().Count();
                bool converted = ws.Cell("A2").Value.TryConvert(out double val, System.Globalization.CultureInfo.CurrentCulture);
                if (!converted)
                    return null;
                if (isFinalExam)
                    for (int i = 2; i <= rowsCount; i++)
                    {
                        var academicCode = ws.Cell("A" + i).Value.ToString();
                        if (!string.IsNullOrEmpty(academicCode))
                            model.Add(new GradesSheetUpdateModel
                            {
                                CourseID = courseID,
                                AcademicYearID = yearID,
                                AcademicCode = academicCode,
                                Final = ws.IsEmptyCell("D" + i) ? null : ws.GetCellValueAsByte("D" + i)
                            });
                    }
                else
                    for (int i = 2; i <= rowsCount; i++)
                    {
                        var academicCode = ws.Cell("A" + i).Value.ToString();
                        if (!string.IsNullOrEmpty(academicCode))
                            model.Add(new GradesSheetUpdateModel
                            {
                                CourseID = courseID,
                                AcademicYearID = yearID,
                                AcademicCode = academicCode,
                                Oral = ws.IsEmptyCell("D" + i) ? null : ws.GetCellValueAsByte("D" + i),
                                YearWork = ws.IsEmptyCell("E" + i) ? null : ws.GetCellValueAsByte("E" + i),
                                Practical = ws.IsEmptyCell("F" + i) ? null : ws.GetCellValueAsByte("F" + i)
                            });
                    }
            }
            return model;
        }
        public static (List<GradesSheetUpdateModel> outModel, List<string> errors)
            ReadMultipleGradesSheet(MultipleCourseExamSheetUploadModel model,
                                                        short yearID, List<Course> courses)
        {
            var outModel = new List<GradesSheetUpdateModel>();
            List<string> errorFiles = new List<string>();
            for (int i = 0; i < model.Files.Count; i++)
            {
                try
                {
                    MemoryStream ms = new MemoryStream();
                    model.Files.ElementAt(i).OpenReadStream().CopyTo(ms);
                    var wb = new XLWorkbook(ms);
                    ms.Close();
                    wb.TryGetWorksheet(wb.Worksheets.ElementAt(0).Name, out var ws);
                    var H2Text = ws.Cell("H2").Value.ToString();
                    var courseCode = H2Text.Split("\n")[1].Trim();
                    courseCode = courseCode.Substring(1, courseCode.Length - 2);
                    var course = courses.FirstOrDefault(x => x.CourseCode == courseCode);
                    var splitedH2 = H2Text.Split(':');
                    var examType = splitedH2[^1].Split("\n")[0].Trim();
                    if ((examType == Helper.GetDescription(ExamTypeEnum.Final) && !model.IsFinalExam) ||
                        (examType == Helper.GetDescription(ExamTypeEnum.YearWork) && model.IsFinalExam))
                        errorFiles.Add(model.Files[i].FileName);
                    else
                        outModel.AddRange(ReadGradesSheet(wb, yearID, course.Id, model.IsFinalExam));
                }
                catch
                {
                    errorFiles.Add(model.Files[i].FileName);
                }
            }
            return (outModel, errorFiles);
        }
    }
}