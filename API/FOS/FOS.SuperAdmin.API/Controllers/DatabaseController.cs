using FOS.Core.IRepositories.Doctor;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using System.IO;
using System.Net;
using System.Net.Http.Headers;

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

        public DatabaseController(IDatabaseRepo databaseRepo,ILogger<DatabaseController> logger)
        {
            this.databaseRepo = databaseRepo;
            this.logger = logger;
        }
        [HttpGet]
        public IActionResult Backup()
        {
            try
            {
                var filePath = databaseRepo.Backup();
                if (filePath == null)
                    return BadRequest();
                return Ok();
            }
            catch (Exception ex)
            {
                logger.LogError(ex.ToString());
                return Problem();
            }
            //MemoryStream ms = new MemoryStream();
            //using (FileStream file = new FileStream(filePath, FileMode.Open, FileAccess.Read))
            //    file.CopyTo(ms);
            //var result = new HttpResponseMessage(HttpStatusCode.OK)
            //{
            //    Content = new ByteArrayContent(ms.ToArray())
            //};
            //result.Content.Headers.ContentDisposition =
            //    new ContentDispositionHeaderValue("attachment")
            //    {
            //        FileName = filePath.Substring(filePath.LastIndexOf('/') + 1)
            //    };
            //result.Content.Headers.ContentType =
            //new MediaTypeHeaderValue("application/octet-stream");

            //return result;
        }
    }

}
