using ClosedXML.Excel;
using FOS.Core.Enums;
using FOS.Core.Models;
using FOS.Core.Models.ParametersModels;
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
        public static Stream Create(Program program)
        {
            return new MemoryStream();
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
            var electiveTables = electiveCoursesWs.Tables;
            for (int i = 0; i < electiveTables.Count(); i++)
            {
                var tableCells = electiveTables.ElementAt(i).CellsUsed();
                for (int j = 0; j < tableCells.Count(); j++)
                {
                    var index = tableCells.ElementAt(j).Address.RowNumber + j + 1;
                    (bool isValid, bool isEmpty,
                    ProgramCourseModel programCourseModel,
                    List<PrerequisiteCourseModel> prerequisiteCourseModel)
                        = electiveCoursesWs.ReadCourseRow((byte)i, CourseTypeEnum.Elective,
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
                        model.ElectiveCoursesDistributionList.Add(electiveCoursesWs
                            .GetElectiveHour(
                                            tableCells.ElementAt(1).Address.RowNumber, (byte)i,
                                            (byte)CourseTypeEnum.Elective, course.Level, course.Semester));
                    }
                }
            }
            //End Of Elective Courses Sheet
            //Start Of University Requirement Courses Sheet
            if (!wb.TryGetWorksheet("مقررات متطلب الجامعة", out var uniReqCoursesWs))
                return null;
            var uniReqTables = uniReqCoursesWs.Tables;
            for (int i = 0; i < uniReqTables.Count(); i++)
            {
                var tableCells = uniReqTables.ElementAt(i).CellsUsed();
                for (int j = 0; j < tableCells.Count(); j++)
                {
                    var index = tableCells.ElementAt(j).Address.RowNumber + j + 1;
                    (bool isValid, bool isEmpty,
                    ProgramCourseModel programCourseModel,
                    List<PrerequisiteCourseModel> prerequisiteCourseModel)
                    = uniReqCoursesWs.ReadCourseRow((byte)i, CourseTypeEnum.UniversityRequirement,
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
                        model.ElectiveCoursesDistributionList.Add(uniReqCoursesWs
                            .GetElectiveHour(
                                            tableCells.ElementAt(0).Address.RowNumber, (byte)i,
                                            (byte)CourseTypeEnum.UniversityRequirement, course.Level, course.Semester));
                    }
                }
            }
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
            else if (courseID == null)
                return (false, isEmpty, null, null);
            else
            {
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
            else if (prereqRelationID == (byte)PrerequisiteCoursesRelationEnum.OnePrerequisite)
            {
                var prereqCourseID = courses.FirstOrDefault(x => x.CourseCode.Replace(" ", "").ToLower() == prereqCoursesCodes.Split(",")[0])?.Id;
                if (prereqCourseID == null)
                    return null;
                return new List<PrerequisiteCourseModel>()
                {
                    new PrerequisiteCourseModel(){ PrerequisiteCourseId = prereqCourseID.Value,CourseId = courseID }
                };
            }
            else
            {
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
        }
        private static short? GetYearID(string yearStr, List<AcademicYear> academicYears, bool isDeleteYearCell = false)
        {
            if (string.IsNullOrEmpty(yearStr) && isDeleteYearCell)
                return null;
            else if (string.IsNullOrEmpty(yearStr))
                return academicYears.FirstOrDefault()?.Id;
            else
            {
                var splited = yearStr.Split(" - ");
                return academicYears.FirstOrDefault(x => x.AcademicYear1 == splited[0]
                && x.Semester == Helpers.Helper.GetSemesterNumber(splited[1]))?.Id;
            }
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
        private static IXLWorkbook GetTemplate()
        {
            return new XLWorkbook("Program Template.xlsx");
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