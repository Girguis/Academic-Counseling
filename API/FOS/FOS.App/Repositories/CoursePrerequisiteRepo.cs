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

        public bool AddPrerequisites(int courseID, int programID, List<int> prerequisiteIDs)
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

        public bool DeletePrerequisites(int courseID, int programID)
        {
            var res = GetPrerequisites(courseID, programID);
            if (res.Count > 0)
            {
                string query = String.Format("DELETE FROM CoursePrerequisites WHERE CourseID = {0}", courseID);
                return context.Database.ExecuteSqlRaw(query) > 0;
            }
            return true;
        }

        public List<CoursePrerequisite> GetPrerequisites(int courseID, int programID)
        {
            return context.CoursePrerequisites
                .Where(x => x.CourseId == courseID && x.ProgramId == programID)
                .Include(x => x.PrerequisiteCourse)
                .AsParallel()
                .ToList();
        }

        public bool UpdatePrerequisites(int courseID, int programID, List<int> prerequisiteIDs)
        {
            var oldPrerequisites = GetPrerequisites(courseID, programID);
            DeletePrerequisites(courseID, programID);
            bool res;
            try
            {
                res = AddPrerequisites(courseID, programID, prerequisiteIDs);
            }
            catch
            {
                DeletePrerequisites(courseID, programID);
                AddPrerequisites(courseID, programID, oldPrerequisites.Select(x => x.PrerequisiteCourseId).ToList());
                return false;
            }
            return res;
        }
    }
}
