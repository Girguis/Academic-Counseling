using FOS.Core.IRepositories.Student;
using FOS.DB.Models;
using Microsoft.Data.SqlClient;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Cryptography.X509Certificates;
using System.Text;
using System.Threading.Tasks;

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

        ////public bool StartNewYear()
        ////{
        ////    AcademicYear currentAcademicYear = GetCurrentYear();
        ////    var newSemester = (byte)((currentAcademicYear.Semester % 3.0) + 1);
        ////    int year =int.Parse(currentAcademicYear?.ToString()?.Split("/")[0]);
        ////    string newYear = (year + 1) + "/" + (year + 2);
        ////    AcademicYear newAcademicYear = new AcademicYear()
        ////    {
        ////        Semester = newSemester,
        ////        AcademicYear1 = newYear
        ////    };
        ////    context.AcademicYears.Add(newAcademicYear);
        ////    return context.SaveChanges() > 0;
        ////}

        //public AcademicYear Get(int id)
        //{
        //    return context.AcademicYears.Find(id);
        //}

        public List<AcademicYear> GetAll(int studentID)
        {
            return context.StudentCourses
                .Where(x=>x.StudentId == studentID)
                .Select(x=>x.AcademicYear)
                .Distinct()
                .ToList();
        }

        public AcademicYear GetCurrentYear()
        {
            return context.AcademicYears
                   .OrderByDescending(x => x.Id)
                   .FirstOrDefault();
        }

        //public bool Delete(AcademicYear academicYear)
        //{
        //    if (academicYear == null)
        //    {
        //        return false;
        //    }
        //    context.Remove(academicYear);
        //    return context.SaveChanges()>0;
        //}
    }
}
