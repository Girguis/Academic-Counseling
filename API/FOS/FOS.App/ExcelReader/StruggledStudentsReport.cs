﻿using ClosedXML.Excel;
using FOS.Core.Models.StoredProcedureOutputModels;

namespace FOS.App.ExcelReader
{
    public class StruggledStudentsReport
    {
        public static Stream Create(List<StruggledStudentsOutModel> students)
        {
            var wb = new XLWorkbook();
            wb.Properties.Author = "Girguis";
            var groupedStudents = students.GroupBy(x => x.ProgramName);
            Parallel.For(0, groupedStudents.Count(), i =>
            {
                var studentGroup = groupedStudents.ElementAt(i);
                var sheetName = studentGroup.Key.Length >= 31 ? studentGroup.Key.Substring(0, 30) : studentGroup.Key;
                var ws = wb.Worksheets.Add(sheetName);
                ws.SetRightToLeft();
                ws.Cell("A1").Value = "الكود الأكاديمى";
                ws.Cell("B1").Value = "الاسم";
                ws.Cell("C1").Value = "رقم الهاتف";
                ws.Cell("D1").Value = "ساعات الإعادة المتاحة";
                ws.Cell("E1").Value = "الإنذارات";
                ws.Cell("F1").Value = "المعدل التراكمى";
                ws.Cell("G1").Value = "المستوى";
                ws.Cell("H1").Value = "ساعات النجاح";
                ws.Cell("I1").Value = "البرنامج";
                for (int j = 0; j < studentGroup.Count(); j++)
                {
                    var student = studentGroup.ElementAt(j);
                    ws.Cell("A" + (j + 2)).Value = student.AcademicCode;
                    ws.Cell("B" + (j + 2)).Value = student.Name;
                    ws.Cell("C" + (j + 2)).Value = student.PhoneNumber;
                    ws.Cell("D" + (j + 2)).Value = student.AvailableCredits;
                    ws.Cell("E" + (j + 2)).Value = student.WarningsNumber;
                    ws.Cell("F" + (j + 2)).Value = student.CGPA;
                    ws.Cell("G" + (j + 2)).Value = student.Level;
                    ws.Cell("H" + (j + 2)).Value = student.PassedHours;
                    ws.Cell("I" + (j + 2)).Value = student.ProgramName;
                }
                var range = ws.Range(1, 1, studentGroup.Count() + 1, 9);
                ExcelCommon.CreateTable(ws, range);
            });
            return ExcelCommon.SaveAsStream(wb);
        }
    }
}
