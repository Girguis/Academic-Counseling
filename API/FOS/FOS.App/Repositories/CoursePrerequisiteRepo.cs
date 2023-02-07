using FOS.Core.IRepositories;
using FOS.DB.Models;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using System.Data;

namespace FOS.App.Repositories
{
    public class CoursePrerequisiteRepo : ICoursePrerequisiteRepo
    {
        private readonly FOSContext context;
        private readonly IConfiguration configuration;

        public CoursePrerequisiteRepo(FOSContext context, IConfiguration configuration)
        {
            this.context = context;
            this.configuration = configuration;
        }

        public bool AddPrerequisites(int courseID, List<int> prerequisiteIDs)
        {
            var query = "INSERT INTO CoursePrerequisites(CourseID,PrerequisiteCourseID) VALUES";
            int count = prerequisiteIDs.Count;
            for (int i = 0; i < count; i++)
            {
                query += String.Concat("(", courseID, ",", prerequisiteIDs.ElementAt(i), ")");
                if (i != count - 1)
                    query += ",";
            }
            return context.Database.ExecuteSqlRaw(query) > 0;
        }

        public bool DeletePrerequisites(int courseID)
        {
            var res = GetPrerequisites(courseID);
            if (res.Count > 0)
            {
                string query = String.Format("DELETE FROM CoursePrerequisites WHERE CourseID = {0}", courseID);
                return context.Database.ExecuteSqlRaw(query) > 0;
            }
            return true;
        }

        public List<CoursePrerequisite> GetPrerequisites(int courseID)
        {
            return context.CoursePrerequisites
                .Where(x => x.CourseId == courseID)
                .Include(x => x.PrerequisiteCourse)
                .AsParallel()
                .ToList();
        }

        public bool UpdatePrerequisites(int courseID, List<int> prerequisiteIDs)
        {
            var oldPrerequisites = GetPrerequisites(courseID);
            DeletePrerequisites(courseID);
            bool res;
            try
            {
                res = AddPrerequisites(courseID, prerequisiteIDs);
            }
            catch
            {
                DeletePrerequisites(courseID);
                AddPrerequisites(courseID, oldPrerequisites.Select(x => x.PrerequisiteCourseId).ToList());
                return false;
            }
            return res;
        }
    }
}
