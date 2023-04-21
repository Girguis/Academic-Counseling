using Dapper;
using FOS.App.Helpers;
using FOS.Core;
using FOS.Core.IRepositories;
using FOS.Core.Models;
using FOS.Core.Models.ParametersModels;
using FOS.Core.SearchModels;
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

        public bool AddProgram(ProgramModel model)
        {
            var coursesLstDt = new DataTable();
            coursesLstDt.Columns.Add("CourseID");
            coursesLstDt.Columns.Add("PrerequisiteRelationID");
            coursesLstDt.Columns.Add("CourseType");
            coursesLstDt.Columns.Add("Category");
            coursesLstDt.Columns.Add("AddtionYearID");
            coursesLstDt.Columns.Add("DeletionYearID");
            for (int i = 0; i < model.CoursesList.Count; i++)
            {
                var course = model.CoursesList.ElementAt(i);
                coursesLstDt.Rows.Add(course.CourseId, course.PrerequisiteRelationId, course.CourseType, course.Category, course.AddtionYearId, course.DeletionYearId);
            }

            var prerequisiteCoursesLstDt = new DataTable();
            prerequisiteCoursesLstDt.Columns.Add("CourseID");
            prerequisiteCoursesLstDt.Columns.Add("PrerequisiteCourseID");
            for (int i = 0; i < model.PrerequisiteCoursesList.Count; i++)
            {
                var prereqCourse = model.PrerequisiteCoursesList.ElementAt(i);
                prerequisiteCoursesLstDt.Rows.Add(prereqCourse.CourseId, prereqCourse.PrerequisiteCourseId);
            }

            var programDistributionLstDt = new DataTable();
            programDistributionLstDt.Columns.Add("Level");
            programDistributionLstDt.Columns.Add("Semester");
            programDistributionLstDt.Columns.Add("NumberOfHours");
            for (int i = 0; i < model.ProgramHoursDistributionList.Count; i++)
            {
                var progDist = model.ProgramHoursDistributionList.ElementAt(i);
                programDistributionLstDt.Rows.Add(progDist.Level, progDist.Semester, progDist.NumberOfHours);
            }

            var electiveCourseDistributionLstDt = new DataTable();
            electiveCourseDistributionLstDt.Columns.Add("Level");
            electiveCourseDistributionLstDt.Columns.Add("Semester");
            electiveCourseDistributionLstDt.Columns.Add("CourseType");
            electiveCourseDistributionLstDt.Columns.Add("Category");
            electiveCourseDistributionLstDt.Columns.Add("Hour");
            for (int i = 0; i < model.ElectiveCoursesDistributionList.Count; i++)
            {
                var elecCourse = model.ElectiveCoursesDistributionList.ElementAt(i);
                electiveCourseDistributionLstDt.Rows.Add(elecCourse.Level, elecCourse.Semester, elecCourse.CourseType, elecCourse.Category, elecCourse.Hour);
            }

            List<SqlParameter> parameters = new List<SqlParameter>() {
                new SqlParameter("@Name", model.programData.Name),
                new SqlParameter("@SuperProgramID", model.programData.SuperProgramID),
                new SqlParameter("@Semester", model.programData.Semester),
                new SqlParameter("@Percentage", model.programData.Percentage),
                new SqlParameter("@IsRegular", model.programData.IsRegular),
                new SqlParameter("@IsGeneral", model.programData.IsGeneral),
                new SqlParameter("@TotalHours", model.programData.TotalHours),
                new SqlParameter("@EnglishName", model.programData.EnglishName),
                new SqlParameter("@ArabicName", model.programData.ArabicName),
                QueryExecuterHelper.DataTableToSqlParameter(coursesLstDt,"CoursesList","ProgramCoursesType"),
                QueryExecuterHelper.DataTableToSqlParameter(prerequisiteCoursesLstDt,"PrerequisiteCoursesList","PrerequisiteCoursesType"),
                QueryExecuterHelper.DataTableToSqlParameter(programDistributionLstDt,"ProgramDistributionList","ProgramDistributionType"),
                QueryExecuterHelper.DataTableToSqlParameter(electiveCourseDistributionLstDt,"ElectiveCourseDistributionList","ElectiveCourseDistributionType"),
            };
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
        public ProgramBasicDataDTO GetProgram(int id)
        {
            DynamicParameters parameters = new DynamicParameters();
            parameters.Add("@ID", id);
            return QueryExecuterHelper.Execute<ProgramBasicDataDTO>(config.CreateInstance(),
                "GetProgramByID", parameters).FirstOrDefault();
        }
        public List<ProgramBasicDataDTO> GetPrograms(int? superProgID = null)
        {
            DynamicParameters parameter = new DynamicParameters();
            parameter.Add("@ProgramID", superProgID);
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

        public bool UpdateProgramBasicData(ProgramBasicDataUpdateParamModel model)
        {
            List<SqlParameter> parameters = new List<SqlParameter>()
            {
                new SqlParameter("@ID",model.Id),
                new SqlParameter("@Name",model.Name),
                new SqlParameter("@Semester",model.Semester),
                new SqlParameter("@Percentage",model.Percentage),
                new SqlParameter("@IsRegular",model.IsRegular),
                new SqlParameter("@IsGeneral",model.IsGeneral),
                new SqlParameter("@TotalHours",model.TotalHours),
                new SqlParameter("@ArabicName",model.ArabicName),
                new SqlParameter("@EnglishName",model.EnglishName),
            };
            if (model.SuperProgramId.HasValue)
                parameters.Add(new SqlParameter("@SuperProgramId", model.SuperProgramId.Value));
            return QueryExecuterHelper.Execute(config.CreateInstance(),
                "UpdateProgramBasicData", parameters);
        }
    }
}
