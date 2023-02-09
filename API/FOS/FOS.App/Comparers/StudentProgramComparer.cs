using FOS.DB.Models;

namespace FOS.App.Comparers
{
    public class StudentProgramComparer : IEqualityComparer<StudentProgram>
    {
        public bool Equals(StudentProgram x, StudentProgram y)
        {
            //First check if both object reference are equal then return true
            if (object.ReferenceEquals(x, y))
            {
                return true;
            }
            //If either one of the object refernce is null, return false
            if (object.ReferenceEquals(x, null) || object.ReferenceEquals(y, null))
            {
                return false;
            }
            //Comparing all the properties one by one
            return x.ProgramId == y.ProgramId && x.StudentId == y.StudentId && x.AcademicYear == y.AcademicYear;
        }
        public int GetHashCode(StudentProgram obj)
        {
            //If obj is null then return 0
            if (obj == null)
            {
                return 0;
            }
            //Get the ID hash code value
            int programIDHashCode = obj.ProgramId.GetHashCode();
            int StudentIDHashCode = obj.StudentId.GetHashCode();
            int AcademicYearIDHashCode = obj.AcademicYear.GetHashCode();
            return programIDHashCode + StudentIDHashCode + AcademicYearIDHashCode;
        }
    }
}
