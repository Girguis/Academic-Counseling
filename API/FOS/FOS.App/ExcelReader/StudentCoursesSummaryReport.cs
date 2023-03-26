using ClosedXML.Excel;
using FOS.App.Helpers;
using FOS.Core.Enums;
using FOS.Core.Models.StoredProcedureOutputModels;
using System.ComponentModel.DataAnnotations;

namespace FOS.App.ExcelReader
{
    public class StudentCoursesSummaryReport
    {
        public static Stream CreateCoursesSummarySheet(StudentCoursesSummaryOutModel model, StudentCoursesSummaryTreeOutModel summaryTree)
        {
            var wb = new XLWorkbook();
            wb.Properties.Author = "Girguis";
            var ws = wb.Worksheets.Add();
            ws.SetRightToLeft();
            ws.Cell("A1").Value = "الكود الأكاديمى";
            ws.Cell("C1").Value = "اسم الطالب";
            ws.Cell("A2").Value = "رقم الهاتف";
            ws.Cell("C2").Value = "المستوى";
            ws.Cell("B1").Value = model.Student.AcademicCode;
            ws.Cell("D1").Value = model.Student.Name;
            ws.Cell("B2").Value = model.Student.PhoneNumber;
            ws.Cell("D2").Value = model.Student.Level;
            ws.Cell("A3").Value = "البرنامج";
            ws.Cell("C3").Value = "ساعات البرنامج";
            ws.Cell("A4").Value = "ساعات النجاح";
            ws.Cell("C4").Value = "الساعات المتبقية";
            ws.Cell("B3").Value = model.Student.ProgramName;
            ws.Cell("D3").Value = model.Student.TotalHours;
            ws.Cell("B4").Value = model.Student.PassedHours;
            ws.Cell("D4").Value = model.Student.RemaningHours;
            ws.Range("A1", "D4").Style.Font.FontSize = 14;
            ws.Range("A1", "D4").Style.Font.FontName = "Calibri";
            var groupedCourses = model.Courses.GroupBy(x => new
            {
                x.Level,
                x.Semester,
                x.CourseType,
                x.Category
            });
            ws.Cell("A5").Value = "عدد الساعات المطلوبة";
            ws.Cell("B5").Value = "نوع المقرر";
            ws.Cell("C5").Value = "كود المقرر";
            ws.Cell("D5").Value = "اسم المقرر";
            ws.Cell("E5").Value = "ساعات المقرر";
            ws.Cell("F5").Value = "تم اجتيازها";
            ws.Cell("G5").Value = "التقدير";
            ws.Cell("H5").Value = "عدد مرات التسجيل";
            ws.Cell("I5").Value = "متى تم اجتيازها";
            var rowNo = 6;
            for (int i = 0; i < groupedCourses.Count(); i++)
            {
                var courses = groupedCourses.ElementAt(i);
                var coursesCount = courses.Count();
                for (int j = 0; j < coursesCount; j++)
                {
                    if (j == 0 ||
                        courses.ElementAt(j).CourseType != 2 &&
                        !(courses.ElementAt(j).CourseType == 3 && courses.ElementAt(j).Level == 4))
                        ws.Cell("A" + rowNo).Value = courses.ElementAt(j).Hours;
                    ws.Cell("B" + rowNo).Value = Helpers.Helper.GetDisplayName((CourseTypeEnum)courses.ElementAt(j).CourseType);
                    ws.Cell("C" + rowNo).Value = courses.ElementAt(j).CourseCode;
                    ws.Cell("D" + rowNo).Value = courses.ElementAt(j).CourseName;
                    ws.Cell("E" + rowNo).Value = courses.ElementAt(j).CreditHours;
                    ws.Cell("F" + rowNo).Value = courses.ElementAt(j).IsPassedCourse ? "نعم" : "لا";
                    ws.Cell("G" + rowNo).Value = courses.ElementAt(j).Grade;
                    ws.Cell("H" + rowNo).Value = courses.ElementAt(j).RegistrationTimes;
                    if (courses.ElementAt(j).IsPassedCourse)
                    {
                        var passedInYear = summaryTree.StudentCourses.FirstOrDefault(x => x.CourseID == courses.ElementAt(j).ID && x.Grade.ToLower() != "f");
                        ws.Cell("I" + rowNo).Value = passedInYear.AcademicYear + " - " + Helper.GetDisplayName((SemesterEnum)passedInYear.Semester);
                    }
                    else
                        ws.Cell("I" + rowNo).Value = "-------";
                    rowNo++;
                }
            }
            var range = ws.Range("A5", "I" + (model.Courses.Count() + 5));
            ExcelCommon.CreateTable(ws, range, false);
            var ws2 = wb.AddWorksheet();
            CreateCoursesSummaryTreeSheet(ws2, summaryTree);
            return ExcelCommon.SaveAsStream(wb);
        }

        public static void CreateCoursesSummaryTreeSheet(IXLWorksheet ws, StudentCoursesSummaryTreeOutModel model)
        {
            ws.SetRightToLeft();
            ws.Cell("A1").Value = "كود المقرر";
            ws.Cell("B1").Value = "اسم المقرر";
            ws.Cell("C1").Value = "ساعات معتمدة";
            ws.Cell("D1").Value = "الدرجة";
            ws.Cell("E1").Value = "التقدير";
            ws.Cell("F1").Value = "العام الدراسى";
            int rowNo = 2;
            for (int i = 0; i < model.ProgramCourses.Count(); i++)
            {
                ws.Cell("A" + rowNo).Value = model.ProgramCourses.ElementAt(i).CourseCode;
                ws.Cell("B" + rowNo).Value = model.ProgramCourses.ElementAt(i).CourseName;
                ws.Cell("C" + rowNo).Value = model.ProgramCourses.ElementAt(i).CreditHours;
                var courses = model.StudentCourses.Where(x => x.CourseID == model.ProgramCourses.ElementAt(i).ID);
                courses.ToList().Sort((x, y) => x.AcademicYearID - y.AcademicYearID);
                if (!courses.Any())
                    rowNo++;
                for (int j = 0; j < courses.Count(); j++)
                {
                    ws.Cell("D"+rowNo).Value = courses.ElementAt(j).Mark;
                    ws.Cell("E"+rowNo).Value = courses.ElementAt(j).Grade;
                    ws.Cell("F" + rowNo).Value = courses.ElementAt(j).AcademicYear + " - " + Helper.GetDisplayName((SemesterEnum)courses.ElementAt(j).Semester);
                    rowNo++;
                }
            }
            var range = ws.Range("A1", "F" + (rowNo - 1));
            ExcelCommon.CreateTable(ws, range, false);
        }
    }
}
