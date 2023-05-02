using Dapper;
using FOS.App.Helpers;
using FOS.Core;
using FOS.Core.IRepositories;
using FOS.Core.Models;
using FOS.Core.Models.ParametersModels;
using FOS.Core.Models.StoredProcedureOutputModels;
using FOS.Core.SearchModels;
using FOS.DB.Models;
using Microsoft.Data.SqlClient;
using System.Data;

namespace FOS.App.Repositories
{
    public class ProgramRepo : IProgramRepo
    {
        private readonly IDbContext config;

        public ProgramRepo(IDbContext config)
        {
            this.config = config;
        }
        private static DataTable GetCoursesListDT(List<ProgramCourseModel> coursesList)
        {
            var coursesLstDt = new DataTable();
            coursesLstDt.Columns.Add("CourseID");
            coursesLstDt.Columns.Add("PrerequisiteRelationID");
            coursesLstDt.Columns.Add("CourseType");
            coursesLstDt.Columns.Add("Category");
            coursesLstDt.Columns.Add("AddtionYearID");
            coursesLstDt.Columns.Add("DeletionYearID");
            for (int i = 0; i < coursesList.Count; i++)
            {
                var course = coursesList.ElementAt(i);
                coursesLstDt.Rows.Add(course.CourseId, course.PrerequisiteRelationId, course.CourseType, course.Category, course.AddtionYearId, course.DeletionYearId);
            }
            return coursesLstDt;
        }
        private static DataTable GetPrerequisiteCoursesListDT(List<PrerequisiteCourseModel> prerequisiteCoursesList)
        {
            var prerequisiteCoursesLstDt = new DataTable();
            prerequisiteCoursesLstDt.Columns.Add("CourseID");
            prerequisiteCoursesLstDt.Columns.Add("PrerequisiteCourseID");
            for (int i = 0; i < prerequisiteCoursesList.Count; i++)
            {
                var prereqCourse = prerequisiteCoursesList.ElementAt(i);
                prerequisiteCoursesLstDt.Rows.Add(prereqCourse.CourseId, prereqCourse.PrerequisiteCourseId);
            }
            return prerequisiteCoursesLstDt;
        }
        private static DataTable GetProgramDistributionDT(List<ProgramDistributionModel> programHoursDistributionList)
        {
            var programDistributionLstDt = new DataTable();
            programDistributionLstDt.Columns.Add("Level");
            programDistributionLstDt.Columns.Add("Semester");
            programDistributionLstDt.Columns.Add("NumberOfHours");
            for (int i = 0; i < programHoursDistributionList.Count; i++)
            {
                var progDist = programHoursDistributionList.ElementAt(i);
                programDistributionLstDt.Rows.Add(progDist.Level, progDist.Semester, progDist.NumberOfHours);
            }
            return programDistributionLstDt;
        }
        private static DataTable GetElectiveCoursesHoursDistributionDT(List<ElectiveCoursesDistributionModel> electiveCoursesDistributionList)
        {
            var electiveCourseDistributionLstDt = new DataTable();
            electiveCourseDistributionLstDt.Columns.Add("Level");
            electiveCourseDistributionLstDt.Columns.Add("Semester");
            electiveCourseDistributionLstDt.Columns.Add("CourseType");
            electiveCourseDistributionLstDt.Columns.Add("Category");
            electiveCourseDistributionLstDt.Columns.Add("Hour");
            for (int i = 0; i < electiveCoursesDistributionList.Count; i++)
            {
                var elecCourse = electiveCoursesDistributionList.ElementAt(i);
                electiveCourseDistributionLstDt.Rows.Add(elecCourse.Level, elecCourse.Semester, elecCourse.CourseType, elecCourse.Category, elecCourse.Hour);
            }
            return electiveCourseDistributionLstDt;
        }
        private static List<SqlParameter> GetStoredProcedureParameter(ProgramModel model)
        {
            return new List<SqlParameter>() {
                new SqlParameter("@Name", model.programData.Name),
                new SqlParameter("@SuperProgramID", model.programData.SuperProgramID),
                new SqlParameter("@Semester", model.programData.Semester),
                new SqlParameter("@Percentage", model.programData.Percentage),
                new SqlParameter("@IsRegular", model.programData.IsRegular),
                new SqlParameter("@IsGeneral", model.programData.IsGeneral),
                new SqlParameter("@TotalHours", model.programData.TotalHours),
                new SqlParameter("@EnglishName", model.programData.EnglishName),
                new SqlParameter("@ArabicName", model.programData.ArabicName),
                QueryExecuterHelper.DataTableToSqlParameter(GetCoursesListDT(model.CoursesList),"CoursesList","ProgramCoursesType"),
                QueryExecuterHelper.DataTableToSqlParameter(GetPrerequisiteCoursesListDT(model.PrerequisiteCoursesList),"PrerequisiteCoursesList","PrerequisiteCoursesType"),
                QueryExecuterHelper.DataTableToSqlParameter(GetProgramDistributionDT(model.ProgramHoursDistributionList),"ProgramDistributionList","ProgramDistributionType"),
                QueryExecuterHelper.DataTableToSqlParameter(GetElectiveCoursesHoursDistributionDT(model.ElectiveCoursesDistributionList),"ElectiveCourseDistributionList","ElectiveCourseDistributionType"),
            };
        }
        public bool AddProgram(ProgramModel model)
        {
            var parameters = GetStoredProcedureParameter(model);
            return QueryExecuterHelper.Execute(config.CreateInstance(),
                "AddProgram", parameters);
        }

