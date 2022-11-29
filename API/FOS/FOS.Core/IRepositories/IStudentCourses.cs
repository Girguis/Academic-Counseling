using FOS.DB.Models;
using Microsoft.EntityFrameworkCore.Migrations.Operations;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FOS.Core.IRepositories
{
    public interface IStudentCourses
    {
        bool Add(StudentCourse studentCourse);
        bool Update(StudentCourse studentCourse);
        bool Delete(StudentCourse studentCourse);
        IQueryable<StudentCourse> Get(int studentID);
        IQueryable<StudentCourse> GetAll();

    }
}
