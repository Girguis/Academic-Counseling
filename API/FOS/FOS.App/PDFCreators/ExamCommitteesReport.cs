using FOS.App.Helpers;
using FOS.Core.Enums;
using FOS.Core.Models.StoredProcedureOutputModels;
using QuestPDF.Fluent;
using QuestPDF.Helpers;
using QuestPDF.Infrastructure;

namespace FOS.App.PDFCreators
{
    public static class ExamCommitteesReport
    {
        public static Document CreateDocument(ExamCommitteeStudentsOutModel model, string examType)
        {
            string borderColor = "#000";
            bool isFinalExam = examType == Helper.GetDescription(ExamTypeEnum.Final);
            var groupedStudentsLst = model.Students.GroupBy(x => new { x.ProgramName, x.Level });
            return Document.Create(container =>
            {
                for (int i = 0; i < groupedStudentsLst.Count(); i++)
                {
                    var students = groupedStudentsLst.ElementAt(i);
                    var studentsCount = students.Count();
                    container.Page(page =>
                    {
                        page.SetPageDefaults();
                        page.GetHeader("كشف توقيعات");
                        page.Content().Column(col =>
                        {
                            col.Spacing(0.5f, Unit.Centimetre);
                            col.Item().Table(tbl =>
                            {
                                tbl.ColumnsDefinition(def =>
                                {
                                    def.ConstantColumn(2.5f, Unit.Centimetre);
                                    def.RelativeColumn();
                                    def.ConstantColumn(2.5f, Unit.Centimetre);
                                    def.RelativeColumn();
                                });
                                tbl.Cell().Row(1).Column(1).CellNoBorder().Text("تاريخ الامتحان").SetFontSize(lineHeight: 1.5f);
                                tbl.Cell().Row(1).Column(2).CellNoBorder().Text("....................................").SetFontSize(lineHeight: 1.5f);
                                tbl.Cell().Row(1).Column(3).CellNoBorder().Text(isFinalExam ? "رقم اللجنة" : "نوع الامتحان").SetFontSize(lineHeight: 1.5f);
                                tbl.Cell().Row(1).Column(4).CellNoBorder().Text(isFinalExam ? "..................." : string.Concat(examType, " ")).SetFontSize(lineHeight: 1.5f);

                                tbl.Cell().Row(2).Column(1).CellNoBorder().Text("البرنامج").SetFontSize(lineHeight: 1.5f);
                                tbl.Cell().Row(2).Column(2).CellNoBorder().Text(string.Concat(students.Key.ProgramName, " ")).SetFontSize(lineHeight: 1.5f);
                                tbl.Cell().Row(2).Column(3).CellNoBorder().Text("المستوى").SetFontSize(lineHeight: 1.5f);
                                tbl.Cell().Row(2).Column(4).CellNoBorder().Text(students.Key.Level.ToString()).SetFontSize(lineHeight: 1.5f);

                                tbl.Cell().Row(3).Column(1).CellNoBorder().Text("كود المقرر").SetFontSize(lineHeight: 1.5f);
                                tbl.Cell().Row(3).Column(2).CellNoBorder().Text(model.Course.CourseCode).SetFontSize(lineHeight: 1.5f);
                                tbl.Cell().Row(3).Column(3).CellNoBorder().Text("اسم المقرر").SetFontSize(lineHeight: 1.5f);
                                tbl.Cell().Row(3).Column(4).CellNoBorder().Text(string.Concat(model.Course.CourseName, " ")).SetFontSize(lineHeight: 1.5f);

                            });
                            col.Item().LineHorizontal(1).LineColor(Colors.Black);
                            col.Item().ShowIf(studentsCount >= 1).Table(tbl =>
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
                                    header.Cell().Row(1).Column(1).CellWithBorder(borderColor).Text("#").SetFontSize(16);
                                    header.Cell().Row(1).Column(2).CellWithBorder(borderColor).Text("الكود الأكاديمى").SetFontSize(16);
                                    header.Cell().Row(1).Column(3).CellWithBorder(borderColor).Text("اسم الطالب").SetFontSize(16);
                                    header.Cell().Row(1).Column(4).CellWithBorder(borderColor).Text("التوقيع").SetFontSize(16);
                                    header.Cell().Row(1).Column(5).CellWithBorder(borderColor).Text("ملاحظات").SetFontSize(16);
                                });
                                for (int i = 0; i < studentsCount; i++)
                                {
                                    uint rowNo = (uint)(i + 2);
                                    var student = students.ElementAt(i);
                                    tbl.Cell().Row(rowNo).Column(1).CellWithBorder(borderColor).Text((rowNo - 1).ToString()).SetFontSize();
                                    tbl.Cell().Row(rowNo).Column(2).CellWithBorder(borderColor).Text(student.AcademicCode).SetFontSize();
                                    tbl.Cell().Row(rowNo).Column(3).CellWithBorder(borderColor).Text(student.Name).SetFontSize();
                                    tbl.Cell().Row(rowNo).Column(4).CellWithBorder(borderColor);
                                    tbl.Cell().Row(rowNo).Column(5).CellWithBorder(borderColor);
                                }
                            });
                            col.Item().ShowIf(studentsCount < 1).AlignCenter().AlignMiddle().Text("لا يوجد طلاب").SetFontSize(18).SemiBold();
                            col.Item().LineHorizontal(1).LineColor(Colors.Black);
                            col.Item().ShowEntire().Table(tbl =>
                            {
                                tbl.ColumnsDefinition(def =>
                                {
                                    def.RelativeColumn();
                                    def.RelativeColumn();
                                    def.RelativeColumn();
                                });
                                tbl.Cell().Row(1).Column(1).CellNoBorder().Text("إجمالى الطلاب").SetFontSize(lineHeight: 1.5f);
                                tbl.Cell().Row(1).Column(2).CellNoBorder().Text("الحضور").SetFontSize(lineHeight: 1.5f);
                                tbl.Cell().Row(1).Column(3).CellNoBorder().Text("الغياب").SetFontSize(lineHeight: 1.5f);

                                tbl.Cell().Row(2).Column(1).CellNoBorder().Text("....................").SetFontSize(lineHeight: 1.5f);
                                tbl.Cell().Row(2).Column(2).CellNoBorder().Text("....................").SetFontSize(lineHeight: 1.5f);
                                tbl.Cell().Row(2).Column(3).CellNoBorder().Text("....................").SetFontSize(lineHeight: 1.5f);
                                if (isFinalExam)
                                {
                                    tbl.Cell().Row(3).Column(1).CellNoBorder().Text("اسم الملاحظ").SetFontSize(lineHeight: 1.5f);
                                    tbl.Cell().Row(3).Column(2).CellNoBorder().Text("المراجع").SetFontSize(lineHeight: 1.5f);
                                    tbl.Cell().Row(3).Column(3).CellNoBorder().Text("مدير شئون التعليم والطلاب").SetFontSize(lineHeight: 1.5f);

                                    tbl.Cell().Row(4).Column(1).CellNoBorder().Text("....................").SetFontSize(lineHeight: 1.5f);
                                    tbl.Cell().Row(4).Column(2).CellNoBorder().Text("....................").SetFontSize(lineHeight: 1.5f);
                                    tbl.Cell().Row(4).Column(3).CellNoBorder().Text("....................").SetFontSize(lineHeight: 1.5f);

                                    tbl.Cell().Row(5).Column(1).CellNoBorder().Text("اعضاء الكنترول").SetFontSize(lineHeight: 1.5f);
                                    tbl.Cell().Row(5).Column(2).CellNoBorder().Text("رئيس الكنترول").SetFontSize(lineHeight: 1.5f);
                                    tbl.Cell().Row(5).Column(3).CellNoBorder().Text("أ.د/ رئيس القسم").SetFontSize(lineHeight: 1.5f);

                                    tbl.Cell().Row(6).Column(1).CellNoBorder().Text("...................").SetFontSize(lineHeight: 1.5f);
                                    tbl.Cell().Row(6).Column(2).CellNoBorder().Text("...................").SetFontSize(lineHeight: 1.5f);
                                    tbl.Cell().Row(6).Column(3).CellNoBorder().Text("...................").SetFontSize(lineHeight: 1.5f);
                                }
                            });
                        });
                        page.GetFooter();
                    });
                }
            });
        }
        public static byte[] CreateCommittePDFAsByteArray
            (ExamCommitteeStudentsOutModel model, string examType)
        {
            var document = CreateDocument(model, examType);
            return document.GeneratePdf();
        }
        public static void SaveCommittePDFAsFile
            (ExamCommitteeStudentsOutModel model, string examType, string filePath)
        {
            var document = CreateDocument(model, examType);
            document.GeneratePdf(filePath);
        }

        public static (byte[] fileContent, string fileName)
            CreateExamCommitteesPdf(IEnumerable<ExamCommitteeStudentsOutModel> models)
        {
            var examType = Helper.GetDescription(ExamTypeEnum.Final);
            var (path, folderName, subFolderName) =
                Helper.CreateDirectory("PdfFiles", "CommitteePdfs");

            Parallel.For(0, models.Count(), i =>
            {
                var filePath = path + "/" + models.ElementAt(i).Course.CourseCode + ".pdf";
                SaveCommittePDFAsFile(models.ElementAt(i), examType, filePath);
            });
            var fileContent = Helper.CreateZipFile(path, folderName, subFolderName);
            return (fileContent, subFolderName);
        }
    }
}