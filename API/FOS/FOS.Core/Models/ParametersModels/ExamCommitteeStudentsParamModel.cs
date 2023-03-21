using System.ComponentModel.DataAnnotations;

namespace FOS.Core.Models.ParametersModels
{
    public class ExamCommitteeStudentsParamModel
    {
        public int CourseID { get; set; }
        [Range(1,3)]
        public int ExamType { get; set; }
    }
}
