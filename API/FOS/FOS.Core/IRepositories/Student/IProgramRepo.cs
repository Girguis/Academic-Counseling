using FOS.DB.Models;

namespace FOS.Core.IRepositories.Student
{
    public interface IProgramRepo
    {
        Program GetProgram(int id);
    }
}
