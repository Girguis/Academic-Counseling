using FOS.Core.Enums;
using System.Security.Cryptography;
using System.Text;

namespace FOS.App.Helpers
{
    public static class Helper
    {
        public static byte GetSemesterNumber(string semesterStr)
        {
            if (semesterStr.Contains("الخريف"))
                return (byte)SemesterEnum.Autumn;
            else if (semesterStr.Contains("الربيع"))
                return (byte)SemesterEnum.Spring;
            else
                return (byte)SemesterEnum.Summer;
        }
        public static string HashPassowrd(string password)
        {
            var sha512 = SHA512.Create();
            var passWithKey = "MSKISH" + password + "20MSKISH22";
            var bytes = sha512.ComputeHash(Encoding.UTF8.GetBytes(passWithKey));
            return BitConverter.ToString(bytes).Replace("-", "");
        }
    }
}
