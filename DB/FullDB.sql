USE [FOS]
GO
/****** Object:  Trigger [UpdateStudentCourse]    Script Date: 2023-01-30 7:09:45 PM ******/
DROP TRIGGER IF EXISTS [dbo].[UpdateStudentCourse]
GO
/****** Object:  Trigger [GiveBackCredits]    Script Date: 2023-01-30 7:09:45 PM ******/
DROP TRIGGER IF EXISTS [dbo].[GiveBackCredits]
GO
/****** Object:  Trigger [EntringStudentCourse]    Script Date: 2023-01-30 7:09:45 PM ******/
DROP TRIGGER IF EXISTS [dbo].[EntringStudentCourse]
GO
/****** Object:  Trigger [CalculateProgramTotalHoursIfAnyDeleted]    Script Date: 2023-01-30 7:09:45 PM ******/
DROP TRIGGER IF EXISTS [dbo].[CalculateProgramTotalHoursIfAnyDeleted]
GO
/****** Object:  Trigger [CalculateProgramTotalHours]    Script Date: 2023-01-30 7:09:45 PM ******/
DROP TRIGGER IF EXISTS [dbo].[CalculateProgramTotalHours]
GO
/****** Object:  Trigger [SetActiveCoursesBySemester]    Script Date: 2023-01-30 7:09:45 PM ******/
DROP TRIGGER IF EXISTS [dbo].[SetActiveCoursesBySemester]
GO
/****** Object:  Trigger [IncreaseNumberOfSemestersInProgramForStudent]    Script Date: 2023-01-30 7:09:45 PM ******/
DROP TRIGGER IF EXISTS [dbo].[IncreaseNumberOfSemestersInProgramForStudent]
GO
/****** Object:  StoredProcedure [dbo].[SP_StudentLogin]    Script Date: 2023-01-30 7:09:45 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[SP_StudentLogin]
GO
/****** Object:  StoredProcedure [dbo].[RegisterCoursesForStudent]    Script Date: 2023-01-30 7:09:45 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[RegisterCoursesForStudent]
GO
/****** Object:  StoredProcedure [dbo].[GetPassedCoursesList]    Script Date: 2023-01-30 7:09:45 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[GetPassedCoursesList]
GO
/****** Object:  StoredProcedure [dbo].[GetFailedCoursesList]    Script Date: 2023-01-30 7:09:45 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[GetFailedCoursesList]
GO
/****** Object:  StoredProcedure [dbo].[GetCoursesListExceptPassed]    Script Date: 2023-01-30 7:09:45 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[GetCoursesListExceptPassed]
GO
/****** Object:  StoredProcedure [dbo].[GetAvailableCoursesToRegister]    Script Date: 2023-01-30 7:09:45 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[GetAvailableCoursesToRegister]
GO
/****** Object:  StoredProcedure [dbo].[BackUpDatabase]    Script Date: 2023-01-30 7:09:45 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[BackUpDatabase]
GO
/****** Object:  StoredProcedure [dbo].[AddStudentsToPrograms]    Script Date: 2023-01-30 7:09:45 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[AddStudentsToPrograms]
GO
/****** Object:  StoredProcedure [dbo].[AddStudentDesires]    Script Date: 2023-01-30 7:09:45 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[AddStudentDesires]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TeacherCourses]') AND type in (N'U'))
ALTER TABLE [dbo].[TeacherCourses] DROP CONSTRAINT IF EXISTS [FK_TeacherCourses_Supervisor]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TeacherCourses]') AND type in (N'U'))
ALTER TABLE [dbo].[TeacherCourses] DROP CONSTRAINT IF EXISTS [FK_TeacherCourses_Course]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TeacherCourses]') AND type in (N'U'))
ALTER TABLE [dbo].[TeacherCourses] DROP CONSTRAINT IF EXISTS [FK_TeacherCourses_AcademicYear]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Supervisor]') AND type in (N'U'))
ALTER TABLE [dbo].[Supervisor] DROP CONSTRAINT IF EXISTS [FK_Supervisor_Program]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SuperAdmin]') AND type in (N'U'))
ALTER TABLE [dbo].[SuperAdmin] DROP CONSTRAINT IF EXISTS [FK_SuperAdmin_Program]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[StudentPrograms]') AND type in (N'U'))
ALTER TABLE [dbo].[StudentPrograms] DROP CONSTRAINT IF EXISTS [FK_StudentPrograms_Student]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[StudentPrograms]') AND type in (N'U'))
ALTER TABLE [dbo].[StudentPrograms] DROP CONSTRAINT IF EXISTS [FK_StudentPrograms_Program]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[StudentPrograms]') AND type in (N'U'))
ALTER TABLE [dbo].[StudentPrograms] DROP CONSTRAINT IF EXISTS [FK_StudentPrograms_AcademicYear]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[StudentDesires]') AND type in (N'U'))
ALTER TABLE [dbo].[StudentDesires] DROP CONSTRAINT IF EXISTS [FK_StudentDesires_Student]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[StudentDesires]') AND type in (N'U'))
ALTER TABLE [dbo].[StudentDesires] DROP CONSTRAINT IF EXISTS [FK_StudentDesires_Program]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[StudentCourses]') AND type in (N'U'))
ALTER TABLE [dbo].[StudentCourses] DROP CONSTRAINT IF EXISTS [FK_StudentCourses_Student]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[StudentCourses]') AND type in (N'U'))
ALTER TABLE [dbo].[StudentCourses] DROP CONSTRAINT IF EXISTS [FK_StudentCourses_Course]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[StudentCourses]') AND type in (N'U'))
ALTER TABLE [dbo].[StudentCourses] DROP CONSTRAINT IF EXISTS [FK_StudentCourses_AcademicYear]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Student]') AND type in (N'U'))
ALTER TABLE [dbo].[Student] DROP CONSTRAINT IF EXISTS [FK_Student_Supervisor]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ProgramRelations]') AND type in (N'U'))
ALTER TABLE [dbo].[ProgramRelations] DROP CONSTRAINT IF EXISTS [FK_ProgramRelations_Program1]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ProgramRelations]') AND type in (N'U'))
ALTER TABLE [dbo].[ProgramRelations] DROP CONSTRAINT IF EXISTS [FK_ProgramRelations_Program]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ProgramDistribution]') AND type in (N'U'))
ALTER TABLE [dbo].[ProgramDistribution] DROP CONSTRAINT IF EXISTS [FK_ProgramDistribution_Program]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ProgramCourses]') AND type in (N'U'))
ALTER TABLE [dbo].[ProgramCourses] DROP CONSTRAINT IF EXISTS [FK_ProgramCourses_Program]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ProgramCourses]') AND type in (N'U'))
ALTER TABLE [dbo].[ProgramCourses] DROP CONSTRAINT IF EXISTS [FK_ProgramCourses_Course]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[OptionalCourse]') AND type in (N'U'))
ALTER TABLE [dbo].[OptionalCourse] DROP CONSTRAINT IF EXISTS [FK_OptionalCourse_Program]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CoursePrerequisites]') AND type in (N'U'))
ALTER TABLE [dbo].[CoursePrerequisites] DROP CONSTRAINT IF EXISTS [FK_CoursePrerequisites_Course1]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CoursePrerequisites]') AND type in (N'U'))
ALTER TABLE [dbo].[CoursePrerequisites] DROP CONSTRAINT IF EXISTS [FK_CoursePrerequisites_Course]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[StudentCourses]') AND type in (N'U'))
ALTER TABLE [dbo].[StudentCourses] DROP CONSTRAINT IF EXISTS [DF_StudentCourses_HasExecuse]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[StudentCourses]') AND type in (N'U'))
ALTER TABLE [dbo].[StudentCourses] DROP CONSTRAINT IF EXISTS [DF_StudentCourses_TookFromCredits]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Student]') AND type in (N'U'))
ALTER TABLE [dbo].[Student] DROP CONSTRAINT IF EXISTS [DF_Student_SemestersNumberInProgram]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Program]') AND type in (N'U'))
ALTER TABLE [dbo].[Program] DROP CONSTRAINT IF EXISTS [DF_Program_TotalHours]
GO
/****** Object:  Table [dbo].[TeacherCourses]    Script Date: 2023-01-30 7:09:45 PM ******/
DROP TABLE IF EXISTS [dbo].[TeacherCourses]
GO
/****** Object:  Table [dbo].[Supervisor]    Script Date: 2023-01-30 7:09:45 PM ******/
DROP TABLE IF EXISTS [dbo].[Supervisor]
GO
/****** Object:  Table [dbo].[SuperAdmin]    Script Date: 2023-01-30 7:09:45 PM ******/
DROP TABLE IF EXISTS [dbo].[SuperAdmin]
GO
/****** Object:  Table [dbo].[StudentPrograms]    Script Date: 2023-01-30 7:09:45 PM ******/
DROP TABLE IF EXISTS [dbo].[StudentPrograms]
GO
/****** Object:  Table [dbo].[StudentDesires]    Script Date: 2023-01-30 7:09:45 PM ******/
DROP TABLE IF EXISTS [dbo].[StudentDesires]
GO
/****** Object:  Table [dbo].[StudentCourses]    Script Date: 2023-01-30 7:09:45 PM ******/
DROP TABLE IF EXISTS [dbo].[StudentCourses]
GO
/****** Object:  Table [dbo].[Student]    Script Date: 2023-01-30 7:09:45 PM ******/
DROP TABLE IF EXISTS [dbo].[Student]
GO
/****** Object:  Table [dbo].[ProgramRelations]    Script Date: 2023-01-30 7:09:45 PM ******/
DROP TABLE IF EXISTS [dbo].[ProgramRelations]
GO
/****** Object:  Table [dbo].[ProgramDistribution]    Script Date: 2023-01-30 7:09:45 PM ******/
DROP TABLE IF EXISTS [dbo].[ProgramDistribution]
GO
/****** Object:  Table [dbo].[ProgramCourses]    Script Date: 2023-01-30 7:09:45 PM ******/
DROP TABLE IF EXISTS [dbo].[ProgramCourses]
GO
/****** Object:  Table [dbo].[Program]    Script Date: 2023-01-30 7:09:45 PM ******/
DROP TABLE IF EXISTS [dbo].[Program]
GO
/****** Object:  Table [dbo].[OptionalCourse]    Script Date: 2023-01-30 7:09:45 PM ******/
DROP TABLE IF EXISTS [dbo].[OptionalCourse]
GO
/****** Object:  Table [dbo].[Date]    Script Date: 2023-01-30 7:09:45 PM ******/
DROP TABLE IF EXISTS [dbo].[Date]
GO
/****** Object:  Table [dbo].[CoursePrerequisites]    Script Date: 2023-01-30 7:09:45 PM ******/
DROP TABLE IF EXISTS [dbo].[CoursePrerequisites]
GO
/****** Object:  Table [dbo].[Course]    Script Date: 2023-01-30 7:09:45 PM ******/
DROP TABLE IF EXISTS [dbo].[Course]
GO
/****** Object:  Table [dbo].[CommonQuestion]    Script Date: 2023-01-30 7:09:45 PM ******/
DROP TABLE IF EXISTS [dbo].[CommonQuestion]
GO
/****** Object:  Table [dbo].[AcademicYear]    Script Date: 2023-01-30 7:09:45 PM ******/
DROP TABLE IF EXISTS [dbo].[AcademicYear]
GO
/****** Object:  UserDefinedFunction [dbo].[TESTWithoutSummerCalculateNumberOfWarnings]    Script Date: 2023-01-30 7:09:45 PM ******/
DROP FUNCTION IF EXISTS [dbo].[TESTWithoutSummerCalculateNumberOfWarnings]
GO
/****** Object:  UserDefinedFunction [dbo].[RankStudent]    Script Date: 2023-01-30 7:09:45 PM ******/
DROP FUNCTION IF EXISTS [dbo].[RankStudent]
GO
/****** Object:  UserDefinedFunction [dbo].[IsGraduatedStudent]    Script Date: 2023-01-30 7:09:45 PM ******/
DROP FUNCTION IF EXISTS [dbo].[IsGraduatedStudent]
GO
/****** Object:  UserDefinedFunction [dbo].[GetStudentProgram]    Script Date: 2023-01-30 7:09:45 PM ******/
DROP FUNCTION IF EXISTS [dbo].[GetStudentProgram]
GO
/****** Object:  UserDefinedFunction [dbo].[GetPrequisteNumber]    Script Date: 2023-01-30 7:09:45 PM ******/
DROP FUNCTION IF EXISTS [dbo].[GetPrequisteNumber]
GO
/****** Object:  UserDefinedFunction [dbo].[GetPassedPrequisteNumber]    Script Date: 2023-01-30 7:09:45 PM ******/
DROP FUNCTION IF EXISTS [dbo].[GetPassedPrequisteNumber]
GO
/****** Object:  UserDefinedFunction [dbo].[GetNumberOfWarnings]    Script Date: 2023-01-30 7:09:45 PM ******/
DROP FUNCTION IF EXISTS [dbo].[GetNumberOfWarnings]
GO
/****** Object:  UserDefinedFunction [dbo].[CheckIfPassedCourse]    Script Date: 2023-01-30 7:09:45 PM ******/
DROP FUNCTION IF EXISTS [dbo].[CheckIfPassedCourse]
GO
/****** Object:  UserDefinedFunction [dbo].[CanRegisterThisCourse]    Script Date: 2023-01-30 7:09:45 PM ******/
DROP FUNCTION IF EXISTS [dbo].[CanRegisterThisCourse]
GO
/****** Object:  UserDefinedFunction [dbo].[CalculateStudentLevel]    Script Date: 2023-01-30 7:09:45 PM ******/
DROP FUNCTION IF EXISTS [dbo].[CalculateStudentLevel]
GO
/****** Object:  UserDefinedFunction [dbo].[CalculateSGPA]    Script Date: 2023-01-30 7:09:45 PM ******/
DROP FUNCTION IF EXISTS [dbo].[CalculateSGPA]
GO
/****** Object:  UserDefinedFunction [dbo].[CalculatePassedHours]    Script Date: 2023-01-30 7:09:45 PM ******/
DROP FUNCTION IF EXISTS [dbo].[CalculatePassedHours]
GO
/****** Object:  UserDefinedFunction [dbo].[CalculateCGPA]    Script Date: 2023-01-30 7:09:45 PM ******/
DROP FUNCTION IF EXISTS [dbo].[CalculateCGPA]
GO
/****** Object:  UserDefinedTableType [dbo].[StudentsProgramsType]    Script Date: 2023-01-30 7:09:45 PM ******/
DROP TYPE IF EXISTS [dbo].[StudentsProgramsType]
GO
/****** Object:  UserDefinedTableType [dbo].[StudentRegistrationCoursesType]    Script Date: 2023-01-30 7:09:45 PM ******/
DROP TYPE IF EXISTS [dbo].[StudentRegistrationCoursesType]
GO
/****** Object:  UserDefinedTableType [dbo].[StudentDesiresType]    Script Date: 2023-01-30 7:09:45 PM ******/
DROP TYPE IF EXISTS [dbo].[StudentDesiresType]
GO
USE [master]
GO
/****** Object:  Database [FOS]    Script Date: 2023-01-30 7:09:45 PM ******/
DROP DATABASE IF EXISTS [FOS]
GO
/****** Object:  Database [FOS]    Script Date: 2023-01-30 7:09:45 PM ******/
CREATE DATABASE [FOS]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'FOS', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.SQLEXPRESS\MSSQL\DATA\FOS.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'FOS_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.SQLEXPRESS\MSSQL\DATA\FOS_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT
GO
ALTER DATABASE [FOS] SET COMPATIBILITY_LEVEL = 150
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [FOS].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [FOS] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [FOS] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [FOS] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [FOS] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [FOS] SET ARITHABORT OFF 
GO
ALTER DATABASE [FOS] SET AUTO_CLOSE ON 
GO
ALTER DATABASE [FOS] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [FOS] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [FOS] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [FOS] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [FOS] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [FOS] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [FOS] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [FOS] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [FOS] SET  ENABLE_BROKER 
GO
ALTER DATABASE [FOS] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [FOS] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [FOS] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [FOS] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [FOS] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [FOS] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [FOS] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [FOS] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [FOS] SET  MULTI_USER 
GO
ALTER DATABASE [FOS] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [FOS] SET DB_CHAINING OFF 
GO
ALTER DATABASE [FOS] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [FOS] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [FOS] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [FOS] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
ALTER DATABASE [FOS] SET QUERY_STORE = OFF
GO
USE [FOS]
GO
/****** Object:  UserDefinedTableType [dbo].[StudentDesiresType]    Script Date: 2023-01-30 7:09:45 PM ******/
CREATE TYPE [dbo].[StudentDesiresType] AS TABLE(
	[ProgramID] [int] NULL,
	[DesireNumber] [tinyint] NULL
)
GO
/****** Object:  UserDefinedTableType [dbo].[StudentRegistrationCoursesType]    Script Date: 2023-01-30 7:09:45 PM ******/
CREATE TYPE [dbo].[StudentRegistrationCoursesType] AS TABLE(
	[CourseID] [int] NULL
)
GO
/****** Object:  UserDefinedTableType [dbo].[StudentsProgramsType]    Script Date: 2023-01-30 7:09:45 PM ******/
CREATE TYPE [dbo].[StudentsProgramsType] AS TABLE(
	[ProgramID] [int] NOT NULL,
	[StudentID] [int] NOT NULL,
	[AcademicYearID] [smallint] NOT NULL
)
GO
/****** Object:  UserDefinedFunction [dbo].[CalculateCGPA]    Script Date: 2023-01-30 7:09:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[CalculateCGPA](@StudentID INT)
RETURNS decimal(5,4)
AS
     BEGIN
         DECLARE @CGPA decimal(5,4);
         Select @CGPA=CAST((SUM(c.CreditHours * sc.points)/SUM(c.CreditHours)) as decimal(5,4))
		 FROM studentCourses sc,Student s,Course c
		 WHERE 
		 c.ID = sc.CourseID AND
		 sc.IsIncluded =1 AND
		 sc.grade IS NOT NULL AND
		 sc.IsGPAIncluded = 1 AND
		 sc.StudentID=@StudentID
		 RETURN @CGPA;
     END;
GO
/****** Object:  UserDefinedFunction [dbo].[CalculatePassedHours]    Script Date: 2023-01-30 7:09:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[CalculatePassedHours] (@StudentID INT)
RETURNS TINYINT
AS
BEGIN
	DECLARE @PassedHours TINYINT;
	Select @PassedHours = SUM(c.CreditHours)
	FROM studentCourses sc,Course c
	WHERE c.ID = sc.CourseID AND sc.IsIncluded =1 AND sc.Grade IS NOT NULL AND sc.Grade <> 'F' AND sc.StudentID=@StudentID
		RETURN @PassedHours;
END;
GO
/****** Object:  UserDefinedFunction [dbo].[CalculateSGPA]    Script Date: 2023-01-30 7:09:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[CalculateSGPA](@StudentID INT,@AcademicYearID TINYINT)
RETURNS DECIMAL(5,4)
AS
     BEGIN
         DECLARE @GPA DECIMAL(5,4);
         SELECT @GPA = SUM(sc.points * c.CreditHours)/SUM(c.credithours)
			FROM StudentCourses sc join Course c ON c.ID = sc.CourseID 
			WHERE StudentID =@StudentID AND AcademicYearID =@AcademicYearID AND sc.IsIncluded =1 AND sc.IsGPAIncluded = 1
			group by AcademicYearid
			Order by AcademicYearID
		 RETURN @GPA;
     END;
GO
/****** Object:  UserDefinedFunction [dbo].[CalculateStudentLevel]    Script Date: 2023-01-30 7:09:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[CalculateStudentLevel] (@StudentID INT)
RETURNS TINYINT
AS
BEGIN
	DECLARE @PassedHours TINYINT;
	Select @PassedHours = [dbo].[CalculatePassedHours](@StudentID);
	DECLARE @Level tinyint;
	IF @PassedHours >=101
	BEGIN
		SET @Level=4;
	END
	ELSE IF @PassedHours >=67
	BEGIN
		SET @Level=3;
	END
	ELSE IF @PassedHours >=33
	BEGIN
		SET @Level=2;
	END
	ELSE
	BEGIN
		SET @Level=1;
	END
	RETURN @Level
END;
GO
/****** Object:  UserDefinedFunction [dbo].[CanRegisterThisCourse]    Script Date: 2023-01-30 7:09:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[CanRegisterThisCourse](@StudentProgram int,
												@StudentID int,
												@Level tinyint,
												@Semester tinyint,
												@CourseType tinyint,
												@CourseCategory tinyint,
												@CourseCredits tinyint)
RETURNS bit
AS
BEGIN
DECLARE @ReturnValue bit;
DECLARE @Hours tinyint;
DECLARE @PassedHours tinyint;

--Get number of optional courses hours in specific level and semester
SELECT @Hours = Hour FROM OptionalCourse
WHERE ProgramID = @StudentProgram AND Level = @Level AND Semester = @Semester AND CourseType = @CourseType AND Category = @CourseCategory;

--Sum of passed courses hours in the same level and semester
SELECT @PassedHours = SUM(c.CreditHours)
FROM Course c JOIN StudentCourses sc ON c.ID = sc.CourseID 
JOIN ProgramCourses pc ON c.ID = pc.CourseID
WHERE 	
	pc.ProgramID = @StudentProgram AND
	sc.StudentID = @StudentID AND
	c.Level = @Level AND
	c.Semester = @Semester AND
	pc.CourseType = @CourseType AND 
	pc.Category = @CourseCategory AND
	[dbo].[CheckIfPassedCourse](@StudentID,c.ID) = 1

--If this condition is met this means that student have passed all optional courses 
--so s/he can't register any optional courses from that semester
IF(@Hours = @PassedHours OR ((@PassedHours + @CourseCredits) > @Hours))
	SET @ReturnValue = 0;
ELSE
	SET @ReturnValue = 1;

RETURN @ReturnValue;
END
GO
/****** Object:  UserDefinedFunction [dbo].[CheckIfPassedCourse]    Script Date: 2023-01-30 7:09:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[CheckIfPassedCourse](@StudentID int,@CourseID int)
RETURNS tinyint
AS
BEGIN 
DECLARE @CountOfPassed tinyint,@IsPassed tinyint;

SELECT @CountOfPassed = COUNT(sc.CourseID) FROM StudentCourses sc 
WHERE (sc.Grade <> 'F') AND
StudentID = @StudentID
AND CourseID =@CourseID

IF @CountOfPassed >= 1
	BEGIN
		SET @IsPassed = 1
	END
ELSE
	BEGIN
		SET @IsPassed = 0
	END

RETURN @IsPassed;
END
GO
/****** Object:  UserDefinedFunction [dbo].[GetNumberOfWarnings]    Script Date: 2023-01-30 7:09:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[GetNumberOfWarnings](@StudentID int)
RETURNS TINYINT
AS
BEGIN
/*
	This function calculates Regular semesters CGPA and checks if it's <2 or not to calaulate number of warnings
*/
	DECLARE @SGPA as decimal(5,4),
			@CGPA as decimal(5,4),
			@SHours tinyint,
			@CHours tinyint,
			@Semester tinyint,
			@NumberOfWarnings as tinyint =0;

	SELECT @CGPA = cast(SUM(sc.points * c.CreditHours)/SUM(c.credithours) as decimal(5,4)),@CHours = SUM(c.CreditHours)
	FROM StudentCourses sc left join Course c ON c.ID = sc.CourseID 
	left join AcademicYear ay ON ay.ID = sc.AcademicYearID
	WHERE StudentID =@StudentID AND sc.IsIncluded =1 AND sc.IsGPAIncluded = 1
		AND sc.AcademicYearID = (SELECT Min(AcademicYearID) From StudentCourses WHERE StudentID = @StudentID)
	group by AcademicYearid,ay.Semester
	Order by AcademicYearID;

	DECLARE Student_Waring_Counter_Cursor CURSOR FOR  
		SELECT cast(SUM(sc.points * c.CreditHours)/SUM(c.credithours) as decimal(5,4)),SUM(CreditHours),ay.Semester
		FROM StudentCourses sc left join Course c ON c.ID = sc.CourseID 
		left join AcademicYear ay ON ay.ID = sc.AcademicYearID
		WHERE StudentID = @StudentID AND sc.IsIncluded =1 AND sc.IsGPAIncluded = 1
			AND sc.AcademicYearID <>(SELECT Min(AcademicYearID) From StudentCourses WHERE StudentID = @StudentID)
		group by AcademicYearid,ay.Semester
		Order by AcademicYearID;

	OPEN Student_Waring_Counter_Cursor;  
	FETCH NEXT FROM Student_Waring_Counter_Cursor INTO @SGPA,@SHours,@Semester;
	WHILE @@FETCH_STATUS = 0
	BEGIN
		IF (@SGPA IS NOT NULL)
			BEGIN
				SET @CGPA = (@CGPA * @CHours + @SGPA * @SHours)/(@SHours + @CHours);
				SET @CHours = @CHours + @SHours;
					IF(@CGPA <2.00 AND @Semester <> 3)
						SET	@NumberOfWarnings = @NumberOfWarnings + 1;
					ELSE IF (@CGPA >=2.00 AND @Semester <> 3)
						SET	@NumberOfWarnings = 0;
			END
		FETCH NEXT FROM Student_Waring_Counter_Cursor INTO @SGPA,@SHours,@Semester;
	END;  
	CLOSE Student_Waring_Counter_Cursor;  
	DEALLOCATE Student_Waring_Counter_Cursor;
	RETURN @NumberOfWarnings;
