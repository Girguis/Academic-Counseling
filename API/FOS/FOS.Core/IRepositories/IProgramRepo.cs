using FOS.Core.Models;
using FOS.Core.Models.ParametersModels;
using FOS.Core.Models.StoredProcedureOutputModels;
using FOS.Core.SearchModels;
using FOS.DB.Models;

namespace FOS.Core.IRepositories
{
    public interface IProgramRepo
    {
        ProgramBasicDataDTO GetProgram(int id);
        ProgramDetailsOutModel GetProgramDetails(int id);
        List<ProgramBasicDataDTO> GetPrograms(out int totalCount, SearchCriteria criteria);
        List<ProgramBasicDataDTO> GetPrograms(int? superProgID = null);
        List<string> GetAllProgramsNames(int? startSemester = null);
        bool AddProgram(ProgramModel model);
        bool UpdateProgram(int id, ProgramModel model);
        bool UpdateProgramBasicData(ProgramBasicDataUpdateParamModel model);
    }
}
