﻿using FOS.Core.IRepositories;
using FOS.DB.Models;
using Microsoft.Data.SqlClient;
using Microsoft.EntityFrameworkCore;
using System.Data;

namespace FOS.App.Repositories
{
    public class BifurcationRepo : IBifurcationRepo
    {
        private readonly FOSContext context;
        private readonly IAcademicYearRepo academicYearRepo;
        private readonly IStudentRepo studentRepo;

        public BifurcationRepo(FOSContext context, IAcademicYearRepo academicYearRepo, IStudentRepo studentRepo)
        {
            this.context = context;
            this.academicYearRepo = academicYearRepo;
            this.studentRepo = studentRepo;
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
                    studentsCountPerProgram.TryGetValue(desire.ProgramId, out int availablePlaces);
                    if (availablePlaces > 0)
                    {
                        studentProgram.Add(new StudentProgram
                        {
                            Student = desire.Student,
                            Program = desire.Program,
                            AcademicYear = currentAcademicYear.Id,
                            ProgramId = desire.ProgramId,
                            StudentId = desire.StudentId,
                        });
                        studentsCountPerProgram[desire.ProgramId] = availablePlaces - 1;
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
        /// <summary>
        /// Method to execute a stored procedure that removes old StudentDesire and add new desires
        /// </summary>
        /// <param name="desires"></param>
        /// <returns></returns>
        public bool AddDesires(int studentID, List<byte> desires)
        {
            var studentIdParam = new SqlParameter("@StudentID", studentID);
            var dt = new DataTable();
            dt.Columns.Add("ProgramID");
            dt.Columns.Add("DesireNumber");
            for (var i = 0; i < desires.Count; i++)
            {
                dt.Rows.Add(desires[i], i + 1);
            }
            var desiresParam = new SqlParameter("@Desires", dt);
            desiresParam.SqlDbType = SqlDbType.Structured;
            desiresParam.TypeName = "[dbo].[StudentDesiresType]";

            return context.Database.ExecuteSqlRaw("EXEC [dbo].[AddStudentDesires] @Desires, @StudentID", desiresParam, studentIdParam) > 0;
        }
        /// <summary>
        /// Method to get programs that student can choose from
        /// i.e i'm a first year CS student and we are in the second term
        /// this function will send me 2 programs CS pure and CS/Math
        /// </summary>
        /// <param name="guid"></param>
        /// <returns></returns>
        public List<Program> GetAvailableProgram(string guid)
        {
            DB.Models.Student student = studentRepo.Get(guid);
            Program studentProgram = studentRepo.GetCurrentProgram(guid).Program;
            List<Program> subPrograms = new List<Program>();
            if (studentProgram == null)
            {
                subPrograms = context.ProgramRelations
                .Where(x => x.Program == null)
                .Include(x => x.SubProgram)
                .Select(x => x.SubProgram)
                .ToList();
            }
            else
            {
                subPrograms = context.ProgramRelations
                .Where(x => x.ProgramId == studentProgram.Id)
                .Include(x => x.SubProgram)
                .Select(x => x.SubProgram)
                .ToList();
            }
            List<Program> result = subPrograms
                .Where(x => x.Semester == student.SemestersNumberInProgram & x.Semester % 2 == academicYearRepo.GetCurrentYear().Semester % 2)
                .ToList();
            return result;
        }
        /// <summary>
        /// Method to get student desires from database
        /// </summary>
        /// <param name="guid"></param>
        /// <returns></returns>
        public List<StudentDesire> GetDesires(string guid)
        {
            IQueryable<StudentDesire> desires = context.StudentDesires.Where(x => x.Student.Guid == guid).Include(x => x.Program);
            if (desires.Count() < 1)
                return null;
            return desires.ToList();
        }

    }
}