        public List<string> GetAllProgramsNames(int? startSemester = null)
        {
            if (startSemester == null)
                return config.CreateInstance().Query<string>("SELECT Name FROM Program").ToList();
            else
                return config.CreateInstance().Query<string>("SELECT Name FROM Program WHERE Semester = " + startSemester.Value).ToList();
        }

        /// <summary>
        /// Method to get details of a certain program by id
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        public ProgramBasicDataDTO GetProgram(string id)
        {
            DynamicParameters parameters = new DynamicParameters();
            parameters.Add("@Guid", id);
            return QueryExecuterHelper.Execute<ProgramBasicDataDTO>(config.CreateInstance(),
                "GetProgramByID", parameters).FirstOrDefault();
        }
        public List<ProgramBasicDataDTO> GetPrograms(string superProgID = null)
        {
            DynamicParameters parameter = new DynamicParameters();
            parameter.Add("@ProgramGuid", superProgID);
            return QueryExecuterHelper.Execute<ProgramBasicDataDTO>(config.CreateInstance(),
                "GetAllSubPrograms",
                parameter);
        }
        public List<ProgramBasicDataDTO> GetPrograms(out int totalCount, SearchCriteria criteria)
        {
            DynamicParameters parameters = new DynamicParameters();
            parameters.Add("@Name", criteria.Filters.FirstOrDefault(x => x.Key.ToLower() == "name")?.Value?.ToString());
            parameters.Add("@Semester", criteria.Filters.FirstOrDefault(x => x.Key.ToLower() == "semester")?.Value?.ToString());
            parameters.Add("@Percentage", criteria.Filters.FirstOrDefault(x => x.Key.ToLower() == "percentage")?.Value?.ToString());
            parameters.Add("@IsRegular", criteria.Filters.FirstOrDefault(x => x.Key.ToLower() == "isregular")?.Value?.ToString());
            parameters.Add("@IsGeneral", criteria.Filters.FirstOrDefault(x => x.Key.ToLower() == "isgeneral")?.Value?.ToString());
            parameters.Add("@TotalHours", criteria.Filters.FirstOrDefault(x => x.Key.ToLower() == "totalhours")?.Value?.ToString());
            parameters.Add("@EnglishName", criteria.Filters.FirstOrDefault(x => x.Key.ToLower() == "englishname")?.Value?.ToString());
            parameters.Add("@ArabicName", criteria.Filters.FirstOrDefault(x => x.Key.ToLower() == "arabicname")?.Value?.ToString());
            parameters.Add("@SuperProgramID", criteria.Filters.FirstOrDefault(x => x.Key.ToLower() == "superprogramid")?.Value?.ToString());
            parameters.GetPageParameters(criteria, "sub.ID");
            var programs = QueryExecuterHelper.Execute<ProgramBasicDataDTO>
                (config.CreateInstance(),
                "GetPrograms",
                parameters);
            totalCount = QueryExecuterHelper.GetTotalCountParamValue(parameters, programs);
            return programs;
        }
        public bool UpdateProgram(int id, ProgramModel model)
        {
            var parameters = GetStoredProcedureParameter(model);
            parameters.Add(new SqlParameter("@ProgramID", id));
            return QueryExecuterHelper.Execute(config.CreateInstance(),
                "UpdateFullProgram", parameters);
        }
        public bool UpdateProgramBasicData(ProgramBasicDataUpdateParamModel model)
        {
            List<SqlParameter> parameters = new()
            {
                new SqlParameter("@Guid",model.Guid),
                new SqlParameter("@Name",model.Name),
                new SqlParameter("@Semester",model.Semester),
                new SqlParameter("@Percentage",model.Percentage),
                new SqlParameter("@IsRegular",model.IsRegular),
                new SqlParameter("@IsGeneral",model.IsGeneral),
                new SqlParameter("@TotalHours",model.TotalHours),
                new SqlParameter("@ArabicName",model.ArabicName),
                new SqlParameter("@EnglishName",model.EnglishName),
            };
            if (!string.IsNullOrEmpty(model.SuperProgramGuid))
                parameters.Add(new SqlParameter("@SuperProgramGuid", model.SuperProgramGuid));
            return QueryExecuterHelper.Execute(config.CreateInstance(),
                "UpdateProgramBasicData", parameters);
        }

        public ProgramDetailsOutModel GetProgramDetails(string id)
        {
            DynamicParameters parameters = new DynamicParameters();
            parameters.Add("@ProgramGuid", id);
            var con = config.CreateInstance();
            var queryResult = con.QueryMultiple("GetProgramDetails", parameters, commandType: CommandType.StoredProcedure);
            ProgramDetailsOutModel model = new()
            {
                BasicData = queryResult.ReadFirstOrDefault<ProgramBasicDataDTO>(),
                ProgramHoursDistribution = queryResult.Read<ProgramDistribution>()?.ToList(),
                Courses = queryResult.Read<CoursesDetailsForExcel>()?.ToList()
            };
            return model;
        }
    }
}
