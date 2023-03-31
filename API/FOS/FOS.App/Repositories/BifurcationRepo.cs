using Dapper;
using FOS.App.ExcelReader;
using FOS.App.Helpers;
using FOS.Core;
using FOS.Core.IRepositories;
using FOS.Core.Models.StoredProcedureOutputModels;
using Microsoft.Data.SqlClient;
using System.Data;

namespace FOS.App.Repositories
{
    public class BifurcationRepo : IBifurcationRepo
    {
        private readonly IAcademicYearRepo academicYearRepo;
        private readonly IDbContext config;

        public BifurcationRepo(IAcademicYearRepo academicYearRepo, IDbContext config)
        {
            this.academicYearRepo = academicYearRepo;
            this.config = config;
        }
        public Stream BifurcateStudents()
        {
            //Get all data from desires table
            var studentsDesireslst = QueryExecuterHelper.Execute<StudentDesiresOutModel>
                (config.CreateInstance(), "GetAllStudentsDesires", null);
            var programs = studentsDesireslst
                .Select(x => new { ID = x.ProgramID, Percentage = x.ProgramPercentage })
                .Distinct();
            //Create Dictionary to calculate number of student per program
            IDictionary<int, int> studentsCountPerProgram = new Dictionary<int, int>();
            for (var i = 0; i < programs.Count(); i++)
            {
                var program = programs.ElementAt(i);
                //Get totalcount of student in program i.e.(Math)
                var stdsCount = studentsDesireslst.Where(x => x.ProgramID == program.ID).Count();
                int perctange;
                //If greater than 1, this means programs accepts exact number of students and not a percentage
                if (program.Percentage > 1)
                    perctange = (int)program.Percentage;
                //If less than one then get percentage from total students count
                else if (program.Percentage < 1)
                    perctange = (int)Math.Ceiling(program.Percentage * stdsCount);
                //Accepts all students
                else
                    perctange = stdsCount;
                studentsCountPerProgram.Add(program.ID, perctange);
            }
            var studentsGroupedByProgram = studentsDesireslst.GroupBy(x => x.StudentCurrentProgramID);
            var currentAcademicYear = academicYearRepo.GetCurrentYear();
            List<StudentProgramInsertParamModel> studentProgram = new();
            Parallel.For(0, studentsGroupedByProgram.Count(), index =>
            {
                var students = studentsGroupedByProgram.ElementAt(index)//.ElementAt(index)
                                                .GroupBy(x => x.StudentID);
                //Loop through students
                for (int i = 0; i < students.Count(); i++)
                {
                    var desires = students.ElementAt(i);
                    //Loop through student desires
                    for (int j = 0; j < desires.Count(); j++)
                    {
                        var desire = desires.ElementAt(j);
                        //Check if program has avaiable seats
                        //If yes then add student to the program
                        studentsCountPerProgram.TryGetValue(desire.ProgramID, out int availablePlaces);
                        if (availablePlaces > 0)
                        {
                            studentProgram.Add(new StudentProgramInsertParamModel
                            {
                                AcademicYear = currentAcademicYear.Id,
                                ProgramId = desire.ProgramID,
                                StudentId = desire.StudentID,
                                CGPA = desire.CGPA,
                                ProgramName = desire.ProgramName
                            });
                            studentsCountPerProgram[desire.ProgramID] = availablePlaces - 1;
                            break;
                        }
                    }
                }
            });
            var res = AddStudentsToPrograms(studentProgram);
            if (!res)
                return null;
            //Summary for each program to get min GPA and accepted students count
            var programsLst = studentProgram.GroupBy(x => x.ProgramId);
            return StudentBirfucationSummary.Create(programsLst, studentsCountPerProgram);
        }
        public bool AddStudentsToPrograms(List<StudentProgramInsertParamModel> studentProgram)
        {
            if (studentProgram == null || studentProgram.Count < 1)
                return false;
            var dt = new DataTable();
            dt.Columns.Add("ProgramID");
            dt.Columns.Add("StudentID");
            dt.Columns.Add("AcademicYearID");
            for (var i = 0; i < studentProgram.Count; i++)
            {
                dt.Rows.Add(studentProgram[i].ProgramId, studentProgram[i].StudentId, studentProgram[i].AcademicYear);
            }
            return QueryExecuterHelper.Execute(config.CreateInstance(), "AddStudentsToPrograms", new List<SqlParameter>()
            {
                QueryExecuterHelper.DataTableToSqlParameter(dt,"StudentProgram","StudentsProgramsType"),
            });
        }
        /// <summary>
        /// Method to execute a stored procedure that removes old StudentDesire and add new desires
        /// </summary>
        /// <param name="desires"></param>
        /// <returns></returns>
        public bool AddDesires(int? currentProgramID, int studentID, List<byte> desires)
        {
            var dt = new DataTable();
            dt.Columns.Add("ProgramID");
            dt.Columns.Add("DesireNumber");
            for (var i = 0; i < desires.Count; i++)
            {
                dt.Rows.Add(desires[i], i + 1);
            }
            return QueryExecuterHelper.Execute(config.CreateInstance(), "AddStudentDesires", new List<SqlParameter>()
            {
                QueryExecuterHelper.DataTableToSqlParameter(dt,"Desires","StudentDesiresType"),
                new SqlParameter("@StudentID", studentID),
                new SqlParameter("@CurrentProgramID", currentProgramID)
            });
        }
        /// <summary>
        /// Method to get student desires from database
        /// </summary>
        /// <param name="guid"></param>
        /// <returns></returns>
        public List<DesireProgramsOutModel> GetDesires(int id)
        {
            DynamicParameters parameters = new DynamicParameters();
            parameters.Add("@ID", id);
            return QueryExecuterHelper.Execute<DesireProgramsOutModel>
                (config.CreateInstance(),
                 "GetStudentDesires",
                 parameters);
        }
        public class StudentProgramInsertParamModel
        {
            public int ProgramId { get; set; }
            public int StudentId { get; set; }
            public int AcademicYear { get; set; }
            public float CGPA { get; set; }
            public string ProgramName { get; set; }
        }
        private class StudentDesiresOutModel
        {
            public int ProgramID { get; set; }
            public string ProgramName { get; set; }
            public float ProgramPercentage { get; set; }
            public int StudentCurrentProgramID { get; set; }
            public int StudentID { get; set; }
            public float CGPA { get; set; }
        }
    }
}
