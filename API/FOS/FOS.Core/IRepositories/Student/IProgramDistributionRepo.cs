namespace FOS.Core.IRepositories.Student
{
    public interface IProgramDistributionRepo
    {
        int GetAllowedHoursToRegister(int programID, int studentLevel, int passedHours, int currentSemester);
    }
}
