using ClosedXML.Excel;
using FOS.App.Helpers;
using FOS.Core.Enums;
using FOS.Core.Models.ParametersModels;
using FOS.Core.Models.StoredProcedureOutputModels;

namespace FOS.App.ExcelReader
{
    public class StudentsByCgpaReport
    {
        public static Stream Create(GetReportByCgpaParamModel model, List<GetReportByCgpaOutModel> students)
        {
            var wb = new XLWorkbook();
            wb.Properties.Author = "Girguis";
            var groupedStudents = students.GroupBy(x => x.ProgramName);
            Parallel.For(0, groupedStudents.Count(), i =>
            {
                var studentGroup = groupedStudents.ElementAt(i);
                var sheetName = studentGroup.Key.Length > 30? studentGroup.Key[..30]:studentGroup.Key;
                var ws = wb.Worksheets.Add(sheetName);
                ws.SetRightToLeft();
                string startCell = "", endCell = "";
                if (model.IsGraduated)
                {
                    ws.Cell("A1").Value = "الكود الإكاديمى";
                    ws.Cell("B1").Value = "الاسم";
                    ws.Cell("C1").Value = "رقم الهاتف";
                    ws.Cell("D1").Value = "المعدل التراكمى";
                    ws.Cell("E1").Value = "سنة الإلتحاق بالكلية";
                    ws.Cell("F1").Value = "سنة التخرج";
                    for (int j = 0; j < studentGroup.Count(); j++)
                    {
                        var student = studentGroup.ElementAt(j);
                        ws.Cell("A" + (j + 2)).Value = student.AcademicCode;
                        ws.Cell("B" + (j + 2)).Value = student.Name;
                        ws.Cell("C" + (j + 2)).Value = student.PhoneNumber;
                        ws.Cell("D" + (j + 2)).Value = student.Cgpa;
                        ws.Cell("E" + (j + 2)).Value = student.EnrollYear;
                        ws.Cell("F" + (j + 2)).Value = string.Concat(student.GraduationYear, " - ", Helper.GetDescription((SemesterEnum)student.GraduationSemester));
                    }
                    ExcelCommon.CreateTable(ws, ws.Range(1, 1, studentGroup.Count() + 1, 6));
                    startCell = "G2";
                    endCell = "M12";
                }
                else
                {
                    ws.Cell("A1").Value = "الكود الإكاديمى";
                    ws.Cell("B1").Value = "الاسم";
                    ws.Cell("C1").Value = "رقم الهاتف";
                    ws.Cell("D1").Value = "المعدل التراكمى";
                    ws.Cell("E1").Value = "المستوى";
                    ws.Cell("F1").Value = "ساعات النجاح";
                    ws.Cell("G1").Value = "سنة الإلتحاق بالكلية";
                    for (int j = 0; j < studentGroup.Count(); j++)
                    {
                        var student = studentGroup.ElementAt(j);
                        ws.Cell("A" + (j + 2)).Value = student.AcademicCode;
                        ws.Cell("B" + (j + 2)).Value = student.Name;
                        ws.Cell("C" + (j + 2)).Value = student.PhoneNumber;
                        ws.Cell("D" + (j + 2)).Value = student.Cgpa;
                        ws.Cell("E" + (j + 2)).Value = student.Level;
                        ws.Cell("F" + (j + 2)).Value = student.PassedHours;
                        ws.Cell("G" + (j + 2)).Value = student.EnrollYear;
                    }
                    ExcelCommon.CreateTable(ws, ws.Range(1, 1, studentGroup.Count() + 1, 7));
                    startCell = "H2";
                    endCell = "N12";
                }
                if (students.Count > 0)
                {
                    ws.Range(startCell, endCell).Merge();
                    if (model.IsGraduated)
                        ws.Cell(startCell).Value = "الطلاب خريجين عام" +
                            Environment.NewLine +
                            string.Join(Environment.NewLine, students.Select(x => x.GraduationYear).Distinct()) +
                            Environment.NewLine +
                            studentGroup.Key +
                            Environment.NewLine +
                            "معدل تراكمى من " + (model.FromCgpa ?? 0) +
                            "الى " + (model.ToCgpa ?? 4);
                    else
                        ws.Cell(startCell).Value = studentGroup.Key +
                        Environment.NewLine + "معدل تراكمى من " + (model.FromCgpa ?? 0) +
                            "الى " + (model.ToCgpa ?? 4);
                    ws.Cell(startCell).Style.Font.FontSize = 26;
                    ws.Cell(startCell).Style.Font.FontName = "Calibri";
                    ws.Cell(startCell).Style.Font.SetBold();
                    ws.Cell(startCell).Style.Fill.BackgroundColor = XLColor.AntiFlashWhite;
                }
                else
                {
                    ws.Range(startCell, endCell).Merge();
                    ws.Cell(startCell).Value = "لا يوجد طلاب";
                }
            });
            return ExcelCommon.SaveAsStream(wb);
        }
    }
}
