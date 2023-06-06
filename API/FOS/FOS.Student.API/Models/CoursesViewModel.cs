using FOS.Core.Enums;
using FOS.Core.Models.StoredProcedureOutputModels;

namespace FOS.Students.API.Models
{
    public class CoursesViewModel
    {
        public int CourseType { get; set; }
        public IEnumerable<CoursesDetailsModel> Courses { get; set; }
        
    }
    public class CoursesDetailsModel
    {
        public IEnumerable<CourseRegistrationOutModel> CourseData { get; set; }
        public int Hours { get; set; }
    }
    public static class CoursesViewModelConvertor
    {
        public static List<CoursesViewModel> ConvertToViewModel(List<CourseRegistrationOutModel> courses,
            List<ElectiveCoursesDistribtionOutModel> optionalCoursesDistribtion)
        {
            var coursesViewModel = new List<CoursesViewModel>{
                    new CoursesViewModel { CourseType = (int)CourseTypeEnum.Mandetory, Courses = new List<CoursesDetailsModel>() },
                    new CoursesViewModel { CourseType = (int)CourseTypeEnum.Elective, Courses = new List<CoursesDetailsModel>() },
                    new CoursesViewModel { CourseType = (int)CourseTypeEnum.UniversityRequirement, Courses = new List<CoursesDetailsModel>() }};
            var groupedCourses = courses.GroupBy(x => new
            {
                x.Level,
                x.Semester,
                x.Category,
                x.CourseType
            });
            for (int i = 0; i < groupedCourses.Count(); i++)
            {
                var currentCourses = groupedCourses.ElementAt(i);
                if (currentCourses.Key.CourseType == (int)CourseTypeEnum.Mandetory)
                {
                    coursesViewModel.ElementAt(0).Courses = coursesViewModel.ElementAt(0).Courses
                        .Append(new CoursesDetailsModel
                        {
                            CourseData = currentCourses.Select(x => x),
                            Hours = currentCourses.Sum(x => x.CreditHours)
                        });
                }
                else
                {
                    var coursesType = currentCourses.Key.CourseType == (int)CourseTypeEnum.Elective ? (int)CourseTypeEnum.Elective : (int)CourseTypeEnum.UniversityRequirement;
                    var index = coursesType == (int)CourseTypeEnum.Elective ? 1 : 2;
                    coursesViewModel.ElementAt(index).Courses = coursesViewModel.ElementAt(index).Courses
                        .Append(new CoursesDetailsModel
                        {
                            CourseData = currentCourses.Select(x => x),
                            Hours = optionalCoursesDistribtion.Where(z => z.Level == currentCourses.Key.Level &&
                                z.Semester == currentCourses.Key.Semester &&
                                z.CourseType == currentCourses.Key.CourseType &&
                                z.Category == currentCourses.Key.Category
                                ).FirstOrDefault()?.Hour ?? 0
                        });
                }
            }
            return coursesViewModel;
        }
    }
}
