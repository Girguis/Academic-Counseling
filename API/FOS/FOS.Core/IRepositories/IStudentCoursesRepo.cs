﻿using FOS.Core.Models;
using FOS.Core.Models.ParametersModels;
using FOS.Core.Models.StoredProcedureOutputModels;
using FOS.DB.Models;

namespace FOS.Core.IRepositories
{
    public interface IStudentCoursesRepo
    {
        IEnumerable<StudentCourse> GetAllCourses(int studentID);
        List<StudentCoursesOutModel> GetCoursesByAcademicYear(int studentID, short academicYearID);
        List<StudentCoursesOutModel> GetCurrentAcademicYearCourses(int studentID);
        List<CourseRegistrationOutModel> GetCoursesForRegistration(int studentID);
        (List<CourseRegistrationOutModel> toAdd,
            List<CourseRegistrationOutModel> toDelete,
            List<ElectiveCoursesDistribtionOutModel> electiveCoursesDistribtion)
            GetCoursesForAddAndDelete(int studentID);
        List<CourseRegistrationOutModel> GetCoursesForWithdraw(int studentID);
        (List<CourseRegistrationOutModel> courses,
            List<ElectiveCoursesDistribtionOutModel> electiveCoursesDistribtion)
            GetCoursesForEnhancement(int studentID);
        (List<CourseRegistrationOutModel> courses,
            List<ElectiveCoursesDistribtionOutModel> electiveCoursesDistribtion)
            GetCoursesForGraduation(int studentID);
        (int RegisteredHours, List<CourseRegistrationOutModel> courses,
            List<ElectiveCoursesDistribtionOutModel> electiveCoursesDistribtion)
            GetCoursesForOverload(int studentID);
        bool RegisterCourses(int studentID, short academicYearID, List<int> courseIDs);
        bool UpdateStudentCourses(List<StudentCourse> studentCourses);
        bool UpdateStudentCourses(int studentID, AcademicRecordModels model);
        (List<StudentCourse> toBeSavedLst, List<StudentCourse> toBeRemovedLst,
            List<StudentCourse> toBeUpdatedLst, List<StudentCourse> toBeUpdatedOldMarksLst)
            CompareStudentCourse(int studentID, List<StudentCourse> studentCourses);
        CourseGradesSheetOutModel GetStudentsMarksList(StudentsExamParamModel model);
        List<CourseGradesSheetOutModel> GetStudentsMarksList(bool isFinalExam);
        ExamCommitteeStudentsOutModel GetStudentsList(int CourseID);
        public IEnumerable<ExamCommitteeStudentsOutModel> GetStudentsLists();
        bool UpdateStudentsGradesFromSheet(List<GradesSheetUpdateModel> model, bool isFinalExam);
        bool RequestAddAndDelete(int studentID, AddAndDeleteCoursesParamModel model);
        bool RequestCourse(int requestType, int studentID, CoursesLstParamModel model, int courseOp);
        List<GetAllCoursesRegistrationModel> GetAllRegistrations();
        IEnumerable<dynamic> GetStudentsForAnalysis(short startYearID, short endYearID);
        IEnumerable<dynamic> GetStudentsGpasForAnalysis(short startYearID, short endYearID);
        IEnumerable<dynamic> GetDoctorsCoursesForAnalysis(short startYearID, short endYearID);
        IEnumerable<dynamic> GetStudentsCoursesForAnalysis(short startYearID, short endYearID);
    }
}
