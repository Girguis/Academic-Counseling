using Microsoft.AspNetCore.Http;
using System.ComponentModel.DataAnnotations;

namespace FOS.Core.Models.ParametersModels
{
    public class StudentsExamParamModel
    {
        public int CourseID { get; set; }
        [Range(1,4)]
        public int ExamType { get; set; }
    }
    public class StudentExamSheetUploadParamModel : StudentsExamParamModel
    {
        public IFormFile file { get; set; }
    }
}
