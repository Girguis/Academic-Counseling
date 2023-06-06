using FOS.App.ExcelReader;
using FOS.App.Helpers;
using FOS.Core.Enums;
using FOS.Core.Models.StoredProcedureOutputModels;
using FOS.Core.StudentDTOs;
using FOS.DB.Models;
using QuestPDF.Fluent;
using QuestPDF.Helpers;
using QuestPDF.Infrastructure;
using System.ComponentModel.DataAnnotations;

namespace FOS.App.PDFCreators
{
    public class StudentAcademicReportPDF
    {
        public static byte[] CreateAcademicReport(AcademicReportOutModel model)
        {
            var student = model.Student;
            var courses = model.Courses;
            var academicYears = model.AcademicYears;
            var groupedCourses = courses.GroupBy(x => x.AcademicYearID);
            int totalPassed = 0;
            var document = Document.Create(container =>
            {
                container.Page(page =>
                {
                    page.SetPageDefaults();
                    page.GetHeader("بيان درجات");
                    page.Content().Column(col =>
                    {
                        col.Item().Table(tbl =>
                        {
                            tbl.ColumnsDefinition(def =>
                            {
                                def.ConstantColumn(3,Unit.Centimetre);
                                def.RelativeColumn();
                                def.ConstantColumn(3,Unit.Centimetre);
                                def.RelativeColumn();
                            });
                            tbl.Cell().Row(1).Column(1).CellNoBorder().Text("الطالب").SetFontSize(lineHeight: 1.5f);
                            tbl.Cell().Row(1).Column(2).CellNoBorder().Text(student.Name).SetFontSize(lineHeight: 1.5f);
                            tbl.Cell().Row(1).Column(3).CellNoBorder().Text("الكود الأكاديمى").SetFontSize(lineHeight: 1.5f);
                            tbl.Cell().Row(1).Column(4).CellNoBorder().Text(student.AcademicCode).SetFontSize(lineHeight: 1.5f);

                            tbl.Cell().Row(2).Column(1).CellNoBorder().Text("البرنامج").SetFontSize(lineHeight: 1.5f);
                            tbl.Cell().Row(2).Column(2).CellNoBorder().Text(student.ProgramName).SetFontSize(lineHeight: 1.5f);
                            tbl.Cell().Row(2).Column(3).CellNoBorder().Text("الرقم القومى").SetFontSize(lineHeight: 1.5f);
                            tbl.Cell().Row(2).Column(4).CellNoBorder().Text(student.SSN).SetFontSize(lineHeight: 1.5f);

                        });
                        for (int i = 0; i < academicYears.Count(); i++)
                        {
                            var semesterCourses = groupedCourses.ElementAt(i);
                            col.Item().ShowEntire().Table(tbl =>
                            {
                                tbl.ColumnsDefinition(def =>
                                {
                                    def.RelativeColumn();
                                    def.RelativeColumn();
                                    def.ConstantColumn(1.5f, Unit.Centimetre);
                                    def.ConstantColumn(1.5f, Unit.Centimetre);
                                    def.ConstantColumn(1.5f, Unit.Centimetre);
                                    def.ConstantColumn(1.5f, Unit.Centimetre);
                                    def.ConstantColumn(0.5f, Unit.Centimetre);
                                });
                                tbl.Header(header =>
                                {
                                    var text = Helper.GetDescription((SemesterEnum)academicYears.ElementAt(i).Semester)+" - "+ PDFCommonFunctions.Reverse(academicYears.ElementAt(i).AcademicYear)+" - "+ academicYears.ElementAt(i).ProgramName;
                                    header.Cell().ColumnSpan(7).Background(Colors.Grey.Lighten1).CellNoBorder().Text(text).SetFontSize(16); 
                                    header.Cell().Row(2).Column(1).Background(Colors.Grey.Lighten3).CellWithBorder().Text("كود").SetFontSize(16);
                                    header.Cell().Row(2).Column(2).Background(Colors.Grey.Lighten3).CellWithBorder().Text("اسم المقرر").SetFontSize(16);
                                    header.Cell().Row(2).Column(3).Background(Colors.Grey.Lighten3).CellWithBorder().Text("التقدير").SetFontSize(16);
                                    header.Cell().Row(2).Column(4).Background(Colors.Grey.Lighten3).CellWithBorder().Text("د.ن.").SetFontSize(16);
                                    header.Cell().Row(2).Column(5).Background(Colors.Grey.Lighten3).CellWithBorder().Text("س.م.").SetFontSize(16);
                                    header.Cell().Row(2).Column(6).Background(Colors.Grey.Lighten3).CellWithBorder().Text("م.ن.").SetFontSize(16);
                                    header.Cell().Row(2).Column(7).Background(Colors.Grey.Lighten3).CellWithBorder().Text("ع").SetFontSize(16);
                                });
                                int semesterPassed = 0;
                                for (int j = 0; j < semesterCourses.Count(); j++)
                                {
                                    uint rowNo = (uint)(j + 3);
                                    var course = semesterCourses.ElementAt(j);
                                    if (course.Grade.ToLower() != "f" && !string.IsNullOrEmpty(course.Grade))
                                    {
                                        totalPassed += course.CreditHours;
                                        semesterPassed += course.CreditHours;
                                    }
                                    int? termMarks = null;
                                    tbl.Cell().Row(rowNo).Column(1).CellWithBorder().Text(course.CourseCode).SetFontSize();
                                    tbl.Cell().Row(rowNo).Column(2).CellWithBorder().Text(string.Concat(course.IsGpaIncluded?"":"*",course.CourseName," ")).SetFontSize();
                                    tbl.Cell().Row(rowNo).Column(3).CellWithBorder().Text(course.Grade).SetFontSize();
                                    tbl.Cell().Row(rowNo).Column(4).CellWithBorder().Text(course.Mark).SetFontSize();
                                    tbl.Cell().Row(rowNo).Column(5).CellWithBorder().Text(course.CreditHours.ToString()).SetFontSize();
                                    tbl.Cell().Row(rowNo).Column(6).CellWithBorder().Text(course.Points.GetValueOrDefault().ToString()).SetFontSize();
                                    tbl.Cell().Row(rowNo).Column(7).CellWithBorder().ShowIf(course.CourseEntringNumber > 1).Image(PDFCommonFunctions.GetCheckedBox());
                                }
                                tbl.Footer(footer =>
                                {
                                    footer.Cell().ColumnSpan(1).Background(Colors.Grey.Lighten3).CellNoBorder().Text("عدد ساعات الترم المجتازة").SetFontSize(16);
                                    footer.Cell().ColumnSpan(1).Background(Colors.Grey.Lighten3).CellNoBorder().Text("عدد الساعات الكلية المجتازة").SetFontSize(16);
                                    footer.Cell().ColumnSpan(2).Background(Colors.Grey.Lighten3).CellNoBorder().Text("المعدل الفصلى").SetFontSize(16);
                                    footer.Cell().ColumnSpan(3).Background(Colors.Grey.Lighten3).CellNoBorder().Text("المعدل التراكمى").SetFontSize(16);
                                    footer.Cell().ColumnSpan(1).Background(Colors.Grey.Lighten3).CellNoBorder().Text(semesterPassed.ToString()).SetFontSize();
                                    footer.Cell().ColumnSpan(1).Background(Colors.Grey.Lighten3).CellNoBorder().Text(totalPassed.ToString()).SetFontSize();
                                    footer.Cell().ColumnSpan(2).Background(Colors.Grey.Lighten3).CellNoBorder().Text(academicYears.ElementAt(i).SGPA?.ToString()).SetFontSize();
                                    footer.Cell().ColumnSpan(3).Background(Colors.Grey.Lighten3).CellNoBorder().Text(academicYears.ElementAt(i).CGPA?.ToString()).SetFontSize();
                                });

                                col.Item().LineHorizontal(1).LineColor(Colors.Black);
                            });
                            col.Spacing(0.5f, Unit.Centimetre);
                        }
                    });
                    page.GetFooter("د.ن.: الدرجة النهائية, س.م.: عدد الساعات المعتمدة, م.ن.: معدل النقاط,*: لا تدخل فى حساب المعدل التراكمى");
                });
            });
            return document.GeneratePdf();
        }
    }
}
