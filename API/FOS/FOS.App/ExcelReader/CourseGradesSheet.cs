using ClosedXML.Excel;
using FOS.App.Helpers;
using FOS.Core.Enums;
using FOS.Core.Models;
using FOS.Core.Models.StoredProcedureOutputModels;

namespace FOS.App.ExcelReader
{
    public static class CourseGradesSheet
    {
        public static Stream CreateSheet(CourseGradesSheetOutModel model)
        {
            var wb = new XLWorkbook();
            wb.Properties.Author = "Girguis";
            var ws = wb.Worksheets.Add(model.Course.CourseCode);
            ws.SetRightToLeft();
            var stdsCount = model.Students.Count;
            ws.Cell("A1").Value = "الكود الأكاديمى";
            ws.Cell("B1").Value = "الاسم";
            ws.Cell("C1").Value = "البرنامج";
            ws.Cell("D1").Value = "المستوى";
            ws.Cell("E1").Value = "الدرجة";
            for (int i = 0; i < stdsCount; i++)
            {
                var student = model.Students.ElementAt(i);
                ws.Cell("A" + (i + 2)).Value = student.AcademicCode;
                ws.Cell("B" + (i + 2)).Value = student.Name;
                ws.Cell("C" + (i + 2)).Value = student.ProgramName;
                ws.Cell("D" + (i + 2)).Value = student.Level;
                ws.Cell("E" + (i + 2)).Value = student.Mark;
            }
            var range = ws.Range(1, 1, model.Students.Count + 1, 5);
            ws.Range("E2:E" + (stdsCount + 1)).Style.Protection.SetLocked(false);
            ws.Range("E2:E" + stdsCount + 1).CreateDataValidation().WholeNumber.Between(0, model.Course.CreditHours * 50);
            ws.Range("G2", "N12").Merge();
            ws.Cell("G2").Value = model.Course.CourseName + Environment.NewLine + model.Course.CourseCode + Environment.NewLine + string.Concat(model.YearModel.Year, " - ", Helper.GetEnumDescription((SemesterEnum)model.YearModel.Semester));
            ws.Cell("G2").Style.Font.FontSize = 26;
            ws.Cell("G2").Style.Font.FontName = "Calibri";
            ws.Cell("G2").Style.Font.SetBold();
            ws.Cell("G2").Style.Fill.BackgroundColor = XLColor.AntiFlashWhite;
            ExcelCommon.CreateTable(ws, range);
            return ExcelCommon.SaveAsStream(wb);
        }
        public static List<GradesSheetUpdateModel> ReadGradesSheet(IXLWorksheet ws, short yearID, int courseID)
        {
            int rowsCount = ws.Rows().Count();
            List<GradesSheetUpdateModel> model = new List<GradesSheetUpdateModel>();
            for (int i = 2; i <= rowsCount; i++)
            {
                byte? mark = null;
                if (ws.Cell("E" + i).Value.ToString().Trim().Length > 0)
                    mark = byte.Parse(ws.Cell("E" + i).Value.ToString());
                var academicCode = ws.Cell("A" + i).Value.ToString();
                if (!string.IsNullOrEmpty(academicCode))
                    model.Add(new GradesSheetUpdateModel
                    {
                        CourseID = courseID,
                        AcademicYearID = yearID,
                        Mark = mark,
                        AcademicCode = academicCode
                    });
            }
            return model;
        }
    }
}
