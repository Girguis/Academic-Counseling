using FOS.Core.IRepositories.Student;
using Microsoft.AspNetCore.Mvc;

namespace FOS.Student.API.Controllers.v1
{
    [Route("api/[controller]")]
    [ApiController]
    [ApiVersion("1.0")]
    public class DummyController : ControllerBase
    {
        private readonly IAcademicYearRepo academicYearRepo;

        public DummyController(IAcademicYearRepo academicYearRepo)
        {
            this.academicYearRepo = academicYearRepo;
        }
        [HttpGet]
        public IActionResult Get()
        {
            return Ok();
        }

        [HttpDelete]
        public IActionResult Delete() { 
        return Ok();
        }

        [HttpPost]
        public IActionResult Post()
        {
            return Ok();
        }
    }
}
