using ClosedXML.Excel;
using FOS.App.Helpers;
using FOS.Core.Enums;
using FOS.Core.IRepositories;
using FOS.Core.Models;
using FOS.DB.Models;

namespace FOS.App.ExcelReader
{
    public static class AcademicReportReader
    {
        public static Tuple<string, string, string, List<StudentCourse>, List<StudentProgramModel>,int>
            Read
            (IXLWorksheet ws,
            IStudentRepo studentRepo,
            List<AcademicYear> academicYearsLst,
            List<Program> programsLst,
            List<Course> coursesLst)
        {
            List<StudentCourse> studentCourses = new List<StudentCourse>();
            List<StudentProgramModel> studentPrograms = new List<StudentProgramModel>();
            int rowsCount = ws.Rows().Count();
            var name = ws.Cell("Q9").Value.ToString();
            var ssn = ws.Cell("E12").Value.ToString();
            var seatNumber = ws.Cell("E9").Value.ToString();
            short currentYearID = 1;
            int currentProgramID;
            int semesterCounter = 0;
            string currentAcademicYearStr = "";
            var std = studentRepo.GetBySSN(ssn);
            int studentID = -1;
            if (std != null)
                studentID = std.Id;
            for (int i = 21; i <= rowsCount; i++)
            {
                if (!ws.Cell("C" + i).IsEmpty()
                    && ws.Cell("C" + i).Value.ToString().Trim().Length > 1
                    && ws.Cell("U" + i).IsEmpty())
                {
                    string cellVal = ws.Cell("C" + i).Value.ToString();
                    var cellValues = cellVal.Split('-');
                    int count = cellValues.Count();
                    if (count == 4)
                    {
                        currentAcademicYearStr = cellValues[1].Trim() + "/" + cellValues[2].Trim();
                        var ProgramNameStr = cellValues[3].Trim();
                        var semesterStr = ws.Cell("C" + (i + 2)).Value.ToString().Split('-')[0].Trim();
                        byte semesterNo = Helper.GetSemesterNumber(semesterStr);
                        if (semesterNo != (int)SemesterEnum.Summer)
                            semesterCounter++;
                        currentYearID = academicYearsLst.FirstOrDefault(x => x.AcademicYear1 == currentAcademicYearStr && x.Semester == semesterNo).Id;
                        currentProgramID = programsLst.Where(x => x.ArabicName == ProgramNameStr && x.Semester <= semesterCounter)
                                            .OrderByDescending(x => x.Semester).FirstOrDefault().Id;
                        if (!studentPrograms.Any(x => x.ProgramId == currentProgramID))
                            studentPrograms.Add(new StudentProgramModel
                            {
                                StudentId = -1,
                                ProgramId = currentProgramID,
                                AcademicYear = currentYearID
                            });
                        i += 4;
                    }
                    else if (count == 2)
                    {
                        var semesterStr = ws.Cell("C" + i).Value.ToString().Split('-')[0].Trim();
                        var semesterNo = Helper.GetSemesterNumber(semesterStr);
                        if (semesterNo != (int)SemesterEnum.Summer)
                            semesterCounter++;
                        currentYearID = academicYearsLst.FirstOrDefault(x => x.AcademicYear1 == currentAcademicYearStr && x.Semester == semesterNo).Id;
                        i += 2;
                    }
                }
                else if (!ws.Cell("U" + i).IsEmpty())
                {
                    StudentCourse course = new StudentCourse();
                    course.AcademicYearId = currentYearID;
                    course.StudentId = studentID;
                    var courseCode = ws.Cell("U" + i).Value.ToString();
                    var courseObj = coursesLst.FirstOrDefault(x => x.CourseCode == courseCode);
                    course.CourseId = courseObj.Id;
                    if (ws.Cell("O" + i).IsEmpty())
                    {
                        course.HasExecuse = true;
                        course.Mark = null;
                        course.IsGpaincluded = false;
                    }
                    else
                    {
                        course.HasExecuse = false;
                        if (ws.Cell("S" + i).Value.ToString().Contains("-**"))
                        {
                            course.IsGpaincluded = false;
                            course.Grade = ws.Cell("R" + i).Value.ToString();
                            course.Mark = null;
                        }
                        else if (ws.Cell("S" + i).Value.ToString().Contains("-"))
                        {
                            course.IsGpaincluded = false;
                            course.Grade = ws.Cell("R" + i).Value.ToString();
                            course.Mark = byte.Parse(ws.Cell("O" + i).Value.ToString());
                        }
                        else
                        {
                            course.IsGpaincluded = true;
                            course.Mark = byte.Parse(ws.Cell("O" + i).Value.ToString());
                        }
                    }
                    course.Course = courseObj;
                    course.IsApproved = true;
                    studentCourses.Add(course);
                }
            }
            return Tuple.Create(name, ssn, seatNumber, studentCourses, studentPrograms,studentID);
        }
    }
}
