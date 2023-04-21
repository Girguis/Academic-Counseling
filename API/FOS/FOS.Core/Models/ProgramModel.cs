using System.ComponentModel.DataAnnotations;

namespace FOS.Core.Models
{
    public class ProgramModel
    {
        [Required]
        public ProgramDataModel programData { get; set; }
        [Required]
        public List<ProgramCourseModel> CoursesList { get; set; }
        [Required]
        public List<PrerequisiteCourseModel> PrerequisiteCoursesList { get; set; }
        [Required]
        public List<ProgramDistributionModel> ProgramHoursDistributionList { get; set; }
        [Required]
        public List<ElectiveCoursesDistributionModel> ElectiveCoursesDistributionList { get; set; }
    }
    public class ProgramDataModel
    {
        [Required]
        public string Name { get; set; }
        [Required]
        public byte Semester { get; set; }
        [Required]
        public double Percentage { get; set; }
        [Required]
        public bool IsRegular { get; set; }
        [Required]
        public bool IsGeneral { get; set; }
        [Required]
        public byte TotalHours { get; set; }
        [Required]
        public string EnglishName { get; set; }
        [Required]
        public string ArabicName { get; set; }
        [Required]
        public int? SuperProgramID { get; set; }
    }
    public class ProgramCourseModel
    {
        public int CourseId { get; set; }
        [Range(0, 3)]
        public byte PrerequisiteRelationId { get; set; }
        [Range(1, 3)]
        public byte CourseType { get; set; }
        public byte Category { get; set; }
        public short AddtionYearId { get; set; }
        public short? DeletionYearId { get; set; }

    }
    public class ProgramDistributionModel
    {
        public ProgramDistributionModel(byte level, byte semester, byte numberOfHours)
        {
            Level = level;
            Semester = semester;
            NumberOfHours = numberOfHours;
        }
        [Range(1, 10)]
        public byte Level { get; set; }
        [Range(1, 2)]
        public byte Semester { get; set; }
        public byte NumberOfHours { get; set; }
    }
    public class ElectiveCoursesDistributionModel
    {
        [Range(1, 10)]
        public byte Level { get; set; }
        [Range(1, 2)]
        public byte Semester { get; set; }
        [Range(1, 3)]
        public byte CourseType { get; set; }
        public byte Category { get; set; }
        public byte Hour { get; set; }
    }
    public class PrerequisiteCourseModel
    {
        public int CourseId { get; set; }
        public int PrerequisiteCourseId { get; set; }
    }
}
