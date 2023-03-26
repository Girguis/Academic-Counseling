using FOS.Core.Models;
using FOS.Core.Models.ParametersModels;
using FOS.DB.Models;

namespace FOS.Core.IRepositories
{
    public interface IStudentProgramRepo
    {
        bool AddStudentPrograms(List<StudentProgramModel> studentPrograms);
        IEnumerable<StudentProgram> GetAllStudentPrograms(int studentID);
        List<DropDownModel> GetProgramsListForProgramTransfer(int programID);
        bool ProgramTransferRequest(int studentID, ProgramTransferParamModel model);

    }
}
