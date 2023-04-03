namespace FOS.Core.Models.StoredProcedureOutputModels
{
    public class GetAllCoursesRegistrationOutModel
    {
        public string SSN { get; set; }
        public string CourseCode { get; set; }
    }
    public class GetAllCoursesRegistrationModel
    {
        public string SSN { get; set; }
        public List<string> Courses { get; set; }
    }
}
