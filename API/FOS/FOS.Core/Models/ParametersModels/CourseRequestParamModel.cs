using System.ComponentModel.DataAnnotations;

namespace FOS.Core.Models.ParametersModels
{
    public class CourseRequestParamModel
    {
        public int? StudentID { get; set; } = null;
        public int? RequestTypeID { get; set; } = null;
        public string RequestID { get; set; } = null;
        public bool? IsApproved { get; set; } = null;
    }
    public class HandleCourseRequestParamModel
    {
        [Required]
        public bool IsApproved { get; set; }
        [Required]
        public string RequestID { get; set; }
    }
}
