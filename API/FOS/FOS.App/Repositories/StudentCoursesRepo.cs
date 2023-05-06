using Dapper;
using FOS.App.Comparers;
using FOS.App.Helpers;
using FOS.Core;
using FOS.Core.Configs;
using FOS.Core.Enums;
using FOS.Core.IRepositories;
using FOS.Core.Models;
using FOS.Core.Models.ParametersModels;
using FOS.Core.Models.StoredProcedureOutputModels;
using FOS.DB.Models;
using Microsoft.Data.SqlClient;
using Microsoft.Extensions.Configuration;
using System.Data;

namespace FOS.App.Repositories
{
    public class StudentCoursesRepo : IStudentCoursesRepo
    {
        private readonly IAcademicYearRepo academicYearRepo;
        private readonly IDbContext config;

        public StudentCoursesRepo(IAcademicYearRepo academicYearRepo,
            IDbContext config)
        {
            this.academicYearRepo = academicYearRepo;
            this.config = config;
        }
        /// <summary>
        /// Method to get all courses for a certain student
        /// </summary>
        /// <param name="studentID"></param>
        /// <returns></returns>
        public IEnumerable<StudentCourse> GetAllCourses(int studentID)
        {
            DynamicParameters parameters = new DynamicParameters();
            parameters.Add("@StudentID", studentID);
            using var con = config.CreateInstance();
            return con.Query<StudentCourse, Course, StudentCourse>
                ("GetAllStudentCourses",
                (studentCourse, course) =>
                {
                    studentCourse.Course = course;
                    return studentCourse;
                },
                splitOn: "ID",
                param: parameters,
                commandType: CommandType.StoredProcedure);
        }
        /// <summary>
        /// Method to get all courses for a certain student for the current year
        /// </summary>
        /// <param name="studentID"></param>
        /// <returns></returns>
        public List<StudentCoursesOutModel> GetCurrentAcademicYearCourses(int studentID)
        {
            return GetCoursesByAcademicYear(studentID, academicYearRepo.GetCurrentYear().Id);
        }
        /// <summary>
        /// Method to get all courses for a certain student in any academic year
        /// </summary>
        /// <param name="studentID"></param>
        /// <param name="academicYearID"></param>
        /// <returns></returns>
        public List<StudentCoursesOutModel> GetCoursesByAcademicYear(int studentID, short academicYearID)
        {
            DynamicParameters parameters = new DynamicParameters();
            parameters.Add("@StudentID", studentID);
            parameters.Add("@AcademicYearID", academicYearID);
            return QueryExecuterHelper.Execute<StudentCoursesOutModel>(config.CreateInstance(), "GetStudentCoursesByAcademicYear", parameters);
        }
        /// <summary>
        /// Method to get courses that student can register
        /// </summary>
        /// <param name="studentID"></param>
        /// <returns></returns>
        public List<CourseRegistrationOutModel> GetCoursesForRegistration(int studentID)
        {
            var parameters = new DynamicParameters();
            parameters.Add("@StudentID", studentID);
            parameters.Add("@Levels", GetLevelFromAppsettings());
            return QueryExecuterHelper.Execute<CourseRegistrationOutModel>(config.CreateInstance(), "GetAvailableCoursesToRegister", parameters);
        }
        public bool RegisterCourses(int studentID, short academicYearID, List<int> courses)
        {
            var insertStatement = "INSERT INTO StudentCourses(StudentID,CourseID,AcademicYearID,IsApproved,IsGPAIncluded) VALUES ({0},{1},{2},{3},{4});";
            string query = "";
            for (int i = 0; i < courses.Count; i++)
            {
                query += string.Format(insertStatement, studentID, courses.ElementAt(i), academicYearID, 1, 1);
            }
            List<SqlParameter> parameters = new List<SqlParameter>()
            {
                new SqlParameter("@Query", query),
                new SqlParameter("@StudentID", studentID),
                new SqlParameter("@CurrentAcademicYearID", academicYearID)
            };
            return QueryExecuterHelper.Execute(config.CreateInstance(), "StudentCoursesRegistration", parameters);
        }