END
GO
/****** Object:  UserDefinedFunction [dbo].[GetPassedPrequisteNumber]    Script Date: 2023-01-30 7:09:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[GetPassedPrequisteNumber](@StudentID int,@CourseID int)
RETURNS int
AS
BEGIN
DECLARE @PrerequisteID int;
DECLARE Count_Passed_Prerequiste_Number CURSOR FOR  
	SELECT cp.PrerequisiteCourseID
	FROM CoursePrerequisites cp
	WHERE CourseID = @CourseID
DECLARE @PassedCoursesNumber tinyint = 0;
OPEN Count_Passed_Prerequiste_Number;  
FETCH NEXT FROM Count_Passed_Prerequiste_Number INTO @PrerequisteID;  
WHILE @@FETCH_STATUS = 0  
BEGIN  
	IF [dbo].[CheckIfPassedCourse](@StudentID,@PrerequisteID) = 1
		BEGIN
			SET @PassedCoursesNumber = @PassedCoursesNumber + 1;
		END
	FETCH NEXT FROM Count_Passed_Prerequiste_Number INTO @PrerequisteID;  
END;  
CLOSE Count_Passed_Prerequiste_Number;  
DEALLOCATE Count_Passed_Prerequiste_Number;
RETURN @PassedCoursesNumber;
END
GO
/****** Object:  UserDefinedFunction [dbo].[GetPrequisteNumber]    Script Date: 2023-01-30 7:09:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[GetPrequisteNumber](@StudentID int,@CourseID int)
RETURNs INT
AS
BEGIN
	DECLARE @PrereqRelation tinyint;
	DECLARE @ReturnValue tinyint;
	SELECT @PrereqRelation = PrerequisiteRelation
	FROM Course
	WHERE ID = @CourseID

	IF @PrereqRelation = 0
		BEGIN
			SET @ReturnValue = 0
		END
	ELSE IF @PrereqRelation = 1
		BEGIN
			SET @ReturnValue = [dbo].[GetPassedPrequisteNumber](@StudentID,@CourseID);
		END
	ELSE IF @PrereqRelation = 2
		BEGIN
			SET @ReturnValue = [dbo].[GetPassedPrequisteNumber](@StudentID,@CourseID);
		END
	ELSE IF @PrereqRelation = 3
		BEGIN
			SET @ReturnValue = [dbo].[GetPassedPrequisteNumber](@StudentID,@CourseID);
				IF @ReturnValue <> 0
					SELECT @ReturnValue = COUNT(CourseID)
					FROM CoursePrerequisites
					WHERE CourseID = @CourseID
		END
	RETURN @ReturnValue;
END
GO
/****** Object:  UserDefinedFunction [dbo].[GetStudentProgram]    Script Date: 2023-01-30 7:09:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE FUNCTION [dbo].[GetStudentProgram](@StudentID INT)
RETURNS int
AS
     BEGIN
         DECLARE @ProgramID int;
         Select @ProgramID=(SELECT ProgramID
				FROM StudentPrograms sp
				WHERE sp.StudentID =@StudentID and (sp.AcademicYear = (SELECT MAX(AcademicYear) FROM StudentPrograms WHERE StudentID = @StudentID)));

		 RETURN @ProgramID;
     END;
GO
/****** Object:  UserDefinedFunction [dbo].[IsGraduatedStudent]    Script Date: 2023-01-30 7:09:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[IsGraduatedStudent](@StudentID INT)
RETURNS bit
AS
--This function retrives program total hours and compare it with student total passed hours and GPA must be >=2.0
     BEGIN
         DECLARE @ProgramID int,
         @IsGraduated bit = 0,
		 @ProgramTotalHours int,
		 @CGPA decimal(5,4),
		 @PassedHours int
		 
		 Select @ProgramID=[dbo].[GetStudentProgram](@StudentID)

		 SELECT @ProgramTotalHours = TotalHours FROM Program WHERE ID = @ProgramID;

		 SELECT @PassedHours = PassedHours, @CGPA = CGPA FROM Student WHERE ID = @StudentID;

		 IF(@CGPA >=2.0 AND (@PassedHours >= @ProgramTotalHours))
			SET @IsGraduated = 1;
		 ELSE
			SET @IsGraduated = 0;
		RETURN @IsGraduated;
     END;
GO
/****** Object:  UserDefinedFunction [dbo].[RankStudent]    Script Date: 2023-01-30 7:09:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[RankStudent](@StudentID int)
RETURNS SMALLINT
AS
	BEGIN
		DECLARE @AcademicYearID SMALLINT;
		DECLARE @ProgramID INT;
		DECLARE @ReturnValue SMALLINT;
		SELECT @AcademicYearID = academicYear,@ProgramID = ProgramID 
		FROM StudentPrograms
		WHERE StudentID = @StudentID AND AcademicYear = (SELECT MAX(AcademicYear) FROM StudentPrograms WHERE StudentID = @StudentID)

		SELECT @ReturnValue = Res.RowNum FROM(
		SELECT ROW_NUMBER() OVER(ORDER BY s.CGPA DESC) AS RowNum,s.ID
		FROM StudentPrograms sp JOIN Student s ON s.ID = sp.StudentID
		WHERE sp.AcademicYear =@AcademicYearID AND sp.ProgramID = @ProgramID AND s.CGPA IS NOT NULL
		) AS Res
		WHERE Res.ID = @StudentID;

		RETURN @ReturnValue;
	END
GO
/****** Object:  UserDefinedFunction [dbo].[TESTWithoutSummerCalculateNumberOfWarnings]    Script Date: 2023-01-30 7:09:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[TESTWithoutSummerCalculateNumberOfWarnings](@StudentID int)
RETURNS TINYINT
AS
BEGIN
/*
	This function calculates Regular semesters GPA
	then loop through Result to calaulate number of warnings
*/
	DECLARE @SGPA as decimal(5,4),
			@CGPA as decimal(5,4),
			@SHours tinyint,
			@CHours tinyint,
			@Semester tinyint,
			@NumberOfWarnings as tinyint =0;

	SELECT @CGPA = cast(SUM(sc.points * c.CreditHours)/SUM(c.credithours) as decimal(5,4)),@CHours = SUM(c.CreditHours)
	FROM StudentCourses sc left join Course c ON c.ID = sc.CourseID 
	left join AcademicYear ay ON ay.ID = sc.AcademicYearID
	WHERE StudentID =@StudentID AND sc.IsIncluded =1 AND sc.IsGPAIncluded = 1
		AND sc.AcademicYearID = (SELECT Min(AcademicYearID) From StudentCourses WHERE StudentID = @StudentID)
	group by AcademicYearid,ay.Semester
	Order by AcademicYearID;

	DECLARE Student_Waring_Counter_Cursor CURSOR FOR  
		SELECT cast(SUM(sc.points * c.CreditHours)/SUM(c.credithours) as decimal(5,4)),SUM(CreditHours),ay.Semester
		FROM StudentCourses sc left join Course c ON c.ID = sc.CourseID 
		left join AcademicYear ay ON ay.ID = sc.AcademicYearID
		WHERE StudentID = @StudentID AND sc.IsIncluded =1 AND sc.IsGPAIncluded = 1
			AND sc.AcademicYearID <>(SELECT Min(AcademicYearID) From StudentCourses WHERE StudentID = @StudentID)
			AND sc.AcademicYearID NOT IN (SELECT ID FROM AcademicYear WHERE Semester =3)
		group by AcademicYearid,ay.Semester
		Order by AcademicYearID;

	OPEN Student_Waring_Counter_Cursor;  
	FETCH NEXT FROM Student_Waring_Counter_Cursor INTO @SGPA,@SHours,@Semester;
	WHILE @@FETCH_STATUS = 0
	BEGIN
		IF (@SGPA IS NOT NULL)
			BEGIN
				SET @CGPA = (@CGPA * @CHours + @SGPA * @SHours)/(@SHours + @CHours);
				SET @CHours = @CHours + @SHours;
					IF(@CGPA <2.00)
						SET	@NumberOfWarnings = @NumberOfWarnings + 1;
					ELSE IF (@CGPA >=2.00)
						SET	@NumberOfWarnings = 0;
			END
		FETCH NEXT FROM Student_Waring_Counter_Cursor INTO @SGPA,@SHours,@Semester;
	END;  
	CLOSE Student_Waring_Counter_Cursor;  
	DEALLOCATE Student_Waring_Counter_Cursor;
	RETURN @NumberOfWarnings;
