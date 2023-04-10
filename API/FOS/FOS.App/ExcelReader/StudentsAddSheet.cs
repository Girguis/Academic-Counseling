using ClosedXML.Excel;
using FOS.Core.Models.ParametersModels;
using Microsoft.AspNetCore.Http;
using System.Data;

namespace FOS.App.ExcelReader
{
    public static class StudentsAddSheet
    {
        public static DataTable Read(IFormFile file, List<ProgramBasicDataDTO> programs)
        {
            var ms = new MemoryStream();
            file.OpenReadStream().CopyTo(ms);
            var wb = new XLWorkbook(ms);
            ms.Close();
            var ws = wb.Worksheets.ElementAt(0);
            int rowsCount = ws.Rows().Count();
            var dt = new DataTable();
            dt.Columns.Add("GUID");
            dt.Columns.Add("Name");
            dt.Columns.Add("Ssn");
            dt.Columns.Add("PhoneNumber");
            dt.Columns.Add("BirthDate");
            dt.Columns.Add("Address");
            dt.Columns.Add("Gender");
            dt.Columns.Add("Nationality");
            dt.Columns.Add("Email");
            dt.Columns.Add("Password");
            dt.Columns.Add("CreatedOn");
            dt.Columns.Add("CurrentProgramId");
            for (int i = 2; i <= rowsCount; i++)
            {
                try
                { 
                    if (string.IsNullOrEmpty(ws.Cell("A" + i).Value.ToString()))
                        break;
                    dt.Rows.Add(
                                Guid.NewGuid().ToString(),
                                ws.Cell("A" + i).Value.ToString(),
                                ws.Cell("B" + i).Value.ToString(),
                                ws.Cell("C" + i).Value.ToString(),
                                DateTime.Parse(ws.Cell("D" + i).Value.ToString()),
                                ws.Cell("E" + i).Value.ToString(),
                                ws.Cell("F" + i).Value.ToString() == "ذكر" ? "1" : "2",
                                ws.Cell("G" + i).Value.ToString(),
                                string.Concat(ws.Cell("B" + i).Value.ToString(), "@sci.asu.edu.eg"),
                                Helpers.Helper.HashPassowrd("Sci@2023"),
                                DateTime.UtcNow.AddHours(2).ToString(),
                                programs.FirstOrDefault(x => x.Name == ws.Cell("H" + i).Value.ToString())?.Id
                                );
                    //var guid = Guid.NewGuid().ToString();
                    //var name = ws.Cell("A" + i).Value.ToString();
                    //var ssn = ws.Cell("B" + i).Value.ToString();
                    //var phoneNumber = ws.Cell("C" + i).Value.ToString();
                    //var birthDate = DateTime.Parse(ws.Cell("D" + i).Value.ToString());
                    //var address = ws.Cell("E" + i).Value.ToString();
                    //var gender = ws.Cell("F" + i).Value.ToString() == "ذكر" ? "1" : "2";
                    //var nationality = ws.Cell("G" + i).Value.ToString();
                    //var email = string.Concat(ws.Cell("B" + i).Value.ToString(), "@sci.asu.edu.eg");
                    //var password = Helpers.Helper.HashPassowrd("Sci@2023");
                    //var createdOn = DateTime.UtcNow.AddHours(2).ToString();
                    //var programID = programs.FirstOrDefault(x => x.Name == ws.Cell("H" + i).Value.ToString())?.Id;
                }
                catch
                {
                    return null;
                }
            }
            return dt;
        }
    }
}
