using FOS.Core.Models.ParametersModels;
using FOS.Core.SearchModels;
using FOS.DB.Models;

namespace FOS.Core.IRepositories
{
    public interface ICourseRepo
    {
        bool Add(AddCourseParamModel course);
        bool Delete(int id);
        bool IsCourseExist(string courseCode);
        bool Update(int id, AddCourseParamModel course);
        Course GetById(int id);
        (Course course, IEnumerable<string> doctors, IEnumerable<string> programs) GetCourseDetails(int id);
        List<Course> GetAll(out int totalCount, string doctorID, SearchCriteria criteria = null, int? doctorProgramID = null);
        List<Course> GetAll();
        bool Activate(List<int> courseIDs);
        bool Deactivate(List<int> courseIDs);
        bool AssignDoctorsToCourse(DoctorsToCourseParamModel model);
        bool ConfirmExamsResult();
    }
}
