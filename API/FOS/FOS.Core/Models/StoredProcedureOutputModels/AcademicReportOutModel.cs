using FOS.Core.Models.DTOs;
using FOS.Core.StudentDTOs;

namespace FOS.Core.Models.StoredProcedureOutputModels
{
    public class AcademicReportOutModel
    {
        public IEnumerable<AcademicYearsDTO> AcademicYears { get; set; }
        public IEnumerable<StudentCoursesGradesOutModel> Courses { get; set; }
        public StudentAcademicReportDTO Student { get; set; }
    }

}
