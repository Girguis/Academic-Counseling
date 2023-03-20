namespace FOS.Core.Models.ParametersModels
{
    public class AddAndDeleteCoursesParamModel
    {
        public List<int> ToAdd { get; set; }
        public List<int> ToDelete { get; set; }
    }
    public class CoursesLstParamModel
    {
        public List<int> CoursesList { get; set; }
    }
}
