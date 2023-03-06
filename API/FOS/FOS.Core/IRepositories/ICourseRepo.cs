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
        List<Course> GetAll(out int totalCount, SearchCriteria criteria = null);
        List<Course> GetAll();
        bool Activate(List<int> courseIDs);
        bool Deactivate(List<int> courseIDs);

    }
}
