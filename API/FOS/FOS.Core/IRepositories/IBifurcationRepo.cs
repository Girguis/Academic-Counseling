using FOS.Core.Models.StoredProcedureOutputModels;

namespace FOS.Core.IRepositories
{
    public interface IBifurcationRepo
    {
        Stream BifurcateStudents();
        List<DesireProgramsOutModel> GetDesires(int id);
        bool AddDesires(int? currentProgramID, int studentID, List<byte> desires);
    }
}
