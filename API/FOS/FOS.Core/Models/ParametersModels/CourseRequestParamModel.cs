namespace FOS.Core.Models.ParametersModels
{
    public class CourseRequestParamModel
    {
        public int? StudentID { get; set; } = null;
        public int? RequestTypeID { get; set; } = null;
        public string RequestID { get; set; } = null;
        public bool? IsApproved { get; set; } = null;
    }
}
