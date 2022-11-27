using FOS.Core.IRepositories;
using Microsoft.AspNetCore.Mvc;

namespace FOS.Student.API.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class WeatherForecastController : ControllerBase
    {
        public WeatherForecastController(ILogger<WeatherForecastController> logger, IStudentRepo studentRepo)
        {
            this.studentRepo = studentRepo;
            _logger = logger;
        }
        private static readonly string[] Summaries = new[]
        {
        "Freezing", "Bracing", "Chilly", "Cool", "Mild", "Warm", "Balmy", "Hot", "Sweltering", "Scorching"
    };

        private readonly ILogger<WeatherForecastController> _logger;
        private readonly IStudentRepo studentRepo;


        [HttpGet(Name = "GetWeatherForecast")]
        public IEnumerable<DB.Models.Student> Get()
        {
            var students = studentRepo.GetAll();
            return students?.ToList();
        }
    }
}