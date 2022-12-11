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
        public double? GetAcademicYearGPA(int studentID, short academicYear)
        {
            List<StudentCourse> coureses = context.StudentCourses.Where(x => x.StudentId == studentID & x.AcademicYearId == academicYear).Include("Course").ToList();
            double? sGpa = coureses.Sum(x => x.Points * x.Course.CreditHours);
            sGpa /= coureses.Sum(x => x.Course.CreditHours);
            return sGpa;
        }
        public List<AcademicYear> GetAll(int studentID)
        {
            return context.StudentCourses
                .Where(x => x.StudentId == studentID)
                .Select(x => x.AcademicYear)
                .Distinct()
                .ToList();
        }
        public AcademicYear GetCurrentYear()
        {
            return context.AcademicYears
                   .OrderByDescending(x => x.Id)
                   .FirstOrDefault();
        }
    }
}
