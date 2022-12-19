using FOS.Core.IRepositories.Supervisor;
using FOS.DB.Models;
using Microsoft.Data.SqlClient;
using Microsoft.EntityFrameworkCore;
using System.Data;

namespace FOS.App.Supervisor.Repositories
{
    public class BifurcationRepo : IBifurcationRepo
    {
        private readonly FOSContext context;
        private readonly IAcademicYearRepo academicYearRepo;

        public BifurcationRepo(FOSContext context, IAcademicYearRepo academicYearRepo)
        {
            this.context = context;
            this.academicYearRepo = academicYearRepo;
        }
        public object BifurcateStudents()
        {
            //Get all data from desires table
            var studentsDesireslst = context.StudentDesires
                .Include(x => x.Student)
                .Include(x => x.Program)
                .OrderByDescending(g => g.Student.Cgpa)
                .ThenBy(x => x.DesireNumber)
                .ToList();
            var programs = studentsDesireslst.Select(x => x.Program).Distinct();
            //Create Dictionary to calculate number of student per program
            IDictionary<int, int> studentsCountPerProgram = new Dictionary<int, int>();
            for (var i = 0; i < programs.Count(); i++)
            {
                var program = programs.ElementAt(i);
                //Get totalcount of student in program i.e.(Math)
                var stdsCount = studentsDesireslst.Where(x => x.ProgramId == program.Id).Count();
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
                studentsCountPerProgram.Add(program.Id, perctange);
            }
            var students = studentsDesireslst.GroupBy(x => x.StudentId);
            var currentAcademicYear = academicYearRepo.GetCurrentYear();
            List<StudentProgram> studentProgram = new();
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
                    studentsCountPerProgram.TryGetValue(desire.ProgramId.Value, out int availablePlaces);
                    if (availablePlaces > 0)
                    {
                        studentProgram.Add(new StudentProgram
                        {
                            Student = desire.Student,
                            Program = desire.Program,
                            AcademicYear = currentAcademicYear.Id,
                            ProgramId = desire.ProgramId.Value,
                            StudentId = desire.StudentId.Value,
                        });
                        studentsCountPerProgram[desire.ProgramId.Value] = availablePlaces - 1;
                        break;
                    }
                }
            }
            var res = AddStudentsToPrograms(studentProgram);
            if (!res)
                return null;
            //Summary for each program to get min GPA and accepted students count
            var programsLst = studentProgram.GroupBy(x => x.Program);
            List<object> programMinGPA = new();
            for (int i = 0; i < programsLst.Count(); i++)
            {
                var currentProgram = programsLst.ElementAt(i);
                programMinGPA.Add(new
                {
                    ProgramName = currentProgram.Key.Name,
                    StudentCount = currentProgram.Count(),
                    MinGPA = currentProgram.OrderBy(x => x.Student.Cgpa).FirstOrDefault().Student.Cgpa,
                    AvaiableSeats = studentsCountPerProgram[currentProgram.Key.Id]
                });
            }
            return programMinGPA;
        }
        public bool AddStudentsToPrograms(List<StudentProgram> studentProgram)
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
            var studentProgramParam = new SqlParameter("@StudentProgram", dt);
            studentProgramParam.SqlDbType = SqlDbType.Structured;
            studentProgramParam.TypeName = "[dbo].[StudentsProgramsType]";

            return context.Database.ExecuteSqlRaw("EXEC [dbo].[AddStudentsToPrograms] @StudentProgram", studentProgramParam) > 0;
        }
    }
}
