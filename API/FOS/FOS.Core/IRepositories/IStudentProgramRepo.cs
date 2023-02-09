﻿using FOS.DB.Models;

namespace FOS.Core.IRepositories
{
    public interface IStudentProgramRepo
    {
        object ProgramsStatistics();
        bool AddStudentProgram(StudentProgram studentProgram);
        bool AddStudentPrograms(List<StudentProgram> studentPrograms);
        StudentProgram GetStudentProgram(StudentProgram studentProgram);
        IEnumerable<StudentProgram> GetAllStudentPrograms(int studentID);
    }
}