        public (List<StudentCourse> toBeSavedLst, List<StudentCourse> toBeRemovedLst,
            List<StudentCourse> toBeUpdatedLst, List<StudentCourse> toBeUpdatedOldMarksLst)
            CompareStudentCourse(int studentID, List<StudentCourse> studentCourses)
        {
            if (studentID == -1)
                return (studentCourses, new List<StudentCourse>(), new List<StudentCourse>(), new List<StudentCourse>());
            var savedCoursesLst = GetAllCourses(studentID);
            ToBeInsertedStudentCoursesComparer insertedCoursesComparer = new();
            ToBeUpdatedStudentCoursesComparer updatedCoursesComparer = new();
            List<StudentCourse> toBeSavedLst = studentCourses
                .Except(savedCoursesLst, insertedCoursesComparer)
                .ToList();
            List<StudentCourse> toBeRemovedLst = savedCoursesLst
                                                .Except(studentCourses, insertedCoursesComparer)
                                                .ToList();
            List<StudentCourse> toBeUpdatedLst = studentCourses
                                                .Except(savedCoursesLst, updatedCoursesComparer)
                                                .Except(toBeSavedLst, insertedCoursesComparer)
                                                .ToList();
            List<StudentCourse> toBeUpdatedOldMarksLst = savedCoursesLst
                                                        .Except(studentCourses, updatedCoursesComparer)
                                                        .Except(toBeSavedLst, insertedCoursesComparer)
                                                        .Except(toBeRemovedLst, insertedCoursesComparer)
                                                        .ToList();
            return (toBeSavedLst, toBeRemovedLst, toBeUpdatedLst, toBeUpdatedOldMarksLst);
        }
        public bool UpdateStudentCourses(int studentID, AcademicRecordModels model)
        {
            string query = "";
            for (int i = 0; i < model.ToBeRemoved.Count; i++)
            {
                var obj = model.ToBeRemoved.ElementAt(i);
                query +=
                    string
                    .Format("UPDATE StudentCourses SET IsIncluded = 0 WHERE CourseID = {0} AND StudentID = {1} AND AcademicYearID = {2}; "
                    , obj.CourseID, studentID, obj.AcademicYearID);
            }
            for (int i = 0; i < model.ToBeUpdated.Count; i++)
            {
                var obj = model.ToBeUpdated.ElementAt(i);
                query += string
                    .Format("UPDATE StudentCourses SET Mark = {0} WHERE CourseID = {1} AND StudentID = {2} AND AcademicYearID = {3}; ",
                    obj.NewMark, obj.CourseID, studentID, obj.AcademicYearID);
            }
            for (int i = 0; i < model.ToBeInserted.Count(); i++)
            {
                var course = model.ToBeInserted.ElementAt(i);
                if (course.HasExcuse == true)
                {
                    query += string.Format("INSERT INTO StudentCourses(StudentID,CourseID,AcademicYearID,IsApproved,HasExcuse,IsGpaIncluded) VALUES({0},{1},{2},{3},{4},{5});",
                        studentID, course.CourseID, course.AcademicYearID, 1, 1, 0);
                }
                else if (course.IsGpaIncluded == false && course.Mark == null)
                {
                    query += string.Format("INSERT INTO StudentCourses(StudentID,CourseID,AcademicYearID,IsApproved,IsGpaIncluded,Grade) VALUES({0},{1},{2},{3},{4},'{5}');",
                        studentID, course.CourseID, course.AcademicYearID, 1, 0, course.Grade.Trim());
                }
                else if (course.IsGpaIncluded == false && course.Mark != null)
                {
                    query += string.Format("INSERT INTO StudentCourses(StudentID,CourseID,AcademicYearID,IsApproved,IsGpaIncluded,Mark) VALUES({0},{1},{2},{3},{4},{5});",
                        studentID, course.CourseID, course.AcademicYearID, 1, 0, course.Mark);
                }
                else
                {
                    query += string.Format("INSERT INTO StudentCourses(StudentID,CourseID,AcademicYearID,IsApproved,IsGpaIncluded,Mark) VALUES({0},{1},{2},{3},{4},{5});",
                            studentID, course.CourseID, course.AcademicYearID, 1, 1, course.Mark);
                }
            }
            if (string.IsNullOrEmpty(query))
                return true;
            List<SqlParameter> parameters = new List<SqlParameter>()
            {
                new SqlParameter("@StudentID", studentID),
                new SqlParameter("@Query", query)
            };
            return QueryExecuterHelper.Execute(config.CreateInstance(), "AddStudentCourses", parameters);
        }
        public CourseGradesSheetOutModel GetStudentsMarksList(StudentsExamParamModel model)
        {
            DynamicParameters parameters = new DynamicParameters();
            parameters.Add("@CourseID", model.CourseID);
            parameters.Add("@IsFinalExam", model.IsFinalExam);
            using var con = config.CreateInstance();
            var result = con.QueryMultiple("Report_CourseGradesSheet", parameters, commandType: CommandType.StoredProcedure);
            CourseGradesSheetOutModel outModel = new CourseGradesSheetOutModel();
            outModel.Course = result.ReadFirstOrDefault<CourseOutModel>();
            if (outModel.Course == null) return null;
            outModel.YearModel = result.ReadFirstOrDefault<AcademicYearOutModel>();
            outModel.Students = result.Read<StudentMarkOutModel>().ToList();
            return outModel;
        }
        public List<CourseGradesSheetOutModel> GetStudentsMarksList(bool isFinalExam)
        {
            DynamicParameters parameters = new();
            parameters.Add("@IsFinalExam", isFinalExam);
            using var con = config.CreateInstance();
            var result = con.QueryMultiple("Report_MultipleCourseGradesSheet", parameters, commandType: CommandType.StoredProcedure);
            int coursesCount = result.ReadFirst<int>();
            var courses = new List<CourseGradesSheetOutModel>();
            for(int i=0;i<coursesCount; i++)
            {
                courses.Add(new CourseGradesSheetOutModel
                {
                    Course = result.ReadFirstOrDefault<CourseOutModel>(),
                    YearModel = result.ReadFirstOrDefault<AcademicYearOutModel>(),
                    Students = result.Read<StudentMarkOutModel>().ToList()
                });
            }
            return courses;
        }
        public ExamCommitteeStudentsOutModel GetStudentsList(int CourseID)
        {
            DynamicParameters parameters = new DynamicParameters();
            parameters.Add("@CourseID", CourseID);
            using var con = config.CreateInstance();
            var result = con.QueryMultiple("Report_ExamCommitteeStudents", parameters, commandType: CommandType.StoredProcedure);
            ExamCommitteeStudentsOutModel outModel = new ExamCommitteeStudentsOutModel();
            outModel.Course = result.ReadFirstOrDefault<CourseOutModel>();
            outModel.Students = result.Read<StudentOutModel>().ToList();
            return outModel;
        }
        public IEnumerable<ExamCommitteeStudentsOutModel> GetStudentsLists()
        {
            var result = config.CreateInstance()
                .QueryMultiple("Report_MultipleExamCommitteeStudents",
                commandType: CommandType.StoredProcedure);
            var coursesCount = result.ReadFirst<int>();
            var outModel = new List<ExamCommitteeStudentsOutModel>();
            for (int i = 0; i < coursesCount; i++)
            {
                outModel.Add(new ExamCommitteeStudentsOutModel()
                {
                    Course = result.ReadFirstOrDefault<CourseOutModel>(),
                    Students = result.Read<StudentOutModel>().ToList()
                });
            }
            return outModel;
        }

