using ClosedXML.Excel;
using FOS.Core.Enums;
using FOS.Core.Models;
using FOS.Core.Models.ParametersModels;
using FOS.Core.Models.StoredProcedureOutputModels;
using FOS.DB.Models;

namespace FOS.App.ExcelReader
{
    public static class ProgramSheet
    {
        public static Stream Create(List<string> programs,
                                    List<Course> courses,
                                    List<AcademicYear> academicYears)
        {
            var wb = GetSheetReady(programs, courses, academicYears);
            return ExcelCommon.SaveAsStream(wb);
        }
        public static Stream Create(ProgramDetailsOutModel programData, List<string> programs,
                                    List<Course> courses, List<AcademicYear> academicYears)
        {
            var wb = GetSheetReady(programs, courses, academicYears);
            wb.Worksheets.TryGetWorksheet("بيانات البرنامج", out var basicDataWs);
            if (basicDataWs == null)
                return null;
            //Start Of Basic Data & Hours Distribution Sheet
            basicDataWs.Cell("B1").Value = programData.BasicData.Name;
            basicDataWs.Cell("B2").Value = programData.BasicData.EnglishName;
            basicDataWs.Cell("B3").Value = programData.BasicData.ArabicName;
            basicDataWs.Cell("B4").Value = programData.BasicData.Semester;
            basicDataWs.Cell("B5").Value = programData.BasicData.IsGeneral ? "نعم" : "لا";
            basicDataWs.Cell("B6").Value = programData.BasicData.Percentage;
            basicDataWs.Cell("B7").Value = programData.BasicData.SuperProgramName;
            //Hours
            basicDataWs.Cell("B11").Value = programData.ProgramHoursDistribution.FirstOrDefault(x => x.Level == 1 && x.Semester == 1)?.NumberOfHours;
            basicDataWs.Cell("C11").Value = programData.ProgramHoursDistribution.FirstOrDefault(x => x.Level == 1 && x.Semester == 2)?.NumberOfHours;
            basicDataWs.Cell("B12").Value = programData.ProgramHoursDistribution.FirstOrDefault(x => x.Level == 2 && x.Semester == 1)?.NumberOfHours;
            basicDataWs.Cell("C12").Value = programData.ProgramHoursDistribution.FirstOrDefault(x => x.Level == 2 && x.Semester == 2)?.NumberOfHours;
            basicDataWs.Cell("B13").Value = programData.ProgramHoursDistribution.FirstOrDefault(x => x.Level == 3 && x.Semester == 1)?.NumberOfHours;
            basicDataWs.Cell("C13").Value = programData.ProgramHoursDistribution.FirstOrDefault(x => x.Level == 3 && x.Semester == 2)?.NumberOfHours;
            basicDataWs.Cell("B14").Value = programData.ProgramHoursDistribution.FirstOrDefault(x => x.Level == 4 && x.Semester == 1)?.NumberOfHours;
            basicDataWs.Cell("C14").Value = programData.ProgramHoursDistribution.FirstOrDefault(x => x.Level == 4 && x.Semester == 2)?.NumberOfHours;
            //End Of Basic Data & Hours Distribution Sheet
            wb.Worksheets.TryGetWorksheet("المقررات الإجبارية", out var mandetoryCoursesWs);
            if (mandetoryCoursesWs == null) return null;
            var modifiedCoursesList = programData.Courses
                .Select(x => new CoursesExcelFormat
                {
                    CourseCode = x.CourseCode,
                    Level = x.Level,
                    Semester = x.Semester,
                    CourseType = x.CourseType,
                    Category = x.Category,
                    CreditHours = x.CreditHours,
                    PrerequisiteRelation = GetPrerequisiteRelationName(x.PrerequisiteRelationID),
                    Prerequisites = x.Prerequisites,
                    AddtionYear = GetYearName(academicYears, x.AddtionYearID),
                    DeletionYear = GetYearName(academicYears, x.DeletionYearID),
                    AllowedHours = x.AllowedHours
                });

            mandetoryCoursesWs.PrepareCoursesSheet(modifiedCoursesList, CourseTypeEnum.Mandetory);

            wb.Worksheets.TryGetWorksheet("المقررات الاختيارية", out var electiveCoursesWs);
            if (electiveCoursesWs == null) return null;
            electiveCoursesWs.PrepareCoursesSheet(modifiedCoursesList, CourseTypeEnum.Elective);

            wb.Worksheets.TryGetWorksheet("مقررات متطلب الجامعة", out var uniCoursesWs);
            if (uniCoursesWs == null) return null;
            uniCoursesWs.PrepareCoursesSheet(modifiedCoursesList, CourseTypeEnum.UniversityRequirement);

            mandetoryCoursesWs.Columns().AdjustToContents();
            mandetoryCoursesWs.SetTabSelected(false);

            electiveCoursesWs.Columns().AdjustToContents();
            electiveCoursesWs.SetTabSelected(false);

            uniCoursesWs.Columns().AdjustToContents();
            uniCoursesWs.SetTabSelected(false);

            wb.Worksheets.ElementAt(0).SetTabSelected(true).TabActive = true;
            return ExcelCommon.SaveAsStream(wb);
        }
        public static void AddExtraRowsToTable(this IXLTable table, int coursesCount, int tableRowsCounts)
        {
            var baseRow = table.Row(2);
            for (int i = 0; i < coursesCount - tableRowsCounts + 1; i++)
            {
                var address = table.InsertRowsBelow(1);
                address.First().Cell(2).FormulaA1 = "=IFERROR(VLOOKUP(A" + address.First().RowNumber() + ",Course_Code_Name,2,0),\"\")";
                baseRow.CopyTo(table.Row(i + 3));
            }
        }
        public static void PrepareCoursesSheet(this IXLWorksheet ws, IEnumerable<CoursesExcelFormat> courses, CourseTypeEnum courseType)
        {
            if (courseType == CourseTypeEnum.Mandetory)
            {
                courses = courses
                                .Where(x => x.CourseType == (byte)courseType);
                var tableRowsCount = ws.Table(0).RowCount() - 1;
                var coursesCount = courses.Count();
                if (tableRowsCount < coursesCount)
                    ws.Table(0).AddExtraRowsToTable(coursesCount, tableRowsCount);
                ws.AddCoursesToTable(courses, 2, coursesCount);
            }
            else
            {
                var groupedCourses = courses
                                    .Where(x => x.CourseType == (byte)courseType)
                                    .GroupBy(x => new { x.Level, x.Semester, x.CourseType, x.Category });
                var wsTables = ws.Tables;
                var wsTablesCount = wsTables.Count();
                var groupedCoursesCount = groupedCourses.Count();
                if (wsTablesCount < groupedCoursesCount)
                {
                    ws.CreateExtraTables(wsTablesCount, groupedCourses.Count());
                    wsTables = ws.Tables;
                }
                var tblIndex = 0;
                var sortedTables = wsTables.OrderBy(t => t.RangeAddress.FirstAddress.RowNumber);
                for (int i = 0; i < groupedCoursesCount; i++)
                {
                    var tblCourses = groupedCourses.ElementAt(i);
                    var tblCoursesCount = tblCourses.Count();
                    var tableRowsCount = sortedTables.ElementAt(tblIndex).RowCount() - 1;
                    var baseRow = sortedTables.ElementAt(tblIndex).Row(2);
                    var rowNo = baseRow.RangeAddress.FirstAddress.RowNumber;
                    if (tableRowsCount < tblCoursesCount)
                        sortedTables.ElementAt(tblIndex).AddExtraRowsToTable(tblCoursesCount, tableRowsCount);

                    ws.AddCoursesToTable(tblCourses, rowNo, tblCoursesCount, true);
                    tblIndex++;
                }
            }
        }
        public static void AddCoursesToTable(this IXLWorksheet ws, IEnumerable<CoursesExcelFormat> courses, int startRow, int coursesCount, bool isElectiveTable = false)
        {
            var rowNo = startRow;
            if (isElectiveTable)
            {
                if (!ws.Cell("D" + (rowNo - 2)).HasDataValidation)
                    ws.Cell("D" + (rowNo - 2)).GetDataValidation().WholeNumber.EqualOrGreaterThan(0);
                ws.Cell("D" + (rowNo - 2)).Value = courses.ElementAt(0).AllowedHours ?? courses.Sum(x => x.CreditHours);
            }
            for (int i = 0; i < coursesCount; i++)
            {
                ws.Cell("A" + rowNo).Value = courses.ElementAt(i).CourseCode;
                ws.Cell("C" + rowNo).Value = courses.ElementAt(i).PrerequisiteRelation;
                ws.Cell("D" + rowNo).Value = courses.ElementAt(i).Prerequisites;
                ws.Cell("E" + rowNo).Value = courses.ElementAt(i).AddtionYear;
                ws.Cell("F" + rowNo).Value = courses.ElementAt(i).DeletionYear;
                rowNo++;
            }
        }
        public static void CreateExtraTables(this IXLWorksheet ws, int existingTablesCount, int totalCoursesGroupsCount)
        {
            var tblsCount = existingTablesCount;
            var firstTableRange = ws.Range("A1:F5");
            for (int i = 0; i < (totalCoursesGroupsCount + 2); i++)
            {
                var index = (tblsCount * 5) + 1;
                firstTableRange.CopyTo(ws.Cell("A" + index));
                var tbl = ws.Range("A" + (index + 1), "F" + (index + 4)).CreateTable();
                tbl.Theme = XLTableTheme.TableStyleMedium16;
                tblsCount++;
            }
        }
        public static ProgramModel Read(XLWorkbook wb,
            List<ProgramBasicDataDTO> programs,
            List<Course> courses,
            List<AcademicYear> academicYears)
        {
            var model = new ProgramModel();
            //Start Of Basic Data & Hours Distribution Sheet
            wb.TryGetWorksheet("بيانات البرنامج", out var programDataWs);
            if (programDataWs == null)
                return null;
            model.programData = new();
            model.programData.Name = programDataWs.Cell("B1").Value.GetText();
            model.programData.EnglishName = programDataWs.Cell("B2").Value.GetText();
            model.programData.ArabicName = programDataWs.Cell("B3").Value.GetText();
            model.programData.Semester = programDataWs.GetCellValueAsByte("B4");
            model.programData.Percentage = programDataWs.GetCellValueAsDouble("B6");
            if (string.IsNullOrEmpty(model.programData.Name) ||
                string.IsNullOrEmpty(model.programData.EnglishName) ||
                string.IsNullOrEmpty(model.programData.ArabicName) ||
                string.IsNullOrEmpty(model.programData.Semester.ToString()) ||
                string.IsNullOrEmpty(model.programData.Percentage.ToString()))
                return null;
            if (programs.FirstOrDefault(x => x.Name == programDataWs.Cell("B7").Value.ToString()) != null)
                model.programData.SuperProgramID = programs.FirstOrDefault(x => x.Name == programDataWs.Cell("B7").Value.GetText()).Id;
            model.programData.IsGeneral = programDataWs.Cell("B5").Value.GetText() == "نعم";
            model.programData.IsRegular = true;
            model.programData.TotalHours = programDataWs.GetCellValueAsByte("D15");

            model.ProgramHoursDistributionList = new List<ProgramDistributionModel>
            {
                new ProgramDistributionModel(1,1,programDataWs.GetCellValueAsByte("B11")),
                new ProgramDistributionModel(1,2,programDataWs.GetCellValueAsByte("C11")),
                new ProgramDistributionModel(2,1,programDataWs.GetCellValueAsByte("B12")),
                new ProgramDistributionModel(2,2,programDataWs.GetCellValueAsByte("C12")),
                new ProgramDistributionModel(3,1,programDataWs.GetCellValueAsByte("B13")),
                new ProgramDistributionModel(3,2,programDataWs.GetCellValueAsByte("C13")),
                new ProgramDistributionModel(4,1,programDataWs.GetCellValueAsByte("B14")),
                new ProgramDistributionModel(4,2,programDataWs.GetCellValueAsByte("C14")),
            };
            //End Of Basic Data & Hours Distribution Sheet
            //Start Of Mandetory Courses Sheet
            model.PrerequisiteCoursesList = new List<PrerequisiteCourseModel>();
            model.CoursesList = new List<ProgramCourseModel>();
            model.ElectiveCoursesDistributionList = new List<ElectiveCoursesDistributionModel>();
            if (!wb.TryGetWorksheet("المقررات الإجبارية", out var mandetoryCoursesWs))
                return null;
            int rows = mandetoryCoursesWs.RowsUsed().Count();
            for (int i = 2; i <= rows; i++)
            {
                (bool isValid,
                   bool isEmpty,
                   ProgramCourseModel programCourseModel,
                   List<PrerequisiteCourseModel> prerequisiteCourseModel)
                   = mandetoryCoursesWs.ReadCourseRow(1, CourseTypeEnum.Mandetory,
                                                        i, academicYears, courses);
                if (!isValid) return null;
                if (isEmpty) break;
                model.CoursesList.Add(programCourseModel);
                if (prerequisiteCourseModel == null) return null;
                if (prerequisiteCourseModel.Count != 0)
                    model.PrerequisiteCoursesList.AddRange(prerequisiteCourseModel);
            }
            //End Of Mandetory Courses Sheet
            //Start Of Elective Courses Sheet
            if (!wb.TryGetWorksheet("المقررات الاختيارية", out var electiveCoursesWs))
                return null;

            var electiveCoursesModel = electiveCoursesWs.ReadElectiveTablesCourses(courses, academicYears, CourseTypeEnum.Elective);
            if (electiveCoursesModel == null) return null;
            model.CoursesList?.AddRange(electiveCoursesModel?.CoursesList);
            model.PrerequisiteCoursesList?.AddRange(electiveCoursesModel?.PrerequisiteCoursesList);
            model.ElectiveCoursesDistributionList?.AddRange(electiveCoursesModel?.ElectiveCoursesDistributionList);

            //End Of Elective Courses Sheet
            //Start Of University Requirement Courses Sheet
            if (!wb.TryGetWorksheet("مقررات متطلب الجامعة", out var uniReqCoursesWs))
                return null;
            var uniCoursesModel = uniReqCoursesWs.ReadElectiveTablesCourses(courses, academicYears, CourseTypeEnum.UniversityRequirement);
            if (uniCoursesModel == null) return null;
            model.CoursesList?.AddRange(uniCoursesModel?.CoursesList);
            model.PrerequisiteCoursesList?.AddRange(uniCoursesModel?.PrerequisiteCoursesList);
            model.ElectiveCoursesDistributionList?.AddRange(uniCoursesModel?.ElectiveCoursesDistributionList);
            //End Of University Requirement Courses Sheet
            return model;
        }
        private static (bool isValid,
            bool isEmpty,
            ProgramCourseModel programCourseModel,
            List<PrerequisiteCourseModel> prerequisiteCourseModel)
            ReadCourseRow(this IXLWorksheet ws, byte category, CourseTypeEnum courseType,
            int index, List<AcademicYear> academicYears, List<Course> courses)
        {
            (bool isEmpty, int? courseID) = ws.GetCourseID("A" + index, courses);
            if (isEmpty)
                return (true, isEmpty, null, null);
            if (courseID == null)
                return (false, isEmpty, null, null);
            var prereqRelationID = ws.GetPrerequisiteRelationId("C" + index);
            var addYearID = GetYearID(ws.Cell("E" + index).Value.ToString(), academicYears);
            var deleteYearID = GetYearID(ws.Cell("F" + index).Value.ToString(), academicYears, true); ;
            var prereqCoursesCodes = ws.Cell("D" + index).Value.ToString().Replace(" ", "").ToLower();
            var programCourseModel = new ProgramCourseModel
            {
                CourseId = courseID.Value,
                CourseType = (byte)courseType,
                Category = category,
                PrerequisiteRelationId = prereqRelationID,
                AddtionYearId = addYearID ?? academicYears.First().Id,
                DeletionYearId = deleteYearID
            };
            var prereqsModel = GetPrerequisitesModel(courseID.Value, prereqCoursesCodes,
                                                prereqRelationID, courses);
            if (prereqsModel == null)
                return (false, isEmpty, null, null);
            return (true, isEmpty, programCourseModel, prereqsModel);
        }
        private static ProgramModel ReadElectiveTablesCourses(this IXLWorksheet ws,
                                                            List<Course> courses,
                                                            List<AcademicYear> academicYears,
                                                            CourseTypeEnum courseType)
        {
            var model = new ProgramModel()
            {
                ElectiveCoursesDistributionList = new List<ElectiveCoursesDistributionModel>(),
                PrerequisiteCoursesList = new List<PrerequisiteCourseModel>(),
                CoursesList = new List<ProgramCourseModel>()
            };
            var uniReqTables = ws.Tables;
            for (int i = 0; i < uniReqTables.Count(); i++)
            {
                var tableCells = uniReqTables.ElementAt(i).CellsUsed();
                for (int j = 0; j < tableCells.Count(); j++)
                {
                    var index = tableCells.ElementAt(j).Address.RowNumber + j + 1;
                    (bool isValid, bool isEmpty,
                    ProgramCourseModel programCourseModel,
                    List<PrerequisiteCourseModel> prerequisiteCourseModel)
                    = ws.ReadCourseRow((byte)i, courseType,
                    index, academicYears, courses);
                    if (!isValid) return null;
                    if (isEmpty) break;
                    model.CoursesList.Add(programCourseModel);
                    if (prerequisiteCourseModel == null) return null;
                    if (prerequisiteCourseModel.Count != 0)
                        model.PrerequisiteCoursesList.AddRange(prerequisiteCourseModel);
                    if (j == 0)
                    {
                        var course = courses.First(x => x.Id == model.CoursesList.LastOrDefault()?.CourseId);
                        model.ElectiveCoursesDistributionList.Add(ws
                            .GetElectiveHour(
                                            tableCells.ElementAt(0).Address.RowNumber, (byte)i,
                                            (byte)courseType, course.Level, course.Semester));
                    }
                }
            }
            return model;
        }
        private static ElectiveCoursesDistributionModel GetElectiveHour(this IXLWorksheet ws, int firstCellRowNumberInTable, byte category, byte courseType, byte level, byte semester)
        {
            return new ElectiveCoursesDistributionModel
            {
                Hour = (byte)ws.Cell("D" + (firstCellRowNumberInTable - 1)).Value.GetNumber(),
                Category = category,
                CourseType = courseType,
                Level = level,
                Semester = semester
            };
        }
        private static (bool isEmpty, int? courseID)
            GetCourseID(this IXLWorksheet ws, string cellAddress, List<Course> courses)
        {
            var courseCode = ws.Cell(cellAddress).Value.ToString();
            if (string.IsNullOrEmpty(courseCode) || courseCode.Contains("عدد الساعات المسموح باختيارها"))
                return (true, null);
            var courseID = courses.FirstOrDefault(x => x.CourseCode.ToLower() == courseCode.ToLower())?.Id;
            return (false, courseID);
        }
        private static List<PrerequisiteCourseModel> GetPrerequisitesModel(int courseID, string prereqCoursesCodes, byte prereqRelationID, List<Course> courses)
        {
            if (string.IsNullOrEmpty(prereqCoursesCodes) &&
                prereqRelationID != (byte)PrerequisiteCoursesRelationEnum.NoPrerequisite)
                return null;
            if (prereqRelationID == (byte)PrerequisiteCoursesRelationEnum.NoPrerequisite)
                return new List<PrerequisiteCourseModel>();
            if (prereqRelationID == (byte)PrerequisiteCoursesRelationEnum.OnePrerequisite)
            {
                var prereqCourseID = courses.FirstOrDefault(x => x.CourseCode.Replace(" ", "").ToLower() == prereqCoursesCodes.Split(",")[0])?.Id;
                if (prereqCourseID == null)
                    return null;
                return new List<PrerequisiteCourseModel>()
                {
                    new PrerequisiteCourseModel(){ PrerequisiteCourseId = prereqCourseID.Value,CourseId = courseID }
                };
            }
            var splitedPrereqCourses = prereqCoursesCodes.Split(",");
            var prerequisiteCourseModelList = new List<PrerequisiteCourseModel>();
            int? currentPreqID = null;
            for (int i = 0; i < splitedPrereqCourses.Length; i++)
            {
                currentPreqID = courses.FirstOrDefault(x => x.CourseCode.Replace(" ", "").ToLower() == splitedPrereqCourses[i])?.Id;
                if (currentPreqID == null)
                    return null;
                prerequisiteCourseModelList.Add(new PrerequisiteCourseModel() { PrerequisiteCourseId = currentPreqID.Value, CourseId = courseID });
            }
            return prerequisiteCourseModelList;
        }
        private static short? GetYearID(string yearStr, List<AcademicYear> academicYears, bool isDeleteYearCell = false)
        {
            if (string.IsNullOrEmpty(yearStr) && isDeleteYearCell)
                return null;
            if (string.IsNullOrEmpty(yearStr))
                return academicYears.FirstOrDefault()?.Id;

            var splited = yearStr.Split(" - ");
            return academicYears.FirstOrDefault(x => x.AcademicYear1 == splited[0]
            && x.Semester == Helpers.Helper.GetSemesterNumber(splited[1]))?.Id;
        }
        private static byte GetPrerequisiteRelationId(this IXLWorksheet ws, string cellAddress)
        {
            var cellValue = ws.Cell(cellAddress).Value.ToString().Trim();
            if (cellValue == "و")
                return (byte)PrerequisiteCoursesRelationEnum.AndRelationPrerequisites;
            else if (cellValue == "أو")
                return (byte)PrerequisiteCoursesRelationEnum.OrRelationPrerequisites;
            else if (cellValue == "متطلب واحد")
                return (byte)PrerequisiteCoursesRelationEnum.OnePrerequisite;
            else
                return (byte)PrerequisiteCoursesRelationEnum.NoPrerequisite;
        }
        private static string GetPrerequisiteRelationName(byte relationID)
        {
            if (relationID == (byte)PrerequisiteCoursesRelationEnum.AndRelationPrerequisites)
                return "و";
            if (relationID == (byte)PrerequisiteCoursesRelationEnum.OrRelationPrerequisites)
                return "أو";
            if (relationID == (byte)PrerequisiteCoursesRelationEnum.OnePrerequisite)
                return "متطلب واحد";

            return "بدون متطلب";
        }
        private static string GetYearName(List<AcademicYear> academicYears, short? yearID)
        {
            if (yearID == null) return "";
            var year = academicYears.FirstOrDefault(x => x.Id == yearID);
            if (year == null) return "";
            return year.AcademicYear1 + " - " + Helpers.Helper.GetDescription((SemesterEnum)year.Semester);
        }
        private static IXLWorkbook GetTemplate()
        {
            return new XLWorkbook("ExcelTemplates/Program Template.xlsx");
        }
        private static IXLWorkbook GetSheetReady(List<string> programs, List<Course> courses,
                                                 List<AcademicYear> academicYears)
        {
            IXLWorkbook wb = GetTemplate();
            wb.TryGetWorksheet("البرامج المتاحه", out IXLWorksheet programsWs);
            programsWs.Tables.FirstOrDefault()?.ReplaceData(programs);
            programsWs.SetFont(16);
            programsWs.LockRange(1, 1, programs.Count + 1, 1);
            wb.TryGetWorksheet("المقررات المتاحه", out IXLWorksheet coursesWs);
            coursesWs.Tables.FirstOrDefault()?.ReplaceData(courses.Select(x => new { x.CourseCode, x.CourseName, x.Level, x.CreditHours }));
            coursesWs.LockRange(1, 1, courses.Count + 1, 4);
            coursesWs.SetFont(16);
            wb.TryGetWorksheet("الأعوام الأكاديمية", out IXLWorksheet academicYearsWs);
            academicYearsWs.Tables.FirstOrDefault()?.ReplaceData(academicYears.Select(x => x.AcademicYear1 + " - " + Helpers.Helper.GetDescription((SemesterEnum)x.Semester)));
            academicYearsWs.SetFont(16);
            academicYearsWs.LockRange(1, 1, academicYears.Count + 1, 1);
            return wb;
        }
        public class CoursesExcelFormat
        {
            public string CourseCode { get; set; }
            public byte Level { get; set; }
            public byte Semester { get; set; }
            public byte CourseType { get; set; }
            public byte Category { get; set; }
            public int CreditHours { get; set; }
            public string PrerequisiteRelation { get; set; }
            public string Prerequisites { get; set; }
            public string AddtionYear { get; set; }
            public string DeletionYear { get; set; }
            public int? AllowedHours { get; set; }
        }
    }
}