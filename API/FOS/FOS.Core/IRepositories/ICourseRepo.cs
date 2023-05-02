using FOS.Core.Models.ParametersModels;
using FOS.Core.SearchModels;
using FOS.DB.Models;

namespace FOS.Core.IRepositories
{
    public interface ICourseRepo
    {
        bool Add(AddCourseParamModel course);
        bool Delete(string id);
        bool IsCourseExist(string courseCode);
        bool Update(int id, AddCourseParamModel course);
        Course GetById(string id);
        (Course course, IEnumerable<string> doctors, IEnumerable<string> programs) GetCourseDetails(int id);
        List<Course> GetAll(out int totalCount, string doctorID, SearchCriteria criteria = null, string? doctorProgramID = null);
        List<Course> GetAll();
        bool ToggleActivation(HashSet<string> courseIDs, bool isActive);
        bool AssignDoctorsToCourse(DoctorsToCourseParamModel model);
        bool ConfirmExamsResult();
    }
}
