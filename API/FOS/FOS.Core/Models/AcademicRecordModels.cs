using FOS.DB.Models;

namespace FOS.Core.Models
{
    public class AcademicRecordModels
    {
        public string Name { get; set; }
        public string SSN { get; set; }
        public string SeatNumber { get; set; }
        public List<StudentProgramModel> StudentPrograms { get; set; }
        public List<StudentCoursesModel> ToBeInserted { get; set; }
        public List<StudentCoursesUpdateModel> ToBeUpdated { get; set; }
        public List<StudentCoursesModel> ToBeRemoved { get; set; }
    }
    public class StudentProgramModel
    {
        public int ProgramId { get; set; }
        public int StudentId { get; set; }
        public short AcademicYear { get; set; }
    }
    public class StudentCoursesModel
    {
        public int CourseID { get; set; }
        public string CourseName { get; set; }
        public string CourseCode { get; set; }
        public int? Mark { get; set; }
        public string? Grade { get; set; }
        public int AcademicYearID { get; set; }
        public string AcademicYear { get; set; }
        public byte? Semester { get; set; }
        public bool IsGpaIncluded { get; set; }
        public bool? HasExecuse { get; set; }
        public static StudentCoursesModel ToViewModel(StudentCourse x, List<AcademicYear> academicYearsLst)
        {
            return new StudentCoursesModel
            {
                CourseID = x.CourseId,
                CourseName = x.Course.CourseName,
                CourseCode = x.Course.CourseCode,
                Mark = x.Mark,
                Grade = x.Grade,
                AcademicYearID = x.AcademicYearId,
                AcademicYear = academicYearsLst.FirstOrDefault(y => y.Id == x.AcademicYearId)?.AcademicYear1,
                Semester = academicYearsLst.FirstOrDefault(y => y.Id == x.AcademicYearId)?.Semester,
                IsGpaIncluded = x.IsGpaincluded,
                HasExecuse = x.HasExecuse.HasValue && x.HasExecuse.Value
            };
        }
    }
    public class StudentCoursesUpdateModel
    {
        public int CourseID { get; set; }
        public string CourseName { get; set; }
        public string CourseCode { get; set; }
        public int? OldMark { get; set; }
        public int? NewMark { get; set; }
        public int AcademicYearID { get; set; }
        public string AcademicYear { get; set; }
        public byte? Semester { get; set; }
        public bool IsGpaIncluded { get; set; }
        public bool? HasExecuse { get; set; }
        public static StudentCoursesUpdateModel ToViewModel(StudentCourse x, List<StudentCourse> courses, List<AcademicYear> academicYearsLst)
        {
            return new StudentCoursesUpdateModel
            {
                CourseID = x.CourseId,
                CourseName = x.Course.CourseName,
                CourseCode = x.Course.CourseCode,
                OldMark = x.Mark,
                NewMark = courses.FirstOrDefault(y => y.CourseId == x.CourseId)?.Mark,
                AcademicYearID = x.AcademicYearId,
                AcademicYear = academicYearsLst.FirstOrDefault(y => y.Id == x.AcademicYearId)?.AcademicYear1,
                Semester = academicYearsLst.FirstOrDefault(y => y.Id == x.AcademicYearId)?.Semester,
                IsGpaIncluded = x.IsGpaincluded,
                HasExecuse = x.HasExecuse
            };
        }
    }
}
