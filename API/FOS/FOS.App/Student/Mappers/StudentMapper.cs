﻿using AutoMapper;
using FOS.App.Student.DTOs;
using FOS.DB.Models;

namespace FOS.App.Student.Mappers
{
    public static class StudentMapper
    {
        public static StudentDTO ToDTO(this DB.Models.Student student, List<StudentCourse> courses,AcademicYear academicYear)
        {
            try
            {
                var config = new MapperConfiguration(c => c.CreateMap<DB.Models.Student, StudentDTO>());
                var mapper = config.CreateMapper();
                var studentDto = mapper.Map<StudentDTO>(student);
                studentDto.Courses = courses.Select(c => c.ToDTO()).Where(c => c != null)?.ToList();
                studentDto.academicYear = academicYear.AcademicYear1;
                studentDto.semester = academicYear.Semester;
                return studentDto;
            }
            catch (Exception ex)
            {

            }
            return null;
        }
    }

}