        public bool UpdateStudentsGradesFromSheet(List<GradesSheetUpdateModel> model, bool isFinalExam)
        {
            string query = "";
            if (isFinalExam)
                for (int i = 0; i < model.Count; i++)
                {
                    var stdMarks = model[i];
                    query += string.Concat("UPDATE StudentCourses SET Final =", stdMarks.Final.HasValue ? model.ElementAt(i).Final : "NULL",
                        " WHERE StudentID = (SELECT ID FROM Student WHERE AcademicCode = ", model.ElementAt(i).AcademicCode, ")",
                        " AND AcademicYearID = ", model.ElementAt(i).AcademicYearID, " AND CourseID = ", model.ElementAt(i).CourseID, "; ");
                }
            else
                for (int i = 0; i < model.Count; i++)
                {
                    var stdMarks = model[i];    
                    query += string.Concat("UPDATE StudentCourses",
                        " SET Oral  = ", stdMarks.Oral.HasValue ? model.ElementAt(i).Oral : "NULL",
                        ",YearWork = ",stdMarks.YearWork.HasValue?stdMarks.YearWork.Value:"NULL",
                        ",Practical = ", stdMarks.Practical.HasValue ? stdMarks.Practical.Value : "NULL",
                        " WHERE StudentID = (SELECT ID FROM Student WHERE AcademicCode = ", model.ElementAt(i).AcademicCode, ")",
                        " AND AcademicYearID = ", model.ElementAt(i).AcademicYearID, " AND CourseID = ", model.ElementAt(i).CourseID, "; ");
                }
            List<SqlParameter> parameters = new List<SqlParameter>
            {
                new SqlParameter("@Query", query)
            };
            return QueryExecuterHelper.Execute(config.CreateInstance(), "QueryExecuter", parameters);
        }
        public bool UpdateStudentCourses(List<StudentCourse> studentCourses)
        {
            int studentID = studentCourses.ElementAt(0).StudentId;
            var savedCoursesLst = GetAllCourses(studentID);
            ToBeInsertedStudentCoursesComparer insertedCoursesComparer = new();
            IEnumerable<StudentCourse> toBeSavedLst = studentCourses.Except(savedCoursesLst, insertedCoursesComparer);
            if (!toBeSavedLst.Any())
                return true;
            string query = "";
            for (int i = 0; i < toBeSavedLst.Count(); i++)
            {
                var course = toBeSavedLst.ElementAt(i);
                if (course.HasExcuse == true)
                {
                    query += string.Format("INSERT INTO StudentCourses(StudentID,CourseID,AcademicYearID,IsApproved,HasExcuse,IsGpaIncluded) VALUES({0},{1},{2},{3},{4},{5});",
                        course.StudentId, course.CourseId, course.AcademicYearId, 1, 1, 0);
                }
                else if (course.IsGpaincluded == false && course.Mark == null)
                {
                    query += string.Format("INSERT INTO StudentCourses(StudentID,CourseID,AcademicYearID,IsApproved,IsGpaIncluded,Grade) VALUES({0},{1},{2},{3},{4},'{5}');",
                        course.StudentId, course.CourseId, course.AcademicYearId, 1, 0, course.Grade.Trim());
                }
                else if (course.IsGpaincluded == false && course.Mark != null)
                {
                    query += string.Format("INSERT INTO StudentCourses(StudentID,CourseID,AcademicYearID,IsApproved,IsGpaIncluded,Mark) VALUES({0},{1},{2},{3},{4},{5});",
                        course.StudentId, course.CourseId, course.AcademicYearId, 1, 0, course.Mark);
                }
                else
                {
                    query += string.Format("INSERT INTO StudentCourses(StudentID,CourseID,AcademicYearID,IsApproved,IsGpaIncluded,Mark) VALUES({0},{1},{2},{3},{4},{5});",
                            course.StudentId, course.CourseId, course.AcademicYearId, 1, 1, course.Mark);
                }
            }
            List<SqlParameter> parameters = new List<SqlParameter>()
            {
                new SqlParameter("@StudentID", studentID),
                new SqlParameter("@Query", query)
            };
            return QueryExecuterHelper.Execute(config.CreateInstance(), "AddStudentCourses", parameters);
        }

