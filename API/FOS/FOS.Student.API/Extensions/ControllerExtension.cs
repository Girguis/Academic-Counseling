using Microsoft.AspNetCore.Mvc;

namespace FOS.Student.API.Extensions
{
    internal static class ControllerExtension
    {
        public static string Guid(this ControllerBase controller)
        {
           return controller.HttpContext.User.Claims.FirstOrDefault(x => x.Type == "Guid")?.Value;
        }
    }
}
