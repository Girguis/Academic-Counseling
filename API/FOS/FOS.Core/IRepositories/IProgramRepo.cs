using FOS.Core.Models;
using FOS.Core.Models.ParametersModels;
using FOS.Core.Models.StoredProcedureOutputModels;
using FOS.Core.SearchModels;

namespace FOS.Core.IRepositories
{
    public interface IProgramRepo
    {
        ProgramBasicDataDTO GetProgram(string id);
        ProgramDetailsOutModel GetProgramDetails(string id);
        List<ProgramBasicDataDTO> GetPrograms(out int totalCount, SearchCriteria criteria);
        List<ProgramBasicDataDTO> GetPrograms(string superProgID = null);
        List<string> GetAllProgramsNames(int? startSemester = null);
        bool AddProgram(ProgramModel model);
        bool UpdateProgram(int id, ProgramModel model);
        bool UpdateProgramBasicData(ProgramBasicDataUpdateParamModel model);
    }
}
