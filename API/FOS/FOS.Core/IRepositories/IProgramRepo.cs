using FOS.Core.Models;
using FOS.Core.SearchModels;
using FOS.DB.Models;

namespace FOS.Core.IRepositories
{
    public interface IProgramRepo
    {
        Program GetProgram(int id);
        List<Program> GetPrograms(out int totalCount, SearchCriteria criteria);
        List<Program> GetPrograms();
        bool AddProgram(ProgramModel model);
    }
}
