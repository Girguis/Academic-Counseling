using FOS.DB.Models;

namespace FOS.App.Comparers
{
    public class ToBeUpdatedStudentCoursesComparer : IEqualityComparer<StudentCourse>
    {
        public bool Equals(StudentCourse x, StudentCourse y)
        {
            //First check if both object reference are equal then return true
            if (ReferenceEquals(x, y))
            {
                return true;
            }
            //If either one of the object refernce is null, return false
            if (ReferenceEquals(x, null) || ReferenceEquals(y, null))
            {
                return false;
            }
            //Comparing all the properties one by one
            return x.CourseId == y.CourseId && x.StudentId == y.StudentId && x.AcademicYearId == y.AcademicYearId && x.Mark == y.Mark;
        }
        public int GetHashCode(StudentCourse obj)
        {
            //If obj is null then return 0
            if (obj == null)
            {
                return 0;
            }
            //Get the ID hash code value
            int CourseIDHashCode = obj.CourseId.GetHashCode();
            int StudentIDHashCode = obj.StudentId.GetHashCode();
            int AcademicYearIDHashCode = obj.AcademicYearId.GetHashCode();
            return CourseIDHashCode + StudentIDHashCode + AcademicYearIDHashCode;
        }
    }
}
