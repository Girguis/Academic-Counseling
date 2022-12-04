using FOS.Core.IRepositories.Student;
using FOS.DB.Models;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FOS.App.Student.Repositories
{
    public class StudentCoursesRepo : IStudentCoursesRepo
    {
        private readonly FOSContext context;
        private readonly IAcademicYearRepo academicYearRepo;

        public StudentCoursesRepo(FOSContext context, IAcademicYearRepo academicYearRepo)
        {
            this.context = context;
            this.academicYearRepo = academicYearRepo;
        }
        public bool Add(List<StudentCourse> studentCourses)
        {
            context.StudentCourses.AddRange(studentCourses);
            return context.SaveChanges() > 0;
        }

        public bool Add(StudentCourse studentCourse)
        {
            context.StudentCourses.Add(studentCourse);
            return context.SaveChanges() > 0;
        }

        public bool Delete(StudentCourse studentCourse)
        {
            context.Remove(studentCourse);
            return context.SaveChanges() > 0;
        }

        public List<StudentCourse> GetAllCourses(int studentID)
        {
            IQueryable<StudentCourse> coursesList = context.StudentCourses.Where(x => x.StudentId == studentID).Include("Course");
            return coursesList.ToList();
        }
        public List<StudentCourse> GetCurrentAcademicYearCourses(int studentID)
        {
            IQueryable<StudentCourse> coursesList = context.StudentCourses
                .Where(x => x.StudentId == studentID & x.AcademicYearId == academicYearRepo.GetCurrentYear().Id)
                .Include("Course"); ;
            return coursesList.ToList();
        }
        public IQueryable<StudentCourse> GetAll()
        {
            return context.StudentCourses;
        }

        public bool Update(StudentCourse studentCourse)
        {
            context.Entry(studentCourse).State = EntityState.Modified;
            return context.SaveChanges() > 0;
        }
        public List<StudentCourse> GetCoursesByAcademicYear(int studentID, short academicYearID)
        {
            IQueryable<StudentCourse> courses = context.StudentCourses
                .Where(x => x.StudentId == studentID & x.AcademicYearId == academicYearID)
                .Include("Course");
            return courses.ToList();
        }
    }
}
