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
        ///eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJHdWlkIjoiQTk1QTQzMDQtRTIxNS00NkEzLUEzQzktM0QwMUY5MEYwODY4IiwibmJmIjoxNjc1OTgwODExLCJleHAiOjE2NzYwMDI0MTEsImlhdCI6MTY3NTk4MDgxMSwiaXNzIjoiaGZkdWV3aHJwN3luNTQ0M3U5cGlyZnR0NXl1aGdmY3hkZmVyNTY0dzhteW4zOXdvcDkzbXo0dTJuN256MzI0NnRiajZ0ejU2MzJjcjUiLCJhdWQiOiIydnQzN2JubXpodm5mc2pid3RubXl1am1hd2VzcnRmZ3lodWppa21uY3hkZXM0NTZ5N3VpamhidmNkeHNlNDU2NzhpOW9rbG1uYiJ9.YeqbQf9YOvlAdyTDluDVv17dErU3VF0F7NL6SFnmtJ1c-Zktrt1OMjHcVsIAOg7rJe0WoXUq09mrb20AnLNyww
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
            return context.SaveChanges() > 0;
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
            return context.AcademicYears.ToList();
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
