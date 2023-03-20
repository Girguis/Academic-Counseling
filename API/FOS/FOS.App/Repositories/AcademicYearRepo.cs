using FOS.Core.IRepositories;
using FOS.DB.Models;
using Microsoft.EntityFrameworkCore;

namespace FOS.App.Repositories
{
    public class AcademicYearRepo : IAcademicYearRepo
    {
        private readonly FOSContext context;

        public AcademicYearRepo(FOSContext context)
        {
            this.context = context;
        }
        /// <summary>
        /// Method used to add new Academic year to DB
        /// </summary>
        /// <returns></returns>
        public bool StartNewYear()
        {
            AcademicYear currentAcademicYear = GetCurrentYear();
            var newSemester = (byte)(currentAcademicYear.Semester % 3.0 + 1);
            string newYear = currentAcademicYear.AcademicYear1;
            if (newSemester == 1)
            {
                _ = int.TryParse(currentAcademicYear?.AcademicYear1?.ToString()?.Split("/")[0], out int year);
                newYear = (year + 1) + "/" + (year + 2);
            }
            AcademicYear newAcademicYear = new AcademicYear()
            {
                Semester = newSemester,
                AcademicYear1 = newYear
            };
            context.AcademicYears.Add(newAcademicYear);
            var added = context.SaveChanges() > 0;
            context.Database.ExecuteSqlInterpolated($"DELETE FROM StudentDesires");
            return added;
        }
        /// <summary>
        /// Method used to get current academic year details
        /// </summary>
        /// <returns></returns>
        public AcademicYear GetCurrentYear()
        {
            return context.AcademicYears
                   .OrderByDescending(x => x.Id)
                   .FirstOrDefault();
        }
        public List<AcademicYear> GetAcademicYearsList()
        {
            return context.AcademicYears.AsNoTracking().ToList();
        }
        /// <summary>
        /// Method used to calulate semester GPA for any student in any academic year
        /// </summary>
        /// <param name="studentID"></param>
        /// <param name="academicYear"></param>
        /// <returns>semester GPA</returns>
        public double? GetAcademicYearGPA(int studentID, short academicYear)
        {
            List<StudentCourse> coureses = context.StudentCourses.Where(x => x.StudentId == studentID & x.AcademicYearId == academicYear).Include("Course").ToList();
            double? sGpa = coureses.Sum(x => x.Points * x.Course.CreditHours);
            sGpa /= coureses.Sum(x => x.Course.CreditHours);
            return sGpa;
        }
        /// <summary>
        /// Method to retrive all academic years which student enrolled in 1 course or more in it
        /// </summary>
        /// <param name="studentID"></param>
        /// <returns></returns>
        public List<AcademicYear> GetAll(int studentID)
        {
            return context.StudentCourses
                .Where(x => x.StudentId == studentID)
                .Select(x => x.AcademicYear)
                .Distinct()
                .ToList();
        }
    }
}
