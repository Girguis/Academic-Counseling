using FOS.Core.Models;
using FOS.Core.Models.ParametersModels;
using FOS.Core.SearchModels;
using FOS.DB.Models;

namespace FOS.Core.IRepositories
{
    public interface IProgramRepo
    {
        ProgramBasicDataDTO GetProgram(int id);
        List<ProgramBasicDataDTO> GetPrograms(out int totalCount, SearchCriteria criteria);
        List<ProgramBasicDataDTO> GetPrograms(int? superProgID = null);
        List<string> GetAllProgramsNames(int? startSemester = null);
        bool AddProgram(ProgramModel model);
        bool UpdateProgramBasicData(ProgramBasicDataUpdateParamModel model);
    }
}
