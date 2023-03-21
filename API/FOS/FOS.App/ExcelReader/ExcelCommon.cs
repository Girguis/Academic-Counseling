using ClosedXML.Excel;

namespace FOS.App.ExcelReader
{
    public class ExcelCommon
    {
        public static void CreateTable(IXLWorksheet ws, IXLRange range,bool locktable = true)
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
            {
                ws.Range(1, 1, ws.LastRow().RangeAddress.RowSpan, ws.LastColumn().RangeAddress.ColumnSpan).Style.Protection.SetLocked(true);
                ws.Protect("G2001G", XLProtectionAlgorithm.Algorithm.SHA512,
                    XLSheetProtectionElements.SelectUnlockedCells
                    | XLSheetProtectionElements.AutoFilter
                    | XLSheetProtectionElements.SelectLockedCells
                    //| XLSheetProtectionElements.Sort
                    );
            }
            ws.Columns().AdjustToContents();
        }
        public static Stream SaveAsStream(IXLWorkbook wb)
        {
            var stream = new MemoryStream();
            wb.SaveAs(stream);
            stream.Seek(0, SeekOrigin.Begin);
            return stream;
        }
    }
}
