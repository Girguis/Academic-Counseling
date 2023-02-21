using FOS.Core.Models;
using FOS.DB.Models;

namespace FOS.Core.IRepositories
{
    public interface IStudentProgramRepo
    {
        object ProgramsStatistics();
        bool AddStudentProgram(StudentProgram studentProgram);
        bool AddStudentPrograms(List<StudentProgramModel> studentPrograms);
        StudentProgram GetStudentProgram(StudentProgram studentProgram);
        Program GetStudentCurrentProgram(int studentID);
        IEnumerable<StudentProgram> GetAllStudentPrograms(int studentID);
    }
}