END
GO
/****** Object:  Table [dbo].[AcademicYear]    Script Date: 2023-01-30 7:09:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AcademicYear](
	[ID] [smallint] IDENTITY(1,1) NOT NULL,
	[AcademicYear] [nvarchar](max) NOT NULL,
	[Semester] [tinyint] NOT NULL,
 CONSTRAINT [PK_AcademicYear] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CommonQuestion]    Script Date: 2023-01-30 7:09:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CommonQuestion](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Question] [nvarchar](max) NOT NULL,
	[Answer] [nvarchar](max) NOT NULL,
 CONSTRAINT [PK_CommonQuestion] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Course]    Script Date: 2023-01-30 7:09:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Course](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[CourseCode] [nvarchar](max) NOT NULL,
	[CourseName] [nvarchar](max) NOT NULL,
	[CreditHours] [tinyint] NOT NULL,
	[LectureHours] [tinyint] NOT NULL,
	[LabHours] [tinyint] NOT NULL,
	[SectionHours] [tinyint] NOT NULL,
	[IsActive] [bit] NOT NULL,
	[PrerequisiteRelation] [tinyint] NOT NULL,
	[Level] [tinyint] NOT NULL,
	[Semester] [tinyint] NOT NULL,
 CONSTRAINT [PK_Course] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CoursePrerequisites]    Script Date: 2023-01-30 7:09:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CoursePrerequisites](
	[CourseID] [int] NOT NULL,
	[PrerequisiteCourseID] [int] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Date]    Script Date: 2023-01-30 7:09:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Date](
	[DateFor] [tinyint] NOT NULL,
	[StartDate] [datetime] NOT NULL,
	[EndDate] [datetime] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[OptionalCourse]    Script Date: 2023-01-30 7:09:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[OptionalCourse](
	[ProgramID] [int] NOT NULL,
	[Level] [tinyint] NOT NULL,
	[Semester] [tinyint] NOT NULL,
	[CourseType] [tinyint] NOT NULL,
	[Category] [tinyint] NOT NULL,
	[Hour] [tinyint] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Program]    Script Date: 2023-01-30 7:09:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Program](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](max) NOT NULL,
	[Semester] [tinyint] NOT NULL,
	[Percentage] [float] NOT NULL,
	[IsRegular] [bit] NOT NULL,
	[IsGeneral] [bit] NOT NULL,
	[TotalHours] [tinyint] NOT NULL,
	[EnglishName] [nvarchar](max) NOT NULL,
	[ArabicName] [nvarchar](max) NOT NULL,
 CONSTRAINT [PK_Program] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ProgramCourses]    Script Date: 2023-01-30 7:09:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ProgramCourses](
	[ProgramID] [int] NOT NULL,
	[CourseID] [int] NOT NULL,
	[CourseType] [tinyint] NOT NULL,
	[Category] [tinyint] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ProgramDistribution]    Script Date: 2023-01-30 7:09:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ProgramDistribution](
	[ProgramID] [int] NOT NULL,
	[Semester] [tinyint] NOT NULL,
	[NumberOfHours] [tinyint] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ProgramRelations]    Script Date: 2023-01-30 7:09:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ProgramRelations](
	[Program] [int] NULL,
	[SubProgram] [int] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Student]    Script Date: 2023-01-30 7:09:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Student](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[GUID] [varchar](max) NOT NULL,
	[FName] [nvarchar](max) NOT NULL,
	[MName] [nvarchar](max) NOT NULL,
	[LName] [nvarchar](max) NOT NULL,
	[SSN] [varchar](15) NOT NULL,
	[PhoneNumber] [varchar](12) NOT NULL,
	[BirthDate] [date] NOT NULL,
	[Address] [nvarchar](max) NOT NULL,
	[Gender] [char](1) NOT NULL,
	[Nationality] [nvarchar](max) NOT NULL,
	[Email] [varchar](max) NOT NULL,
	[Password] [varchar](max) NOT NULL,
	[AcademicCode] [varchar](10) NULL,
	[SeatNumber] [varchar](10) NULL,
	[AvailableCredits] [tinyint] NOT NULL,
	[WarningsNumber]  AS ([dbo].[GetNumberOfWarnings]([ID])),
	[Rank]  AS ([dbo].[RankStudent]([ID])),
	[IsInSpecialProgram] [bit] NOT NULL,
	[SupervisorID] [int] NOT NULL,
	[CreatedOn] [datetime] NOT NULL,
	[IsCrossStudent] [bit] NOT NULL,
	[SemestersNumberInProgram] [tinyint] NOT NULL,
	[CGPA]  AS ([dbo].[CalculateCGPA]([ID])),
	[PassedHours]  AS ([dbo].[CalculatePassedHours]([ID])),
	[Level]  AS ([dbo].[CalculateStudentLevel]([ID])),
	[IsGraduated]  AS ([dbo].[IsGraduatedStudent]([ID])),
 CONSTRAINT [PK_Student] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[StudentCourses]    Script Date: 2023-01-30 7:09:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[StudentCourses](
	[StudentID] [int] NOT NULL,
	[CourseID] [int] NOT NULL,
	[Mark] [tinyint] NULL,
	[Grade] [nvarchar](2) NULL,
	[points] [float] NULL,
	[IsApproved] [bit] NOT NULL,
	[IsGPAIncluded] [bit] NOT NULL,
	[IsIncluded] [bit] NOT NULL,
	[CourseEntringNumber] [tinyint] NULL,
	[AffectReEntringCourses] [bit] NULL,
	[AcademicYearID] [smallint] NOT NULL,
	[WillTakeFullCredit] [bit] NULL,
	[TookFromCredits] [bit] NULL,
	[HasExecuse] [bit] NULL,
	[IsEnhancementCourse] [bit] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[StudentDesires]    Script Date: 2023-01-30 7:09:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[StudentDesires](
	[ProgramID] [int] NOT NULL,
	[StudentID] [int] NOT NULL,
	[DesireNumber] [tinyint] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[StudentPrograms]    Script Date: 2023-01-30 7:09:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[StudentPrograms](
	[ProgramID] [int] NOT NULL,
	[StudentID] [int] NOT NULL,
	[AcademicYear] [smallint] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SuperAdmin]    Script Date: 2023-01-30 7:09:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SuperAdmin](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[GUID] [varchar](max) NOT NULL,
	[FName] [nvarchar](max) NOT NULL,
	[MName] [nvarchar](max) NOT NULL,
	[LName] [nvarchar](max) NOT NULL,
	[Email] [nvarchar](max) NOT NULL,
	[Password] [nvarchar](max) NOT NULL,
	[ProgramID] [int] NOT NULL,
 CONSTRAINT [PK_SuperAdmin] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Supervisor]    Script Date: 2023-01-30 7:09:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Supervisor](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[GUID] [varchar](max) NOT NULL,
	[FName] [nvarchar](max) NOT NULL,
	[MName] [nvarchar](max) NOT NULL,
	[LName] [nvarchar](max) NOT NULL,
	[Email] [nvarchar](max) NOT NULL,
	[Password] [nvarchar](max) NOT NULL,
	[IsActive] [bit] NOT NULL,
	[CreatedOn] [datetime] NOT NULL,
	[ProgramID] [int] NOT NULL,
 CONSTRAINT [PK_Supervisor] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TeacherCourses]    Script Date: 2023-01-30 7:09:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TeacherCourses](
	[SupervisorID] [int] NULL,
	[CourseID] [int] NOT NULL,
	[AcademicYearID] [smallint] NOT NULL
) ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[AcademicYear] ON 
GO
INSERT [dbo].[AcademicYear] ([ID], [AcademicYear], [Semester]) VALUES (1, N'2016/2017', 1)
GO
INSERT [dbo].[AcademicYear] ([ID], [AcademicYear], [Semester]) VALUES (2, N'2016/2017', 2)
GO
INSERT [dbo].[AcademicYear] ([ID], [AcademicYear], [Semester]) VALUES (3, N'2016/2017', 3)
GO
INSERT [dbo].[AcademicYear] ([ID], [AcademicYear], [Semester]) VALUES (4, N'2017/2018', 1)
GO
INSERT [dbo].[AcademicYear] ([ID], [AcademicYear], [Semester]) VALUES (5, N'2017/2018', 2)
GO
INSERT [dbo].[AcademicYear] ([ID], [AcademicYear], [Semester]) VALUES (6, N'2017/2018', 3)
GO
INSERT [dbo].[AcademicYear] ([ID], [AcademicYear], [Semester]) VALUES (7, N'2018/2019', 1)
GO
INSERT [dbo].[AcademicYear] ([ID], [AcademicYear], [Semester]) VALUES (8, N'2018/2019', 2)
GO
INSERT [dbo].[AcademicYear] ([ID], [AcademicYear], [Semester]) VALUES (9, N'2018/2019', 3)
GO
INSERT [dbo].[AcademicYear] ([ID], [AcademicYear], [Semester]) VALUES (10, N'2019/2020', 1)
GO
INSERT [dbo].[AcademicYear] ([ID], [AcademicYear], [Semester]) VALUES (11, N'2019/2020', 2)
GO
INSERT [dbo].[AcademicYear] ([ID], [AcademicYear], [Semester]) VALUES (12, N'2019/2020', 3)
GO
INSERT [dbo].[AcademicYear] ([ID], [AcademicYear], [Semester]) VALUES (13, N'2020/2021', 1)
GO
INSERT [dbo].[AcademicYear] ([ID], [AcademicYear], [Semester]) VALUES (14, N'2020/2021', 2)
GO
INSERT [dbo].[AcademicYear] ([ID], [AcademicYear], [Semester]) VALUES (15, N'2020/2021', 3)
GO
INSERT [dbo].[AcademicYear] ([ID], [AcademicYear], [Semester]) VALUES (16, N'2021/2022', 1)
GO
INSERT [dbo].[AcademicYear] ([ID], [AcademicYear], [Semester]) VALUES (17, N'2021/2022', 2)
GO
INSERT [dbo].[AcademicYear] ([ID], [AcademicYear], [Semester]) VALUES (18, N'2021/2022', 3)
GO
INSERT [dbo].[AcademicYear] ([ID], [AcademicYear], [Semester]) VALUES (19, N'2022/2023', 1)
GO
SET IDENTITY_INSERT [dbo].[AcademicYear] OFF
GO
SET IDENTITY_INSERT [dbo].[CommonQuestion] ON 
GO
INSERT [dbo].[CommonQuestion] ([ID], [Question], [Answer]) VALUES (1, N'Q1', N'A1')
GO
INSERT [dbo].[CommonQuestion] ([ID], [Question], [Answer]) VALUES (2, N'Q2', N'A2')
GO
INSERT [dbo].[CommonQuestion] ([ID], [Question], [Answer]) VALUES (3, N'Q3', N'A3')
GO
INSERT [dbo].[CommonQuestion] ([ID], [Question], [Answer]) VALUES (4, N'Q4', N'A4')
GO
INSERT [dbo].[CommonQuestion] ([ID], [Question], [Answer]) VALUES (5, N'Q5', N'A5')
GO
INSERT [dbo].[CommonQuestion] ([ID], [Question], [Answer]) VALUES (6, N'Q6', N'A6')
GO
INSERT [dbo].[CommonQuestion] ([ID], [Question], [Answer]) VALUES (7, N'Q7', N'A7')
GO
INSERT [dbo].[CommonQuestion] ([ID], [Question], [Answer]) VALUES (8, N'Q8', N'A8')
GO
INSERT [dbo].[CommonQuestion] ([ID], [Question], [Answer]) VALUES (9, N'Q9', N'A9')
GO
INSERT [dbo].[CommonQuestion] ([ID], [Question], [Answer]) VALUES (10, N'Q10', N'A10')
GO
SET IDENTITY_INSERT [dbo].[CommonQuestion] OFF
GO
SET IDENTITY_INSERT [dbo].[Course] ON 
GO
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [PrerequisiteRelation], [Level], [Semester]) VALUES (1, N'CHEM 101', N'كيمياء عامة 1', 3, 3, 0, 0, 1, 0, 1, 1)
GO
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [PrerequisiteRelation], [Level], [Semester]) VALUES (2, N'CHEM 103', N'عملي كيمياء عامة 1', 1, 0, 3, 0, 1, 0, 1, 1)
GO
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [PrerequisiteRelation], [Level], [Semester]) VALUES (3, N'COMP 102', N'مقدمة في الحاسب الالي', 3, 2, 2, 0, 0, 0, 1, 2)
GO
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [PrerequisiteRelation], [Level], [Semester]) VALUES (4, N'COMP 104', N'برمجة حاسب 1', 3, 2, 2, 0, 0, 0, 1, 2)
GO
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [PrerequisiteRelation], [Level], [Semester]) VALUES (5, N'COMP 106', N'تصميم منطق', 3, 2, 0, 2, 0, 0, 1, 2)
GO
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [PrerequisiteRelation], [Level], [Semester]) VALUES (6, N'COMP 201', N'تصميم وتحليل الخوارزميات', 3, 3, 0, 0, 1, 0, 2, 1)
GO
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [PrerequisiteRelation], [Level], [Semester]) VALUES (7, N'COMP 202', N'تراكيب البيانات', 3, 2, 2, 0, 0, 1, 2, 2)
GO
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [PrerequisiteRelation], [Level], [Semester]) VALUES (8, N'COMP 203', N'نظرية الحسابات', 2, 2, 0, 0, 1, 0, 2, 1)
GO
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [PrerequisiteRelation], [Level], [Semester]) VALUES (9, N'COMP 204', N'شبكات الحاسب', 3, 2, 2, 0, 0, 0, 2, 2)
GO
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [PrerequisiteRelation], [Level], [Semester]) VALUES (10, N'COMP 205', N'برمجة حاسب 2', 3, 2, 2, 0, 1, 1, 2, 1)
GO
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [PrerequisiteRelation], [Level], [Semester]) VALUES (11, N'COMP 206', N'برمجة الويب', 3, 2, 3, 0, 0, 1, 2, 2)
GO
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [PrerequisiteRelation], [Level], [Semester]) VALUES (12, N'COMP 207', N'نظم قواعد البيانات', 4, 3, 2, 0, 1, 0, 2, 1)
GO
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [PrerequisiteRelation], [Level], [Semester]) VALUES (13, N'COMP 208', N'نظرية الاليات الذاتية', 3, 2, 0, 2, 0, 0, 2, 2)
GO
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [PrerequisiteRelation], [Level], [Semester]) VALUES (14, N'COMP 210', N'خورزميات الرسوم', 2, 2, 0, 0, 0, 0, 2, 2)
GO
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [PrerequisiteRelation], [Level], [Semester]) VALUES (15, N'COMP 301', N'برمجة متقدمة', 3, 2, 3, 0, 1, 1, 3, 1)
GO
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [PrerequisiteRelation], [Level], [Semester]) VALUES (16, N'COMP 302', N'تاليفات خوارزمية', 2, 2, 0, 1, 0, 0, 3, 2)
GO
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [PrerequisiteRelation], [Level], [Semester]) VALUES (17, N'COMP 303', N'قواعد ودلالات لغات البرمجة', 2, 2, 0, 0, 1, 0, 3, 1)
GO
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [PrerequisiteRelation], [Level], [Semester]) VALUES (18, N'COMP 304', N'تصميم مؤلفات', 3, 2, 2, 0, 0, 2, 3, 2)
GO
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [PrerequisiteRelation], [Level], [Semester]) VALUES (19, N'COMP 305', N'نظرية التعقيد', 3, 3, 0, 0, 1, 1, 3, 1)
GO
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [PrerequisiteRelation], [Level], [Semester]) VALUES (20, N'COMP 306', N'رسومات الحاسب', 3, 2, 2, 0, 0, 1, 3, 2)
GO
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [PrerequisiteRelation], [Level], [Semester]) VALUES (21, N'COMP 307', N'نظم التشغيل', 3, 3, 0, 0, 1, 0, 3, 1)
GO
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [PrerequisiteRelation], [Level], [Semester]) VALUES (22, N'COMP 308', N'تشفير', 3, 3, 0, 0, 0, 0, 3, 2)
GO
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [PrerequisiteRelation], [Level], [Semester]) VALUES (23, N'COMP 309', N'نظم الوسائط المتعددة', 2, 2, 1, 0, 1, 0, 3, 1)
GO
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [PrerequisiteRelation], [Level], [Semester]) VALUES (24, N'COMP 310', N'برمجة ويب متقدمة', 2, 1, 3, 0, 0, 1, 3, 2)
GO
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [PrerequisiteRelation], [Level], [Semester]) VALUES (25, N'COMP 311', N'اللغات التصريحية', 2, 2, 1, 0, 1, 0, 3, 1)
GO
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [PrerequisiteRelation], [Level], [Semester]) VALUES (26, N'COMP 312', N'تنظيم الملفات', 2, 2, 0, 0, 0, 0, 3, 2)
GO
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [PrerequisiteRelation], [Level], [Semester]) VALUES (27, N'COMP 314', N'نظم قواعد بيانات متقدمة', 2, 2, 0, 0, 0, 1, 3, 2)
GO
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [PrerequisiteRelation], [Level], [Semester]) VALUES (28, N'COMP 401', N'ذكاء اصطناعي', 3, 3, 0, 0, 1, 0, 4, 1)
GO
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [PrerequisiteRelation], [Level], [Semester]) VALUES (29, N'COMP 402', N'المعلومات الحيوية', 3, 3, 0, 0, 0, 2, 4, 2)
GO
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [PrerequisiteRelation], [Level], [Semester]) VALUES (30, N'COMP 403', N'المعالجة المتوازية الموزعة', 3, 3, 1, 0, 1, 0, 4, 1)
GO
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [PrerequisiteRelation], [Level], [Semester]) VALUES (31, N'COMP 404', N'هندسة البرمجيات', 3, 2, 2, 0, 0, 1, 4, 2)
GO
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [PrerequisiteRelation], [Level], [Semester]) VALUES (32, N'COMP 405', N'مشروع حاسب (أ)', 2, 0, 3, 2, 1, 0, 4, 1)
GO
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [PrerequisiteRelation], [Level], [Semester]) VALUES (33, N'COMP 406', N'مشروع حاسب (ب)', 4, 0, 4, 4, 0, 0, 4, 2)
GO
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [PrerequisiteRelation], [Level], [Semester]) VALUES (34, N'COMP 407', N'معالجة الصور', 3, 3, 1, 0, 1, 1, 4, 1)
GO
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [PrerequisiteRelation], [Level], [Semester]) VALUES (35, N'COMP 408', N'موضوعات متقدمة في الذكاء الاصطناعي', 3, 3, 0, 0, 0, 0, 4, 2)
GO
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [PrerequisiteRelation], [Level], [Semester]) VALUES (36, N'COMP 409', N'امن شبكات', 3, 3, 0, 0, 1, 2, 4, 1)
GO
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [PrerequisiteRelation], [Level], [Semester]) VALUES (37, N'COMP 410', N'الرؤية بالحاسب', 3, 3, 0, 0, 0, 2, 4, 2)
GO
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [PrerequisiteRelation], [Level], [Semester]) VALUES (38, N'COMP 411', N'الهندسة الحسابية', 3, 3, 0, 0, 1, 2, 4, 1)
GO
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [PrerequisiteRelation], [Level], [Semester]) VALUES (39, N'COMP 412', N'موضوعات مختارة في امن المعلومات', 3, 3, 0, 0, 0, 0, 4, 2)
GO
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [PrerequisiteRelation], [Level], [Semester]) VALUES (40, N'COMP 413', N'موضوعات مختارة في الخوارزميات', 3, 3, 0, 0, 1, 1, 4, 1)
GO
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [PrerequisiteRelation], [Level], [Semester]) VALUES (41, N'COMP 414', N'موضوعات مختارة في الحوسبة', 3, 3, 0, 0, 0, 1, 4, 2)
GO
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [PrerequisiteRelation], [Level], [Semester]) VALUES (42, N'COMP 415', N'مؤلفات متقدمة', 3, 2, 2, 0, 1, 3, 4, 1)
GO
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [PrerequisiteRelation], [Level], [Semester]) VALUES (43, N'COMP 416', N'استخلاص البيانات والويب', 3, 3, 0, 0, 0, 1, 4, 2)
GO
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [PrerequisiteRelation], [Level], [Semester]) VALUES (44, N'COMP 418', N'مشروع حاسب ( لمزدوج التخصص )', 3, 0, 4, 2, 0, 0, 4, 2)
GO
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [PrerequisiteRelation], [Level], [Semester]) VALUES (45, N'ENCU 401', N'ثقافة بينية', 1, 1, 0, 0, 1, 0, 4, 1)
GO
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [PrerequisiteRelation], [Level], [Semester]) VALUES (46, N'ENGL 102', N'لغة انجليزية 1', 2, 2, 0, 0, 0, 0, 1, 2)
GO
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [PrerequisiteRelation], [Level], [Semester]) VALUES (47, N'ENGL 201', N'لغة انجليزية 2', 2, 2, 0, 0, 1, 1, 2, 1)
GO
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [PrerequisiteRelation], [Level], [Semester]) VALUES (48, N'ETHR 302', N'اخلاقيات البحث العلمي', 1, 1, 0, 0, 0, 0, 3, 2)
GO
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [PrerequisiteRelation], [Level], [Semester]) VALUES (49, N'GHDS 401', N'نشاة تاريخ وتطور العالم', 1, 1, 0, 0, 1, 0, 4, 1)
GO
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [PrerequisiteRelation], [Level], [Semester]) VALUES (50, N'HURI 101', N'حقوق الانسان', 0, 1, 0, 0, 1, 0, 1, 1)
GO
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [PrerequisiteRelation], [Level], [Semester]) VALUES (51, N'INCO 102', N'مدخل في الحاسب الالي', 0, 1, 0, 0, 0, 0, 1, 2)
GO
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [PrerequisiteRelation], [Level], [Semester]) VALUES (52, N'MATH 101', N'تفاضل وتكامل 1', 4, 3, 0, 2, 1, 0, 1, 1)
GO
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [PrerequisiteRelation], [Level], [Semester]) VALUES (53, N'MATH 102', N'تفاضل وتكامل 2', 3, 3, 0, 1, 0, 0, 1, 2)
GO
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [PrerequisiteRelation], [Level], [Semester]) VALUES (54, N'MATH 104', N'مفاهيم اساسية في الرياضيات', 3, 3, 0, 1, 0, 0, 1, 2)
GO
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [PrerequisiteRelation], [Level], [Semester]) VALUES (55, N'MATH 201', N'التحليل الرياضى', 3, 3, 0, 1, 1, 0, 2, 1)
GO
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [PrerequisiteRelation], [Level], [Semester]) VALUES (56, N'MATH 202', N'معادلات تفاضلية عادية', 3, 3, 0, 1, 0, 3, 2, 2)
GO
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [PrerequisiteRelation], [Level], [Semester]) VALUES (57, N'MATH 203', N'جبر خطي', 3, 3, 0, 1, 1, 0, 2, 1)
GO
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [PrerequisiteRelation], [Level], [Semester]) VALUES (58, N'MATH 204', N'تحليل حقيقى', 3, 3, 0, 1, 0, 0, 2, 2)
GO
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [PrerequisiteRelation], [Level], [Semester]) VALUES (59, N'MATH 205', N'نظرية الأعداد', 3, 3, 0, 1, 1, 0, 2, 1)
GO
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [PrerequisiteRelation], [Level], [Semester]) VALUES (60, N'MATH 206', N'نظرية الألعاب', 2, 2, 0, 0, 0, 0, 2, 2)
GO
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [PrerequisiteRelation], [Level], [Semester]) VALUES (61, N'MATH 208', N'البرمجة الخطية', 2, 2, 0, 0, 0, 0, 2, 2)
GO
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [PrerequisiteRelation], [Level], [Semester]) VALUES (62, N'MATH 222', N'المنطق الرياضى', 2, 2, 0, 0, 0, 0, 2, 2)
GO
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [PrerequisiteRelation], [Level], [Semester]) VALUES (63, N'MATH 301', N'الجبر المجرد (1) نظرية الزمر', 3, 3, 0, 1, 1, 0, 3, 1)
GO
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [PrerequisiteRelation], [Level], [Semester]) VALUES (64, N'MATH 302', N'التوبولوجى العام', 3, 3, 0, 0, 0, 0, 3, 2)
GO
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [PrerequisiteRelation], [Level], [Semester]) VALUES (65, N'MATH 303', N'التحليل العددي', 3, 3, 0, 1, 1, 0, 3, 1)
GO
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [PrerequisiteRelation], [Level], [Semester]) VALUES (66, N'MATH 304', N'نظرية القياس', 3, 3, 0, 0, 0, 1, 3, 2)
GO
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [PrerequisiteRelation], [Level], [Semester]) VALUES (67, N'MATH 305', N'الهندسة التفاضلية', 2, 2, 0, 0, 1, 0, 3, 1)
GO
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [PrerequisiteRelation], [Level], [Semester]) VALUES (68, N'MATH 306', N'بحوث العمليات', 2, 2, 0, 0, 0, 0, 3, 2)
GO
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [PrerequisiteRelation], [Level], [Semester]) VALUES (69, N'MATH 307', N'نظرية الخوارزميات', 2, 2, 0, 0, 1, 0, 3, 1)
GO
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [PrerequisiteRelation], [Level], [Semester]) VALUES (70, N'MATH 319', N'مبادئ نمذجة رياضية', 2, 2, 0, 0, 1, 0, 3, 1)
GO
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [PrerequisiteRelation], [Level], [Semester]) VALUES (71, N'MATH 331', N'مبادئ حساب التغيرات', 3, 2, 0, 2, 1, 0, 3, 1)
GO
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [PrerequisiteRelation], [Level], [Semester]) VALUES (72, N'MATH 333', N'الجبر المجرد لعلوم الحاسب', 3, 2, 0, 2, 1, 0, 3, 1)
GO
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [PrerequisiteRelation], [Level], [Semester]) VALUES (73, N'MATH 401', N'التحليل الدالى', 3, 3, 0, 0, 1, 0, 4, 1)
GO
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [PrerequisiteRelation], [Level], [Semester]) VALUES (74, N'MATH 402', N'الجبر المجرد (2) (الحلقات و الحقول)', 3, 3, 0, 1, 0, 1, 4, 2)
GO
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [PrerequisiteRelation], [Level], [Semester]) VALUES (75, N'MATH 403', N'التحليل المركب', 3, 3, 0, 0, 1, 1, 4, 1)
GO
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [PrerequisiteRelation], [Level], [Semester]) VALUES (76, N'MATH 404', N'المعادلات التفاضلية الجزئية', 3, 3, 0, 0, 0, 1, 4, 2)
GO
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [PrerequisiteRelation], [Level], [Semester]) VALUES (77, N'MATH 406', N'جبر خطى متقدم', 3, 2, 2, 0, 0, 0, 4, 2)
GO
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [PrerequisiteRelation], [Level], [Semester]) VALUES (78, N'MATH 407', N'الهندسة الجبرية', 2, 2, 0, 0, 1, 0, 4, 1)
GO
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [PrerequisiteRelation], [Level], [Semester]) VALUES (79, N'MATH 408', N'موضوعات مختارة فى الرياضيات البحتة', 3, 3, 0, 0, 0, 0, 4, 2)
GO
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [PrerequisiteRelation], [Level], [Semester]) VALUES (80, N'MATH 409', N'نظرية الرسوم', 2, 2, 0, 0, 1, 0, 4, 1)
GO
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [PrerequisiteRelation], [Level], [Semester]) VALUES (81, N'MATH 421', N'جبر خطى عددى', 2, 2, 0, 0, 1, 1, 4, 1)
GO
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [PrerequisiteRelation], [Level], [Semester]) VALUES (82, N'MATH 423', N'مشروع بحثى رياضيات بحتة', 1, 0, 0, 3, 1, 0, 4, 1)
GO
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [PrerequisiteRelation], [Level], [Semester]) VALUES (83, N'PHYS 101', N'فيزياء 1', 4, 3, 3, 0, 1, 0, 1, 1)
GO
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [PrerequisiteRelation], [Level], [Semester]) VALUES (84, N'SAFS 101', N'الامن والسلامة', 1, 1, 0, 0, 1, 0, 1, 1)
GO
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [PrerequisiteRelation], [Level], [Semester]) VALUES (85, N'SCTH 301', N'التفكير العلمي', 1, 1, 0, 0, 1, 0, 3, 1)
GO
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [PrerequisiteRelation], [Level], [Semester]) VALUES (86, N'SKIL 401', N'مهارات العمل', 1, 1, 0, 0, 1, 0, 4, 1)
GO
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [PrerequisiteRelation], [Level], [Semester]) VALUES (87, N'STAT 101', N'مقدمة في الاحصاء', 3, 3, 0, 1, 1, 0, 1, 1)
GO
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [PrerequisiteRelation], [Level], [Semester]) VALUES (88, N'STAT 102', N'نظرية الاحتمالات 1', 3, 3, 0, 1, 0, 0, 1, 2)
GO
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [PrerequisiteRelation], [Level], [Semester]) VALUES (89, N'STAT 201', N'(1) نظرية الإحصاء', 3, 3, 0, 1, 1, 0, 2, 1)
GO
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [PrerequisiteRelation], [Level], [Semester]) VALUES (90, N'STAT 202', N'(2) نظرية الإحصاء', 3, 3, 0, 1, 0, 0, 2, 2)
GO
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [PrerequisiteRelation], [Level], [Semester]) VALUES (91, N'STAT 203', N'(1) طرق إحصائية', 3, 2, 3, 0, 1, 0, 2, 1)
GO
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [PrerequisiteRelation], [Level], [Semester]) VALUES (92, N'STAT 204', N'(1) طرق إحتمالية فى بحوث العمليات', 3, 3, 0, 1, 1, 0, 2, 2)
GO
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [PrerequisiteRelation], [Level], [Semester]) VALUES (93, N'STAT 205', N'رياضيات إحصائية', 3, 3, 0, 1, 1, 0, 2, 1)
GO
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [PrerequisiteRelation], [Level], [Semester]) VALUES (94, N'STAT 206', N'(2) طرق إحصائية', 3, 2, 3, 0, 0, 0, 2, 2)
GO
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [PrerequisiteRelation], [Level], [Semester]) VALUES (95, N'STAT 208', N'مبادئ تحاليل الانحدار', 3, 3, 1, 0, 0, 0, 2, 2)
GO
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [PrerequisiteRelation], [Level], [Semester]) VALUES (96, N'STAT 218', N'مقدمة في نظرية الاحتمالات', 3, 3, 0, 1, 0, 0, 2, 2)
GO
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [PrerequisiteRelation], [Level], [Semester]) VALUES (97, N'STAT 301', N'(1) استدلال إحصائى', 3, 3, 0, 1, 1, 0, 3, 1)
GO
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [PrerequisiteRelation], [Level], [Semester]) VALUES (98, N'STAT 302', N'(2) استدلال إحصائى', 3, 3, 0, 1, 0, 0, 3, 2)
GO
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [PrerequisiteRelation], [Level], [Semester]) VALUES (99, N'STAT 303', N'(1) عمليات عشوائية', 3, 3, 0, 1, 1, 0, 3, 1)
GO
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [PrerequisiteRelation], [Level], [Semester]) VALUES (100, N'STAT 304', N'طرق المعاينة', 3, 3, 0, 0, 0, 0, 3, 2)
GO
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [PrerequisiteRelation], [Level], [Semester]) VALUES (101, N'STAT 305', N'إحصاءات مرتبة', 3, 3, 0, 1, 1, 0, 3, 1)
GO
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [PrerequisiteRelation], [Level], [Semester]) VALUES (102, N'STAT 311', N'محاكاة ونمذجة', 3, 3, 0, 1, 1, 0, 3, 1)
GO
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [PrerequisiteRelation], [Level], [Semester]) VALUES (103, N'STAT 314', N'نظرية الصلاحية', 2, 2, 0, 0, 0, 0, 3, 2)
GO
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [PrerequisiteRelation], [Level], [Semester]) VALUES (104, N'STAT 315', N'(2) طرق إحتمالية فى بحوث العمليات', 3, 3, 0, 1, 1, 0, 3, 1)
GO
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [PrerequisiteRelation], [Level], [Semester]) VALUES (105, N'STAT 405', N'تصميم و تحليل التجارب', 4, 3, 2, 0, 1, 0, 4, 1)
GO
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [PrerequisiteRelation], [Level], [Semester]) VALUES (106, N'STAT 408', N'سلاسل زمنية', 3, 3, 0, 0, 0, 0, 4, 2)
GO
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [PrerequisiteRelation], [Level], [Semester]) VALUES (107, N'STAT 411', N'التحليل التتابعى', 2, 2, 0, 0, 1, 0, 4, 1)
GO
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [PrerequisiteRelation], [Level], [Semester]) VALUES (108, N'STAT 412', N'نظرية الطوابير', 2, 2, 0, 0, 0, 0, 4, 2)
GO
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [PrerequisiteRelation], [Level], [Semester]) VALUES (109, N'STAT 415', N'تحليل إحصائى متعدد', 2, 2, 0, 1, 1, 0, 4, 1)
GO
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [PrerequisiteRelation], [Level], [Semester]) VALUES (110, N'STAT 416', N'نظرية التجديد', 2, 2, 0, 0, 0, 0, 4, 2)
GO
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [PrerequisiteRelation], [Level], [Semester]) VALUES (111, N'STAT 417', N'نظرية اتخاذ القرار', 2, 2, 0, 0, 1, 0, 4, 1)
GO
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [PrerequisiteRelation], [Level], [Semester]) VALUES (112, N'STAT 418', N'(2) عمليات عشوائية', 2, 2, 0, 0, 0, 0, 4, 2)
GO
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [PrerequisiteRelation], [Level], [Semester]) VALUES (113, N'STAT 424', N'مشروع بحثى فى الإحصاء', 2, 0, 2, 2, 0, 0, 4, 2)
GO
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [PrerequisiteRelation], [Level], [Semester]) VALUES (114, N'COMP 212', N'برمجة حاسب متقدم', 3, 2, 2, 0, 0, 0, 2, 2)
GO
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [PrerequisiteRelation], [Level], [Semester]) VALUES (115, N'COMP 313', N'حزم برمجية', 1, 0, 3, 0, 1, 0, 3, 1)
GO
SET IDENTITY_INSERT [dbo].[Course] OFF
GO
INSERT [dbo].[CoursePrerequisites] ([CourseID], [PrerequisiteCourseID]) VALUES (7, 4)
GO
INSERT [dbo].[CoursePrerequisites] ([CourseID], [PrerequisiteCourseID]) VALUES (10, 4)
GO
INSERT [dbo].[CoursePrerequisites] ([CourseID], [PrerequisiteCourseID]) VALUES (11, 4)
GO
INSERT [dbo].[CoursePrerequisites] ([CourseID], [PrerequisiteCourseID]) VALUES (15, 10)
GO
INSERT [dbo].[CoursePrerequisites] ([CourseID], [PrerequisiteCourseID]) VALUES (18, 13)
GO
INSERT [dbo].[CoursePrerequisites] ([CourseID], [PrerequisiteCourseID]) VALUES (19, 9)
GO
INSERT [dbo].[CoursePrerequisites] ([CourseID], [PrerequisiteCourseID]) VALUES (20, 10)
GO
INSERT [dbo].[CoursePrerequisites] ([CourseID], [PrerequisiteCourseID]) VALUES (24, 11)
GO
INSERT [dbo].[CoursePrerequisites] ([CourseID], [PrerequisiteCourseID]) VALUES (27, 12)
GO
INSERT [dbo].[CoursePrerequisites] ([CourseID], [PrerequisiteCourseID]) VALUES (29, 6)
GO
INSERT [dbo].[CoursePrerequisites] ([CourseID], [PrerequisiteCourseID]) VALUES (29, 10)
GO
INSERT [dbo].[CoursePrerequisites] ([CourseID], [PrerequisiteCourseID]) VALUES (31, 10)
GO
INSERT [dbo].[CoursePrerequisites] ([CourseID], [PrerequisiteCourseID]) VALUES (34, 10)
GO
INSERT [dbo].[CoursePrerequisites] ([CourseID], [PrerequisiteCourseID]) VALUES (36, 9)
GO
INSERT [dbo].[CoursePrerequisites] ([CourseID], [PrerequisiteCourseID]) VALUES (36, 22)
GO
INSERT [dbo].[CoursePrerequisites] ([CourseID], [PrerequisiteCourseID]) VALUES (37, 6)
GO
INSERT [dbo].[CoursePrerequisites] ([CourseID], [PrerequisiteCourseID]) VALUES (37, 10)
GO
INSERT [dbo].[CoursePrerequisites] ([CourseID], [PrerequisiteCourseID]) VALUES (38, 6)
GO
INSERT [dbo].[CoursePrerequisites] ([CourseID], [PrerequisiteCourseID]) VALUES (38, 10)
GO
INSERT [dbo].[CoursePrerequisites] ([CourseID], [PrerequisiteCourseID]) VALUES (40, 6)
GO
INSERT [dbo].[CoursePrerequisites] ([CourseID], [PrerequisiteCourseID]) VALUES (41, 10)
GO
INSERT [dbo].[CoursePrerequisites] ([CourseID], [PrerequisiteCourseID]) VALUES (42, 17)
GO
INSERT [dbo].[CoursePrerequisites] ([CourseID], [PrerequisiteCourseID]) VALUES (42, 18)
GO
INSERT [dbo].[CoursePrerequisites] ([CourseID], [PrerequisiteCourseID]) VALUES (43, 12)
GO
INSERT [dbo].[CoursePrerequisites] ([CourseID], [PrerequisiteCourseID]) VALUES (47, 46)
GO
INSERT [dbo].[CoursePrerequisites] ([CourseID], [PrerequisiteCourseID]) VALUES (56, 52)
GO
INSERT [dbo].[CoursePrerequisites] ([CourseID], [PrerequisiteCourseID]) VALUES (56, 53)
GO
INSERT [dbo].[CoursePrerequisites] ([CourseID], [PrerequisiteCourseID]) VALUES (66, 58)
GO
INSERT [dbo].[CoursePrerequisites] ([CourseID], [PrerequisiteCourseID]) VALUES (74, 63)
GO
INSERT [dbo].[CoursePrerequisites] ([CourseID], [PrerequisiteCourseID]) VALUES (75, 58)
GO
INSERT [dbo].[CoursePrerequisites] ([CourseID], [PrerequisiteCourseID]) VALUES (76, 56)
GO
INSERT [dbo].[CoursePrerequisites] ([CourseID], [PrerequisiteCourseID]) VALUES (77, 57)
GO
INSERT [dbo].[CoursePrerequisites] ([CourseID], [PrerequisiteCourseID]) VALUES (81, 57)
GO
INSERT [dbo].[CoursePrerequisites] ([CourseID], [PrerequisiteCourseID]) VALUES (89, 88)
GO
INSERT [dbo].[CoursePrerequisites] ([CourseID], [PrerequisiteCourseID]) VALUES (90, 88)
GO
INSERT [dbo].[CoursePrerequisites] ([CourseID], [PrerequisiteCourseID]) VALUES (91, 87)
GO
INSERT [dbo].[CoursePrerequisites] ([CourseID], [PrerequisiteCourseID]) VALUES (97, 90)
GO
INSERT [dbo].[CoursePrerequisites] ([CourseID], [PrerequisiteCourseID]) VALUES (98, 90)
GO
INSERT [dbo].[CoursePrerequisites] ([CourseID], [PrerequisiteCourseID]) VALUES (99, 93)
GO
INSERT [dbo].[CoursePrerequisites] ([CourseID], [PrerequisiteCourseID]) VALUES (101, 90)
GO
INSERT [dbo].[CoursePrerequisites] ([CourseID], [PrerequisiteCourseID]) VALUES (102, 90)
GO
INSERT [dbo].[CoursePrerequisites] ([CourseID], [PrerequisiteCourseID]) VALUES (104, 92)
GO
INSERT [dbo].[CoursePrerequisites] ([CourseID], [PrerequisiteCourseID]) VALUES (105, 98)
GO
INSERT [dbo].[CoursePrerequisites] ([CourseID], [PrerequisiteCourseID]) VALUES (106, 98)
GO
INSERT [dbo].[CoursePrerequisites] ([CourseID], [PrerequisiteCourseID]) VALUES (107, 98)
GO
INSERT [dbo].[CoursePrerequisites] ([CourseID], [PrerequisiteCourseID]) VALUES (108, 99)
GO
INSERT [dbo].[CoursePrerequisites] ([CourseID], [PrerequisiteCourseID]) VALUES (109, 93)
GO
INSERT [dbo].[CoursePrerequisites] ([CourseID], [PrerequisiteCourseID]) VALUES (110, 93)
GO
INSERT [dbo].[CoursePrerequisites] ([CourseID], [PrerequisiteCourseID]) VALUES (112, 99)
GO
INSERT [dbo].[CoursePrerequisites] ([CourseID], [PrerequisiteCourseID]) VALUES (111, 97)
GO
INSERT [dbo].[CoursePrerequisites] ([CourseID], [PrerequisiteCourseID]) VALUES (114, 4)
GO
INSERT [dbo].[Date] ([DateFor], [StartDate], [EndDate]) VALUES (0, CAST(N'2022-12-02T00:00:00.000' AS DateTime), CAST(N'2023-02-15T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[Date] ([DateFor], [StartDate], [EndDate]) VALUES (1, CAST(N'2022-12-01T00:00:00.000' AS DateTime), CAST(N'2023-02-15T00:00:00.000' AS DateTime))
GO
INSERT [dbo].[OptionalCourse] ([ProgramID], [Level], [Semester], [CourseType], [Category], [Hour]) VALUES (5, 2, 2, 2, 1, 3)
GO
INSERT [dbo].[OptionalCourse] ([ProgramID], [Level], [Semester], [CourseType], [Category], [Hour]) VALUES (5, 3, 1, 2, 1, 2)
GO
INSERT [dbo].[OptionalCourse] ([ProgramID], [Level], [Semester], [CourseType], [Category], [Hour]) VALUES (5, 3, 1, 2, 2, 3)
GO
INSERT [dbo].[OptionalCourse] ([ProgramID], [Level], [Semester], [CourseType], [Category], [Hour]) VALUES (5, 3, 2, 2, 1, 4)
GO
INSERT [dbo].[OptionalCourse] ([ProgramID], [Level], [Semester], [CourseType], [Category], [Hour]) VALUES (5, 4, 1, 3, 1, 1)
GO
INSERT [dbo].[OptionalCourse] ([ProgramID], [Level], [Semester], [CourseType], [Category], [Hour]) VALUES (5, 4, 1, 2, 1, 6)
GO
INSERT [dbo].[OptionalCourse] ([ProgramID], [Level], [Semester], [CourseType], [Category], [Hour]) VALUES (5, 4, 2, 2, 1, 6)
GO
INSERT [dbo].[OptionalCourse] ([ProgramID], [Level], [Semester], [CourseType], [Category], [Hour]) VALUES (6, 2, 2, 2, 1, 2)
GO
INSERT [dbo].[OptionalCourse] ([ProgramID], [Level], [Semester], [CourseType], [Category], [Hour]) VALUES (6, 2, 2, 2, 2, 3)
GO
INSERT [dbo].[OptionalCourse] ([ProgramID], [Level], [Semester], [CourseType], [Category], [Hour]) VALUES (6, 3, 1, 2, 1, 2)
GO
INSERT [dbo].[OptionalCourse] ([ProgramID], [Level], [Semester], [CourseType], [Category], [Hour]) VALUES (6, 3, 1, 2, 2, 2)
GO
INSERT [dbo].[OptionalCourse] ([ProgramID], [Level], [Semester], [CourseType], [Category], [Hour]) VALUES (6, 3, 1, 2, 3, 1)
GO
INSERT [dbo].[OptionalCourse] ([ProgramID], [Level], [Semester], [CourseType], [Category], [Hour]) VALUES (6, 3, 2, 2, 2, 3)
GO
INSERT [dbo].[OptionalCourse] ([ProgramID], [Level], [Semester], [CourseType], [Category], [Hour]) VALUES (6, 4, 1, 3, 1, 1)
GO
INSERT [dbo].[OptionalCourse] ([ProgramID], [Level], [Semester], [CourseType], [Category], [Hour]) VALUES (6, 4, 1, 2, 1, 2)
GO
INSERT [dbo].[OptionalCourse] ([ProgramID], [Level], [Semester], [CourseType], [Category], [Hour]) VALUES (6, 4, 1, 2, 2, 3)
GO
INSERT [dbo].[OptionalCourse] ([ProgramID], [Level], [Semester], [CourseType], [Category], [Hour]) VALUES (6, 4, 2, 2, 1, 3)
GO
INSERT [dbo].[OptionalCourse] ([ProgramID], [Level], [Semester], [CourseType], [Category], [Hour]) VALUES (6, 4, 2, 2, 2, 3)
GO
INSERT [dbo].[OptionalCourse] ([ProgramID], [Level], [Semester], [CourseType], [Category], [Hour]) VALUES (7, 2, 2, 2, 1, 3)
GO
INSERT [dbo].[OptionalCourse] ([ProgramID], [Level], [Semester], [CourseType], [Category], [Hour]) VALUES (7, 2, 2, 2, 2, 3)
GO
INSERT [dbo].[OptionalCourse] ([ProgramID], [Level], [Semester], [CourseType], [Category], [Hour]) VALUES (7, 3, 1, 2, 1, 3)
GO
INSERT [dbo].[OptionalCourse] ([ProgramID], [Level], [Semester], [CourseType], [Category], [Hour]) VALUES (7, 3, 1, 2, 2, 2)
GO
INSERT [dbo].[OptionalCourse] ([ProgramID], [Level], [Semester], [CourseType], [Category], [Hour]) VALUES (7, 3, 2, 2, 2, 3)
GO
INSERT [dbo].[OptionalCourse] ([ProgramID], [Level], [Semester], [CourseType], [Category], [Hour]) VALUES (7, 4, 1, 3, 1, 1)
GO
INSERT [dbo].[OptionalCourse] ([ProgramID], [Level], [Semester], [CourseType], [Category], [Hour]) VALUES (7, 4, 1, 2, 1, 2)
GO
INSERT [dbo].[OptionalCourse] ([ProgramID], [Level], [Semester], [CourseType], [Category], [Hour]) VALUES (7, 4, 1, 2, 2, 3)
GO
INSERT [dbo].[OptionalCourse] ([ProgramID], [Level], [Semester], [CourseType], [Category], [Hour]) VALUES (7, 4, 2, 2, 1, 2)
GO
INSERT [dbo].[OptionalCourse] ([ProgramID], [Level], [Semester], [CourseType], [Category], [Hour]) VALUES (7, 4, 2, 2, 2, 3)
GO
SET IDENTITY_INSERT [dbo].[Program] ON 
GO
INSERT [dbo].[Program] ([ID], [Name], [Semester], [Percentage], [IsRegular], [IsGeneral], [TotalHours], [EnglishName], [ArabicName]) VALUES (1, N'Math', 1, 1, 1, 1, 16, N'Mathmatics Department', N'قسم الرياضيات')
GO
INSERT [dbo].[Program] ([ID], [Name], [Semester], [Percentage], [IsRegular], [IsGeneral], [TotalHours], [EnglishName], [ArabicName]) VALUES (2, N'Cs', 2, 0.35, 1, 1, 17, N'Computer Science', N'برنامج علوم الحاسب')
GO
INSERT [dbo].[Program] ([ID], [Name], [Semester], [Percentage], [IsRegular], [IsGeneral], [TotalHours], [EnglishName], [ArabicName]) VALUES (3, N'Stat', 2, 0.35, 1, 1, 17, N'Statistics', N'برنامج الإحصاء الرياضى')
GO
INSERT [dbo].[Program] ([ID], [Name], [Semester], [Percentage], [IsRegular], [IsGeneral], [TotalHours], [EnglishName], [ArabicName]) VALUES (4, N'Pure Math', 2, 0.3, 1, 0, 134, N'Pure Mathmatics', N'برنامج الرياضات البحته منفرد')
GO
INSERT [dbo].[Program] ([ID], [Name], [Semester], [Percentage], [IsRegular], [IsGeneral], [TotalHours], [EnglishName], [ArabicName]) VALUES (5, N'Pure Cs', 3, 0.6, 1, 0, 134, N'Pure Computer Science', N'برنامح علوم الحاسب منفرد')
GO
INSERT [dbo].[Program] ([ID], [Name], [Semester], [Percentage], [IsRegular], [IsGeneral], [TotalHours], [EnglishName], [ArabicName]) VALUES (6, N'Math Cs', 3, 0.4, 1, 0, 140, N'Mathmathic & Computer Science', N'برنامج الرياضيات البحتة وعلو الحاسب')
GO
INSERT [dbo].[Program] ([ID], [Name], [Semester], [Percentage], [IsRegular], [IsGeneral], [TotalHours], [EnglishName], [ArabicName]) VALUES (7, N'Stat Cs', 3, 1, 1, 0, 140, N'Statistics & Computer Science', N'برنامج الإحصاء الرياضى وعلوم الحاسب')
GO
INSERT [dbo].[Program] ([ID], [Name], [Semester], [Percentage], [IsRegular], [IsGeneral], [TotalHours], [EnglishName], [ArabicName]) VALUES (8, N'Pure Stat', 3, 1, 1, 0, 134, N'Pure Statisstics', N'برنامج الإحصاء الرياضى منفرد')
GO
INSERT [dbo].[Program] ([ID], [Name], [Semester], [Percentage], [IsRegular], [IsGeneral], [TotalHours], [EnglishName], [ArabicName]) VALUES (9, N'Stat Math', 3, 1, 1, 0, 140, N'Statistics & Mathmatics', N'برنامج الإحصاء الرياضى والرياضات البحته')
GO
INSERT [dbo].[Program] ([ID], [Name], [Semester], [Percentage], [IsRegular], [IsGeneral], [TotalHours], [EnglishName], [ArabicName]) VALUES (10, N'Chemistry', 1, 0.2, 1, 1, 140, N'Chemistry', N'قسم الكيمياء')
GO
SET IDENTITY_INSERT [dbo].[Program] OFF
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType], [Category]) VALUES (5, 1, 1, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType], [Category]) VALUES (5, 2, 1, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType], [Category]) VALUES (5, 3, 1, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType], [Category]) VALUES (5, 4, 1, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType], [Category]) VALUES (5, 5, 1, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType], [Category]) VALUES (5, 6, 1, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType], [Category]) VALUES (5, 7, 1, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType], [Category]) VALUES (5, 8, 1, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType], [Category]) VALUES (5, 9, 1, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType], [Category]) VALUES (5, 10, 1, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType], [Category]) VALUES (5, 11, 1, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType], [Category]) VALUES (5, 12, 1, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType], [Category]) VALUES (5, 13, 1, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType], [Category]) VALUES (5, 14, 1, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType], [Category]) VALUES (5, 15, 1, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType], [Category]) VALUES (5, 16, 1, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType], [Category]) VALUES (5, 17, 1, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType], [Category]) VALUES (5, 18, 1, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType], [Category]) VALUES (5, 19, 1, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType], [Category]) VALUES (5, 20, 1, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType], [Category]) VALUES (5, 21, 1, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType], [Category]) VALUES (5, 22, 1, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType], [Category]) VALUES (5, 23, 2, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType], [Category]) VALUES (5, 24, 2, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType], [Category]) VALUES (5, 25, 2, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType], [Category]) VALUES (5, 26, 2, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType], [Category]) VALUES (5, 27, 2, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType], [Category]) VALUES (5, 28, 1, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType], [Category]) VALUES (5, 29, 1, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType], [Category]) VALUES (5, 30, 1, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType], [Category]) VALUES (5, 31, 1, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType], [Category]) VALUES (5, 32, 1, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType], [Category]) VALUES (5, 33, 1, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType], [Category]) VALUES (5, 34, 1, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType], [Category]) VALUES (5, 35, 2, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType], [Category]) VALUES (5, 36, 2, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType], [Category]) VALUES (5, 37, 2, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType], [Category]) VALUES (5, 38, 2, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType], [Category]) VALUES (5, 39, 2, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType], [Category]) VALUES (5, 40, 2, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType], [Category]) VALUES (5, 41, 2, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType], [Category]) VALUES (5, 42, 2, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType], [Category]) VALUES (5, 43, 2, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType], [Category]) VALUES (5, 45, 3, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType], [Category]) VALUES (5, 46, 3, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType], [Category]) VALUES (5, 47, 3, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType], [Category]) VALUES (5, 48, 3, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType], [Category]) VALUES (5, 49, 3, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType], [Category]) VALUES (5, 50, 3, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType], [Category]) VALUES (5, 51, 3, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType], [Category]) VALUES (5, 52, 1, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType], [Category]) VALUES (5, 53, 1, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType], [Category]) VALUES (5, 54, 1, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType], [Category]) VALUES (5, 56, 2, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType], [Category]) VALUES (5, 57, 1, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType], [Category]) VALUES (5, 65, 2, 2)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType], [Category]) VALUES (5, 72, 2, 2)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType], [Category]) VALUES (5, 83, 1, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType], [Category]) VALUES (5, 84, 3, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType], [Category]) VALUES (5, 85, 3, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType], [Category]) VALUES (5, 86, 3, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType], [Category]) VALUES (5, 87, 1, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType], [Category]) VALUES (5, 96, 2, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType], [Category]) VALUES (6, 44, 1, 2)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType], [Category]) VALUES (6, 52, 1, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType], [Category]) VALUES (6, 83, 1, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType], [Category]) VALUES (6, 1, 1, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType], [Category]) VALUES (6, 2, 1, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType], [Category]) VALUES (6, 87, 1, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType], [Category]) VALUES (6, 84, 3, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType], [Category]) VALUES (6, 50, 3, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType], [Category]) VALUES (6, 46, 3, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType], [Category]) VALUES (6, 51, 3, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType], [Category]) VALUES (6, 53, 1, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType], [Category]) VALUES (6, 54, 1, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType], [Category]) VALUES (6, 3, 1, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType], [Category]) VALUES (6, 4, 1, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType], [Category]) VALUES (6, 5, 1, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType], [Category]) VALUES (6, 47, 3, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType], [Category]) VALUES (6, 55, 1, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType], [Category]) VALUES (6, 57, 1, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType], [Category]) VALUES (6, 59, 1, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType], [Category]) VALUES (6, 6, 1, 2)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType], [Category]) VALUES (6, 12, 1, 2)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType], [Category]) VALUES (6, 56, 1, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType], [Category]) VALUES (6, 58, 1, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType], [Category]) VALUES (6, 60, 2, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType], [Category]) VALUES (6, 61, 2, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType], [Category]) VALUES (6, 62, 2, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType], [Category]) VALUES (6, 7, 1, 2)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType], [Category]) VALUES (6, 114, 1, 2)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType], [Category]) VALUES (6, 9, 2, 2)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType], [Category]) VALUES (6, 11, 2, 2)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType], [Category]) VALUES (6, 13, 2, 2)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType], [Category]) VALUES (6, 85, 3, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType], [Category]) VALUES (6, 63, 1, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType], [Category]) VALUES (6, 65, 1, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType], [Category]) VALUES (6, 67, 2, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType], [Category]) VALUES (6, 69, 2, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType], [Category]) VALUES (6, 70, 2, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType], [Category]) VALUES (6, 71, 2, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType], [Category]) VALUES (6, 19, 1, 2)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType], [Category]) VALUES (6, 21, 1, 2)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType], [Category]) VALUES (6, 17, 2, 2)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType], [Category]) VALUES (6, 23, 2, 2)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType], [Category]) VALUES (6, 25, 2, 2)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType], [Category]) VALUES (6, 115, 2, 3)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType], [Category]) VALUES (6, 48, 3, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType], [Category]) VALUES (6, 64, 1, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType], [Category]) VALUES (6, 66, 1, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType], [Category]) VALUES (6, 68, 1, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType], [Category]) VALUES (6, 16, 1, 2)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType], [Category]) VALUES (6, 22, 1, 2)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType], [Category]) VALUES (6, 18, 2, 2)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType], [Category]) VALUES (6, 20, 2, 2)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType], [Category]) VALUES (6, 86, 3, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType], [Category]) VALUES (6, 45, 3, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType], [Category]) VALUES (6, 49, 3, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType], [Category]) VALUES (6, 73, 1, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType], [Category]) VALUES (6, 75, 1, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType], [Category]) VALUES (6, 82, 1, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType], [Category]) VALUES (6, 78, 2, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType], [Category]) VALUES (6, 80, 2, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType], [Category]) VALUES (6, 81, 2, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType], [Category]) VALUES (6, 28, 1, 2)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType], [Category]) VALUES (6, 30, 1, 2)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType], [Category]) VALUES (6, 34, 2, 2)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType], [Category]) VALUES (6, 38, 2, 2)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType], [Category]) VALUES (6, 40, 2, 2)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType], [Category]) VALUES (6, 74, 1, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType], [Category]) VALUES (6, 76, 1, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType], [Category]) VALUES (6, 77, 2, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType], [Category]) VALUES (6, 79, 2, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType], [Category]) VALUES (6, 29, 1, 2)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType], [Category]) VALUES (6, 39, 2, 2)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType], [Category]) VALUES (6, 41, 2, 2)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType], [Category]) VALUES (6, 43, 2, 2)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType], [Category]) VALUES (7, 52, 1, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType], [Category]) VALUES (7, 83, 1, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType], [Category]) VALUES (7, 1, 1, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType], [Category]) VALUES (7, 2, 1, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType], [Category]) VALUES (7, 87, 1, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType], [Category]) VALUES (7, 84, 3, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType], [Category]) VALUES (7, 50, 3, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType], [Category]) VALUES (7, 46, 3, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType], [Category]) VALUES (7, 51, 3, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType], [Category]) VALUES (7, 53, 1, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType], [Category]) VALUES (7, 54, 1, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType], [Category]) VALUES (7, 3, 1, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType], [Category]) VALUES (7, 4, 1, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType], [Category]) VALUES (7, 88, 1, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType], [Category]) VALUES (7, 47, 3, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType], [Category]) VALUES (7, 89, 1, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType], [Category]) VALUES (7, 91, 1, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType], [Category]) VALUES (7, 93, 1, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType], [Category]) VALUES (7, 6, 1, 2)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType], [Category]) VALUES (7, 12, 1, 2)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType], [Category]) VALUES (7, 90, 1, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType], [Category]) VALUES (7, 92, 1, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType], [Category]) VALUES (7, 94, 2, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType], [Category]) VALUES (7, 95, 2, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType], [Category]) VALUES (7, 7, 1, 2)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType], [Category]) VALUES (7, 114, 1, 2)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType], [Category]) VALUES (7, 9, 2, 2)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType], [Category]) VALUES (7, 11, 2, 2)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType], [Category]) VALUES (7, 13, 2, 2)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType], [Category]) VALUES (7, 85, 3, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType], [Category]) VALUES (7, 97, 1, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType], [Category]) VALUES (7, 99, 1, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType], [Category]) VALUES (7, 101, 2, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType], [Category]) VALUES (7, 102, 2, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType], [Category]) VALUES (7, 104, 2, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType], [Category]) VALUES (7, 19, 1, 2)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType], [Category]) VALUES (7, 21, 1, 2)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType], [Category]) VALUES (7, 17, 2, 2)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType], [Category]) VALUES (7, 23, 2, 2)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType], [Category]) VALUES (7, 25, 2, 2)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType], [Category]) VALUES (7, 48, 3, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType], [Category]) VALUES (7, 98, 1, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType], [Category]) VALUES (7, 100, 1, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType], [Category]) VALUES (7, 103, 1, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType], [Category]) VALUES (7, 16, 1, 2)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType], [Category]) VALUES (7, 22, 1, 2)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType], [Category]) VALUES (7, 18, 2, 2)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType], [Category]) VALUES (7, 20, 2, 2)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType], [Category]) VALUES (7, 86, 3, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType], [Category]) VALUES (7, 45, 3, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType], [Category]) VALUES (7, 49, 3, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType], [Category]) VALUES (7, 105, 1, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType], [Category]) VALUES (7, 109, 1, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType], [Category]) VALUES (7, 107, 2, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType], [Category]) VALUES (7, 111, 2, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType], [Category]) VALUES (7, 28, 1, 2)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType], [Category]) VALUES (7, 30, 1, 2)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType], [Category]) VALUES (7, 34, 2, 2)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType], [Category]) VALUES (7, 38, 2, 2)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType], [Category]) VALUES (7, 40, 2, 2)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType], [Category]) VALUES (7, 106, 1, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType], [Category]) VALUES (7, 112, 1, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType], [Category]) VALUES (7, 113, 1, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType], [Category]) VALUES (7, 108, 2, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType], [Category]) VALUES (7, 110, 2, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType], [Category]) VALUES (7, 29, 1, 2)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType], [Category]) VALUES (7, 44, 1, 2)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType], [Category]) VALUES (7, 31, 2, 2)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType], [Category]) VALUES (7, 41, 2, 2)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType], [Category]) VALUES (7, 43, 2, 2)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType], [Category]) VALUES (1, 1, 1, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType], [Category]) VALUES (1, 2, 1, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType], [Category]) VALUES (1, 52, 1, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType], [Category]) VALUES (1, 83, 1, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType], [Category]) VALUES (1, 87, 1, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType], [Category]) VALUES (1, 50, 3, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType], [Category]) VALUES (1, 84, 3, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType], [Category]) VALUES (2, 3, 1, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType], [Category]) VALUES (2, 4, 1, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType], [Category]) VALUES (2, 5, 1, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType], [Category]) VALUES (2, 53, 1, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType], [Category]) VALUES (2, 54, 1, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType], [Category]) VALUES (2, 46, 3, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType], [Category]) VALUES (2, 51, 3, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType], [Category]) VALUES (3, 3, 1, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType], [Category]) VALUES (3, 4, 1, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType], [Category]) VALUES (3, 53, 1, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType], [Category]) VALUES (3, 54, 1, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType], [Category]) VALUES (3, 88, 1, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType], [Category]) VALUES (3, 46, 3, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType], [Category]) VALUES (3, 51, 3, 1)
GO
INSERT [dbo].[ProgramDistribution] ([ProgramID], [Semester], [NumberOfHours]) VALUES (1, 1, 16)
GO
INSERT [dbo].[ProgramDistribution] ([ProgramID], [Semester], [NumberOfHours]) VALUES (2, 2, 17)
GO
INSERT [dbo].[ProgramDistribution] ([ProgramID], [Semester], [NumberOfHours]) VALUES (3, 2, 17)
GO
INSERT [dbo].[ProgramDistribution] ([ProgramID], [Semester], [NumberOfHours]) VALUES (4, 1, 16)
GO
INSERT [dbo].[ProgramDistribution] ([ProgramID], [Semester], [NumberOfHours]) VALUES (4, 2, 17)
GO
INSERT [dbo].[ProgramDistribution] ([ProgramID], [Semester], [NumberOfHours]) VALUES (4, 3, 18)
GO
INSERT [dbo].[ProgramDistribution] ([ProgramID], [Semester], [NumberOfHours]) VALUES (4, 4, 16)
GO
INSERT [dbo].[ProgramDistribution] ([ProgramID], [Semester], [NumberOfHours]) VALUES (4, 5, 17)
GO
INSERT [dbo].[ProgramDistribution] ([ProgramID], [Semester], [NumberOfHours]) VALUES (4, 6, 17)
GO
INSERT [dbo].[ProgramDistribution] ([ProgramID], [Semester], [NumberOfHours]) VALUES (4, 7, 17)
GO
INSERT [dbo].[ProgramDistribution] ([ProgramID], [Semester], [NumberOfHours]) VALUES (4, 8, 16)
GO
INSERT [dbo].[ProgramDistribution] ([ProgramID], [Semester], [NumberOfHours]) VALUES (5, 1, 16)
GO
INSERT [dbo].[ProgramDistribution] ([ProgramID], [Semester], [NumberOfHours]) VALUES (5, 2, 17)
GO
INSERT [dbo].[ProgramDistribution] ([ProgramID], [Semester], [NumberOfHours]) VALUES (5, 3, 17)
GO
INSERT [dbo].[ProgramDistribution] ([ProgramID], [Semester], [NumberOfHours]) VALUES (5, 4, 17)
GO
INSERT [dbo].[ProgramDistribution] ([ProgramID], [Semester], [NumberOfHours]) VALUES (5, 5, 17)
GO
INSERT [dbo].[ProgramDistribution] ([ProgramID], [Semester], [NumberOfHours]) VALUES (5, 6, 16)
GO
INSERT [dbo].[ProgramDistribution] ([ProgramID], [Semester], [NumberOfHours]) VALUES (5, 7, 18)
GO
INSERT [dbo].[ProgramDistribution] ([ProgramID], [Semester], [NumberOfHours]) VALUES (5, 8, 16)
GO
INSERT [dbo].[ProgramDistribution] ([ProgramID], [Semester], [NumberOfHours]) VALUES (6, 1, 16)
GO
INSERT [dbo].[ProgramDistribution] ([ProgramID], [Semester], [NumberOfHours]) VALUES (6, 2, 17)
GO
INSERT [dbo].[ProgramDistribution] ([ProgramID], [Semester], [NumberOfHours]) VALUES (6, 3, 18)
GO
INSERT [dbo].[ProgramDistribution] ([ProgramID], [Semester], [NumberOfHours]) VALUES (6, 4, 17)
GO
INSERT [dbo].[ProgramDistribution] ([ProgramID], [Semester], [NumberOfHours]) VALUES (6, 5, 18)
GO
INSERT [dbo].[ProgramDistribution] ([ProgramID], [Semester], [NumberOfHours]) VALUES (6, 6, 17)
GO
INSERT [dbo].[ProgramDistribution] ([ProgramID], [Semester], [NumberOfHours]) VALUES (6, 7, 19)
GO
INSERT [dbo].[ProgramDistribution] ([ProgramID], [Semester], [NumberOfHours]) VALUES (6, 8, 18)
GO
INSERT [dbo].[ProgramDistribution] ([ProgramID], [Semester], [NumberOfHours]) VALUES (7, 1, 16)
GO
INSERT [dbo].[ProgramDistribution] ([ProgramID], [Semester], [NumberOfHours]) VALUES (7, 2, 17)
GO
INSERT [dbo].[ProgramDistribution] ([ProgramID], [Semester], [NumberOfHours]) VALUES (7, 3, 18)
GO
INSERT [dbo].[ProgramDistribution] ([ProgramID], [Semester], [NumberOfHours]) VALUES (7, 4, 18)
GO
INSERT [dbo].[ProgramDistribution] ([ProgramID], [Semester], [NumberOfHours]) VALUES (7, 5, 18)
GO
INSERT [dbo].[ProgramDistribution] ([ProgramID], [Semester], [NumberOfHours]) VALUES (7, 6, 17)
GO
INSERT [dbo].[ProgramDistribution] ([ProgramID], [Semester], [NumberOfHours]) VALUES (7, 7, 18)
GO
INSERT [dbo].[ProgramDistribution] ([ProgramID], [Semester], [NumberOfHours]) VALUES (7, 8, 18)
GO
INSERT [dbo].[ProgramDistribution] ([ProgramID], [Semester], [NumberOfHours]) VALUES (8, 1, 16)
GO
INSERT [dbo].[ProgramDistribution] ([ProgramID], [Semester], [NumberOfHours]) VALUES (8, 2, 17)
GO
INSERT [dbo].[ProgramDistribution] ([ProgramID], [Semester], [NumberOfHours]) VALUES (8, 3, 17)
GO
INSERT [dbo].[ProgramDistribution] ([ProgramID], [Semester], [NumberOfHours]) VALUES (8, 4, 17)
GO
INSERT [dbo].[ProgramDistribution] ([ProgramID], [Semester], [NumberOfHours]) VALUES (8, 5, 16)
GO
INSERT [dbo].[ProgramDistribution] ([ProgramID], [Semester], [NumberOfHours]) VALUES (8, 6, 16)
GO
INSERT [dbo].[ProgramDistribution] ([ProgramID], [Semester], [NumberOfHours]) VALUES (8, 7, 18)
GO
INSERT [dbo].[ProgramDistribution] ([ProgramID], [Semester], [NumberOfHours]) VALUES (8, 8, 17)
GO
INSERT [dbo].[ProgramDistribution] ([ProgramID], [Semester], [NumberOfHours]) VALUES (9, 1, 16)
GO
INSERT [dbo].[ProgramDistribution] ([ProgramID], [Semester], [NumberOfHours]) VALUES (9, 2, 17)
GO
INSERT [dbo].[ProgramDistribution] ([ProgramID], [Semester], [NumberOfHours]) VALUES (9, 3, 18)
GO
INSERT [dbo].[ProgramDistribution] ([ProgramID], [Semester], [NumberOfHours]) VALUES (9, 4, 17)
GO
INSERT [dbo].[ProgramDistribution] ([ProgramID], [Semester], [NumberOfHours]) VALUES (9, 5, 18)
GO
INSERT [dbo].[ProgramDistribution] ([ProgramID], [Semester], [NumberOfHours]) VALUES (9, 6, 17)
GO
INSERT [dbo].[ProgramDistribution] ([ProgramID], [Semester], [NumberOfHours]) VALUES (9, 7, 19)
GO
INSERT [dbo].[ProgramDistribution] ([ProgramID], [Semester], [NumberOfHours]) VALUES (9, 8, 18)
GO
INSERT [dbo].[ProgramRelations] ([Program], [SubProgram]) VALUES (1, 2)
GO
INSERT [dbo].[ProgramRelations] ([Program], [SubProgram]) VALUES (1, 3)
GO
INSERT [dbo].[ProgramRelations] ([Program], [SubProgram]) VALUES (1, 4)
GO
INSERT [dbo].[ProgramRelations] ([Program], [SubProgram]) VALUES (2, 5)
GO
INSERT [dbo].[ProgramRelations] ([Program], [SubProgram]) VALUES (2, 6)
GO
INSERT [dbo].[ProgramRelations] ([Program], [SubProgram]) VALUES (3, 7)
GO
INSERT [dbo].[ProgramRelations] ([Program], [SubProgram]) VALUES (3, 8)
GO
INSERT [dbo].[ProgramRelations] ([Program], [SubProgram]) VALUES (3, 9)
GO
INSERT [dbo].[ProgramRelations] ([Program], [SubProgram]) VALUES (NULL, 1)
GO
INSERT [dbo].[ProgramRelations] ([Program], [SubProgram]) VALUES (NULL, 10)
GO
SET IDENTITY_INSERT [dbo].[Student] ON 
GO
INSERT [dbo].[Student] ([ID], [GUID], [FName], [MName], [LName], [SSN], [PhoneNumber], [BirthDate], [Address], [Gender], [Nationality], [Email], [Password], [AcademicCode], [SeatNumber], [AvailableCredits], [IsInSpecialProgram], [SupervisorID], [CreatedOn], [IsCrossStudent], [SemestersNumberInProgram]) VALUES (5, N'94A552CF-AF8D-402A-AB9D-F37D11220E97', N'Momen', N'Essam', N'Arafa', N'30105050106293', N'01021179969', CAST(N'2001-05-05' AS Date), N'26 شارع راضى سليم الاول - الزيتون - القاهره', N'1', N'مصرى', N'30105050106293@sci.asu.edu.eg', N'0FBC1FB9CDE268DF12C8CE7A0CF5847B9D1246F76D994A335EBBE0068D777BF00641A9CF776BEF92DBBC4A9B9389095D7ABAFECF9560BC8BD42FD5AA3564DE8C', N'190691', NULL, 9, 1, 2, CAST(N'2022-11-27T00:00:00.000' AS DateTime), 0, 7)
GO
INSERT [dbo].[Student] ([ID], [GUID], [FName], [MName], [LName], [SSN], [PhoneNumber], [BirthDate], [Address], [Gender], [Nationality], [Email], [Password], [AcademicCode], [SeatNumber], [AvailableCredits], [IsInSpecialProgram], [SupervisorID], [CreatedOn], [IsCrossStudent], [SemestersNumberInProgram]) VALUES (8, N'5A0F826F-770A-44FA-BE66-62721E55D5F1', N'Girguis', N'Ashraf', N'Fekry', N'30109272102534', N'01033916944', CAST(N'2001-09-27' AS Date), N'11 شارع كمال احمد منصور - ارض اللواء  العجوزة - الجيزة', N'1', N'مصرى', N'30109272102534@sci.asu.edu.eg', N'0FBC1FB9CDE268DF12C8CE7A0CF5847B9D1246F76D994A335EBBE0068D777BF00641A9CF776BEF92DBBC4A9B9389095D7ABAFECF9560BC8BD42FD5AA3564DE8C', N'190114', NULL, 12, 1, 2, CAST(N'2022-11-27T00:00:00.000' AS DateTime), 0, 7)
GO
INSERT [dbo].[Student] ([ID], [GUID], [FName], [MName], [LName], [SSN], [PhoneNumber], [BirthDate], [Address], [Gender], [Nationality], [Email], [Password], [AcademicCode], [SeatNumber], [AvailableCredits], [IsInSpecialProgram], [SupervisorID], [CreatedOn], [IsCrossStudent], [SemestersNumberInProgram]) VALUES (11, N'03CBB008-52E8-4904-BDC4-70AD821E4388', N'Giovany', N'Nady', N'Zekry', N'30105120101332', N'01227901024', CAST(N'2001-05-12' AS Date), N'عين شمس', N'1', N'مصرى', N'30105120101332@sci.asu.edu.eg', N'0FBC1FB9CDE268DF12C8CE7A0CF5847B9D1246F76D994A335EBBE0068D777BF00641A9CF776BEF92DBBC4A9B9389095D7ABAFECF9560BC8BD42FD5AA3564DE8C', N'190552', NULL, 12, 1, 2, CAST(N'2022-11-27T00:00:00.000' AS DateTime), 0, 7)
GO
INSERT [dbo].[Student] ([ID], [GUID], [FName], [MName], [LName], [SSN], [PhoneNumber], [BirthDate], [Address], [Gender], [Nationality], [Email], [Password], [AcademicCode], [SeatNumber], [AvailableCredits], [IsInSpecialProgram], [SupervisorID], [CreatedOn], [IsCrossStudent], [SemestersNumberInProgram]) VALUES (12, N'2B6289DA-B16C-49B2-BF48-CCF5D5B5B433', N'Yossef', N'Tarek', N'Masoud', N'30101150105477', N'01278552284', CAST(N'2001-01-15' AS Date), N'7916 شارع المدينة المنورة متفرع من شارع 9 المقطم', N'1', N'مصرى', N'30101150105477@sci.asu.edu.eg', N'0FBC1FB9CDE268DF12C8CE7A0CF5847B9D1246F76D994A335EBBE0068D777BF00641A9CF776BEF92DBBC4A9B9389095D7ABAFECF9560BC8BD42FD5AA3564DE8C', N'190823', NULL, 9, 1, 2, CAST(N'2022-11-28T00:00:00.000' AS DateTime), 0, 7)
GO
INSERT [dbo].[Student] ([ID], [GUID], [FName], [MName], [LName], [SSN], [PhoneNumber], [BirthDate], [Address], [Gender], [Nationality], [Email], [Password], [AcademicCode], [SeatNumber], [AvailableCredits], [IsInSpecialProgram], [SupervisorID], [CreatedOn], [IsCrossStudent], [SemestersNumberInProgram]) VALUES (13, N'FFEDC23A-8946-423D-AAFB-34D19EC18C64', N'Malak', N'Mohamed', N'AbdElhamed', N'30106190104688', N'01023883386', CAST(N'2001-06-19' AS Date), N'الزاوية', N'2', N'مصرى', N'30106190104688@sci.asu.edu.eg', N'0FBC1FB9CDE268DF12C8CE7A0CF5847B9D1246F76D994A335EBBE0068D777BF00641A9CF776BEF92DBBC4A9B9389095D7ABAFECF9560BC8BD42FD5AA3564DE8C', N'190787', NULL, 0, 1, 2, CAST(N'2022-11-28T00:00:00.000' AS DateTime), 0, 7)
GO
INSERT [dbo].[Student] ([ID], [GUID], [FName], [MName], [LName], [SSN], [PhoneNumber], [BirthDate], [Address], [Gender], [Nationality], [Email], [Password], [AcademicCode], [SeatNumber], [AvailableCredits], [IsInSpecialProgram], [SupervisorID], [CreatedOn], [IsCrossStudent], [SemestersNumberInProgram]) VALUES (14, N'D0CCA8BC-0736-4298-98D6-994E01EF3EDE', N'Ganna', N'Mahmoud', N'hemeda', N'30010282102447', N'01141733612', CAST(N'2000-10-28' AS Date), N'الهرم', N'2', N'مصرى', N'30010282102447@sci.asu.edu.eg', N'0FBC1FB9CDE268DF12C8CE7A0CF5847B9D1246F76D994A335EBBE0068D777BF00641A9CF776BEF92DBBC4A9B9389095D7ABAFECF9560BC8BD42FD5AA3564DE8C', N'190111', NULL, 2, 1, 2, CAST(N'2022-11-28T00:00:00.000' AS DateTime), 0, 7)
GO
INSERT [dbo].[Student] ([ID], [GUID], [FName], [MName], [LName], [SSN], [PhoneNumber], [BirthDate], [Address], [Gender], [Nationality], [Email], [Password], [AcademicCode], [SeatNumber], [AvailableCredits], [IsInSpecialProgram], [SupervisorID], [CreatedOn], [IsCrossStudent], [SemestersNumberInProgram]) VALUES (15, N'9C93E126-DD0B-4231-B664-43CD9EF58535', N'Ahmed', N'Mohamed', N'Shaker', N'29705222101212', N'01000000011', CAST(N'1997-05-22' AS Date), N'القاهرة', N'1', N'مصرى', N'29705222101212@sci.asu.edu.eg', N'0FBC1FB9CDE268DF12C8CE7A0CF5847B9D1246F76D994A335EBBE0068D777BF00641A9CF776BEF92DBBC4A9B9389095D7ABAFECF9560BC8BD42FD5AA3564DE8C', N'150142', NULL, 1, 1, 2, CAST(N'2022-11-28T00:00:00.000' AS DateTime), 0, 12)
GO
INSERT [dbo].[Student] ([ID], [GUID], [FName], [MName], [LName], [SSN], [PhoneNumber], [BirthDate], [Address], [Gender], [Nationality], [Email], [Password], [AcademicCode], [SeatNumber], [AvailableCredits], [IsInSpecialProgram], [SupervisorID], [CreatedOn], [IsCrossStudent], [SemestersNumberInProgram]) VALUES (17, N'A047BE0D-AD6A-435A-AE4D-65FFF78AFA42', N'Ali', N'Saed', N'Ali', N'29704032114789', N'01000000012', CAST(N'1997-04-03' AS Date), N'القاهرة', N'1', N'مصرى', N'29704032114789@sci.asu.edu.eg', N'0FBC1FB9CDE268DF12C8CE7A0CF5847B9D1246F76D994A335EBBE0068D777BF00641A9CF776BEF92DBBC4A9B9389095D7ABAFECF9560BC8BD42FD5AA3564DE8C', N'150111', NULL, 1, 1, 2, CAST(N'2022-11-29T00:00:00.000' AS DateTime), 0, 10)
GO
INSERT [dbo].[Student] ([ID], [GUID], [FName], [MName], [LName], [SSN], [PhoneNumber], [BirthDate], [Address], [Gender], [Nationality], [Email], [Password], [AcademicCode], [SeatNumber], [AvailableCredits], [IsInSpecialProgram], [SupervisorID], [CreatedOn], [IsCrossStudent], [SemestersNumberInProgram]) VALUES (18, N'98F9F7E1-59DE-4AE0-B52A-FFC731D02253', N'Mahmoud', N'Salem', N'Farouk', N'29612121014574', N'01000000013', CAST(N'1996-12-12' AS Date), N'القاهرة', N'1', N'مصرى', N'29612121014574@sci.asu.edu.eg', N'0FBC1FB9CDE268DF12C8CE7A0CF5847B9D1246F76D994A335EBBE0068D777BF00641A9CF776BEF92DBBC4A9B9389095D7ABAFECF9560BC8BD42FD5AA3564DE8C', N'150123', NULL, 0, 1, 2, CAST(N'2022-11-29T00:00:00.000' AS DateTime), 0, 12)
GO
INSERT [dbo].[Student] ([ID], [GUID], [FName], [MName], [LName], [SSN], [PhoneNumber], [BirthDate], [Address], [Gender], [Nationality], [Email], [Password], [AcademicCode], [SeatNumber], [AvailableCredits], [IsInSpecialProgram], [SupervisorID], [CreatedOn], [IsCrossStudent], [SemestersNumberInProgram]) VALUES (19, N'44B6F0C0-550C-4501-982E-5ABFB287BE3B', N'student', N'level', N'1', N'22222214562145', N'01000000014', CAST(N'2005-05-05' AS Date), N'القاهرة', N'1', N'مصرى', N'22222214562145@sci.asu.edu.eg', N'0FBC1FB9CDE268DF12C8CE7A0CF5847B9D1246F76D994A335EBBE0068D777BF00641A9CF776BEF92DBBC4A9B9389095D7ABAFECF9560BC8BD42FD5AA3564DE8C', N'140140', NULL, 12, 0, 2, CAST(N'2022-12-06T00:00:00.000' AS DateTime), 0, 1)
GO
SET IDENTITY_INSERT [dbo].[Student] OFF
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (5, 28, NULL, NULL, NULL, 1, 1, 1, 1, 0, 19, 1, 0, 0, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (5, 30, NULL, NULL, NULL, 1, 1, 1, 1, 0, 19, 1, 0, 0, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (5, 34, NULL, NULL, NULL, 1, 1, 1, 1, 0, 19, 1, 0, 0, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (5, 32, NULL, NULL, NULL, 1, 1, 1, 1, 0, 19, 1, 0, 0, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (5, 36, NULL, NULL, NULL, 1, 1, 1, 1, 0, 19, 1, 0, 0, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (5, 38, NULL, NULL, NULL, 1, 1, 1, 1, 0, 19, 1, 0, 0, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (5, 86, NULL, NULL, NULL, 1, 1, 1, 1, 0, 19, 1, 0, 0, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (8, 28, NULL, NULL, NULL, 1, 1, 1, 1, 0, 19, 1, 0, 0, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (8, 30, NULL, NULL, NULL, 1, 1, 1, 1, 0, 19, 1, 0, 0, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (8, 34, NULL, NULL, NULL, 1, 1, 1, 1, 0, 19, 1, 0, 0, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (8, 32, NULL, NULL, NULL, 1, 1, 1, 1, 0, 19, 1, 0, 0, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (8, 36, NULL, NULL, NULL, 1, 1, 1, 1, 0, 19, 1, 0, 0, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (8, 38, NULL, NULL, NULL, 1, 1, 1, 1, 0, 19, 1, 0, 0, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (8, 86, NULL, NULL, NULL, 1, 1, 1, 1, 0, 19, 1, 0, 0, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (5, 1, 119, N'B', 3, 1, 1, 1, 1, 0, 10, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (5, 2, 49, N'A', 4, 1, 1, 1, 1, 0, 10, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (5, 50, 37, N'P', 0, 1, 0, 1, 1, 0, 10, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (5, 52, 148, N'C+', 2.67, 1, 1, 1, 1, 0, 10, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (5, 83, 147, N'C+', 2.67, 1, 1, 1, 1, 0, 10, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (5, 84, 38, N'B', 3, 1, 1, 1, 1, 0, 10, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (5, 87, 138, N'A', 4, 1, 1, 1, 1, 0, 10, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (5, 3, NULL, N'P', 0, 1, 0, 1, 1, 0, 11, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (5, 4, NULL, N'P', 0, 1, 0, 1, 1, 0, 11, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (5, 5, NULL, N'P', 0, 1, 0, 1, 1, 0, 11, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (5, 46, NULL, N'P', 0, 1, 0, 1, 1, 0, 11, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (5, 51, NULL, N'P', 0, 1, 0, 1, 1, 0, 11, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (5, 53, NULL, N'P', 0, 1, 0, 1, 1, 0, 11, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (5, 54, NULL, N'P', 0, 1, 0, 1, 1, 0, 11, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (5, 6, 103, N'C', 2.33, 1, 1, 1, 1, 0, 13, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (5, 8, 68, N'C', 2.33, 1, 1, 1, 1, 0, 13, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (5, 10, 138, N'A', 4, 1, 1, 1, 1, 0, 13, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (5, 12, 152, N'B', 3, 1, 1, 1, 1, 0, 13, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (5, 47, 84, N'B+', 3.33, 1, 1, 1, 1, 0, 13, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (5, 57, 90, N'D', 2, 1, 1, 1, 1, 0, 13, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (5, 85, 41, N'B+', 3.33, 1, 1, 1, 1, 0, 13, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (5, 7, 119, N'B', 3, 1, 1, 1, 1, 0, 14, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (5, 9, 89, N'F', 0, 1, 1, 1, 1, 0, 14, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (5, 11, 138, N'A', 4, 1, 1, 1, 1, 0, 14, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (5, 13, 138, N'A', 4, 1, 1, 1, 1, 0, 14, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (5, 14, 80, N'B+', 3.33, 1, 1, 1, 1, 0, 14, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (5, 48, 44, N'A-', 3.67, 1, 1, 1, 1, 0, 14, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (5, 56, 138, N'A', 4, 1, 1, 1, 1, 0, 14, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (5, 15, 119, N'B', 3, 1, 1, 1, 1, 0, 16, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (5, 17, 72, N'C+', 2.67, 1, 1, 1, 1, 0, 16, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (5, 19, 96, N'D', 2, 1, 1, 1, 1, 0, 16, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (5, 21, 119, N'B', 3, 1, 1, 1, 1, 0, 16, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (5, 23, 68, N'C', 2.33, 1, 1, 1, 1, 0, 16, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (5, 72, 119, N'B', 3, 1, 1, 1, 1, 0, 16, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (5, 18, 112, N'C+', 2.67, 1, 1, 1, 1, 0, 17, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (5, 20, 112, N'C+', 2.67, 1, 1, 1, 1, 0, 17, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (5, 22, 119, N'B', 3, 1, 1, 1, 1, 0, 17, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (5, 24, 92, N'A', 4, 1, 1, 1, 1, 0, 17, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (5, 27, 92, N'A', 4, 1, 1, 1, 1, 0, 17, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (5, 9, 119, N'B', 3, 1, 1, 1, 2, 0, 17, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (5, 16, 72, N'C+', 2.67, 1, 1, 1, 1, 0, 18, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (8, 1, 108, N'C+', 2.67, 1, 1, 1, 1, 0, 10, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (8, 2, 45, N'A', 4, 1, 1, 1, 1, 0, 10, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (8, 50, 35, N'P', 0, 1, 0, 1, 1, 0, 10, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (8, 52, 141, N'C+', 2.67, 1, 1, 1, 1, 0, 10, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (8, 83, 149, N'C+', 2.67, 1, 1, 1, 1, 0, 10, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (8, 84, 45, N'A', 4, 1, 1, 1, 1, 0, 10, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (8, 87, 122, N'B+', 3.33, 1, 1, 1, 1, 0, 10, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (8, 3, NULL, N'P', 0, 1, 0, 1, 1, 0, 11, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (8, 4, NULL, N'P', 0, 1, 0, 1, 1, 0, 11, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (8, 5, NULL, N'P', 0, 1, 0, 1, 1, 0, 11, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (8, 46, NULL, N'P', 0, 1, 0, 1, 1, 0, 11, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (8, 51, NULL, N'P', 0, 1, 0, 1, 1, 0, 11, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (8, 53, NULL, N'P', 0, 1, 0, 1, 1, 0, 11, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (8, 54, NULL, N'P', 0, 1, 0, 1, 1, 0, 11, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (8, 6, 102, N'C', 2.33, 1, 1, 1, 1, 0, 13, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (8, 8, 68, N'C', 2.33, 1, 1, 1, 1, 0, 13, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (8, 10, 149, N'A', 4, 1, 1, 1, 1, 0, 13, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (8, 12, 150, N'B', 3, 1, 1, 1, 1, 0, 13, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (8, 47, 88, N'A-', 3.67, 1, 1, 1, 1, 0, 13, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (8, 57, 95, N'D', 2, 1, 1, 1, 1, 0, 13, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (8, 7, 133, N'A-', 3.67, 1, 1, 1, 1, 0, 14, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (8, 9, 119, N'B', 3, 1, 1, 1, 1, 0, 14, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (8, 11, 131, N'A-', 3.67, 1, 1, 1, 1, 0, 14, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (8, 13, 141, N'A', 4, 1, 1, 1, 1, 0, 14, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (8, 14, 76, N'B', 3, 1, 1, 1, 1, 0, 14, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (8, 56, 139, N'A', 4, 1, 1, 1, 1, 0, 14, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (8, 15, 144, N'A', 4, 1, 1, 1, 1, 0, 16, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (8, 17, 71, N'C+', 2.67, 1, 1, 1, 1, 0, 16, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (8, 19, 106, N'C+', 2.67, 1, 1, 1, 1, 0, 16, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (8, 21, 119, N'B', 3, 1, 1, 1, 1, 0, 16, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (8, 23, 72, N'C+', 2.67, 1, 1, 1, 1, 0, 16, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (8, 72, 71, N'F', 0, 1, 1, 1, 1, 0, 16, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (8, 85, 48, N'A', 4, 1, 1, 1, 1, 0, 16, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (8, 16, 91, N'A', 4, 1, 1, 1, 1, 0, 17, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (8, 18, 92, N'D', 2, 1, 1, 1, 1, 0, 17, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (8, 20, 117, N'B', 3, 1, 1, 1, 1, 0, 17, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (8, 22, 111, N'C+', 2.67, 1, 1, 1, 1, 0, 17, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (8, 24, 91, N'A', 4, 1, 1, 1, 1, 0, 17, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (8, 27, 90, N'A', 4, 1, 1, 1, 1, 0, 17, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (8, 48, 50, N'A', 4, 1, 1, 1, 1, 0, 17, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (8, 31, 127, N'B+', 3.33, 1, 1, 1, 1, 0, 18, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (13, 1, NULL, N'F', 0, 1, 1, 1, 1, 0, 10, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (13, 2, NULL, N'A', 4, 1, 1, 1, 1, 0, 10, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (13, 50, NULL, N'P', 0, 1, 0, 1, 1, 0, 10, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (13, 52, NULL, N'D', 2, 1, 1, 1, 1, 0, 10, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (13, 83, NULL, N'D', 2, 1, 1, 1, 1, 0, 10, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (13, 84, NULL, N'C', 2.33, 1, 1, 1, 1, 0, 10, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (13, 87, NULL, N'C', 2.33, 1, 1, 1, 1, 0, 10, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (13, 3, NULL, N'P', 0, 1, 0, 1, 1, 0, 11, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (13, 4, NULL, N'P', 0, 1, 0, 1, 1, 0, 11, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (13, 46, NULL, N'P', 0, 1, 0, 1, 1, 0, 11, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (13, 51, NULL, N'P', 0, 1, 0, 1, 1, 0, 11, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (13, 53, NULL, N'P', 0, 1, 0, 1, 1, 0, 11, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (13, 54, NULL, N'P', 0, 1, 0, 1, 1, 0, 11, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (13, 1, NULL, N'B+', 3.33, 1, 1, 1, 2, 0, 12, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (13, 6, NULL, N'F', 0, 1, 1, 1, 1, 0, 13, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (13, 12, NULL, N'F', 0, 1, 1, 1, 1, 0, 13, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (13, 47, NULL, N'B', 3, 1, 1, 1, 1, 0, 13, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (13, 55, NULL, N'F', 0, 1, 1, 1, 1, 0, 13, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (13, 57, NULL, N'F', 0, 1, 1, 1, 1, 0, 13, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (13, 59, NULL, N'F', 0, 1, 1, 1, 1, 0, 13, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (13, 7, NULL, N'F', 0, 1, 1, 1, 1, 0, 14, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (13, 114, NULL, N'C+', 2.67, 1, 1, 1, 1, 0, 14, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (13, 56, NULL, N'A', 4, 1, 1, 1, 1, 0, 14, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (13, 58, NULL, N'B', 3, 1, 1, 1, 1, 0, 14, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (13, 6, NULL, N'C', 2.33, 1, 1, 1, 2, 0, 15, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (13, 7, NULL, N'A-', 3.67, 1, 1, 1, 2, 0, 15, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (13, 19, NULL, N'B', 3, 1, 1, 1, 1, 0, 16, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (13, 23, NULL, N'F', 0, 1, 1, 1, 1, 0, 16, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (13, 115, NULL, N'D', 2, 1, 1, 1, 1, 0, 16, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (13, 63, NULL, N'F', 0, 1, 1, 1, 1, 0, 16, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (13, 67, NULL, N'D', 2, 1, 1, 1, 1, 0, 16, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (13, 85, NULL, N'B+', 3.33, 1, 1, 1, 1, 0, 16, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (13, 13, NULL, N'B', 3, 1, 1, 1, 1, 0, 17, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (13, 16, NULL, N'C', 2.33, 1, 1, 1, 1, 0, 17, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (13, 20, NULL, N'B', 3, 1, 1, 1, 1, 0, 17, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (13, 48, NULL, N'A', 4, 1, 1, 1, 1, 0, 17, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (13, 64, NULL, N'C+', 2.67, 1, 1, 1, 1, 0, 17, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (13, 22, NULL, N'C+', 2.67, 1, 1, 1, 1, 0, 18, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (13, 57, NULL, N'B', 3, 1, 1, 1, 2, 0, 18, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (14, 1, NULL, N'F', 0, 1, 1, 1, 1, 0, 10, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (14, 2, NULL, N'A', 4, 1, 1, 1, 1, 0, 10, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (14, 50, NULL, N'P', 0, 1, 0, 1, 1, 0, 10, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (14, 52, NULL, N'D', 2, 1, 1, 1, 1, 0, 10, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (14, 83, NULL, N'F', 0, 1, 1, 1, 1, 0, 10, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (14, 84, NULL, N'B', 3, 1, 1, 1, 1, 0, 10, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (14, 87, NULL, N'C+', 2.67, 1, 1, 1, 1, 0, 10, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (14, 3, NULL, N'P', 0, 1, 0, 1, 1, 0, 11, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (14, 4, NULL, N'P', 0, 1, 0, 1, 1, 0, 11, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (14, 46, NULL, N'P', 0, 1, 0, 1, 1, 0, 11, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (14, 51, NULL, N'P', 0, 1, 0, 1, 1, 0, 11, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (14, 53, NULL, N'P', 0, 1, 0, 1, 1, 0, 11, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (14, 54, NULL, N'P', 0, 1, 0, 1, 1, 0, 11, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (14, 88, NULL, N'P', 0, 1, 0, 1, 1, 0, 11, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (14, 1, NULL, N'C', 2.33, 1, 1, 1, 2, 0, 12, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (14, 83, NULL, N'B', 3, 1, 1, 1, 2, 0, 12, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (14, 6, NULL, N'D', 2, 1, 1, 1, 1, 0, 13, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (14, 12, NULL, N'C+', 2.67, 1, 1, 1, 1, 0, 13, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (14, 47, NULL, N'A', 4, 1, 1, 1, 1, 0, 13, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (14, 89, NULL, N'F', 0, 1, 1, 1, 1, 0, 13, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (14, 91, NULL, N'B+', 3.33, 1, 1, 1, 1, 0, 13, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (14, 93, NULL, N'C+', 2.67, 1, 1, 1, 1, 0, 13, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (14, 7, NULL, N'B', 3, 1, 1, 1, 1, 0, 14, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (14, 13, NULL, N'A-', 3.67, 1, 1, 1, 1, 0, 14, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (14, 114, NULL, N'A', 4, 1, 1, 1, 1, 0, 14, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (14, 90, NULL, N'F', 0, 1, 1, 1, 1, 0, 14, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (14, 92, NULL, N'B+', 3.33, 1, 1, 1, 1, 0, 14, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (14, 95, NULL, N'F', 0, 1, 1, 1, 1, 0, 14, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (14, 19, NULL, N'D', 2, 1, 1, 1, 1, 0, 16, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (14, 21, NULL, N'D', 2, 1, 1, 1, 1, 0, 16, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (14, 23, NULL, N'F', 0, 1, 1, 1, 1, 0, 16, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (14, 85, NULL, N'B', 3, 1, 1, 1, 1, 0, 16, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (14, 89, NULL, N'F', 0, 1, 1, 1, 2, 0, 16, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (14, 99, NULL, N'F', 0, 1, 1, 1, 1, 0, 16, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (14, 28, NULL, N'C', 2.33, 1, 1, 1, 1, 0, 16, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (14, 16, NULL, N'D', 2, 1, 1, 1, 1, 0, 17, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (14, 20, NULL, N'B', 3, 1, 1, 1, 1, 0, 17, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (14, 48, NULL, N'A', 4, 1, 1, 1, 1, 0, 17, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (14, 98, NULL, N'D', 2, 1, 1, 1, 1, 0, 17, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (14, 103, NULL, N'C+', 2.67, 1, 1, 1, 1, 0, 17, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (14, 22, NULL, N'B', 3, 1, 1, 1, 1, 0, 18, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (14, 31, NULL, N'A-', 3.67, 1, 1, 1, 1, 0, 18, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (15, 1, 95, N'D', 2, 1, 1, 1, 1, 0, 1, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (15, 2, 47, N'A', 4, 1, 1, 1, 1, 0, 1, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (15, 50, 34, N'P', 0, 1, 0, 1, 1, 0, 1, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (15, 52, 159, N'B', 3, 1, 1, 1, 1, 0, 1, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (15, 83, 130, N'C', 2.33, 1, 1, 1, 1, 0, 1, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (15, 84, 30, N'D', 2, 1, 1, 1, 1, 0, 1, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (15, 87, 108, N'C+', 2.67, 1, 1, 1, 1, 0, 1, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (15, 3, 77, N'F', 0, 1, 1, 1, 1, 0, 2, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (15, 4, 84, N'F', 0, 1, 1, 1, 1, 0, 2, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (15, 5, 142, N'A', 4, 1, 1, 1, 1, 0, 2, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (15, 46, 44, N'F', 0, 1, 1, 1, 1, 0, 2, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (15, 51, 31, N'P', 0, 1, 0, 1, 1, 0, 2, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (15, 53, 100, N'C', 2.33, 1, 1, 1, 1, 0, 2, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (15, 54, 122, N'B+', 3.33, 1, 1, 1, 1, 0, 2, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (15, 3, 118, N'B', 3, 1, 1, 1, 2, 0, 3, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (15, 4, 140, N'A', 4, 1, 1, 1, 2, 0, 3, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (15, 6, 0, N'F', 0, 1, 1, 1, 1, 0, 4, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (15, 8, 69, N'C', 2.33, 1, 1, 1, 1, 0, 4, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (15, 10, 120, N'B+', 3.33, 1, 1, 1, 1, 0, 4, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (15, 12, 140, N'C+', 2.67, 1, 1, 1, 1, 0, 4, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (15, 57, 109, N'C+', 2.67, 1, 1, 1, 1, 0, 4, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (15, 7, 0, N'F', 0, 1, 1, 1, 1, 0, 5, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (15, 9, 0, N'F', 0, 1, 1, 1, 1, 0, 5, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (15, 11, 0, N'F', 0, 1, 1, 1, 1, 0, 5, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (15, 13, 90, N'D', 2, 1, 1, 1, 1, 0, 5, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (15, 46, 43, N'F', 0, 1, 1, 1, 2, 0, 5, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (15, 14, 57, N'F', 0, 1, 1, 1, 1, 0, 5, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (15, 56, 0, N'F', 0, 1, 1, 1, 1, 0, 5, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (15, 15, 68, N'F', 0, 1, 1, 1, 1, 0, 7, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (15, 17, 0, N'F', 0, 1, 1, 1, 1, 0, 7, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (15, 19, 0, N'F', 0, 1, 1, 1, 1, 0, 7, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (15, 21, 0, N'F', 0, 1, 1, 1, 1, 0, 7, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (15, 23, 0, N'F', 0, 1, 1, 1, 1, 0, 7, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (15, 72, 0, N'F', 0, 1, 1, 1, 1, 0, 7, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (15, 9, 76, N'F', 0, 1, 1, 1, 2, 0, 8, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (15, 11, 95, N'D', 2, 1, 1, 1, 2, 0, 8, 0, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (15, 46, 55, N'F', 0, 1, 1, 1, 3, 1, 8, 0, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (15, 48, 39, N'B', 3, 1, 1, 1, 1, 0, 8, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (15, 56, 96, N'D', 2, 1, 1, 1, 2, 0, 8, 0, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (15, 17, 55, N'F', 0, 1, 1, 1, 2, 0, 9, 0, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (15, 85, 31, N'D', 2, 1, 1, 1, 1, 0, 9, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (15, 28, 129, N'A-', 3.67, 1, 1, 1, 1, 0, 10, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (15, 30, 99, N'C', 2.33, 1, 1, 1, 1, 0, 10, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (15, 32, 92, N'A', 4, 1, 1, 1, 1, 0, 10, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (15, 86, 34, N'C', 2.33, 1, 1, 1, 1, 0, 10, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (15, 34, 119, N'B', 3, 1, 1, 1, 1, 0, 10, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (15, 26, 72, N'C+', 2.67, 1, 1, 1, 1, 0, 11, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (15, 33, 182, N'A', 4, 1, 1, 1, 1, 0, 11, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (15, 35, 111, N'C+', 2.67, 1, 1, 1, 1, 0, 11, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (15, 43, 126, N'B+', 3.33, 1, 1, 1, 1, 0, 11, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (15, 6, 96, N'D', 2, 1, 1, 1, 2, 0, 12, 0, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (15, 15, 103, N'D', 2, 1, 1, 1, 2, 0, 13, 0, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (15, 17, 72, N'D', 2, 1, 1, 1, 3, 1, 13, 0, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (15, 19, 99, N'D', 2, 1, 1, 1, 2, 0, 13, 0, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (15, 72, 102, N'D', 2, 1, 1, 1, 2, 0, 13, 0, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (15, 20, 122, N'B+', 3.33, 1, 1, 1, 1, 0, 14, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (15, 24, 66, N'C', 2.33, 1, 1, 1, 1, 0, 14, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (15, 29, 132, N'A-', 3.67, 1, 1, 1, 1, 0, 14, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (15, 31, 101, N'C', 2.33, 1, 1, 1, 1, 0, 14, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (15, 21, 96, N'D', 2, 1, 1, 1, 2, 0, 16, 0, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (15, 23, 74, N'D', 2, 1, 1, 1, 2, 0, 16, 0, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (15, 38, 141, N'A', 4, 1, 1, 1, 1, 0, 16, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (15, 47, 79, N'B', 3, 1, 1, 1, 1, 0, 16, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (15, 7, 87, N'F', 0, 1, 1, 1, 2, 0, 17, 0, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (15, 9, 96, N'D', 2, 1, 1, 1, 3, 1, 17, 0, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (15, 16, 57, N'F', 0, 1, 1, 1, 1, 0, 17, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (15, 22, 93, N'D', 2, 1, 1, 1, 1, 0, 17, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (18, 1, 85, N'F', 0, 1, 1, 1, 1, 0, 1, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (18, 2, 45, N'A', 4, 1, 1, 1, 1, 0, 1, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (18, 50, 32, N'P', 0, 1, 0, 1, 1, 0, 1, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (18, 52, 137, N'C', 2.33, 1, 1, 1, 1, 0, 1, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (18, 83, 143, N'C+', 2.67, 1, 1, 1, 1, 0, 1, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (18, 84, 41, N'B+', 3.33, 1, 1, 1, 1, 0, 1, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (18, 87, 108, N'C+', 2.67, 1, 1, 1, 1, 0, 1, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (18, 3, 114, N'B', 3, 1, 1, 1, 1, 0, 2, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (18, 4, 107, N'C+', 2.67, 1, 1, 1, 1, 0, 2, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (18, 46, 70, N'C+', 2.67, 1, 1, 1, 1, 0, 2, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (18, 51, 32, N'P', 0, 1, 0, 1, 1, 0, 2, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (18, 53, 67, N'F', 0, 1, 1, 1, 1, 0, 2, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (18, 54, 92, N'D', 2, 1, 1, 1, 1, 0, 2, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (18, 53, 57, N'F', 0, 1, 1, 1, 2, 0, 3, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (18, 6, 81, N'F', 0, 1, 1, 1, 1, 0, 4, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (18, 10, 90, N'D', 2, 1, 1, 1, 1, 0, 4, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (18, 12, 128, N'D', 2, 1, 1, 1, 1, 0, 4, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (18, 47, 77, N'B', 3, 1, 1, 1, 1, 0, 4, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (18, 7, 90, N'D', 2, 1, 1, 1, 1, 0, 5, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (18, 9, 116, N'B', 3, 1, 1, 1, 1, 0, 5, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (18, 1, 82, N'F', 0, 1, 1, 1, 2, 0, 6, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (18, 6, 104, N'C', 2.33, 1, 1, 1, 2, 0, 6, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (18, 17, 0, N'F', 0, 1, 1, 1, 1, 0, 7, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (18, 19, 0, N'F', 0, 1, 1, 1, 1, 0, 7, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (18, 21, 82, N'F', 0, 1, 1, 1, 1, 0, 7, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (18, 85, 28, N'F', 0, 1, 1, 1, 1, 0, 7, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (18, 11, 92, N'D', 2, 1, 1, 1, 1, 0, 8, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (18, 13, 94, N'D', 2, 1, 1, 1, 1, 0, 8, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (18, 14, 48, N'F', 0, 1, 1, 1, 1, 0, 8, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (18, 16, 53, N'F', 0, 1, 1, 1, 1, 0, 8, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (18, 27, 53, N'F', 0, 1, 1, 1, 1, 0, 8, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (18, 5, 109, N'C+', 2.67, 1, 1, 1, 1, 0, 9, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (18, 17, 60, N'D', 2, 1, 1, 1, 2, 0, 9, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (18, 85, 40, N'B+', 3.33, 1, 1, 1, 2, 0, 9, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (18, 15, 107, N'C+', 2.67, 1, 1, 1, 1, 0, 10, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (18, 23, 83, N'B+', 3.33, 1, 1, 1, 1, 0, 10, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (18, 28, 125, N'B+', 3.33, 1, 1, 1, 1, 0, 10, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (18, 34, 129, N'A-', 3.67, 1, 1, 1, 1, 0, 10, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (18, 86, 35, N'C+', 2.67, 1, 1, 1, 1, 0, 10, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (18, 18, 76, N'F', 0, 1, 1, 1, 1, 0, 11, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (18, 26, 72, N'C+', 2.67, 1, 1, 1, 1, 0, 11, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (18, 29, 119, N'B', 3, 1, 1, 1, 1, 0, 11, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (18, 31, 129, N'A-', 3.67, 1, 1, 1, 1, 0, 11, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (18, 35, 116, N'B', 3, 1, 1, 1, 1, 0, 11, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (18, 43, 132, N'A-', 3.67, 1, 1, 1, 1, 0, 11, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (18, 14, NULL, N'P', 0, 1, 0, 1, 2, 0, 11, 0, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (18, 53, 96, N'D', 2, 1, 1, 1, 3, 1, 12, 0, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (18, 8, 71, N'C+', 2.67, 1, 1, 1, 1, 0, 13, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (18, 30, 116, N'B', 3, 1, 1, 1, 1, 0, 13, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (18, 32, 80, N'B+', 3.33, 1, 1, 1, 1, 0, 13, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (18, 42, 25, N'F', 0, 1, 1, 1, 1, 0, 13, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (18, 72, 107, N'C+', 2.67, 1, 1, 1, 1, 0, 13, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (18, 19, 85, N'F', 0, 1, 1, 1, 2, 0, 13, 0, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (18, 21, 95, N'D', 2, 1, 1, 1, 2, 0, 13, 0, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (18, 20, 116, N'B', 3, 1, 1, 1, 1, 0, 14, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (18, 22, 73, N'F', 0, 1, 1, 1, 1, 0, 14, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (18, 24, 56, N'F', 0, 1, 1, 1, 1, 0, 14, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (18, 33, 180, N'A', 4, 1, 1, 1, 1, 0, 14, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (18, 56, NULL, N'P', 0, 1, 0, 1, 1, 0, 14, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (18, 18, 107, N'D', 2, 1, 1, 1, 2, 0, 14, 0, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (18, 22, 113, N'D', 2, 1, 1, 1, 2, 0, 15, 0, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (18, 36, 127, N'B+', 3.33, 1, 1, 1, 1, 0, 16, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (18, 38, 133, N'A-', 3.67, 1, 1, 1, 1, 0, 16, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (18, 57, 6, N'F', 0, 1, 1, 1, 1, 0, 16, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (18, 19, 100, N'D', 2, 1, 1, 1, 3, 1, 16, 0, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (18, 48, 49, N'A', 4, 1, 1, 1, 1, 0, 17, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (18, 1, 109, N'D', 2, 1, 1, 1, 3, 1, 17, 0, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (18, 16, 58, N'F', 0, 1, 1, 1, 2, 0, 17, 0, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (18, 24, 70, N'D', 2, 1, 1, 1, 2, 0, 17, 0, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (18, 57, 102, N'D', 2, 1, 1, 1, 2, 0, 17, 0, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (18, 16, 64, N'D', 2, 1, 1, 1, 3, 1, 18, 0, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (17, 1, 94, N'D', 2, 1, 1, 1, 1, 0, 4, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (17, 2, 41, N'B+', 3.33, 1, 1, 1, 1, 0, 4, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (17, 50, 36, N'P', 0, 1, 0, 1, 1, 0, 4, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (17, 52, 120, N'D', 2, 1, 1, 1, 1, 0, 4, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (17, 83, 138, N'C', 2.33, 1, 1, 1, 1, 0, 4, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (17, 84, 32, N'D', 2, 1, 1, 1, 1, 0, 4, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (17, 87, 92, N'D', 2, 1, 1, 1, 1, 0, 4, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (17, 3, 110, N'C+', 2.67, 1, 1, 1, 1, 0, 5, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (17, 4, 90, N'D', 2, 1, 1, 1, 1, 0, 5, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (17, 5, 95, N'D', 2, 1, 1, 1, 1, 0, 5, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (17, 46, 71, N'C+', 2.67, 1, 1, 1, 1, 0, 5, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (17, 51, 40, N'P', 0, 1, 0, 1, 1, 0, 5, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (17, 53, 106, N'C+', 2.67, 1, 1, 1, 1, 0, 5, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (17, 54, 112, N'C+', 2.67, 1, 1, 1, 1, 0, 5, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (17, 6, 85, N'F', 0, 1, 1, 1, 1, 0, 7, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (17, 12, 104, N'F', 0, 1, 1, 1, 1, 0, 7, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (17, 47, 82, N'B+', 3.33, 1, 1, 1, 1, 0, 7, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (17, 57, 70, N'F', 0, 1, 1, 1, 1, 0, 7, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (17, 9, 94, N'D', 2, 1, 1, 1, 1, 0, 8, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (17, 11, 90, N'D', 2, 1, 1, 1, 1, 0, 8, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (17, 13, 90, N'D', 2, 1, 1, 1, 1, 0, 8, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (17, 14, 69, N'C', 2.33, 1, 1, 1, 1, 0, 8, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (17, 12, 176, N'A-', 3.67, 1, 1, 1, 2, 0, 9, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (17, 10, 126, N'B+', 3.33, 1, 1, 1, 1, 0, 9, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (17, 8, 0, N'F', 0, 1, 1, 1, 1, 0, 10, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (17, 15, 74, N'F', 0, 1, 1, 1, 1, 0, 10, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (17, 17, NULL, NULL, NULL, 1, 0, 1, 1, 0, 10, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (17, 19, 72, N'F', 0, 1, 1, 1, 1, 0, 10, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (17, 21, 60, N'F', 0, 1, 1, 1, 1, 0, 10, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (17, 23, 55, N'F', 0, 1, 1, 1, 1, 0, 10, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (17, 72, NULL, NULL, NULL, 1, 0, 1, 1, 0, 10, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (17, 85, 32, N'D', 2, 1, 1, 1, 1, 0, 10, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (17, 43, 118, N'B', 3, 1, 1, 1, 1, 0, 11, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (17, 16, 74, N'C+', 2.67, 1, 1, 1, 1, 0, 11, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (17, 26, 75, N'B', 3, 1, 1, 1, 1, 0, 11, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (17, 48, 0, N'F', 0, 1, 1, 1, 1, 0, 11, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (17, 56, NULL, N'P', 0, 1, 0, 1, 1, 0, 11, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (17, 15, 93, N'D', 2, 1, 1, 1, 2, 0, 13, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (17, 21, 94, N'D', 2, 1, 1, 1, 2, 0, 13, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (17, 19, 71, N'F', 0, 1, 1, 1, 2, 0, 13, 0, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (17, 72, 83, N'F', 0, 1, 1, 1, 2, 0, 13, 0, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (17, 18, 100, N'C', 2.33, 1, 1, 1, 1, 0, 14, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (17, 20, 108, N'C+', 2.67, 1, 1, 1, 1, 0, 14, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (17, 22, 86, N'F', 0, 1, 1, 1, 1, 0, 14, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (17, 24, 80, N'B+', 3.33, 1, 1, 1, 1, 0, 14, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (17, 48, 46, N'A', 4, 1, 1, 1, 2, 0, 14, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (17, 34, 104, N'C', 2.33, 1, 1, 1, 1, 0, 15, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (17, 28, 118, N'B', 3, 1, 1, 1, 1, 0, 16, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (17, 30, 120, N'B+', 3.33, 1, 1, 1, 1, 0, 16, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (17, 32, 86, N'A-', 3.67, 1, 1, 1, 1, 0, 16, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (17, 36, 130, N'A-', 3.67, 1, 1, 1, 1, 0, 16, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (17, 86, 33, N'C', 2.33, 1, 1, 1, 1, 0, 16, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (17, 29, 85, N'F', 0, 1, 1, 1, 1, 0, 17, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (17, 31, 104, N'C', 2.33, 1, 1, 1, 1, 0, 17, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (17, 33, 176, N'A-', 3.67, 1, 1, 1, 1, 0, 17, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (17, 35, 109, N'C+', 2.67, 1, 1, 1, 1, 0, 17, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (17, 19, 126, N'D', 2, 1, 1, 1, 3, 1, 18, 0, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (17, 57, 108, N'D', 2, 1, 1, 1, 2, 0, 18, 0, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (12, 1, 103, N'C', 2.33, 1, 1, 1, 1, 0, 10, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (12, 2, 49, N'A', 4, 1, 1, 1, 1, 0, 10, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (12, 50, 35, N'P', 0, 1, 0, 1, 1, 0, 10, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (12, 52, 120, N'D', 2, 1, 1, 1, 1, 0, 10, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (12, 83, 152, N'B', 3, 1, 1, 1, 1, 0, 10, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (12, 84, 35, N'C+', 2.67, 1, 1, 1, 1, 0, 10, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (12, 87, 132, N'A-', 3.67, 1, 1, 1, 1, 0, 10, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (12, 3, NULL, N'P', 0, 1, 0, 1, 1, 0, 11, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (12, 4, NULL, N'P', 0, 1, 0, 1, 1, 0, 11, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (12, 5, NULL, N'P', 0, 1, 0, 1, 1, 0, 11, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (12, 46, NULL, N'P', 0, 1, 0, 1, 1, 0, 11, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (12, 51, NULL, N'P', 0, 1, 0, 1, 1, 0, 11, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (12, 53, NULL, N'P', 0, 1, 0, 1, 1, 0, 11, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (12, 54, NULL, N'P', 0, 1, 0, 1, 1, 0, 11, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (12, 6, 103, N'C', 2.33, 1, 1, 1, 1, 0, 13, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (12, 8, 68, N'C', 2.33, 1, 1, 1, 1, 0, 13, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (12, 10, 138, N'A', 4, 1, 1, 1, 1, 0, 13, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (12, 12, 132, N'C', 2.33, 1, 1, 1, 1, 0, 13, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (12, 47, 92, N'A', 4, 1, 1, 1, 1, 0, 13, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (12, 57, 103, N'C', 2.33, 1, 1, 1, 1, 0, 13, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (12, 7, 103, N'C', 2.33, 1, 1, 1, 1, 0, 14, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (12, 9, 112, N'C+', 2.67, 1, 1, 1, 1, 0, 14, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (12, 11, 133, N'A-', 3.67, 1, 1, 1, 1, 0, 14, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (12, 13, 125, N'B+', 3.33, 1, 1, 1, 1, 0, 14, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (12, 14, 77, N'B', 3, 1, 1, 1, 1, 0, 14, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (12, 56, 112, N'C+', 2.67, 1, 1, 1, 1, 0, 14, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (12, 15, 103, N'C', 2.33, 1, 1, 1, 1, 0, 16, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (12, 17, 68, N'C', 2.33, 1, 1, 1, 1, 0, 16, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (12, 19, 112, N'C+', 2.67, 1, 1, 1, 1, 0, 16, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (12, 21, 112, N'C+', 2.67, 1, 1, 1, 1, 0, 16, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (12, 23, 77, N'B', 3, 1, 1, 1, 1, 0, 16, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (12, 72, 0, N'F', 0, 1, 1, 1, 1, 0, 16, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (12, 85, 44, N'A-', 3.67, 1, 1, 1, 1, 0, 16, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (12, 16, 68, N'C', 2.33, 1, 1, 1, 1, 0, 17, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (12, 18, 103, N'C', 2.33, 1, 1, 1, 1, 0, 17, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (12, 20, 119, N'B', 3, 1, 1, 1, 1, 0, 17, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (12, 22, 88, N'F', 0, 1, 1, 1, 1, 0, 17, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (12, 24, 60, N'D', 2, 1, 1, 1, 1, 0, 17, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (12, 27, 80, N'B+', 3.33, 1, 1, 1, 1, 0, 17, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (12, 48, 49, N'A', 4, 1, 1, 1, 1, 0, 17, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (12, 31, 149, N'A', 4, 1, 1, 1, 1, 0, 18, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExecuse], [IsEnhancementCourse]) VALUES (12, 22, 119, N'B', 3, 1, 1, 1, 2, 0, 18, 1, NULL, NULL, NULL)
GO
INSERT [dbo].[StudentPrograms] ([ProgramID], [StudentID], [AcademicYear]) VALUES (1, 5, 10)
GO
INSERT [dbo].[StudentPrograms] ([ProgramID], [StudentID], [AcademicYear]) VALUES (2, 5, 11)
GO
INSERT [dbo].[StudentPrograms] ([ProgramID], [StudentID], [AcademicYear]) VALUES (5, 5, 13)
GO
INSERT [dbo].[StudentPrograms] ([ProgramID], [StudentID], [AcademicYear]) VALUES (1, 8, 10)
GO
INSERT [dbo].[StudentPrograms] ([ProgramID], [StudentID], [AcademicYear]) VALUES (2, 8, 11)
GO
INSERT [dbo].[StudentPrograms] ([ProgramID], [StudentID], [AcademicYear]) VALUES (5, 8, 13)
GO
INSERT [dbo].[StudentPrograms] ([ProgramID], [StudentID], [AcademicYear]) VALUES (1, 12, 10)
GO
INSERT [dbo].[StudentPrograms] ([ProgramID], [StudentID], [AcademicYear]) VALUES (2, 12, 11)
GO
INSERT [dbo].[StudentPrograms] ([ProgramID], [StudentID], [AcademicYear]) VALUES (5, 12, 13)
GO
INSERT [dbo].[StudentPrograms] ([ProgramID], [StudentID], [AcademicYear]) VALUES (1, 13, 10)
GO
INSERT [dbo].[StudentPrograms] ([ProgramID], [StudentID], [AcademicYear]) VALUES (2, 13, 11)
GO
INSERT [dbo].[StudentPrograms] ([ProgramID], [StudentID], [AcademicYear]) VALUES (6, 13, 13)
GO
INSERT [dbo].[StudentPrograms] ([ProgramID], [StudentID], [AcademicYear]) VALUES (1, 14, 10)
GO
INSERT [dbo].[StudentPrograms] ([ProgramID], [StudentID], [AcademicYear]) VALUES (3, 14, 11)
GO
INSERT [dbo].[StudentPrograms] ([ProgramID], [StudentID], [AcademicYear]) VALUES (7, 14, 13)
GO
INSERT [dbo].[StudentPrograms] ([ProgramID], [StudentID], [AcademicYear]) VALUES (1, 15, 1)
GO
INSERT [dbo].[StudentPrograms] ([ProgramID], [StudentID], [AcademicYear]) VALUES (2, 15, 2)
GO
INSERT [dbo].[StudentPrograms] ([ProgramID], [StudentID], [AcademicYear]) VALUES (5, 15, 4)
GO
INSERT [dbo].[StudentPrograms] ([ProgramID], [StudentID], [AcademicYear]) VALUES (1, 17, 4)
GO
INSERT [dbo].[StudentPrograms] ([ProgramID], [StudentID], [AcademicYear]) VALUES (2, 17, 5)
GO
INSERT [dbo].[StudentPrograms] ([ProgramID], [StudentID], [AcademicYear]) VALUES (5, 17, 7)
GO
INSERT [dbo].[StudentPrograms] ([ProgramID], [StudentID], [AcademicYear]) VALUES (1, 18, 1)
GO
INSERT [dbo].[StudentPrograms] ([ProgramID], [StudentID], [AcademicYear]) VALUES (2, 18, 2)
GO
INSERT [dbo].[StudentPrograms] ([ProgramID], [StudentID], [AcademicYear]) VALUES (5, 18, 4)
GO
INSERT [dbo].[StudentPrograms] ([ProgramID], [StudentID], [AcademicYear]) VALUES (1, 19, 19)
GO
SET IDENTITY_INSERT [dbo].[Supervisor] ON 
GO
INSERT [dbo].[Supervisor] ([ID], [GUID], [FName], [MName], [LName], [Email], [Password], [IsActive], [CreatedOn], [ProgramID]) VALUES (2, N'A95A4304-E215-46A3-A3C9-3D01F90F0868', N'CS', N'Supervisor', N'1', N'cssuper@sci.asu.edu.eg', N'0FBC1FB9CDE268DF12C8CE7A0CF5847B9D1246F76D994A335EBBE0068D777BF00641A9CF776BEF92DBBC4A9B9389095D7ABAFECF9560BC8BD42FD5AA3564DE8C', 1, CAST(N'2022-11-27T00:00:00.000' AS DateTime), 6)
GO
SET IDENTITY_INSERT [dbo].[Supervisor] OFF
GO
ALTER TABLE [dbo].[Program] ADD  CONSTRAINT [DF_Program_TotalHours]  DEFAULT ((140)) FOR [TotalHours]
GO
ALTER TABLE [dbo].[Student] ADD  CONSTRAINT [DF_Student_SemestersNumberInProgram]  DEFAULT ((0)) FOR [SemestersNumberInProgram]
GO
ALTER TABLE [dbo].[StudentCourses] ADD  CONSTRAINT [DF_StudentCourses_TookFromCredits]  DEFAULT ((0)) FOR [TookFromCredits]
GO
ALTER TABLE [dbo].[StudentCourses] ADD  CONSTRAINT [DF_StudentCourses_HasExecuse]  DEFAULT ((0)) FOR [HasExecuse]
GO
ALTER TABLE [dbo].[CoursePrerequisites]  WITH CHECK ADD  CONSTRAINT [FK_CoursePrerequisites_Course] FOREIGN KEY([CourseID])
REFERENCES [dbo].[Course] ([ID])
GO
ALTER TABLE [dbo].[CoursePrerequisites] CHECK CONSTRAINT [FK_CoursePrerequisites_Course]
GO
ALTER TABLE [dbo].[CoursePrerequisites]  WITH CHECK ADD  CONSTRAINT [FK_CoursePrerequisites_Course1] FOREIGN KEY([PrerequisiteCourseID])
REFERENCES [dbo].[Course] ([ID])
GO
ALTER TABLE [dbo].[CoursePrerequisites] CHECK CONSTRAINT [FK_CoursePrerequisites_Course1]
GO
ALTER TABLE [dbo].[OptionalCourse]  WITH CHECK ADD  CONSTRAINT [FK_OptionalCourse_Program] FOREIGN KEY([ProgramID])
REFERENCES [dbo].[Program] ([ID])
GO
ALTER TABLE [dbo].[OptionalCourse] CHECK CONSTRAINT [FK_OptionalCourse_Program]
GO
ALTER TABLE [dbo].[ProgramCourses]  WITH CHECK ADD  CONSTRAINT [FK_ProgramCourses_Course] FOREIGN KEY([CourseID])
REFERENCES [dbo].[Course] ([ID])
GO
ALTER TABLE [dbo].[ProgramCourses] CHECK CONSTRAINT [FK_ProgramCourses_Course]
GO
ALTER TABLE [dbo].[ProgramCourses]  WITH CHECK ADD  CONSTRAINT [FK_ProgramCourses_Program] FOREIGN KEY([ProgramID])
REFERENCES [dbo].[Program] ([ID])
GO
ALTER TABLE [dbo].[ProgramCourses] CHECK CONSTRAINT [FK_ProgramCourses_Program]
GO
ALTER TABLE [dbo].[ProgramDistribution]  WITH CHECK ADD  CONSTRAINT [FK_ProgramDistribution_Program] FOREIGN KEY([ProgramID])
REFERENCES [dbo].[Program] ([ID])
GO
ALTER TABLE [dbo].[ProgramDistribution] CHECK CONSTRAINT [FK_ProgramDistribution_Program]
GO
ALTER TABLE [dbo].[ProgramRelations]  WITH CHECK ADD  CONSTRAINT [FK_ProgramRelations_Program] FOREIGN KEY([Program])
REFERENCES [dbo].[Program] ([ID])
GO
ALTER TABLE [dbo].[ProgramRelations] CHECK CONSTRAINT [FK_ProgramRelations_Program]
GO
ALTER TABLE [dbo].[ProgramRelations]  WITH CHECK ADD  CONSTRAINT [FK_ProgramRelations_Program1] FOREIGN KEY([SubProgram])
REFERENCES [dbo].[Program] ([ID])
GO
ALTER TABLE [dbo].[ProgramRelations] CHECK CONSTRAINT [FK_ProgramRelations_Program1]
GO
ALTER TABLE [dbo].[Student]  WITH CHECK ADD  CONSTRAINT [FK_Student_Supervisor] FOREIGN KEY([SupervisorID])
REFERENCES [dbo].[Supervisor] ([ID])
GO
ALTER TABLE [dbo].[Student] CHECK CONSTRAINT [FK_Student_Supervisor]
GO
ALTER TABLE [dbo].[StudentCourses]  WITH CHECK ADD  CONSTRAINT [FK_StudentCourses_AcademicYear] FOREIGN KEY([AcademicYearID])
REFERENCES [dbo].[AcademicYear] ([ID])
GO
ALTER TABLE [dbo].[StudentCourses] CHECK CONSTRAINT [FK_StudentCourses_AcademicYear]
GO
ALTER TABLE [dbo].[StudentCourses]  WITH CHECK ADD  CONSTRAINT [FK_StudentCourses_Course] FOREIGN KEY([CourseID])
REFERENCES [dbo].[Course] ([ID])
GO
ALTER TABLE [dbo].[StudentCourses] CHECK CONSTRAINT [FK_StudentCourses_Course]
GO
ALTER TABLE [dbo].[StudentCourses]  WITH CHECK ADD  CONSTRAINT [FK_StudentCourses_Student] FOREIGN KEY([StudentID])
REFERENCES [dbo].[Student] ([ID])
GO
ALTER TABLE [dbo].[StudentCourses] CHECK CONSTRAINT [FK_StudentCourses_Student]
GO
ALTER TABLE [dbo].[StudentDesires]  WITH CHECK ADD  CONSTRAINT [FK_StudentDesires_Program] FOREIGN KEY([ProgramID])
REFERENCES [dbo].[Program] ([ID])
GO
ALTER TABLE [dbo].[StudentDesires] CHECK CONSTRAINT [FK_StudentDesires_Program]
GO
ALTER TABLE [dbo].[StudentDesires]  WITH CHECK ADD  CONSTRAINT [FK_StudentDesires_Student] FOREIGN KEY([StudentID])
REFERENCES [dbo].[Student] ([ID])
GO
ALTER TABLE [dbo].[StudentDesires] CHECK CONSTRAINT [FK_StudentDesires_Student]
GO
ALTER TABLE [dbo].[StudentPrograms]  WITH CHECK ADD  CONSTRAINT [FK_StudentPrograms_AcademicYear] FOREIGN KEY([AcademicYear])
REFERENCES [dbo].[AcademicYear] ([ID])
GO
ALTER TABLE [dbo].[StudentPrograms] CHECK CONSTRAINT [FK_StudentPrograms_AcademicYear]
GO
ALTER TABLE [dbo].[StudentPrograms]  WITH CHECK ADD  CONSTRAINT [FK_StudentPrograms_Program] FOREIGN KEY([ProgramID])
REFERENCES [dbo].[Program] ([ID])
GO
ALTER TABLE [dbo].[StudentPrograms] CHECK CONSTRAINT [FK_StudentPrograms_Program]
GO
ALTER TABLE [dbo].[StudentPrograms]  WITH CHECK ADD  CONSTRAINT [FK_StudentPrograms_Student] FOREIGN KEY([StudentID])
REFERENCES [dbo].[Student] ([ID])
GO
ALTER TABLE [dbo].[StudentPrograms] CHECK CONSTRAINT [FK_StudentPrograms_Student]
GO
ALTER TABLE [dbo].[SuperAdmin]  WITH CHECK ADD  CONSTRAINT [FK_SuperAdmin_Program] FOREIGN KEY([ProgramID])
REFERENCES [dbo].[Program] ([ID])
GO
ALTER TABLE [dbo].[SuperAdmin] CHECK CONSTRAINT [FK_SuperAdmin_Program]
GO
ALTER TABLE [dbo].[Supervisor]  WITH CHECK ADD  CONSTRAINT [FK_Supervisor_Program] FOREIGN KEY([ProgramID])
REFERENCES [dbo].[Program] ([ID])
GO
ALTER TABLE [dbo].[Supervisor] CHECK CONSTRAINT [FK_Supervisor_Program]
GO
ALTER TABLE [dbo].[TeacherCourses]  WITH CHECK ADD  CONSTRAINT [FK_TeacherCourses_AcademicYear] FOREIGN KEY([AcademicYearID])
REFERENCES [dbo].[AcademicYear] ([ID])
GO
ALTER TABLE [dbo].[TeacherCourses] CHECK CONSTRAINT [FK_TeacherCourses_AcademicYear]
GO
ALTER TABLE [dbo].[TeacherCourses]  WITH CHECK ADD  CONSTRAINT [FK_TeacherCourses_Course] FOREIGN KEY([CourseID])
REFERENCES [dbo].[Course] ([ID])
GO
ALTER TABLE [dbo].[TeacherCourses] CHECK CONSTRAINT [FK_TeacherCourses_Course]
GO
ALTER TABLE [dbo].[TeacherCourses]  WITH CHECK ADD  CONSTRAINT [FK_TeacherCourses_Supervisor] FOREIGN KEY([SupervisorID])
REFERENCES [dbo].[Supervisor] ([ID])
GO
ALTER TABLE [dbo].[TeacherCourses] CHECK CONSTRAINT [FK_TeacherCourses_Supervisor]
GO
/****** Object:  StoredProcedure [dbo].[AddStudentDesires]    Script Date: 2023-01-30 7:09:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[AddStudentDesires]
@Desires StudentDesiresType READONLY,
@StudentID INT
AS 
BEGIN
	BEGIN TRANSACTION
	BEGIN TRY
	DELETE FROM [dbo].[StudentDesires]
	WHERE [StudentID] = @StudentID;

		INSERT INTO [dbo].[StudentDesires]
			([ProgramID], [StudentID], [DesireNumber])
		SELECT [ProgramID], @StudentID, [DesireNumber] FROM @Desires;
	END TRY
	BEGIN CATCH
		IF @@ERROR <> 0
			ROLLBACK;
	END CATCH
	COMMIT;
END
GO
/****** Object:  StoredProcedure [dbo].[AddStudentsToPrograms]    Script Date: 2023-01-30 7:09:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[AddStudentsToPrograms]
@StudentProgram StudentsProgramsType READONLY
AS 
BEGIN
	BEGIN TRANSACTION
	BEGIN TRY
	
		INSERT INTO [dbo].StudentPrograms
			([ProgramID], [StudentID], [AcademicYear])
		SELECT [ProgramID], [StudentID], [AcademicYearID] FROM @StudentProgram;
	END TRY
	BEGIN CATCH
		IF @@ERROR <> 0
			ROLLBACK;
	END CATCH
	COMMIT;
END
GO
/****** Object:  StoredProcedure [dbo].[BackUpDatabase]    Script Date: 2023-01-30 7:09:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[BackUpDatabase]
@DBName nvarchar(MAX),
@Path nvarchar(MAX)
AS
BEGIN
BACKUP DATABASE @DBName TO DISK = @Path;
END
GO
/****** Object:  StoredProcedure [dbo].[GetAvailableCoursesToRegister]    Script Date: 2023-01-30 7:09:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetAvailableCoursesToRegister]
@StudentID int
AS
BEGIN
DECLARE @StudentLevel int = [dbo].[CalculateStudentLevel](@StudentID); 
DECLARE @StudentProgram int = [dbo].[GetStudentProgram](@StudentID);
	SELECT pc.*,c.*
	FROM Course c,ProgramCourses pc
	WHERE c.ID = pc.CourseID 
		AND pc.ProgramID = @StudentProgram
		AND c.ID NOT IN(SELECT sc.CourseID FROM StudentCourses sc WHERE sc.Grade <> 'F' AND StudentID =@StudentID)
		AND [dbo].GetPrequisteNumber(@StudentID,c.ID) = (SELECT COUNT(cp.CourseID) FROM CoursePrerequisites cp WHERE cp.CourseID =  c.id)
		AND (c.[Level] = @StudentLevel OR c.[Level] = @StudentLevel + 1)
		AND c.IsActive = 1
		AND (pc.CourseType = 1 OR [dbo].[CanRegisterThisCourse](@StudentProgram,@StudentID,c.Level,c.Semester,pc.CourseType,pc.Category,c.CreditHours) = 1)
	UNION
	SELECT pc.*,c.*
	FROM StudentCourses sc JOIN Course c ON c.ID = sc.CourseID JOIN ProgramCourses pc ON sc.CourseID = pc.CourseID
	WHERE sc.Grade ='F' AND
		StudentID = @StudentID AND
		sc.CourseID NOT IN(SELECT sc.CourseID FROM StudentCourses sc WHERE sc.Grade <> 'F' AND StudentID =@StudentID)
END
GO
/****** Object:  StoredProcedure [dbo].[GetCoursesListExceptPassed]    Script Date: 2023-01-30 7:09:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetCoursesListExceptPassed]
--Retrives list of courses that student can register
@StudentID int
AS
BEGIN
SELECT c.ID
FROM Course c,ProgramCourses pc,CoursePrerequisites cp
WHERE c.ID = pc.CourseID AND cp.CourseID = c.ID
AND pc.ProgramID = [dbo].[GetStudentProgram](@StudentID)
AND c.ID NOT IN(SELECT sc.CourseID FROM StudentCourses sc WHERE sc.Grade <> 'F' AND StudentID = @StudentID)
UNION
SELECT sc.CourseID FROM StudentCourses sc 
WHERE sc.Grade ='F' AND
StudentID =@StudentID AND
sc.CourseID NOT IN(SELECT sc.CourseID FROM StudentCourses sc WHERE sc.Grade <> 'F' AND StudentID = @StudentID)
END
GO
/****** Object:  StoredProcedure [dbo].[GetFailedCoursesList]    Script Date: 2023-01-30 7:09:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetFailedCoursesList]
--Retrives list of courses that student got F and haven't pass it yet
@StudentID int
AS
BEGIN
SELECT sc.CourseID FROM StudentCourses sc 
WHERE sc.Grade ='F' AND
StudentID = @StudentID AND
sc.CourseID NOT IN(SELECT sc.CourseID FROM StudentCourses sc WHERE sc.Grade <> 'F' AND StudentID =@StudentID)
END
GO
/****** Object:  StoredProcedure [dbo].[GetPassedCoursesList]    Script Date: 2023-01-30 7:09:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetPassedCoursesList]
@StudentID int
AS
BEGIN
SELECT sc.CourseID FROM StudentCourses sc WHERE sc.Grade <> 'F' AND StudentID = @StudentID
END
GO
/****** Object:  StoredProcedure [dbo].[RegisterCoursesForStudent]    Script Date: 2023-01-30 7:09:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[RegisterCoursesForStudent]
@StudentID INT,
@CourseIDs StudentRegistrationCoursesType READONLY,
@CurrentAcademicYearID TINYINT
AS 
BEGIN
	BEGIN TRANSACTION
	BEGIN TRY
	DELETE FROM [dbo].StudentCourses
	WHERE [StudentID] = @StudentID AND IsApproved = 0 AND AcademicYearID = @CurrentAcademicYearID;

		INSERT INTO [dbo].StudentCourses
			([StudentID], CourseID,AcademicYearID,IsApproved,IsGPAIncluded,IsIncluded)
		SELECT @StudentID, [CourseID],@CurrentAcademicYearID,1,1,1 FROM @CourseIDs;
	END TRY
	BEGIN CATCH
		IF @@ERROR <> 0
			ROLLBACK;
	END CATCH
	COMMIT;
END
GO
/****** Object:  StoredProcedure [dbo].[SP_StudentLogin]    Script Date: 2023-01-30 7:09:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_StudentLogin]
@Email nvarchar(MAX),
@Password nvarchar(MAX)
AS
BEGIN
SELECT * FROM Student WHERE Email = @Email AND Password = @Password;
END
GO
/****** Object:  Trigger [dbo].[IncreaseNumberOfSemestersInProgramForStudent]    Script Date: 2023-01-30 7:09:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[IncreaseNumberOfSemestersInProgramForStudent]
ON [dbo].[AcademicYear]
AFTER INSERT
AS
SET NOCOUNT ON;
BEGIN
	DECLARE @Semester tinyint
	SELECT @Semester = inserted.Semester
	FROM inserted;
	--Trigger to Increase counter for number of semesters in a program for student
	--number of semesters will be used for bifurcation
	IF @Semester <> 3
	BEGIN
		UPDATE Student SET SemestersNumberInProgram = SemestersNumberInProgram + 1 WHERE IsGraduated =0;
	END
END
GO
ALTER TABLE [dbo].[AcademicYear] ENABLE TRIGGER [IncreaseNumberOfSemestersInProgramForStudent]
GO
/****** Object:  Trigger [dbo].[SetActiveCoursesBySemester]    Script Date: 2023-01-30 7:09:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[SetActiveCoursesBySemester]
ON [dbo].[AcademicYear]
AFTER INSERT
AS
SET NOCOUNT ON;
BEGIN
	DECLARE @Semester tinyint
	SELECT @Semester = inserted.Semester
	FROM inserted;
	--Trigger to Activate course by semester (summer courses will be activated manualy)
	IF @Semester <> 3
		BEGIN
			UPDATE Course SET IsActive = 1 WHERE Semester = @Semester;
			UPDATE Course SET IsActive = 0 WHERE Semester <> @Semester;
		END
	ELSE
		BEGIN
			UPDATE Course SET IsActive = 0;
		END
END
GO
ALTER TABLE [dbo].[AcademicYear] ENABLE TRIGGER [SetActiveCoursesBySemester]
GO
/****** Object:  Trigger [dbo].[CalculateProgramTotalHours]    Script Date: 2023-01-30 7:09:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[CalculateProgramTotalHours]
ON [dbo].[ProgramDistribution]
AFTER INSERT,UPDATE
AS
SET NOCOUNT ON;
BEGIN
DECLARE 	
@TotalHours tinyint,
@ProgramID int

SELECT @ProgramID = inserted.ProgramID
FROM inserted;

SELECT @TotalHours = SUM(NumberOfHours)
FROM ProgramDistribution
WHERE ProgramID = @ProgramID;

UPDATE Program 
SET TotalHours = @TotalHours
WHERE ID = @ProgramID;

END
GO
ALTER TABLE [dbo].[ProgramDistribution] ENABLE TRIGGER [CalculateProgramTotalHours]
GO
/****** Object:  Trigger [dbo].[CalculateProgramTotalHoursIfAnyDeleted]    Script Date: 2023-01-30 7:09:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[CalculateProgramTotalHoursIfAnyDeleted]
ON [dbo].[ProgramDistribution]
AFTER DELETE
AS
SET NOCOUNT ON;
BEGIN
DECLARE 	
@TotalHours tinyint,
@ProgramID int

SELECT @ProgramID = deleted.ProgramID
FROM deleted;

SELECT @TotalHours = SUM(NumberOfHours)
FROM ProgramDistribution
WHERE ProgramID = @ProgramID;

UPDATE Program 
SET TotalHours = @TotalHours
WHERE ID = @ProgramID;

END
GO
ALTER TABLE [dbo].[ProgramDistribution] ENABLE TRIGGER [CalculateProgramTotalHoursIfAnyDeleted]
GO
/****** Object:  Trigger [dbo].[EntringStudentCourse]    Script Date: 2023-01-30 7:09:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
This trigger is used to calculate
courseEntringNumber, avaiable credits for student, AffectCourseReEntring,
Points, Grade depening on entered Mark
*/
CREATE TRIGGER [dbo].[EntringStudentCourse]
ON [dbo].[StudentCourses]
AFTER INSERT
AS
SET NOCOUNT ON;
BEGIN
	DECLARE
	@StudentID int,
	@StudentProgramTotalHours int,
	@StudentPassedHours int,
	@StudentCGPA decimal(5,4),
	@CourseID int,
	@AcademicYearID int,
	@CreditHours int,
	@CourseEntringNo int,
	@IsGpaIncluded int = 1,
	@Mark int,
	@AvailableCredits int,
	@WillTakeFullCredit bit=1,
	@Points float,
	@Grade nvarchar(2),
	@AffectCourseReEntring bit,
	@TookFromCredits bit =0,
	@HasExecuse bit = 0,
	@IsEnhancementCourse bit = 0
	SELECT @StudentID= INSERTED.StudentID,
	@AcademicYearID = INSERTED.AcademicYearID,
	@IsGpaIncluded = INSERTED.IsGPAIncluded,
	@CourseID= INSERTED.CourseID,
	@Mark =INSERTED.Mark,
	@Points =inserted.points,
	@Grade = inserted.Grade,
	@HasExecuse =inserted.HasExecuse
	FROM INSERTED;

			SELECT @StudentProgramTotalHours =TotalHours FROM Program WHERE ID = [dbo].[GetStudentProgram](@StudentID);
			SELECT @StudentCGPA = CGPA,@StudentPassedHours =PassedHours FROM Student WHERE ID = @StudentID;

			IF(@StudentCGPA <= 2.0 AND @StudentPassedHours >= @StudentProgramTotalHours)
				BEGIN
					SET @IsEnhancementCourse = 1;
				END

			IF @HasExecuse IS NULL
				BEGIN
					SET @HasExecuse=0;
				END
			--Get Course CreditHours
			SELECT @CreditHours=CreditHours 
			FROM Course
			WHERE id=@CourseID;

			--Calculate number of Course entring times
			SELECT @CourseEntringNo=Count(courseID)+1
			FROM StudentCourses 
			WHERE StudentID=@StudentID AND CourseID=@CourseID AND @HasExecuse <> 1 AND AcademicYearID <> @AcademicYearID;
	
			--If it's not the first time to enter the course
			--it will take from student available credits
	
			IF(@CourseEntringNo > 1)
			BEGIN
				SELECT @AvailableCredits = AvailableCredits FROM Student WHERE ID = @StudentID;
				IF (@AvailableCredits - @CreditHours >=0) -- course credits must be greater than or equal available credits
					BEGIN
						UPDATE Student WITH (TABLOCK) SET AvailableCredits = AvailableCredits - @CreditHours WHERE ID =@StudentID;
						SET @WillTakeFullCredit = 1;
						SET @TookFromCredits = 1; --just an attribute to give back credits in case the student deleted the course
					END
				ELSE
					BEGIN 
						IF @IsEnhancementCourse =1
							BEGIN
								SET @WillTakeFullCredit = 1;
							END
						ELSE
							BEGIN
								SET @WillTakeFullCredit = 0; -- to set course grade to D and points to 2 in case he passed
							END
					END
			END

			-- if it's the 3rd time or more Grade will be D even there's available credits
			IF(@CourseEntringNo >2)
				BEGIN
					SET @AffectCourseReEntring =1;
				END
			ELSE
				BEGIN
					SET @AffectCourseReEntring =0;
				END
			--if it's enhancement chance, student will take full points
			IF @IsEnhancementCourse = 1
				BEGIN
					SET @AffectCourseReEntring =0;
				END

			DECLARE @MarkPer float;
			--Calculate Grade and Points
			--In case it's the first time to enter a course or in 12 hours limit or enhancement chance
			IF(@Mark IS NOT NULL AND @CreditHours <> 0 AND @AffectCourseReEntring = 0  AND @WillTakeFullCredit = 1)
			BEGIN
				SET @MarkPer = (@Mark * 100.0) / (@CreditHours * 50.0);
				IF @MarkPer >=90.0
					BEGIN
						SET @Grade = 'A';
						SET @Points =4.0;
					END
				ELSE IF @MarkPer >=85.0
					BEGIN
						SET @Grade = 'A-';
						SET @Points =3.67;
					END
				ELSE IF @MarkPer >=80.0
					BEGIN
						SET @Grade = 'B+';
						SET @Points =3.33;
					END
				ELSE IF @MarkPer >=75.0
					BEGIN
						SET @Grade = 'B';
						SET @Points =3.0;
					END
				ELSE IF @MarkPer >=70.0
					BEGIN
						SET @Grade = 'C+';
						SET @Points =2.67;
					END
				ELSE IF @MarkPer >=65.0
					BEGIN
						SET @Grade = 'C';
						SET @Points =2.33;
					END
				ELSE IF @MarkPer >=60.0
					BEGIN
						SET @Grade = 'D';
						SET @Points =2.0;
					END
				ELSE
					BEGIN
						SET @Grade = 'F';
						SET @Points =0.0;
					END
			END
			--in case it's not the first time or not in 12 hour limit
			ELSE IF(@Mark IS NOT NULL AND @CreditHours <> 0 AND (@AffectCourseReEntring = 1 OR @WillTakeFullCredit = 0))
			BEGIN
			SET @MarkPer = (@Mark * 100.0) / (@CreditHours * 50.0);
				IF @MarkPer >=60.0
					BEGIN
						SET @Grade = 'D';
						SET @Points =2.0;
					END
				ELSE
					BEGIN
						SET @Grade = 'F';
						SET @Points =0.0;
					END
			END
			-- in case it's Human rights Or Introduction to computer course
			ELSE IF (@Mark IS NOT NULL AND @CreditHours = 0)
			BEGIN
				SET @MarkPer = (@Mark * 100) /50.0;
				IF @MarkPer >=60.0
					BEGIN
						SET @Grade = 'P';
						SET @Points =0.0;
					END
				ELSE
					BEGIN
						SET @Grade = 'F';
						SET @Points =0.0;
					END
			END
	
			--to execulde Human rights and Introduction to computer from begin caculated in GPA
			IF @IsGpaIncluded = 1 AND @CreditHours =0
			BEGIN
				SET @IsGpaIncluded = 0
			END
			--to execulde Research term (2019/2020 2nd term) Courses form beign calaulated in GPA
			IF @Grade = 'P'
			BEGIN
				SET @IsGpaIncluded =0;
			END

			UPDATE StudentCourses WITH (TABLOCK)
			SET CourseEntringNumber =@CourseEntringNo,
			AffectReEntringCourses = @AffectCourseReEntring,
			IsGPAIncluded =@IsGpaIncluded,
			Grade=@Grade,
			Points = @Points,
			WillTakeFullCredit =@WillTakeFullCredit,
			TookFromCredits = @TookFromCredits,
			HasExecuse = @HasExecuse,
			IsEnhancementCourse =@IsEnhancementCourse
			WHERE StudentID=@StudentID AND CourseID =@CourseID AND AcademicYearID = @AcademicYearID;
