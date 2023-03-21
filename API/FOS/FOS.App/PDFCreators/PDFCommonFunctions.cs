using QuestPDF.Fluent;
using QuestPDF.Helpers;
using QuestPDF.Infrastructure;

namespace FOS.App.PDFCreators
{
    public static class PDFCommonFunctions
    {
        public static TextSpanDescriptor SetFontSize(this TextSpanDescriptor descriptor, float value = 14, float lineHeight = 1)
        {
            descriptor.FontFamily(GetFont());
            descriptor.FontSize(value);
            descriptor.LineHeight(lineHeight);
            return descriptor;
        }
        public static IContainer CellWithBorder(this IContainer container, string borderColor = "#ddd")
        {
            return container
                .Border(1)
                .BorderColor(borderColor)
                .ContentFromRightToLeft()
                .MinHeight(0.6f)
                //.MinWidth(minWidth)
                .ShowOnce()
                .AlignCenter()
                .AlignMiddle();
        }
        public static IContainer CellNoBorder(this IContainer container)
        {
            return container
                .ContentFromRightToLeft()
                .MinHeight(0.6f)
                //.MinWidth(minWidth)
                .ShowOnce()
                .AlignCenter()
                .AlignMiddle();
        }

        public static byte[] GetFacultyLogo()
        {
            return File.ReadAllBytes("Images/facultyLogo.jpg");
        }
        public static byte[] GetUnivLogo()
        {
            return File.ReadAllBytes("Images/AinShamsUniv.png");
        }
        public static byte[] GetCheckedBox()
        {
            return File.ReadAllBytes("Images/checked.png");
        }
        public static byte[] GetUnCheckedBox()
        {
            return File.ReadAllBytes("Images/unchecked.png");
        }
        public static string GetFont()
        {
            return "Calibri";
        }
        public static void GetFooter(this PageDescriptor page)
        {
            page.Footer()
                .ContentFromRightToLeft()
                .AlignRight()
                .AlignMiddle()
                .Text(x =>
                {
                    x.Span("صفحة ").FontFamily(GetFont());
                    x.CurrentPageNumber();
                    x.Span("/");
                    x.TotalPages();
                });
        }
        public static void GetHeader(this PageDescriptor page,string title)
        {
            page.Header()
                .Column(col =>
                    col.Item().Table(tbl =>
                    {
                        tbl.ColumnsDefinition(def =>
                        {
                            def.RelativeColumn();
                            def.RelativeColumn();
                            def.RelativeColumn();
                        });
                        tbl.ExtendLastCellsToTableBottom();
                        tbl.Cell().AlignRight().MaxHeight(2.54f, Unit.Centimetre).MaxWidth(2.54f, Unit.Centimetre).Image(GetFacultyLogo());
                        tbl.Cell().AlignCenter().AlignMiddle().Text(txt =>
                        {
                            txt.Line("كلية العلوم").SetFontSize(20);
                            txt.Line("جامعة عين شمس").SetFontSize(20);
                            txt.Line(title).SetFontSize(18);
                        });
                        tbl.Cell().AlignLeft().MaxHeight(2.54f, Unit.Centimetre).MaxWidth(2.54f, Unit.Centimetre).Image(GetUnivLogo());
                        col.Item().LineHorizontal(1).LineColor(Colors.Black);
                    }));
        }
        public static void SetPageDefaults(this PageDescriptor page)
        {
            page.Size(PageSizes.A4);
            page.Margin(1, Unit.Centimetre);
            page.PageColor(Colors.White);
            page.ContentFromRightToLeft();
        }
        public static string Reverse(string s)
        {
            char[] charArray = s.ToCharArray();
            Array.Reverse(charArray);
            return new string(charArray);
        }
    }
}
