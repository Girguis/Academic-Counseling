using ClosedXML.Excel;
using static FOS.App.Repositories.BifurcationRepo;

namespace FOS.App.ExcelReader
{
    public class StudentBirfucationSummary
    {
        public static Stream Create(IEnumerable<IGrouping<int, StudentProgramInsertParamModel>> programsLst, IDictionary<int, int> studentsCountPerProgram)
        {
            var wb = new XLWorkbook();
            wb.Properties.Author = "Girguis";
            var ws = wb.Worksheets.Add();
            ws.SetRightToLeft();
            ws.Cell("A1").Value = "اسم البرنامج";
            ws.Cell("B1").Value = "عدد الطلاب";
            ws.Cell("C1").Value = "أقل معدل تراكمى";
            ws.Cell("D1").Value = "الأماكن المتاحه";
            var progsCount = programsLst.Count();
            for (int i = 0; i < progsCount; i++)
            {
                var currentProgram = programsLst.ElementAt(i);

                ws.Cell("A" + (i + 2)).Value = currentProgram.ElementAt(0)?.ProgramName;
                ws.Cell("B" + (i + 2)).Value = currentProgram.Count();
                ws.Cell("C" + (i + 2)).Value = currentProgram.OrderBy(x => x.CGPA).FirstOrDefault().CGPA;
                ws.Cell("D" + (i + 2)).Value = studentsCountPerProgram[currentProgram.Key];
            }

            IXLRange range;
            if (progsCount < 1)
            {
                ws.Range("A2:E2").Merge();
                ws.Cell("A2").Value = "لا يوجد طلبه حتى يتم تشعيبهم";
                ws.Style.Font.SetBold(true);
                ws.Style.Font.FontSize = 16;
                ws.Style.Font.FontName = "Calibri";
                range = ws.Range(1, 1, 1, 4);
            }
            else
            {
                range = ws.Range(1, 1, progsCount + 1, 4);
            }
            ExcelCommon.CreateTable(ws, range, false);
            return ExcelCommon.SaveAsStream(wb);
        }
    }
}
