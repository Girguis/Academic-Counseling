using FOS.Core.Models.StoredProcedureOutputModels;
using QuestPDF.Fluent;
using QuestPDF.Helpers;
using QuestPDF.Infrastructure;

public static class PdfCreator
{
    public static byte[] CreateExamCommitteesPdf(ExamCommitteeStudentsOutModel model, int level, string examType)
    {
        var document = Document.Create(container =>
        {
            container.Page(page =>
            {
                page.Size(PageSizes.A4);
                page.Margin(1, Unit.Centimetre);
                page.PageColor(Colors.White);
                page.ContentFromRightToLeft();
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
                            txt.Line("كشف توقيعات الطلاب").SetFontSize(18);
                        });
                        tbl.Cell().AlignLeft().MaxHeight(2.54f, Unit.Centimetre).MaxWidth(2.54f, Unit.Centimetre).Image(GetUnivLogo());
                        col.Item().LineHorizontal(1).LineColor(Colors.Black);
                    }));
                page.Content().Column(col =>
                {
                    col.Spacing(0.5f, Unit.Centimetre);
                    col.Item().Table(tbl =>
                    {
                        tbl.ColumnsDefinition(def =>
                        {
                            def.RelativeColumn();
                            def.RelativeColumn();
                            def.RelativeColumn();
                            def.RelativeColumn();
                        });
                        tbl.Cell().Row(1).Column(1).CellNoBoder(3).Text("تاريخ الامتحان").SetFontSize(lineHeight: 1.5f);
                        tbl.Cell().Row(1).Column(2).CellNoBoder(6).Text("....................................").SetFontSize(lineHeight: 1.5f);
                        tbl.Cell().Row(1).Column(3).CellNoBoder(3).Text("نوع الامتحان").SetFontSize(lineHeight: 1.5f);
                        tbl.Cell().Row(1).Column(4).CellNoBoder(6).Text(examType).SetFontSize(lineHeight: 1.5f);

                        tbl.Cell().Row(2).Column(1).CellNoBoder(3).Text("البرنامج").SetFontSize(lineHeight: 1.5f);
                        tbl.Cell().Row(2).Column(2).CellNoBoder(6).Text(model.Program.Name).SetFontSize(lineHeight: 1.5f);
                        tbl.Cell().Row(2).Column(3).CellNoBoder(3).Text("المستوى").SetFontSize(lineHeight: 1.5f);
                        tbl.Cell().Row(2).Column(4).CellNoBoder(6).Text(level.ToString()).SetFontSize(lineHeight: 1.5f);

                        tbl.Cell().Row(3).Column(1).CellNoBoder(3).Text("كود المقرر").SetFontSize(lineHeight: 1.5f);
                        tbl.Cell().Row(3).Column(2).CellNoBoder(6).Text(model.Course.CourseCode).SetFontSize(lineHeight: 1.5f);
                        tbl.Cell().Row(3).Column(3).CellNoBoder(3).Text("اسم المقرر").SetFontSize(lineHeight: 1.5f);
                        tbl.Cell().Row(3).Column(4).CellNoBoder(6).Text(model.Course.CourseName).SetFontSize(lineHeight: 1.5f);

                    });
                    col.Item().LineHorizontal(1).LineColor(Colors.Black);
                    col.Item().ShowIf(model.Students.Count >= 1).Table(tbl =>
                    {
                        tbl.ColumnsDefinition(def =>
                        {
                            def.ConstantColumn(1.1f, Unit.Centimetre);
                            def.ConstantColumn(2.8f, Unit.Centimetre);
                            def.RelativeColumn();
                            def.RelativeColumn();
                            def.ConstantColumn(2.5f, Unit.Centimetre);
                        });
                        tbl.Header(header =>
                        {
                            header.Cell().Row(1).Column(1).CellWithBoder(1).Text("#").SetFontSize(16);
                            header.Cell().Row(1).Column(2).CellWithBoder(2).Text("الكود الأكاديمى").SetFontSize(16);
                            header.Cell().Row(1).Column(3).CellWithBoder(6).Text("اسم الطالب").SetFontSize(16);
                            header.Cell().Row(1).Column(4).CellWithBoder(6).Text("التوقيع").SetFontSize(16);
                            header.Cell().Row(1).Column(5).CellWithBoder(3).Text("ملاحظات").SetFontSize(16);
                        });
                        for (int i = 0; i < model.Students.Count; i++)
                        {
                            uint rowNo = (uint)(i + 2);
                            var student = model.Students.ElementAt(i);
                            tbl.Cell().Row(rowNo).Column(1).CellWithBoder(1).Text((rowNo - 1).ToString()).SetFontSize();
                            tbl.Cell().Row(rowNo).Column(2).CellWithBoder(2).Text(student.AcademicCode).SetFontSize();
                            tbl.Cell().Row(rowNo).Column(3).CellWithBoder(6).Text(student.Name).SetFontSize();
                            tbl.Cell().Row(rowNo).Column(4).CellWithBoder(6);
                            tbl.Cell().Row(rowNo).Column(5).CellWithBoder(3);
                        }
                    });
                    col.Item().ShowIf(model.Students.Count < 1).AlignCenter().AlignMiddle().Text("لا يوجد طلاب").SetFontSize(18).SemiBold();
                    col.Item().LineHorizontal(1).LineColor(Colors.Black);
                    col.Item().Table(tbl =>
                    {
                        tbl.ColumnsDefinition(def =>
                        {
                            def.RelativeColumn();
                            def.RelativeColumn();
                            def.RelativeColumn();
                        });
                        tbl.Cell().Row(1).Column(1).CellNoBoder(minWidth: 6).Text("إجمالى الطلاب").SetFontSize(lineHeight: 1.5f);
                        tbl.Cell().Row(1).Column(2).CellNoBoder(minWidth: 6).Text("الحضور").SetFontSize(lineHeight: 1.5f);
                        tbl.Cell().Row(1).Column(3).CellNoBoder(minWidth: 6).Text("الغياب").SetFontSize(lineHeight: 1.5f);

                        tbl.Cell().Row(2).Column(1).CellNoBoder(minWidth: 6).Text("....................").SetFontSize(lineHeight: 1.5f);
                        tbl.Cell().Row(2).Column(2).CellNoBoder(minWidth: 6).Text("....................").SetFontSize(lineHeight: 1.5f);
                        tbl.Cell().Row(2).Column(3).CellNoBoder(minWidth: 6).Text("....................").SetFontSize(lineHeight: 1.5f);

                        //tbl.Cell().Row(3).Column(1).CellNoBoder(minWidth:6).Text("اسم الملاحظ").SetFontSize(lineHeight: 1.5f);
                        //tbl.Cell().Row(3).Column(2).CellNoBoder(minWidth:6).Text("المراجع").SetFontSize(lineHeight: 1.5f);
                        //tbl.Cell().Row(3).Column(3).CellNoBoder(minWidth:6).Text("مدير شئون التعليم والطلاب").SetFontSize(lineHeight: 1.5f);

                        //tbl.Cell().Row(4).Column(1).CellNoBoder(minWidth:6).Text("....................").SetFontSize(lineHeight:1.5f);
                        //tbl.Cell().Row(4).Column(2).CellNoBoder(minWidth:6).Text("....................").SetFontSize(lineHeight:1.5f);
                        //tbl.Cell().Row(4).Column(3).CellNoBoder(minWidth:6).Text("....................").SetFontSize(lineHeight:1.5f);

                        //tbl.Cell().Row(5).Column(1).CellNoBoder(minWidth:6).Text("اعضاء الكنترول").SetFontSize(lineHeight:1.5f);
                        //tbl.Cell().Row(5).Column(2).CellNoBoder(minWidth:6).Text("رئيس الكنترول").SetFontSize(lineHeight:1.5f);
                        //tbl.Cell().Row(5).Column(3).CellNoBoder(minWidth:6).Text("أ.د/ رئيس القسم").SetFontSize(lineHeight:1.5f);

                        //tbl.Cell().Row(6).Column(1).CellNoBoder(minWidth:6).Text("...................").SetFontSize(lineHeight:1.5f);
                        //tbl.Cell().Row(6).Column(2).CellNoBoder(minWidth:6).Text("...................").SetFontSize(lineHeight:1.5f);
                        //tbl.Cell().Row(6).Column(3).CellNoBoder(minWidth:6).Text("...................").SetFontSize(lineHeight:1.5f);
                    });
                });
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
            });
        });
        return document.GeneratePdf();
    }
    public static TextSpanDescriptor SetFontSize(this TextSpanDescriptor descriptor, float value = 14, float lineHeight = 1)
    {
        descriptor.FontFamily(GetFont());
        descriptor.FontSize(value);
        descriptor.LineHeight(lineHeight);
        return descriptor;
    }
    static IContainer CellWithBoder(this IContainer container, float minWidth = 1.1f)
    {
        return container
            .Border(1)
            .ContentFromRightToLeft()
            .MinHeight(0.6f)
            //.MinWidth(minWidth)
            .ShowOnce()
            .AlignCenter()
            .AlignMiddle();
    }
    static IContainer CellNoBoder(this IContainer container, float minWidth = 1.1f)
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
    public static string GetFont()
    {
        return "Calibri";
    }
}