using ClosedXML.Excel;
using FOS.App.PDFCreators;

namespace FOS.App.ExcelReader
{
    public static class ExcelCommon
    {
        public static void HorizontalLine(this IXLWorksheet ws, string rangeAddress)
        {
            ws.Range(rangeAddress).Style.Border.BottomBorder = XLBorderStyleValues.Medium;
        }
        public static byte GetCellValueAsByte(this IXLWorksheet ws, string cellAddress, byte defaultValue = 0)
        {
            if (!byte.TryParse(ws.Cell(cellAddress).Value.ToString(), out byte cellValue))
                return defaultValue;
            return cellValue;
        }
        public static void SetFont(this IXLWorksheet ws, int size)
        {
            ws.Style.Font.FontSize = size;
            ws.Style.Font.FontName = "calibri";
        }
        public static void CreateTable(IXLWorksheet ws, IXLRange range, bool locktable = true)
        {
            var table = range.CreateTable();
            table.Theme = XLTableTheme.TableStyleMedium16;
            table.Style.Font.FontSize = 14;
            table.Style.Font.FontName = "Calibri";
            table.HeadersRow().Style.Font.Bold = true;
            table.HeadersRow().Style.Font.FontSize = 16;
            ws.Style.Alignment.SetHorizontal(XLAlignmentHorizontalValues.Center);
            ws.Style.Alignment.SetVertical(XLAlignmentVerticalValues.Center);
            if (locktable)
                ws.LockRange(1, 1, ws.LastRow().RangeAddress.RowSpan, ws.LastColumn().RangeAddress.ColumnSpan);
            ws.Columns().AdjustToContents();
        }
        public static void LockRange(this IXLWorksheet ws, int firstCellRow, int firstCellColumn, int lastCellRow, int lastCellColumn)
        {
            ws.Range(firstCellRow, firstCellColumn, lastCellRow, lastCellColumn).Style.Protection.SetLocked(true);
            ws.Protect("G2001G", XLProtectionAlgorithm.Algorithm.SHA512,
                XLSheetProtectionElements.SelectUnlockedCells
                | XLSheetProtectionElements.AutoFilter
                | XLSheetProtectionElements.SelectLockedCells
                | XLSheetProtectionElements.Sort
                );
        }
        public static Stream SaveAsStream(IXLWorkbook wb)
        {
            var stream = new MemoryStream();
            wb.SaveAs(stream);
            stream.Seek(0, SeekOrigin.Begin);
            return stream;
        }
        public static void SetRangeColor(IXLWorksheet ws, string range, XLColor color)
        {
            ws.Range(range).Style.Fill.BackgroundColor = color;
        }
        public static void SetCellColor(IXLWorksheet ws, string cell, XLColor color)
        {
            ws.Cell(cell).Style.Fill.BackgroundColor = color;
        }
        public static bool IsEmptyCell(this IXLWorksheet ws, string cellAddress)
        {
            return ws.Cell(cellAddress).Value.ToString().Trim().Length < 1;
        }
        public static IXLWorksheet InitSheet(this IXLWorkbook wb, string sheetName = "")
        {
            var ws = string.IsNullOrEmpty(sheetName) ? wb.AddWorksheet() : wb.AddWorksheet(sheetName);
            ws.SetRightToLeft();
            ws.Author = "Girguis";
            return ws;
        }
        public static Stream GetFacultyLogoAsStream()
        {
            return new MemoryStream(PDFCommonFunctions.GetFacultyLogo());
        }
        public static Stream GetUnivLogoAsStream()
        {
            return new MemoryStream(PDFCommonFunctions.GetUnivLogo());
        }
    }
}
