using FOS.Core.Models;
using FOS.Core.Models.ParametersModels;
using FOS.Core.SearchModels;
using FOS.DB.Models;

namespace FOS.Core.IRepositories
{
    public interface IProgramRepo
    {
        Program GetProgram(int id);
        List<Program> GetPrograms(out int totalCount, SearchCriteria criteria);
        List<Program> GetPrograms(int? superProgID = null);
        bool AddProgram(ProgramModel model);
        bool UpdateProgramBasicData(ProgramBasicDataUpdateParamModel model);
    }
}
