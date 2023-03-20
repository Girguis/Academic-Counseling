using FOS.Core.Models;
using FOS.Core.Models.ParametersModels;
using FOS.DB.Models;

namespace FOS.Core.IRepositories
{
    public interface IStudentProgramRepo
    {
        bool AddStudentProgram(StudentProgram studentProgram);
        bool AddStudentPrograms(List<StudentProgramModel> studentPrograms);
        StudentProgram GetStudentProgram(StudentProgram studentProgram);
        Program GetStudentCurrentProgram(int studentID);
        IEnumerable<StudentProgram> GetAllStudentPrograms(int studentID);

        List<DropDownModel> GetProgramsListForProgramTransfer(int programID);
        bool ProgramTransferRequest(int studentID, ProgramTransferParamModel model);

    }
}