        public (List<CourseRegistrationOutModel> toAdd, List<CourseRegistrationOutModel> toDelete, List<ElectiveCoursesDistribtionOutModel> electiveCoursesDistribtion) GetCoursesForAddAndDelete(int studentID)
        {
            DynamicParameters parameters = new DynamicParameters();
            parameters.Add("@StudentID", studentID);
            parameters.Add("@Levels", GetLevelFromAppsettings());
            using var con = config.CreateInstance();
            var result = con.QueryMultiple("GetCoursesForAddAndDelete", parameters, commandType: CommandType.StoredProcedure);
            var distribtion = result.Read<ElectiveCoursesDistribtionOutModel>().ToList();
            var toAdd = result.Read<CourseRegistrationOutModel>().ToList();
            var toDelete = result.Read<CourseRegistrationOutModel>().ToList();
            return (toAdd, toDelete, distribtion);
        }

        public bool RequestAddAndDelete(int studentID, AddAndDeleteCoursesParamModel model)
        {
            var query = "DELETE FROM StudentCourseRequest" +
                " WHERE StudentID = " + studentID + " AND" +
                " RequestTypeID = " + (int)CourseRequestEnum.AddtionDeletion + ";";
            var guid = Guid.NewGuid().ToString();

            for (int i = 0; i < model.ToAdd.Count; i++)
                query += "INSERT INTO StudentCourseRequest(RequestID,RequestTypeID,StudentID,CourseID,CourseOperationID)" +
                    " VALUES('" + guid + "'," + (int)CourseRequestEnum.AddtionDeletion + "," +
                    studentID + "," + model.ToAdd.ElementAt(i) + "," + (int)CourseOperationEnum.Addtion + ");";

            for (int i = 0; i < model.ToDelete.Count; i++)
                query += "INSERT INTO StudentCourseRequest(RequestID,RequestTypeID,StudentID,CourseID,CourseOperationID)" +
                    " VALUES('" + guid + "'," + (int)CourseRequestEnum.AddtionDeletion + "," +
                    studentID + "," + model.ToDelete.ElementAt(i) + "," + (int)CourseOperationEnum.Deletion + ");";

            return QueryExecuterHelper.Execute(config.CreateInstance(), query);
        }

