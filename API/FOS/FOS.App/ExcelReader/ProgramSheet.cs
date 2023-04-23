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
                .Select(x => new
                {
                    x.CourseCode,
                    x.Level,
                    x.Semester,
                    x.CourseType,
                    x.Category,
                    x.CreditHours,
                    PrerequisiteRelation = GetPrerequisiteRelationName(x.PrerequisiteRelationID),
                    x.Prerequisites,
                    AddtionYear = GetYearName(academicYears, x.AddtionYearID),
                    DeletionYear = GetYearName(academicYears, x.DeletionYearID),
                    x.AllowedHours
                });
            var mandetoryCourses = modifiedCoursesList
                                .Where(x => x.CourseType == (byte)CourseTypeEnum.Mandetory);
            var groupedElectiveCourses = modifiedCoursesList
                                .Where(x => x.CourseType == (byte)CourseTypeEnum.Elective)
                                .GroupBy(x => new { x.Level, x.Semester, x.CourseType, x.Category });
            var groupedUniCourses = modifiedCoursesList
                                .Where(x => x.CourseType == (byte)CourseTypeEnum.UniversityRequirement)
                                .GroupBy(x => new { x.Level, x.Semester, x.CourseType, x.Category });

            var mandetoryCoursesCount = mandetoryCourses.Count();
            var tableRowsCount = mandetoryCoursesWs.Table(0).RowCount() - 1;
            if (tableRowsCount < mandetoryCoursesCount)
            {
                var baseRow = mandetoryCoursesWs.Table(0).Row(2);
                for (int i = 0; i < mandetoryCoursesCount - tableRowsCount + 1; i++)
                {
                    mandetoryCoursesWs.Table(0).InsertRowsBelow(1);
                    baseRow.CopyTo(mandetoryCoursesWs.Table(0).Row(i + 3));
                }
            }
            for (int i = 0; i < mandetoryCoursesCount; i++)
            {
                mandetoryCoursesWs.Cell("A" + (i + 2)).Value = mandetoryCourses.ElementAt(i).CourseCode;
                mandetoryCoursesWs.Cell("C" + (i + 2)).Value = mandetoryCourses.ElementAt(i).PrerequisiteRelation;
                mandetoryCoursesWs.Cell("D" + (i + 2)).Value = mandetoryCourses.ElementAt(i).Prerequisites;
                mandetoryCoursesWs.Cell("E" + (i + 2)).Value = mandetoryCourses.ElementAt(i).AddtionYear;
                mandetoryCoursesWs.Cell("F" + (i + 2)).Value = mandetoryCourses.ElementAt(i).DeletionYear;
            }
            wb.Worksheets.TryGetWorksheet("المقررات الاختيارية", out var electiveCoursesWs);
            if (electiveCoursesWs == null) return null;
            var electiveWsTables = electiveCoursesWs.Tables;
            var tblIndex = 0;
            for (int i = 0; i < groupedElectiveCourses.Count(); i++)
            {
                var electiveCourses = groupedElectiveCourses.ElementAt(i);
                var electiveCoursesCount = electiveCourses.Count();
                tableRowsCount = electiveCoursesWs.Table(tblIndex).RowCount() - 1;
                var baseRow = electiveCoursesWs.Table(tblIndex).Row(2);
                var rowNo = baseRow.RangeAddress.FirstAddress.RowNumber;
                if (tableRowsCount < electiveCoursesCount)
                    for (int j = 0; j < electiveCoursesCount - tableRowsCount + 1; j++)
                    {
                        electiveWsTables.ElementAt(tblIndex).InsertRowsBelow(1);
                        baseRow.CopyTo(electiveCoursesWs.Table(tblIndex).Row(j + 3));
                    }
                electiveCoursesWs.Cell("D" + (rowNo - 2)).Value = electiveCourses.ElementAt(0).AllowedHours ?? electiveCourses.Sum(x => x.CreditHours);
                for (int j = 0; j < electiveCoursesCount; j++)
                {
                    electiveCoursesWs.Cell("A" + rowNo).Value = electiveCourses.ElementAt(j).CourseCode;
                    electiveCoursesWs.Cell("C" + rowNo).Value = electiveCourses.ElementAt(j).PrerequisiteRelation;
                    electiveCoursesWs.Cell("D" + rowNo).Value = electiveCourses.ElementAt(j).Prerequisites;
                    electiveCoursesWs.Cell("E" + rowNo).Value = electiveCourses.ElementAt(j).AddtionYear;
                    electiveCoursesWs.Cell("F" + rowNo).Value = electiveCourses.ElementAt(j).DeletionYear;
                    rowNo++;
                }
                tblIndex++;
            }

            wb.Worksheets.TryGetWorksheet("مقررات متطلب الجامعة", out var uniCoursesWs);
            if (uniCoursesWs == null) return null;
            var uniWsTables = uniCoursesWs.Tables;
            tblIndex = 0;
            for (int i = 0; i < groupedUniCourses.Count(); i++)
            {
                var uniCourses = groupedUniCourses.ElementAt(i);
                var uniCoursesCount = uniCourses.Count();
                tableRowsCount = uniCoursesWs.Table(tblIndex).RowCount() - 1;
                var baseRow = uniCoursesWs.Table(tblIndex).Row(2);
                var rowNo = baseRow.RangeAddress.FirstAddress.RowNumber;
                if (tableRowsCount < uniCoursesCount)
                    for (int j = 0; j < uniCoursesCount - tableRowsCount + 1; j++)
                    {
                        uniWsTables.ElementAt(tblIndex).InsertRowsBelow(1);
                        baseRow.CopyTo(uniCoursesWs.Table(tblIndex).Row(j + 3));
                    }
                uniCoursesWs.Cell("D" + (rowNo - 2)).Value = uniCourses.ElementAt(0).AllowedHours ?? uniCourses.Sum(x => x.CreditHours);
                for (int j = 0; j < uniCoursesCount; j++)
                {
                    uniCoursesWs.Cell("A" + rowNo).Value = uniCourses.ElementAt(j).CourseCode;
                    uniCoursesWs.Cell("C" + rowNo).Value = uniCourses.ElementAt(j).PrerequisiteRelation;
                    uniCoursesWs.Cell("D" + rowNo).Value = uniCourses.ElementAt(j).Prerequisites;
                    uniCoursesWs.Cell("E" + rowNo).Value = uniCourses.ElementAt(j).AddtionYear;
                    uniCoursesWs.Cell("F" + rowNo).Value = uniCourses.ElementAt(j).DeletionYear;
                    rowNo++;
                }
                tblIndex++;
            }
            mandetoryCoursesWs.Columns().AdjustToContents();
            electiveCoursesWs.Columns().AdjustToContents();
            uniCoursesWs.Columns().AdjustToContents();
            return ExcelCommon.SaveAsStream(wb);
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
            model.programData = new ProgramDataModel();
            model.programData.Name = programDataWs.Cell("B1").Value.GetText();
            model.programData.EnglishName = programDataWs.Cell("B2").Value.GetText();
            model.programData.ArabicName = programDataWs.Cell("B3").Value.GetText();
            model.programData.Semester = programDataWs.GetCellValueAsByte("B4");
            model.programData.Percentage = programDataWs.Cell("B6").Value.GetNumber();
            if (string.IsNullOrEmpty(model.programData.Name) ||
                string.IsNullOrEmpty(model.programData.EnglishName) ||
                string.IsNullOrEmpty(model.programData.ArabicName) ||
                string.IsNullOrEmpty(model.programData.Semester.ToString()) ||
                string.IsNullOrEmpty(model.programData.Percentage.ToString()))
                return null;
            model.programData.SuperProgramID = programs.FirstOrDefault(x => x.Name == programDataWs.Cell("B7").Value.GetText())?.Id;
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
    }
}