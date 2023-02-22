﻿using FOS.App.Helpers;
using FOS.Core.IRepositories;
using FOS.Core.Models;
using FOS.Core.SearchModels;
using FOS.DB.Models;
using Microsoft.Data.SqlClient;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using System.Data;

namespace FOS.App.Repositories
{
    public class ProgramRepo : IProgramRepo
    {
        private readonly FOSContext context;
        private readonly IConfiguration configuration;
        private readonly string connectionString;

        public ProgramRepo(FOSContext context, IConfiguration configuration)
        {
            this.context = context;
            this.configuration = configuration;
            connectionString = this.configuration["ConnectionStrings:FosDB"];
        }

        public bool AddProgram(ProgramModel model)
        {
            var coursesLstDt = new DataTable();
            coursesLstDt.Columns.Add("CourseID");
            coursesLstDt.Columns.Add("PrerequisiteRelationID");
            coursesLstDt.Columns.Add("CourseType");
            coursesLstDt.Columns.Add("Category");
            for (int i = 0; i < model.CoursesList.Count; i++)
            {
                var course = model.CoursesList.ElementAt(i);
                coursesLstDt.Rows.Add(course.CourseId, course.PrerequisiteRelationId, course.CourseType, course.Category);
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
                QueryHelper.DataTableToSqlParameter(coursesLstDt,"CoursesList","ProgramCoursesType"),
                QueryHelper.DataTableToSqlParameter(prerequisiteCoursesLstDt,"PrerequisiteCoursesList","PrerequisiteCoursesType"),
                QueryHelper.DataTableToSqlParameter(programDistributionLstDt,"ProgramDistributionList","ProgramDistributionType"),
                QueryHelper.DataTableToSqlParameter(electiveCourseDistributionLstDt,"ElectiveCourseDistributionList","ElectiveCourseDistributionType"),
            };
            return QueryHelper.Execute(connectionString, "AddProgram", parameters);
        }

        /// <summary>
        /// Method to get details of a certain program by id
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        public Program GetProgram(int id)
        {
            return context.Programs.FirstOrDefault(x => x.Id == id);
        }
        public List<Program> GetPrograms()
        {
            return context.Programs.AsParallel().ToList();
        }
        public List<Program> GetPrograms(out int totalCount, SearchCriteria criteria)
        {
            DbSet<Program> programs = context.Programs;
            return DataFilter<Program>.FilterData(programs, criteria, out totalCount);
        }
    }
}
