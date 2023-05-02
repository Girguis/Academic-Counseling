using Microsoft.AspNetCore.Http;
using System.ComponentModel.DataAnnotations;

namespace FOS.Core.Models.ParametersModels
{
    public class StudentsExamParamModel
    {
        public int CourseID { get; set; }
        public bool IsFinalExam { get; set; }
    }
    public class StudentExamSheetUploadParamModel
    {
        public string CourseID { get; set; }
        public bool IsFinalExam { get; set; }
        public IFormFile file { get; set; }
    }
}
