using FOS.DB.Models;

namespace FOS.Core.IRepositories.Student
{
    public interface IBifurcationRepo
    {
        List<Program> GetAvailableProgram(string guid);
        List<StudentDesire> GetDesires(string guid);
        bool AddDesires(List<StudentDesire> desires);
        bool IsBifurcationAvailable();
    }
}
