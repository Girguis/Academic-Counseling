namespace FOS.Core.IRepositories
{
    public interface IDatabaseRepo
    {
        string Backup();
        bool Restore(string filePath);
    }
}