        public List<CourseRegistrationOutModel> GetCoursesForWithdraw(int studentID)
        {
            DynamicParameters parameters = new DynamicParameters();
            parameters.Add("@StudentID", studentID);
            return QueryExecuterHelper.Execute<CourseRegistrationOutModel>(config.CreateInstance(), "GetCoursesForDeletionOrWithdraw", parameters);
        }
        public (int RegisteredHours, List<CourseRegistrationOutModel> courses,
            List<ElectiveCoursesDistribtionOutModel> electiveCoursesDistribtion)
            GetCoursesForOverload(int studentID)
        {
            DynamicParameters parameters = new DynamicParameters();
            parameters.Add("@StudentID", studentID);
            parameters.Add("@Levels", GetLevelFromAppsettings());
            using var con = config.CreateInstance();
            var result = con.QueryMultiple("GetCoursesForOverload", parameters, commandType: CommandType.StoredProcedure);
            var hours = result.ReadFirstOrDefault<int>();
            var courses = result.Read<CourseRegistrationOutModel>().ToList();
            var distribution = result.Read<ElectiveCoursesDistribtionOutModel>().ToList();
            return (hours, courses, distribution);
        }

        public bool RequestCourse(int requestType, int studentID, CoursesLstParamModel model, int courseOp)
        {
            var query = "DELETE FROM StudentCourseRequest" +
             " WHERE StudentID = " + studentID + " AND" +
             " RequestTypeID = " + requestType + ";";
            var guid = Guid.NewGuid().ToString();
            for (int i = 0; i < model.CoursesList.Count; i++)
                query += "INSERT INTO StudentCourseRequest(RequestID,RequestTypeID,StudentID,CourseID,CourseOperationID)" +
                    " VALUES('" + guid + "'," + requestType + "," +
                    studentID + "," + model.CoursesList.ElementAt(i) + "," + courseOp + ");";
            return QueryExecuterHelper.Execute(config.CreateInstance(), query);
        }

