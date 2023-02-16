using FOS.Core.IRepositories;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace FOS.Doctor.API.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    [ApiVersion("1.0")]
    [Authorize]
    public class DatabaseController : ControllerBase
    {
        private readonly IDatabaseRepo databaseRepo;
        private readonly ILogger<DatabaseController> logger;

        public DatabaseController(IDatabaseRepo databaseRepo, ILogger<DatabaseController> logger)
        {
            this.databaseRepo = databaseRepo;
            this.logger = logger;
        }
        [HttpGet("Backup")]
        public IActionResult Backup()
        {
            try
            {
                var filePath = databaseRepo.Backup();
                if (filePath == null)
                    return BadRequest();
                MemoryStream ms = new MemoryStream();
                using (FileStream file = new FileStream(filePath, FileMode.Open, FileAccess.Read))
                    file.CopyTo(ms);
                ms.Seek(0, SeekOrigin.Begin);

                return File(ms,
                    "application/octet-stream",
                    filePath.Substring(filePath.LastIndexOf('/') + 1)
                    );
            }
            catch (Exception ex)
            {
                logger.LogError(ex.ToString());
                return Problem();
            }
        }
    }

}
