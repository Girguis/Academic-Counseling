using FOS.Core.IRepositories;
using FOS.DB.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FOS.App.Repositories
{
    public class StudentCourses : IStudentCourses
    {
        private readonly FOSContext context;

        public StudentCourses(FOSContext context)
        {
            this.context = context;
        }
        public bool Add(StudentCourse studentCourse)
        {
            throw new NotImplementedException();
        }

        public bool Delete(StudentCourse studentCourse)
        {
            throw new NotImplementedException();
        }

        public IQueryable<StudentCourse> Get(int studentID)
        {
            return context.StudentCourses.Where(x=>x.StudentId == studentID);
        }

        public IQueryable<StudentCourse> GetAll()
        {
            return context.StudentCourses;
        }

        public bool Update(StudentCourse studentCourse)
        {
            throw new NotImplementedException();
        }
    }
}