END
GO
ALTER TABLE [dbo].[StudentCourses] ENABLE TRIGGER [EntringStudentCourse]
GO
/****** Object:  Trigger [dbo].[GiveBackCredits]    Script Date: 2023-01-30 7:09:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[GiveBackCredits]
ON [dbo].[StudentCourses]
AFTER DELETE
AS
BEGIN
	DECLARE
	@StudentID int,
	@CourseID int,
	@CreditHours tinyint,
	@CourseEntringNo int,
	@IsGpaIncluded bit,
	@IsIncluded bit,
	@AcademicYearID tinyint,
	@AffectCourseReEntring bit,
	@TookFromCredits bit
	-- Get deleted record
	SELECT 
	@StudentID= DELETED.StudentID,
	@IsGpaIncluded = DELETED.IsGPAIncluded,
	@CourseID= DELETED.CourseID,
	@IsIncluded=DELETED.IsIncluded,
	@AcademicYearID =DELETED.AcademicYearID,
	@TookFromCredits = DELETED.TookFromCredits
	FROM DELETED;

	--Get Course CreditHours to add it back
	SELECT @CreditHours=CreditHours 
	FROM Course
	WHERE id=@CourseID;

	--Check if deleted course took from avaible credits or not
	IF(@TookFromCredits = 1)
	BEGIN
		UPDATE Student SET AvailableCredits = AvailableCredits + @CreditHours WHERE ID = @StudentID;
	END
END
GO
ALTER TABLE [dbo].[StudentCourses] ENABLE TRIGGER [GiveBackCredits]
GO
/****** Object:  Trigger [dbo].[UpdateStudentCourse]    Script Date: 2023-01-30 7:09:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[UpdateStudentCourse]
ON [dbo].[StudentCourses]
AFTER UPDATE
AS
SET NOCOUNT ON;
BEGIN
	DECLARE
	@StudentID int,
	@CourseID int,
	@AcademicYearID int,
	@CreditHours int,
	@CourseEntringNo int,
	@IsGpaIncluded int,
	@Mark int,
	@AvailableCredits int,
	@WillTakeFullCredit bit=1,
	@Points float,
	@Grade nvarchar(2),
	@AffectCourseReEntring bit,
	@TookFromCredits bit,
	@HasExecuse bit
	SELECT @StudentID= INSERTED.StudentID,
	@AcademicYearID = INSERTED.AcademicYearID,
	@IsGpaIncluded = INSERTED.IsGPAIncluded,
	@CourseID= INSERTED.CourseID,
	@Mark =INSERTED.Mark,
	@Points =INSERTED.points,
	@Grade = INSERTED.Grade,
	@AffectCourseReEntring =INSERTED.AffectReEntringCourses,
	@WillTakeFullCredit = INSERTED.WillTakeFullCredit,
	@TookFromCredits = INSERTED.TookFromCredits,
	@HasExecuse =INSERTED.HasExecuse
	FROM INSERTED;

			SELECT @CreditHours=CreditHours 
			FROM Course
			WHERE id=@CourseID;		

			IF (@TookFromCredits = 1 AND @HasExecuse =1)
				BEGIN 
					UPDATE Student SET AvailableCredits = AvailableCredits + @CreditHours WHERE ID= @StudentID;
					SET @TookFromCredits = 0;
				END
			ELSE
				BEGIN
					DECLARE @MarkPer float;
					IF(@Mark IS NOT NULL AND @CreditHours <> 0 AND @AffectCourseReEntring = 0  AND @WillTakeFullCredit = 1)
					BEGIN
						SET @MarkPer = (@Mark * 100.0) / (@CreditHours * 50.0);
						IF @MarkPer >=90.0
						BEGIN
							SET @Grade = 'A';
							SET @Points =4.0;
						END
						ELSE IF @MarkPer >=85.0
						BEGIN
							SET @Grade = 'A-';
							SET @Points =3.67;
						END
						ELSE IF @MarkPer >=80.0
						BEGIN
							SET @Grade = 'B+';
							SET @Points =3.33;
						END
						ELSE IF @MarkPer >=75.0
						BEGIN
							SET @Grade = 'B';
							SET @Points =3.0;
						END
						ELSE IF @MarkPer >=70.0
						BEGIN
							SET @Grade = 'C+';
							SET @Points =2.67;
						END
						ELSE IF @MarkPer >=65.0
						BEGIN
							SET @Grade = 'C';
							SET @Points =2.33;
						END
						ELSE IF @MarkPer >=60.0
						BEGIN
							SET @Grade = 'D';
							SET @Points =2.0;
						END
						ELSE
						BEGIN
							SET @Grade = 'F';
							SET @Points =0.0;
						END
					END
					ELSE IF(@Mark IS NOT NULL AND @CreditHours <> 0 AND (@AffectCourseReEntring = 1 OR @WillTakeFullCredit = 0))
					BEGIN
					SET @MarkPer = (@Mark * 100.0) / (@CreditHours * 50.0);
						IF @MarkPer >=60.0
							BEGIN
								SET @Grade = 'D';
								SET @Points =2.0;
							END
						ELSE
							BEGIN
								SET @Grade = 'F';
								SET @Points =0.0;
							END
					END
					ELSE IF (@Mark IS NOT NULL AND @CreditHours = 0)
					BEGIN
						SET @MarkPer = (@Mark * 100) /50.0;
						IF @MarkPer >=60.0
							BEGIN
								SET @Grade = 'P';
								SET @Points =0.0;
							END
						ELSE
							BEGIN
								SET @Grade = 'F';
								SET @Points =0.0;
							END
					END
					ELSE IF (@Mark IS NULL)
						BEGIN
							SET @Grade = NULL;
							SET @Points = NULL;
						END
					IF @Grade = 'P'
					BEGIN
						SET @IsGpaIncluded =0;
					END
			END
			UPDATE StudentCourses WITH (TABLOCK)
			SET
			Mark =@Mark,
			Grade=@Grade,
			Points = @Points,
			TookFromCredits = @TookFromCredits
			WHERE StudentID=@StudentID AND CourseID =@CourseID AND AcademicYearID = @AcademicYearID;
END
GO
ALTER TABLE [dbo].[StudentCourses] ENABLE TRIGGER [UpdateStudentCourse]
GO
USE [master]
GO
ALTER DATABASE [FOS] SET  READ_WRITE 
GO
