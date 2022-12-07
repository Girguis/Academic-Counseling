﻿using FOS.DB.Models;

namespace FOS.Core.IRepositories.Student
{
    public interface IStudentRepo
    {
        bool Update(DB.Models.Student student);
        DB.Models.Student Login(string email, string hashedPassword);
        DB.Models.Student Get(string GUID);
        Program GetCurrentProgram(string guid);
    }
}
