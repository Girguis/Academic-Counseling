namespace FOS.Core.IRepositories.Student
{
    public interface IDateRepo
    {
        bool IsInRegisrationInterval(int id);
    }
}
