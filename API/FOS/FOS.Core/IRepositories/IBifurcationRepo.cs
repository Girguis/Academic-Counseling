using FOS.DB.Models;

namespace FOS.Core.IRepositories
{
    public interface IBifurcationRepo
    {
        object BifurcateStudents();
        List<Program> GetAvailableProgram(string guid);
        List<StudentDesire> GetDesires(string guid);
        bool AddDesires(int? currentProgramID, int studentID, List<byte> desires);
    }
}
