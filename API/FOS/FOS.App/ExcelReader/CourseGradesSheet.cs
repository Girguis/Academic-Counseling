﻿using ClosedXML.Excel;
using DocumentFormat.OpenXml.Spreadsheet;
using FOS.Core.Models;
using FOS.DB.Models;

namespace FOS.App.ExcelReader
{
    public static class CourseGradesSheet
    {
        public static MemoryStream CreateSheet(List<StudentCourse> studentsList, Course course,string academicYear)
        {
            var wb = new XLWorkbook();
            wb.Properties.Author = "Girguis";
            var ws = wb.Worksheets.Add(course.CourseCode);
            ws.SetRightToLeft();
            var stdsCount = studentsList.Count;
            ws.Cell("A1").Value = "الكود الاكاديمى";
            ws.Cell("B1").Value = "الاسم";
            ws.Cell("C1").Value = "البرنامج";
            ws.Cell("D1").Value = "المستوى";
            ws.Cell("E1").Value = "الدرجة";
            for (int i = 0; i < stdsCount; i++)
            {
                var student = studentsList.ElementAt(i).Student;
                ws.Cell("A" + (i + 2)).Value = student.AcademicCode;
                ws.Cell("B" + (i + 2)).Value = student.Name;
                ws.Cell("C" + (i + 2)).Value = student.CurrentProgram.ArabicName;
                ws.Cell("D" + (i + 2)).Value = student.Level;
                ws.Cell("E" + (i + 2)).Value = studentsList.ElementAt(i).Mark;
            }
            var range = ws.Range(1, 1, studentsList.Count() + 1, 5);
            var table = range.CreateTable();
            table.Theme = XLTableTheme.TableStyleMedium16;
            table.Style.Font.FontSize = 14;
            table.Style.Font.FontName = "Calibri";
            table.HeadersRow().Style.Font.Bold = true;
            table.HeadersRow().Style.Font.FontSize = 16;
            ws.Range("G2", "N12").Merge();
            ws.Cell("G2").Value = (course.CourseName + Environment.NewLine + course.CourseCode + Environment.NewLine + academicYear);
            ws.Cell("G2").Style.Font.FontSize = 30;
            ws.Cell("G2").Style.Font.FontName = "Calibri";
            ws.Cell("G2").Style.Font.SetBold();
            ws.Cell("G2").Style.Fill.BackgroundColor = XLColor.AntiFlashWhite;
            ws.Style.Alignment.SetHorizontal(XLAlignmentHorizontalValues.Center);
            ws.Style.Alignment.SetVertical(XLAlignmentVerticalValues.Center);
            ws.Range(1, 1, ws.LastRow().RangeAddress.RowSpan, ws.LastColumn().RangeAddress.ColumnSpan).Style.Protection.SetLocked(true);
            ws.Range("E2:E" + (stdsCount + 1)).Style.Protection.SetLocked(false);
            ws.Range("E2:E" + stdsCount + 1).CreateDataValidation().WholeNumber.Between(0, course.CreditHours * 50);
            ws.Protect("G2001G", XLProtectionAlgorithm.Algorithm.SHA512,
                XLSheetProtectionElements.SelectUnlockedCells
                | XLSheetProtectionElements.AutoFilter
                | XLSheetProtectionElements.SelectLockedCells
                | XLSheetProtectionElements.Sort
                );
            ws.Columns().AdjustToContents();
            var stream = new MemoryStream();
            wb.SaveAs(stream);
            stream.Seek(0, SeekOrigin.Begin);
            return stream;
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
