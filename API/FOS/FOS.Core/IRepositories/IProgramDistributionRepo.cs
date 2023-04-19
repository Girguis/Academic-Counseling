namespace FOS.Core.IRepositories
{
    public interface IProgramDistributionRepo
    {
        int? GetAllowedHoursToRegister(int programID, int studentLevel, int passedHours, int currentSemester);
    }
}
