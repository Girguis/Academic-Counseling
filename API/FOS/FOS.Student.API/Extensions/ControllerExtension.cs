using Microsoft.AspNetCore.Mvc;

namespace FOS.Student.API.Extensions
{
    internal static class ControllerExtension
    {
        //This function returns GUID of student from the access token
        public static string Guid(this ControllerBase controller)
        {
           return controller.HttpContext.User.Claims.FirstOrDefault(x => x.Type == "Guid")?.Value;
        }
    }
}
