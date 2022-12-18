using FOS.Core.IRepositories.Student;
using FOS.DB.Models;
using Microsoft.EntityFrameworkCore;

namespace FOS.App.Student.Repositories
{
    public class AcademicYearRepo : IAcademicYearRepo
    {
        private readonly FOSContext context;
        public AcademicYearRepo(FOSContext context)
        {
            this.context = context;
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
        /// <summary>
        /// Method to retrive current academic year details
        /// </summary>
        /// <returns>AcademicYear</returns>
        public AcademicYear GetCurrentYear()
        {
            return context.AcademicYears
                   .OrderByDescending(x => x.Id)
                   .FirstOrDefault();
        }
    }
}
