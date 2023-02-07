﻿using AutoMapper;
using FOS.App.Student.DTOs;
using FOS.DB.Models;

namespace FOS.App.Student.Mappers
{
    public static class StudentMapper
    {
        /// <summary>
        /// Extension method used to map data from Student, StudentCourse and AcademicYear models (models from database)
        /// to StudentDTO model
        /// </summary>
        public static StudentDTO ToDTO(this DB.Models.Student student, List<StudentCourse> courses, AcademicYear academicYear)
        {

            var config = new MapperConfiguration(c => c.CreateMap<DB.Models.Student, StudentDTO>()
            .ForMember(x => x.SupervisorName, o => o.MapFrom(z =>z.Supervisor.Name)));
            var mapper = config.CreateMapper();
            var studentDto = mapper.Map<StudentDTO>(student);
            studentDto.Rank = student.IsGraduated.Value ? student.Rank : student.CalculatedRank;
            studentDto.Courses = courses.Select(c => c.ToDTO()).Where(c => c != null)?.ToList();
            studentDto.academicYear = academicYear.AcademicYear1;
            studentDto.semester = academicYear.Semester;
            return studentDto;
        }
    }

}
