using AutoMapper;
using FOS.Core.Models.StoredProcedureOutputModels;
using FOS.DB.Models;

namespace FOS.App.Students.Mappers
{
    public static class OptionalCourseMapper
    {
        public static ElectiveCoursesDistribtionOutModel ToDTO(this ElectiveCourseDistribution optionalCourse)
        {
            var config = new MapperConfiguration(c => c.CreateMap<ElectiveCourseDistribution, ElectiveCoursesDistribtionOutModel>());
            var mapper = config.CreateMapper();
            var optionalCourseDTO = mapper.Map<ElectiveCoursesDistribtionOutModel>(optionalCourse);
            return optionalCourseDTO;
        }
    }
}
