using FOS.Core.SearchModels;
using FOS.DB.Models;

namespace FOS.Core.IRepositories
{
    public interface ICourseRepo
    {
        Course Add(Course course);
        bool Delete(Course course);
        bool Update(Course course);
        Course GetById(int id);
        List<Course> GetAll(out int totalCount, SearchCriteria criteria = null);
        List<Course> GetAll();
    }
}
