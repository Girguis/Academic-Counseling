using Dapper;
using FOS.App.Comparers;
using FOS.App.Helpers;
using FOS.Core;
using FOS.Core.IRepositories;
using FOS.Core.Models;
using FOS.Core.Models.ParametersModels;
using FOS.DB.Models;
using Microsoft.Data.SqlClient;
using System.Data;

namespace FOS.App.Repositories
{
    public class StudentProgramRepo : IStudentProgramRepo
    {
        private readonly IDbContext config;

        public StudentProgramRepo(IDbContext config)
        {
            this.config = config;
        }

        public bool AddStudentPrograms(List<StudentProgramModel> model)
        {
            var savedStudentProgramsLst = GetAllStudentPrograms(model.ElementAt(0).StudentId);
            var studentPrograms = model.Select(x => new StudentProgram()
            {
                StudentId = x.StudentId,
                AcademicYear = x.AcademicYear,
                ProgramId = x.ProgramId,
                AcademicYearNavigation = null,
                Program = null,
                Student = null
            });
            StudentProgramComparer programComparer = new StudentProgramComparer();
            IEnumerable<StudentProgram> toBeSavedLst = studentPrograms.Except(savedStudentProgramsLst, programComparer);
            if (!toBeSavedLst.Any())
                return true;
            var dt = new DataTable();
            dt.Columns.Add("ProgramID");
            dt.Columns.Add("StudentID");
            dt.Columns.Add("AcademicYearID");
            for (var i = 0; i < toBeSavedLst.Count(); i++)
                dt.Rows.Add(toBeSavedLst.ElementAt(i).ProgramId, toBeSavedLst.ElementAt(i).StudentId, toBeSavedLst.ElementAt(i).AcademicYear);

            return QueryExecuterHelper.Execute(config.CreateInstance(), "AddStudentsToPrograms",
                new List<SqlParameter>()
                {
                    QueryExecuterHelper.DataTableToSqlParameter(dt, "StudentProgram", "StudentsProgramsType")
                });
        }

        public IEnumerable<StudentProgram> GetAllStudentPrograms(int studentID)
        {
            using var con = config.CreateInstance();
            return con.Query<StudentProgram>("SELECT * FROM StudentPrograms WHERE StudentID = " + studentID);
        }

        public List<DropDownModel> GetProgramsListForProgramTransfer(int programID)
        {
            DynamicParameters parameters = new DynamicParameters();
            parameters.Add("@ProgramID", programID);
            return QueryExecuterHelper.Execute<DropDownModel>(config.CreateInstance(),
                "GetProgramsListForProgramTransfer",
                parameters);
        }
        public bool ProgramTransferRequest(int studentID, ProgramTransferParamModel model)
        {
            return QueryExecuterHelper.Execute(config.CreateInstance()
                , "SubmitStudentProgramTransferRequest",
                new List<SqlParameter>
            {
                new SqlParameter("@StudentID",studentID),
                new SqlParameter("@ProgramID",model.ProgramID),
                new SqlParameter("@ReasonForTransfer",model.ReasonForTransfer)
            });
        }
    }
}