        public (List<CourseRegistrationOutModel> courses,
            List<ElectiveCoursesDistribtionOutModel> electiveCoursesDistribtion)
            GetCoursesForEnhancement(int studentID)
        {
            DynamicParameters parameters = new DynamicParameters();
            parameters.Add("@studentID", studentID);
            using var con = config.CreateInstance();
            var result = con.QueryMultiple("GetCoursesForEnhancement", parameters, commandType: CommandType.StoredProcedure);
            var courses = result.Read<CourseRegistrationOutModel>().ToList();
            var distribution = result.Read<ElectiveCoursesDistribtionOutModel>().ToList();
            return (courses, distribution);
        }
        public (List<CourseRegistrationOutModel> courses,
            List<ElectiveCoursesDistribtionOutModel> electiveCoursesDistribtion)
            GetCoursesForGraduation(int studentID)
        {
            DynamicParameters parameters = new DynamicParameters();
            parameters.Add("@studentID", studentID);
            using var con = config.CreateInstance();
            var result = con.QueryMultiple("GetCoursesForGraduation", parameters, commandType: CommandType.StoredProcedure);
            var courses = result.Read<CourseRegistrationOutModel>().ToList();
            var distribution = result.Read<ElectiveCoursesDistribtionOutModel>().ToList();
            return (courses, distribution);
        }

        public List<GetAllCoursesRegistrationModel> GetAllRegistrations()
        {
            using var con = config.CreateInstance();
            return con.Query<GetAllCoursesRegistrationOutModel>("GetAllCoursesRegistration",
                commandType: CommandType.StoredProcedure).GroupBy(x => x.SSN).Select(y => new GetAllCoursesRegistrationModel
                {
                    SSN = y.Key,
                    Courses = y.Select(x => x.CourseCode).ToList(),
                }).ToList();
        }
        private int GetLevelFromAppsettings() => ConfigurationsManager.TryGetNumber(Config.LevelsRangeForCourseRegistraion, 1);

        public IEnumerable<dynamic> GetStudentsForAnalysis(short startYearID, short endYearID)
        {
            DynamicParameters parameters = new DynamicParameters();
            parameters.Add("@StartYear", startYearID);
            parameters.Add("@EndYear", endYearID);
            return config.CreateInstance().Query("[dbo].[AnalysisTeam_StudentsBasicData]",param: parameters,
                commandType: CommandType.StoredProcedure);
        }
        public IEnumerable<dynamic> GetStudentsGpasForAnalysis(short startYearID, short endYearID)
        {
            DynamicParameters parameters = new DynamicParameters();
            parameters.Add("@StartYear", startYearID);
            parameters.Add("@EndYear", endYearID);
            return config.CreateInstance().Query("[dbo].[AnalysisTeam_StudentsSemestersGpa]",
                parameters,
                commandType: CommandType.StoredProcedure);
        }
        public IEnumerable<dynamic> GetDoctorsCoursesForAnalysis(short startYearID, short endYearID)
        {
            DynamicParameters parameters = new DynamicParameters();
            parameters.Add("@StartYear", startYearID);
            parameters.Add("@EndYear", endYearID);
            return config.CreateInstance().Query("[dbo].[AnalysisTeam_CoursesAndTheirDoctors]",
                parameters,
                commandType: CommandType.StoredProcedure);
        }
        public IEnumerable<dynamic> GetStudentsCoursesForAnalysis(short startYearID, short endYearID)
        {
            DynamicParameters parameters = new DynamicParameters();
            parameters.Add("@StartYear", startYearID);
            parameters.Add("@EndYear", endYearID);
            return config.CreateInstance()
                .Query("[dbo].[AnalysisTeam_StudentsCoursesDetails]",
                parameters,
                commandType: CommandType.StoredProcedure);
        }
        
    }
}