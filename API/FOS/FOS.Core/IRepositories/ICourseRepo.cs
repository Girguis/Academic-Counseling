using FOS.Core.SearchModels;
using FOS.DB.Models;

namespace FOS.Core.IRepositories
{
    public interface ICourseRepo
    {
        bool Add(List<Course> course);
        bool Delete(Course course);
        bool Update(Course course);
        Course GetById(int id);
        (Course course, IEnumerable<string> doctors, IEnumerable<string> programs) GetCourseDetails(int id);
        List<Course> GetAll(out int totalCount, SearchCriteria criteria = null,int? doctorProgramID = null);
        List<Course> GetAll();
        bool Activate(List<int> courseIDs);
        bool Deactivate(List<int> courseIDs);

    }
}
