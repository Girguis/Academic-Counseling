using Microsoft.AspNetCore.Mvc;

namespace FOS.Supervisor.API.Extenstions
{
    internal static class ControllerExtension
    {
        //This function returns GUID of supervisor from the access token
        public static string Guid(this ControllerBase controller)
        {
            return controller.HttpContext.User.Claims.FirstOrDefault(x => x.Type == "Guid")?.Value;
        }
    }

}
