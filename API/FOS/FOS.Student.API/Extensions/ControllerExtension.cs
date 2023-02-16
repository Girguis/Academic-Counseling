using Microsoft.AspNetCore.Mvc;
using System.Security.Cryptography;
using System.Text;

namespace FOS.Student.API.Extensions
{
    internal static class ControllerExtension
    {
        /// <summary>
        /// Get logged in user's GUID from access token 
        /// access token is sent in the header of each request 
        /// </summary>
        /// <param name="controller"></param>
        /// <returns>GUID of logged in user</returns>
        public static string Guid(this ControllerBase controller)
        {
           return controller.HttpContext.User.Claims.FirstOrDefault(x => x.Type == "Guid")?.Value;
        }
        public static string HashPassowrd(this ControllerBase controller, string password)
        {
            var sha512 = SHA512.Create();
            var passWithKey = "MSKISH" + password + "20MSKISH22";
            var bytes = sha512.ComputeHash(Encoding.UTF8.GetBytes(passWithKey));
            return BitConverter.ToString(bytes).Replace("-", "");
        }
    }
}
