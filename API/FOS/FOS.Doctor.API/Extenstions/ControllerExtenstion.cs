using Microsoft.AspNetCore.Mvc;

namespace FOS.Doctors.API.Extenstions
{
    internal static class ControllerExtension
    {
        /// <summary>
        /// Get logged in user's GUID from access token 
        /// access token is sent in the header of each request 
        /// </summary>
        /// <param name="controller"></param>
        /// <returns>GUID of logged in user</returns>
        public static string? Guid(this ControllerBase controller)
        {
            return controller.HttpContext.User.Claims.FirstOrDefault(x => x.Type == "Guid")?.Value;
        }        
        public static string? ProgramID(this ControllerBase controller)
        {
            var pid = controller.HttpContext.User.Claims.FirstOrDefault(x => x.Type == "ProgramID")?.Value;
            if (string.IsNullOrEmpty(pid))
                return null;
            return pid;
        }
    }

}
