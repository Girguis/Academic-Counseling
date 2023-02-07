using FOS.App.Doctor.DTOs;
using FOS.App.Doctor.Mappers;
using FOS.Core.Enums;
using FOS.Core.IRepositories;
using FOS.Core.SearchModels;
using FOS.DB.Models;
using FOS.Doctor.API.Mappers;
using FOS.Doctor.API.Models;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace FOS.Doctor.API.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    [ApiVersion("1.0")]
    //[Authorize]
    public class CourseController : ControllerBase
    {
        private readonly ILogger<CourseController> logger;
        private readonly ICourseRepo courseRepo;
        private readonly ICoursePrerequisiteRepo coursePrerequisiteRepo;

        public CourseController(ILogger<CourseController> logger,
            ICoursePrerequisiteRepo coursePrerequisiteRepo
            ,ICourseRepo courseRepo)
        {
            this.logger = logger;
            this.courseRepo = courseRepo;
            this.coursePrerequisiteRepo = coursePrerequisiteRepo;
        }
        [HttpPost("Get")]
        public IActionResult GetCourses([FromBody] SearchCriteria criteria)
        {
            try
            {
                var courses = courseRepo.GetAll(out int totalCount, criteria);
                var prerequisites = new List<CoursePrerequisite>();
                var courseDTO = new List<CourseDTO>();
                for (int i = 0; i < courses.Count; i++)
                {
                    var course = courses.ElementAt(i);
                    if (course.PrerequisiteRelation != (int)PrerequisiteCoursesRelationEnum.NoPrerequisite)
                    {
                        prerequisites = coursePrerequisiteRepo.GetPrerequisites(course.Id);
                        courseDTO.Add(course.ToDTO(prerequisites));
                    }
                    else
                        courseDTO.Add(course.ToDTO(new List<CoursePrerequisite>()));
                }
                return Ok(new
                {
                    Courses = courseDTO,
                    TotalCount = totalCount
                });
            }
            catch (Exception ex)
            {
                logger.LogError(ex.Message);
                return Problem();
            }
        }

        [HttpGet("GetByID/{id}")]
        public IActionResult GetByID(int id)
        {
            try
            {
                var course = courseRepo.GetById(id);
                if (course == null)
                    return NotFound();
                var prerequisites = new List<CoursePrerequisite>();
                var courseDTO = new CourseDTO();
                if (course.PrerequisiteRelation != (int)PrerequisiteCoursesRelationEnum.NoPrerequisite)
                {
                    prerequisites = coursePrerequisiteRepo.GetPrerequisites(course.Id);
                    courseDTO = course.ToDTO(prerequisites);
                }
                else
                    courseDTO = course.ToDTO(new List<CoursePrerequisite>());
                return Ok(new
                {
                    Data = courseDTO
                });
            }
            catch (Exception ex)
            {
                logger.LogError(ex.Message);
                return Problem();
            }
        }

        [HttpPost("Add")]
        public IActionResult AddCourse(CourseModel courseModel)
        {
            try
            {
                Course course = courseModel.ToDBCourseModel();
                var savedCourse = courseRepo.Add(course);
                if (savedCourse == null)
                    return BadRequest(new
                    {
                        Massage = "Error Occured while adding course",
                        Data = courseModel
                    });
                bool res = true;
                var prequisitesIDs = courseModel.prequisitesIDs;
                if (prequisitesIDs.Count > 0 && prequisitesIDs != null)
                    res = coursePrerequisiteRepo.AddPrerequisites(savedCourse.Id, prequisitesIDs);
                if (!res)
                    return BadRequest(new
                    {
                        Massage = "Error Occured while adding prerequisites",
                        Data = new
                        {
                            Course = course,
                            Prerequisites = prequisitesIDs
                        }
                    });
                return Ok();
            }
            catch (Exception ex)
            {
                logger.LogError(ex.Message);
                return Problem();
            }
        }

        [HttpDelete("Delete/{id}")]
        public IActionResult DeleteCourse(int id)
        {
            try
            {
                var course = courseRepo.GetById(id);
                if (course == null)
                    return NotFound();
                var res = courseRepo.Delete(course);
                if (!res)
                    return BadRequest();
                return Ok();
            }
            catch (Exception ex)
            {
                logger.LogError(ex.Message);
                return Problem();
            }
        }
        [HttpPut("Update")]
        public IActionResult UpdateCourse(CourseModel courseModel)
        {
            try
            {
                Course course = courseModel.ToDBCourseModel();
                bool res = courseRepo.Update(course);
                if (!res) return BadRequest(courseModel);
                if (course.PrerequisiteRelation == (int)PrerequisiteCoursesRelationEnum.NoPrerequisite)
                    res = coursePrerequisiteRepo.DeletePrerequisites(course.Id);
                if (!res) return BadRequest(courseModel);
                var prerequisitesIDs = courseModel.prequisitesIDs;
                if(prerequisitesIDs.Count < 1 || prerequisitesIDs == null)
                    return BadRequest(courseModel);
                res = coursePrerequisiteRepo.UpdatePrerequisites(course.Id, prerequisitesIDs);
                if (!res) return BadRequest(courseModel);
                return Ok();
            }
            catch (Exception ex)
            {
                logger.LogError(ex.Message);
                return Problem();
            }
        }
    }
}
