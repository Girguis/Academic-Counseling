using FOS.Core.IRepositories;
using FOS.Core.Languages;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace FOS.Doctors.API.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    [ApiVersion("1.0")]
    [Authorize(Roles = "SuperAdmin")]
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
                    return BadRequest(new
                    {
                        Massage = Resource.ErrorOccurred
                    });
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
        [HttpPost("Restore")]
        public IActionResult Restore(IFormFile dbFile)
        {
            try
            {
                if (dbFile.Length < 1)
                    return BadRequest(new { Massage = Resource.FileNotValid });

                string uploads = Path.Combine(Directory.GetCurrentDirectory(), "DbRestoreFiles");
                if (!Directory.Exists(uploads))
                    Directory.CreateDirectory(uploads);
                string filePath = Path.Combine(uploads, dbFile.FileName);
                using Stream fileStream = new FileStream(filePath, FileMode.Create);
                dbFile.CopyTo(fileStream);
                fileStream.Close();
                filePath = filePath.Replace("\\", "/");
                bool restored = databaseRepo.Restore(filePath);
                if (!restored)
                    return BadRequest(new { Massage = Resource.ErrorOccurred });
                return Ok(new
                {
                    Massage = Resource.Restored
                });
            }
            catch (Exception ex)
            {
                logger.LogError(ex.ToString());
                return Problem();
            }
        }
    }

}
