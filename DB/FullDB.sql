USE [master]
GO
/****** Object:  Database [FOS]    Script Date: 2023-03-31 10:44:14 PM ******/
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
ALTER DATABASE [FOS] SET  DISABLE_BROKER 
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
/****** Object:  UserDefinedTableType [dbo].[CommonQuestionsType]    Script Date: 2023-03-31 10:44:14 PM ******/
CREATE TYPE [dbo].[CommonQuestionsType] AS TABLE(
	[Question] [nvarchar](max) NULL,
	[Answer] [nvarchar](max) NULL
)
GO
/****** Object:  UserDefinedTableType [dbo].[CourseType]    Script Date: 2023-03-31 10:44:14 PM ******/
CREATE TYPE [dbo].[CourseType] AS TABLE(
	[CourseCode] [nvarchar](max) NULL,
	[CourseName] [nvarchar](max) NULL,
	[CreditHours] [tinyint] NULL,
	[LectureHours] [tinyint] NULL,
	[LabHours] [tinyint] NULL,
	[SectionHours] [tinyint] NULL,
	[IsActive] [bit] NULL,
	[Level] [tinyint] NULL,
	[Semester] [tinyint] NULL
)
GO
/****** Object:  UserDefinedTableType [dbo].[DoctorsGuidType]    Script Date: 2023-03-31 10:44:14 PM ******/
CREATE TYPE [dbo].[DoctorsGuidType] AS TABLE(
	[DoctorGuid] [nvarchar](max) NULL
)
GO
/****** Object:  UserDefinedTableType [dbo].[ElectiveCourseDistributionType]    Script Date: 2023-03-31 10:44:14 PM ******/
CREATE TYPE [dbo].[ElectiveCourseDistributionType] AS TABLE(
	[Level] [tinyint] NULL,
	[Semester] [tinyint] NULL,
	[CourseType] [tinyint] NULL,
	[Category] [tinyint] NULL,
	[Hour] [tinyint] NULL
)
GO
/****** Object:  UserDefinedTableType [dbo].[PrerequisiteCoursesType]    Script Date: 2023-03-31 10:44:14 PM ******/
CREATE TYPE [dbo].[PrerequisiteCoursesType] AS TABLE(
	[CourseID] [int] NULL,
	[PrerequisiteCourseID] [int] NULL
)
GO
/****** Object:  UserDefinedTableType [dbo].[ProgramCoursesType]    Script Date: 2023-03-31 10:44:14 PM ******/
CREATE TYPE [dbo].[ProgramCoursesType] AS TABLE(
	[CourseID] [int] NULL,
	[PrerequisiteRelationID] [tinyint] NULL,
	[CourseType] [tinyint] NULL,
	[Category] [tinyint] NULL
)
GO
/****** Object:  UserDefinedTableType [dbo].[ProgramDistributionType]    Script Date: 2023-03-31 10:44:14 PM ******/
CREATE TYPE [dbo].[ProgramDistributionType] AS TABLE(
	[Level] [tinyint] NULL,
	[Semester] [tinyint] NULL,
	[NumberOfHours] [tinyint] NULL
)
GO
/****** Object:  UserDefinedTableType [dbo].[StudentDesiresType]    Script Date: 2023-03-31 10:44:14 PM ******/
CREATE TYPE [dbo].[StudentDesiresType] AS TABLE(
	[ProgramID] [int] NULL,
	[DesireNumber] [tinyint] NULL
)
GO
/****** Object:  UserDefinedTableType [dbo].[StudentRegistrationCoursesType]    Script Date: 2023-03-31 10:44:14 PM ******/
CREATE TYPE [dbo].[StudentRegistrationCoursesType] AS TABLE(
	[CourseID] [int] NULL
)
GO
/****** Object:  UserDefinedTableType [dbo].[StudentsProgramsType]    Script Date: 2023-03-31 10:44:14 PM ******/
CREATE TYPE [dbo].[StudentsProgramsType] AS TABLE(
	[ProgramID] [int] NOT NULL,
	[StudentID] [int] NOT NULL,
	[AcademicYearID] [smallint] NOT NULL
)
GO
/****** Object:  UserDefinedFunction [dbo].[CalculateCGPA]    Script Date: 2023-03-31 10:44:14 PM ******/
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
		 sc.HasWithdrawn = 0 AND
		 sc.StudentID=@StudentID
		 RETURN @CGPA;
     END;
GO
/****** Object:  UserDefinedFunction [dbo].[CalculatePassedHours]    Script Date: 2023-03-31 10:44:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[CalculatePassedHours] (@StudentID INT)
RETURNS TINYINT
AS
BEGIN
	DECLARE @PassedHours TINYINT = 0;
	Select @PassedHours = SUM(c.CreditHours)
	FROM studentCourses sc,Course c
	WHERE 
		c.ID = sc.CourseID AND
		sc.IsIncluded =1 AND
		sc.Grade IS NOT NULL AND
		sc.HasWithdrawn = 0 AND
		sc.Grade <> 'F' AND
		sc.StudentID=@StudentID
	IF @PassedHours IS NOT NULL 
		RETURN @PassedHours;
	RETURN 0;
END;
GO
/****** Object:  UserDefinedFunction [dbo].[CalculateSGPA]    Script Date: 2023-03-31 10:44:14 PM ******/
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
			WHERE StudentID =@StudentID AND
			AcademicYearID =@AcademicYearID AND
			sc.IsIncluded =1 AND
			sc.IsGPAIncluded = 1 AND
			sc.HasWithdrawn = 0 AND
			sc.HasExcuse = 0
			group by AcademicYearid
			Order by AcademicYearID
		 RETURN @GPA;
     END;
GO
/****** Object:  UserDefinedFunction [dbo].[CalculateStudentLevel]    Script Date: 2023-03-31 10:44:14 PM ******/
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
	DECLARE @StudentProgram INT = [dbo].[GetStudentProgram](@StudentID);
	
	DECLARE @Level TINYINT;
	DECLARE @StudentLevel TINYINT = 1;
	DECLARE @Continue BIT = 1;
	
	DECLARE Level_Cursor CURSOR FOR  
		SELECT DISTINCT(LEVEL) FROM ProgramDistribution
			WHERE ProgramID = @StudentProgram
			ORDER by Level desc
	OPEN Level_Cursor;  
	FETCH NEXT FROM Level_Cursor INTO @Level;
		WHILE @@FETCH_STATUS = 0 AND @Continue = 1
			BEGIN
				IF @PassedHours >=(SELECT SUM(NumberOfHours) FROM ProgramDistribution WHERE ProgramID = @StudentProgram AND Level < @Level)
				BEGIN
					SET @StudentLevel = @Level;
					SET @Continue = 0;
				END
				FETCH NEXT FROM Level_Cursor INTO @Level;
			END;  
		CLOSE Level_Cursor;  
	DEALLOCATE Level_Cursor;

	RETURN @StudentLevel
END;
GO
/****** Object:  UserDefinedFunction [dbo].[CanRegisterThisCourse]    Script Date: 2023-03-31 10:44:14 PM ******/
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
SELECT @Hours = Hour FROM ElectiveCourseDistribution
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
/****** Object:  UserDefinedFunction [dbo].[CheckIfPassedCourse]    Script Date: 2023-03-31 10:44:14 PM ******/
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
/****** Object:  UserDefinedFunction [dbo].[CountRegistrationTimes]    Script Date: 2023-03-31 10:44:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[CountRegistrationTimes](@StudentID INT,@CourseID INT)
RETURNS TINYINT
AS
BEGIN
	DECLARE @RegCounter INT;
	SELECT @RegCounter = COUNT(CourseID) 
	FROM StudentCourses 
	WHERE StudentID = @StudentID AND CourseID = @CourseID
	
	IF @RegCounter IS NULL
		BEGIN
			RETURN 0;
		END
	RETURN @RegCounter;
END
GO
/****** Object:  UserDefinedFunction [dbo].[GetCurrentYearID]    Script Date: 2023-03-31 10:44:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[GetCurrentYearID]()
RETURNS SMALLINT
AS
BEGIN
	DECLARE @ID SMALLINT;
	SELECT @ID =MAX(ID) FROM AcademicYear;
	RETURN @ID;
END
GO
/****** Object:  UserDefinedFunction [dbo].[GetDoctorIDFromGuid]    Script Date: 2023-03-31 10:44:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE FUNCTION [dbo].[GetDoctorIDFromGuid](@GUID NVARCHAR(MAX))
RETURNS INT
AS
BEGIN
	DECLARE @ID INT
	SELECT @ID = ID FROM Doctor 
		WHERE GUID = @GUID
	IF @ID IS NULL
		RETURN -1;
	RETURN @ID;
END
GO
/****** Object:  UserDefinedFunction [dbo].[GetLastRegularSemesterGpa]    Script Date: 2023-03-31 10:44:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[GetLastRegularSemesterGpa](@StudentID INT)
RETURNS FLOAT
AS
BEGIN
	DECLARE @Semester TINYINT,
	@AcademicYearID SMALLINT;
	
	SELECT @Semester = Semester 
	FROM AcademicYear 
	WHERE ID = [dbo].[GetCurrentYearID]();

	IF(@Semester = 1 OR @Semester = 3)
		BEGIN
			SELECT @AcademicYearID = ID 
			FROM AcademicYear 
			WHERE ID = (SELECT MAX(ID) FROM AcademicYear WHERE Semester = 2)
		END
	ELSE
		BEGIN
			SELECT @AcademicYearID = ID 
			FROM AcademicYear 
			WHERE ID = (SELECT MAX(ID) FROM AcademicYear WHERE Semester = 1)
		END
	RETURN [dbo].[CalculateSGPA](@StudentID,@AcademicYearID);
END
GO
/****** Object:  UserDefinedFunction [dbo].[GetNumberOfWarnings]    Script Date: 2023-03-31 10:44:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[GetNumberOfWarnings](@StudentID int)
RETURNS TINYINT
AS
BEGIN
/*
	This function calculates Regular semesters CGPA and checks if it''s <2 or not to calaulate number of warnings
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
	WHERE StudentID =@StudentID AND sc.IsIncluded =1 AND sc.IsGPAIncluded = 1 AND sc.HasWithdrawn = 0
		AND sc.AcademicYearID = (SELECT Min(AcademicYearID) From StudentCourses WHERE StudentID = @StudentID)
	group by AcademicYearid,ay.Semester
	Order by AcademicYearID;

	DECLARE Student_Waring_Counter_Cursor CURSOR FOR  
		SELECT cast(SUM(sc.points * c.CreditHours)/SUM(c.credithours) as decimal(5,4)),SUM(CreditHours),ay.Semester
		FROM StudentCourses sc left join Course c ON c.ID = sc.CourseID 
		left join AcademicYear ay ON ay.ID = sc.AcademicYearID
		WHERE StudentID = @StudentID AND sc.IsIncluded =1 AND sc.IsGPAIncluded = 1 AND sc.HasWithdrawn = 0
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
/****** Object:  UserDefinedFunction [dbo].[GetPassedPrequisteNumber]    Script Date: 2023-03-31 10:44:14 PM ******/
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
	WHERE CourseID = @CourseID AND ProgramID = [dbo].[GetStudentProgram](@StudentID);
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
/****** Object:  UserDefinedFunction [dbo].[GetPrequisteNumber]    Script Date: 2023-03-31 10:44:14 PM ******/
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
	SELECT @PrereqRelation = PrerequisiteRelationID
	FROM ProgramCourses
	WHERE CourseID = @CourseID AND ProgramID = [dbo].[GetStudentProgram](@StudentID);

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
/****** Object:  UserDefinedFunction [dbo].[GetStudentGradeInCourse]    Script Date: 2023-03-31 10:44:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[GetStudentGradeInCourse](@StudentID INT,@CourseID INT)
RETURNS NVARCHAR(3)
AS
BEGIN
	DECLARE @Grade NVARCHAR(3);
	SELECT TOP(1) @Grade = Grade FROM StudentCourses WHERE StudentID = @StudentID AND CourseID = @CourseID
	ORDER BY AcademicYearID DESC
	RETURN @Grade;
END
GO
/****** Object:  UserDefinedFunction [dbo].[GetStudentProgram]    Script Date: 2023-03-31 10:44:14 PM ******/
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
/****** Object:  UserDefinedFunction [dbo].[GetStudentProgramNameAtAcademicYear]    Script Date: 2023-03-31 10:44:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[GetStudentProgramNameAtAcademicYear](@StudentID INT,@AcademicYearID TINYINT)
RETURNS NVARCHAR(MAX)
AS
BEGIN
	DECLARE @ProgName NVARCHAR(MAX);
	SELECT TOP (1) @ProgName = p.Name
	FROM Program p
	JOIN StudentPrograms pc ON pc.ProgramID = p.ID
	WHERE pc.StudentID = @StudentID AND pc.AcademicYear <= @AcademicYearID	
	ORDER BY AcademicYear DESC
	RETURN @ProgName;
END
GO
/****** Object:  UserDefinedFunction [dbo].[GetSumOfElectivePassedHours]    Script Date: 2023-03-31 10:44:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[GetSumOfElectivePassedHours](@StudentProgramID INT,
@StudentID INT,
@CourseLevel TINYINT,
@CourseSemester TINYINT,
@CourseType TINYINT,
@CourseCategory TINYINT,
@ForOverload BIT = 0)
RETURNS TINYINT
AS
BEGIN
	DECLARE @HoursSum TINYINT;
	IF @ForOverload = 0
	BEGIN
		SELECT @HoursSum = SUM(c.CreditHours)
		FROM Course c JOIN ProgramCourses pc ON pc.CourseID = c.ID
		WHERE c.Level = @CourseLevel AND c.Semester = @CourseSemester AND c.ID IN (
			SELECT sc.CourseID
			FROM StudentCourses sc
			WHERE sc.Grade IS NOT NULL AND sc.Grade <> 'F' AND StudentID = @StudentID
		) AND pc.ProgramID = @StudentProgramID AND pc.Category = @CourseCategory AND pc.CourseType = @CourseType;
	END
	ELSE
	BEGIN
		SELECT @HoursSum = SUM(c.CreditHours)
		FROM Course c JOIN ProgramCourses pc ON pc.CourseID = c.ID
		WHERE c.Level = @CourseLevel AND c.Semester = @CourseSemester AND c.ID IN (
			SELECT sc.CourseID
			FROM StudentCourses sc
			WHERE ( 
			(sc.Grade IS NOT NULL AND sc.Grade <> 'F') OR (sc.AcademicYearID = [dbo].[GetCurrentYearID]()))
			AND StudentID = @StudentID
			)
			AND pc.ProgramID = @StudentProgramID 
			AND pc.Category = @CourseCategory 
			AND pc.CourseType = @CourseType;
	END
	IF @HoursSum IS NULL
		SET @HoursSum = 0;
	RETURN @HoursSum;
END
GO
/****** Object:  UserDefinedFunction [dbo].[IsCourseExist]    Script Date: 2023-03-31 10:44:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[IsCourseExist](@CourseCode NVARCHAR(MAX))
RETURNS BIT
AS
BEGIN
	IF EXISTS ( SELECT 1 FROM Course WHERE CourseCode = @CourseCode)
		BEGIN
			RETURN 1;
		END
	
	RETURN 0;
END
GO
/****** Object:  UserDefinedFunction [dbo].[IsCourseIncluded]    Script Date: 2023-03-31 10:44:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[IsCourseIncluded](@StudentID int,@CourseID int)
RETURNS bit
AS
	BEGIN
		DECLARE @StudentProgram int = [dbo].[GetStudentProgram](@StudentID);
		DECLARE @CourseCount int= (SELECT COUNT(CourseID) FROM ProgramCourses WHERE ProgramID = @StudentProgram AND CourseID = @CourseID);
		IF @CourseCount IS NOT NULL AND @CourseCount = 1
			BEGIN
				RETURN 1;
			END
		RETURN 0;
	END
GO
/****** Object:  UserDefinedFunction [dbo].[IsDoctorEmailExist]    Script Date: 2023-03-31 10:44:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[IsDoctorEmailExist](@Email NVARCHAR(MAX))
RETURNS BIT
AS
BEGIN
IF EXISTS ( SELECT 1 FROM Doctor WHERE Email = @Email)
		BEGIN
			RETURN 1;
		END
	
	RETURN 0;
END
GO
/****** Object:  UserDefinedFunction [dbo].[IsGraduatedStudent]    Script Date: 2023-03-31 10:44:14 PM ******/
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
/****** Object:  UserDefinedFunction [dbo].[IsStudentInSpecialProgram]    Script Date: 2023-03-31 10:44:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[IsStudentInSpecialProgram](@StudentID INT)
RETURNS bit
AS
     BEGIN
	 	 DECLARE @ProgramID int;
		 SET @ProgramID = [dbo].[GetStudentProgram](@StudentID);
		 IF @ProgramID IS NULL
			RETURN 0;
			DECLARE @IsGeneral BIT;
		SELECT @IsGeneral = IsGeneral
		FROM Program
		WHERE ID = @ProgramID;
		IF @IsGeneral = 1
			RETURN 0;
		RETURN 1;
  --       --Get current program of student
		-- DECLARE @ProgramID int;
		-- SET @ProgramID = [dbo].[GetStudentProgram](@StudentID);
		-- IF @ProgramID IS NULL
		--	RETURN 0;
		-- --Select subprograms count of student program
		-- DECLARE @SubProgramsCount TINYINT;
		-- SELECT @SubProgramsCount = COUNT(*)
		-- FROM ProgramRelations
		-- WHERE ProgramID = @ProgramID;
		-- --IF = 0 this mean it has no sub programs
		-- --Which mean it's a final(Special) program
		-- IF @SubProgramsCount = 0
		--	RETURN 1;

		--RETURN 0;
     END;
GO
/****** Object:  UserDefinedFunction [dbo].[RankStudent]    Script Date: 2023-03-31 10:44:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[RankStudent](@StudentID int)
RETURNS SMALLINT
AS
	BEGIN
		DECLARE @StudentLevel SMALLINT;
		DECLARE @ProgramID INT;
		DECLARE @ReturnValue SMALLINT;

		SELECT @ProgramID = ProgramID 
		FROM StudentPrograms
		WHERE StudentID = @StudentID AND AcademicYear = (SELECT MAX(AcademicYear) FROM StudentPrograms WHERE StudentID = @StudentID);

		SELECT @StudentLevel = Level FROM Student WHERE ID = @StudentID;

		SELECT @ReturnValue = Res.RowNum FROM(
		SELECT ROW_NUMBER() OVER(ORDER BY s.CGPA DESC) AS RowNum,s.ID
		FROM StudentPrograms sp JOIN Student s ON s.ID = sp.StudentID
		WHERE 
			s.Level =@StudentLevel AND
			sp.ProgramID = @ProgramID AND
			s.CGPA IS NOT NULL AND
			s.IsGraduated = 0
		) AS Res
		WHERE Res.ID = @StudentID;
		RETURN @ReturnValue;
	END
GO
/****** Object:  Table [dbo].[AcademicYear]    Script Date: 2023-03-31 10:44:14 PM ******/
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
/****** Object:  Table [dbo].[CommonQuestion]    Script Date: 2023-03-31 10:44:14 PM ******/
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
/****** Object:  Table [dbo].[Course]    Script Date: 2023-03-31 10:44:14 PM ******/
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
	[Level] [tinyint] NOT NULL,
	[Semester] [tinyint] NOT NULL,
	[Final] [int] NOT NULL,
	[YearWork] [int] NOT NULL,
	[Oral] [int] NOT NULL,
	[Practical] [int] NOT NULL,
 CONSTRAINT [PK_Course] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CoursePrerequisites]    Script Date: 2023-03-31 10:44:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CoursePrerequisites](
	[ProgramID] [int] NOT NULL,
	[CourseID] [int] NOT NULL,
	[PrerequisiteCourseID] [int] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Date]    Script Date: 2023-03-31 10:44:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Date](
	[DateFor] [tinyint] NOT NULL,
	[StartDate] [smalldatetime] NOT NULL,
	[EndDate] [smalldatetime] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Doctor]    Script Date: 2023-03-31 10:44:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Doctor](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[GUID] [varchar](max) NOT NULL,
	[Name] [nvarchar](max) NOT NULL,
	[Email] [nvarchar](max) NOT NULL,
	[Password] [nvarchar](max) NOT NULL,
	[IsActive] [bit] NOT NULL,
	[CreatedOn] [smalldatetime] NOT NULL,
	[ProgramID] [int] NOT NULL,
	[Type] [tinyint] NOT NULL,
 CONSTRAINT [PK_Supervisor] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ElectiveCourseDistribution]    Script Date: 2023-03-31 10:44:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ElectiveCourseDistribution](
	[ProgramID] [int] NOT NULL,
	[Level] [tinyint] NOT NULL,
	[Semester] [tinyint] NOT NULL,
	[CourseType] [tinyint] NOT NULL,
	[Category] [tinyint] NOT NULL,
	[Hour] [tinyint] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Program]    Script Date: 2023-03-31 10:44:14 PM ******/
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
	[SuperProgramID] [int] NULL,
 CONSTRAINT [PK_Program] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ProgramCourses]    Script Date: 2023-03-31 10:44:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ProgramCourses](
	[ProgramID] [int] NOT NULL,
	[CourseID] [int] NOT NULL,
	[PrerequisiteRelationID] [tinyint] NOT NULL,
	[CourseType] [tinyint] NOT NULL,
	[Category] [tinyint] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ProgramDistribution]    Script Date: 2023-03-31 10:44:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ProgramDistribution](
	[ProgramID] [int] NOT NULL,
	[Level] [tinyint] NOT NULL,
	[Semester] [tinyint] NOT NULL,
	[NumberOfHours] [tinyint] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Student]    Script Date: 2023-03-31 10:44:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Student](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[GUID] [varchar](60) NOT NULL,
	[Name] [nvarchar](max) NOT NULL,
	[SSN] [varchar](20) NOT NULL,
	[PhoneNumber] [varchar](12) NOT NULL,
	[BirthDate] [date] NOT NULL,
	[Address] [nvarchar](max) NOT NULL,
	[Gender] [char](1) NOT NULL,
	[Nationality] [nvarchar](max) NOT NULL,
	[Email] [nvarchar](max) NOT NULL,
	[Password] [nvarchar](max) NOT NULL,
	[AcademicCode] [varchar](10) NOT NULL,
	[SeatNumber] [varchar](10) NOT NULL,
	[AvailableCredits] [tinyint] NOT NULL,
	[WarningsNumber]  AS ([dbo].[GetNumberOfWarnings]([ID])),
	[SupervisorID] [int] NULL,
	[CreatedOn] [smalldatetime] NOT NULL,
	[IsCrossStudent] [bit] NOT NULL,
	[SemestersNumberInProgram] [tinyint] NOT NULL,
	[CGPA]  AS ([dbo].[CalculateCGPA]([ID])),
	[PassedHours]  AS ([dbo].[CalculatePassedHours]([ID])),
	[Level]  AS ([dbo].[CalculateStudentLevel]([ID])),
	[IsGraduated]  AS ([dbo].[IsGraduatedStudent]([ID])),
	[Rank] [smallint] NULL,
	[CalculatedRank]  AS ([dbo].[RankStudent]([ID])),
	[IsActive] [bit] NOT NULL,
	[IsInSpecialProgram]  AS ([dbo].[IsStudentInSpecialProgram]([ID])),
	[CurrentProgramID] [int] NULL,
	[AvailableWithdraws] [tinyint] NOT NULL,
	[AvailableEnhancementCredits] [tinyint] NOT NULL,
 CONSTRAINT [PK_Student] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[StudentCourseRequest]    Script Date: 2023-03-31 10:44:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[StudentCourseRequest](
	[RequestID] [nvarchar](max) NOT NULL,
	[RequestTypeID] [smallint] NOT NULL,
	[StudentID] [int] NOT NULL,
	[CourseID] [int] NOT NULL,
	[IsApproved] [bit] NULL,
	[CourseOperationID] [bit] NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[StudentCourses]    Script Date: 2023-03-31 10:44:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[StudentCourses](
	[StudentID] [int] NOT NULL,
	[CourseID] [int] NOT NULL,
	[Mark] [tinyint] NULL,
	[Final] [int] NULL,
	[YearWork] [int] NULL,
	[Oral] [int] NULL,
	[Practical] [int] NULL,
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
	[HasExcuse] [bit] NOT NULL,
	[IsEnhancementCourse] [bit] NULL,
	[HasWithdrawn] [bit] NOT NULL,
	[TookFromEnhancementCredits] [bit] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[StudentDesires]    Script Date: 2023-03-31 10:44:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[StudentDesires](
	[ProgramID] [int] NOT NULL,
	[StudentID] [int] NOT NULL,
	[DesireNumber] [tinyint] NOT NULL,
	[StudentCurrentProgramID] [int] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[StudentPrograms]    Script Date: 2023-03-31 10:44:14 PM ******/
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
/****** Object:  Table [dbo].[StudentProgramTransferRequest]    Script Date: 2023-03-31 10:44:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[StudentProgramTransferRequest](
	[StudentID] [int] NOT NULL,
	[ToProgramID] [int] NOT NULL,
	[ReasonForTransfer] [nvarchar](max) NULL,
	[IsApproved] [bit] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SuperAdmin]    Script Date: 2023-03-31 10:44:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SuperAdmin](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[GUID] [varchar](max) NOT NULL,
	[Name] [nvarchar](max) NOT NULL,
	[Email] [nvarchar](max) NOT NULL,
	[Password] [nvarchar](max) NOT NULL,
 CONSTRAINT [PK_SuperAdmin] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TeacherCourses]    Script Date: 2023-03-31 10:44:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TeacherCourses](
	[DoctorID] [int] NULL,
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
INSERT [dbo].[AcademicYear] ([ID], [AcademicYear], [Semester]) VALUES (20, N'2022/2023', 2)
GO
SET IDENTITY_INSERT [dbo].[AcademicYear] OFF
GO
SET IDENTITY_INSERT [dbo].[CommonQuestion] ON 
GO
INSERT [dbo].[CommonQuestion] ([ID], [Question], [Answer]) VALUES (1, N'Question No.1', N'Answer For Question 1')
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
INSERT [dbo].[CommonQuestion] ([ID], [Question], [Answer]) VALUES (11, N'updated', N'answer')
GO
SET IDENTITY_INSERT [dbo].[CommonQuestion] OFF
GO
SET IDENTITY_INSERT [dbo].[Course] ON 
GO
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [Level], [Semester], [Final], [YearWork], [Oral], [Practical]) VALUES (1, N'CHEM 101', N'كيمياء عامة 1', 3, 3, 0, 0, 0, 1, 1, 105, 37, 8, 0)
GO
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [Level], [Semester], [Final], [YearWork], [Oral], [Practical]) VALUES (2, N'CHEM 103', N'عملي كيمياء عامة 1', 1, 0, 3, 0, 0, 1, 1, 0, 35, 0, 15)
GO
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [Level], [Semester], [Final], [YearWork], [Oral], [Practical]) VALUES (3, N'COMP 102', N'مقدمة في الحاسب الالي', 3, 2, 2, 0, 1, 1, 2, 90, 15, 8, 37)
GO
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [Level], [Semester], [Final], [YearWork], [Oral], [Practical]) VALUES (4, N'COMP 104', N'برمجة حاسب 1', 3, 2, 2, 0, 1, 1, 2, 90, 15, 8, 37)
GO
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [Level], [Semester], [Final], [YearWork], [Oral], [Practical]) VALUES (5, N'COMP 106', N'تصميم منطق', 3, 2, 0, 2, 1, 1, 2, 105, 37, 8, 0)
GO
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [Level], [Semester], [Final], [YearWork], [Oral], [Practical]) VALUES (6, N'COMP 201', N'تصميم وتحليل الخوارزميات', 3, 3, 0, 0, 0, 2, 1, 105, 37, 8, 0)
GO
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [Level], [Semester], [Final], [YearWork], [Oral], [Practical]) VALUES (7, N'COMP 202', N'تراكيب البيانات', 3, 2, 2, 0, 1, 2, 2, 90, 15, 8, 37)
GO
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [Level], [Semester], [Final], [YearWork], [Oral], [Practical]) VALUES (8, N'COMP 203', N'نظرية الحسابات', 2, 2, 0, 0, 0, 2, 1, 70, 25, 5, 0)
GO
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [Level], [Semester], [Final], [YearWork], [Oral], [Practical]) VALUES (9, N'COMP 204', N'شبكات الحاسب', 3, 2, 2, 0, 1, 2, 2, 90, 15, 8, 37)
GO
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [Level], [Semester], [Final], [YearWork], [Oral], [Practical]) VALUES (10, N'COMP 205', N'برمجة حاسب 2', 3, 2, 2, 0, 0, 2, 1, 90, 15, 8, 37)
GO
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [Level], [Semester], [Final], [YearWork], [Oral], [Practical]) VALUES (11, N'COMP 206', N'برمجة الويب', 3, 2, 3, 0, 1, 2, 2, 90, 15, 8, 37)
GO
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [Level], [Semester], [Final], [YearWork], [Oral], [Practical]) VALUES (12, N'COMP 207', N'نظم قواعد البيانات', 4, 3, 2, 0, 0, 2, 1, 120, 20, 10, 50)
GO
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [Level], [Semester], [Final], [YearWork], [Oral], [Practical]) VALUES (13, N'COMP 208', N'نظرية الاليات الذاتية', 3, 2, 0, 2, 1, 2, 2, 105, 37, 8, 0)
GO
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [Level], [Semester], [Final], [YearWork], [Oral], [Practical]) VALUES (14, N'COMP 210', N'خورزميات الرسوم', 2, 2, 0, 0, 1, 2, 2, 70, 25, 5, 0)
GO
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [Level], [Semester], [Final], [YearWork], [Oral], [Practical]) VALUES (15, N'COMP 301', N'برمجة متقدمة', 3, 2, 3, 0, 0, 3, 1, 90, 15, 8, 37)
GO
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [Level], [Semester], [Final], [YearWork], [Oral], [Practical]) VALUES (16, N'COMP 302', N'تاليفات خوارزمية', 2, 2, 0, 1, 1, 3, 2, 70, 25, 5, 0)
GO
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [Level], [Semester], [Final], [YearWork], [Oral], [Practical]) VALUES (17, N'COMP 303', N'قواعد ودلالات لغات البرمجة', 2, 2, 0, 0, 0, 3, 1, 70, 25, 5, 0)
GO
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [Level], [Semester], [Final], [YearWork], [Oral], [Practical]) VALUES (18, N'COMP 304', N'تصميم مؤلفات', 3, 2, 2, 0, 1, 3, 2, 90, 15, 8, 37)
GO
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [Level], [Semester], [Final], [YearWork], [Oral], [Practical]) VALUES (19, N'COMP 305', N'نظرية التعقيد', 3, 3, 0, 0, 0, 3, 1, 105, 37, 8, 0)
GO
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [Level], [Semester], [Final], [YearWork], [Oral], [Practical]) VALUES (20, N'COMP 306', N'رسومات الحاسب', 3, 2, 2, 0, 1, 3, 2, 90, 15, 8, 37)
GO
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [Level], [Semester], [Final], [YearWork], [Oral], [Practical]) VALUES (21, N'COMP 307', N'نظم التشغيل', 3, 3, 0, 0, 0, 3, 1, 105, 37, 8, 0)
GO
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [Level], [Semester], [Final], [YearWork], [Oral], [Practical]) VALUES (22, N'COMP 308', N'تشفير', 3, 3, 0, 0, 1, 3, 2, 105, 37, 8, 0)
GO
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [Level], [Semester], [Final], [YearWork], [Oral], [Practical]) VALUES (23, N'COMP 309', N'نظم الوسائط المتعددة', 2, 2, 1, 0, 0, 3, 1, 70, 25, 5, 0)
GO
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [Level], [Semester], [Final], [YearWork], [Oral], [Practical]) VALUES (24, N'COMP 310', N'برمجة ويب متقدمة', 2, 1, 3, 0, 1, 3, 2, 60, 10, 5, 25)
GO
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [Level], [Semester], [Final], [YearWork], [Oral], [Practical]) VALUES (25, N'COMP 311', N'اللغات التصريحية', 2, 2, 1, 0, 0, 3, 1, 70, 25, 5, 0)
GO
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [Level], [Semester], [Final], [YearWork], [Oral], [Practical]) VALUES (26, N'COMP 312', N'تنظيم الملفات', 2, 2, 0, 0, 1, 3, 2, 70, 25, 5, 0)
GO
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [Level], [Semester], [Final], [YearWork], [Oral], [Practical]) VALUES (27, N'COMP 314', N'نظم قواعد بيانات متقدمة', 2, 2, 0, 0, 1, 3, 2, 70, 25, 5, 0)
GO
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [Level], [Semester], [Final], [YearWork], [Oral], [Practical]) VALUES (28, N'COMP 401', N'ذكاء اصطناعي', 3, 3, 0, 0, 0, 4, 1, 105, 37, 8, 0)
GO
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [Level], [Semester], [Final], [YearWork], [Oral], [Practical]) VALUES (29, N'COMP 402', N'المعلومات الحيوية', 3, 3, 0, 0, 1, 4, 2, 105, 37, 8, 0)
GO
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [Level], [Semester], [Final], [YearWork], [Oral], [Practical]) VALUES (30, N'COMP 403', N'المعالجة المتوازية الموزعة', 3, 3, 1, 0, 0, 4, 1, 105, 37, 8, 0)
GO
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [Level], [Semester], [Final], [YearWork], [Oral], [Practical]) VALUES (31, N'COMP 404', N'هندسة البرمجيات', 3, 2, 2, 0, 1, 4, 2, 90, 15, 8, 37)
GO
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [Level], [Semester], [Final], [YearWork], [Oral], [Practical]) VALUES (32, N'COMP 405', N'مشروع حاسب (أ)', 2, 0, 3, 2, 0, 4, 1, 70, 25, 5, 0)
GO
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [Level], [Semester], [Final], [YearWork], [Oral], [Practical]) VALUES (33, N'COMP 406', N'مشروع حاسب (ب)', 4, 0, 4, 4, 1, 4, 2, 0, 60, 70, 70)
GO
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [Level], [Semester], [Final], [YearWork], [Oral], [Practical]) VALUES (34, N'COMP 407', N'معالجة الصور', 3, 3, 1, 0, 0, 4, 1, 105, 37, 8, 0)
GO
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [Level], [Semester], [Final], [YearWork], [Oral], [Practical]) VALUES (35, N'COMP 408', N'موضوعات متقدمة في الذكاء الاصطناعي', 3, 3, 0, 0, 1, 4, 2, 105, 37, 8, 0)
GO
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [Level], [Semester], [Final], [YearWork], [Oral], [Practical]) VALUES (36, N'COMP 409', N'امن شبكات', 3, 3, 0, 0, 0, 4, 1, 105, 37, 8, 0)
GO
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [Level], [Semester], [Final], [YearWork], [Oral], [Practical]) VALUES (37, N'COMP 410', N'الرؤية بالحاسب', 3, 3, 0, 0, 1, 4, 2, 105, 37, 8, 0)
GO
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [Level], [Semester], [Final], [YearWork], [Oral], [Practical]) VALUES (38, N'COMP 411', N'الهندسة الحسابية', 3, 3, 0, 0, 0, 4, 1, 105, 37, 8, 0)
GO
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [Level], [Semester], [Final], [YearWork], [Oral], [Practical]) VALUES (39, N'COMP 412', N'موضوعات مختارة في امن المعلومات', 3, 3, 0, 0, 1, 4, 2, 105, 37, 8, 0)
GO
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [Level], [Semester], [Final], [YearWork], [Oral], [Practical]) VALUES (40, N'COMP 413', N'موضوعات مختارة في الخوارزميات', 3, 3, 0, 0, 0, 4, 1, 105, 37, 8, 0)
GO
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [Level], [Semester], [Final], [YearWork], [Oral], [Practical]) VALUES (41, N'COMP 414', N'موضوعات مختارة في الحوسبة', 3, 3, 0, 0, 1, 4, 2, 105, 37, 8, 0)
GO
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [Level], [Semester], [Final], [YearWork], [Oral], [Practical]) VALUES (42, N'COMP 415', N'مؤلفات متقدمة', 3, 2, 2, 0, 0, 4, 1, 90, 15, 8, 37)
GO
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [Level], [Semester], [Final], [YearWork], [Oral], [Practical]) VALUES (43, N'COMP 416', N'استخلاص البيانات والويب', 3, 3, 0, 0, 1, 4, 2, 105, 37, 8, 0)
GO
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [Level], [Semester], [Final], [YearWork], [Oral], [Practical]) VALUES (44, N'COMP 418', N'مشروع حاسب ( لمزدوج التخصص )', 3, 0, 4, 2, 1, 4, 2, 0, 40, 55, 55)
GO
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [Level], [Semester], [Final], [YearWork], [Oral], [Practical]) VALUES (45, N'ENCU 401', N'ثقافة بينية', 1, 1, 0, 0, 0, 4, 1, 50, 0, 0, 0)
GO
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [Level], [Semester], [Final], [YearWork], [Oral], [Practical]) VALUES (46, N'ENGL 102', N'لغة انجليزية 1', 2, 2, 0, 0, 1, 1, 2, 100, 0, 0, 0)
GO
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [Level], [Semester], [Final], [YearWork], [Oral], [Practical]) VALUES (47, N'ENGL 201', N'لغة انجليزية 2', 2, 2, 0, 0, 0, 2, 1, 100, 0, 0, 0)
GO
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [Level], [Semester], [Final], [YearWork], [Oral], [Practical]) VALUES (48, N'ETHR 302', N'اخلاقيات البحث العلمي', 1, 1, 0, 0, 1, 3, 2, 50, 0, 0, 0)
GO
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [Level], [Semester], [Final], [YearWork], [Oral], [Practical]) VALUES (49, N'GHDS 401', N'نشاة تاريخ وتطور العالم', 1, 1, 0, 0, 0, 4, 1, 50, 0, 0, 0)
GO
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [Level], [Semester], [Final], [YearWork], [Oral], [Practical]) VALUES (50, N'HURI 101', N'حقوق الانسان', 0, 1, 0, 0, 0, 1, 1, 50, 0, 0, 0)
GO
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [Level], [Semester], [Final], [YearWork], [Oral], [Practical]) VALUES (51, N'INCO 102', N'مدخل في الحاسب الالي', 0, 1, 0, 0, 1, 1, 2, 50, 0, 0, 0)
GO
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [Level], [Semester], [Final], [YearWork], [Oral], [Practical]) VALUES (52, N'MATH 101', N'تفاضل وتكامل 1', 4, 3, 0, 2, 0, 1, 1, 140, 50, 10, 0)
GO
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [Level], [Semester], [Final], [YearWork], [Oral], [Practical]) VALUES (53, N'MATH 102', N'تفاضل وتكامل 2', 3, 3, 0, 1, 1, 1, 2, 105, 37, 8, 0)
GO
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [Level], [Semester], [Final], [YearWork], [Oral], [Practical]) VALUES (54, N'MATH 104', N'مفاهيم اساسية في الرياضيات', 3, 3, 0, 1, 1, 1, 2, 105, 37, 8, 0)
GO
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [Level], [Semester], [Final], [YearWork], [Oral], [Practical]) VALUES (55, N'MATH 201', N'التحليل الرياضى', 3, 3, 0, 1, 0, 2, 1, 105, 37, 8, 0)
GO
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [Level], [Semester], [Final], [YearWork], [Oral], [Practical]) VALUES (56, N'MATH 202', N'معادلات تفاضلية عادية', 3, 3, 0, 1, 1, 2, 2, 105, 37, 8, 0)
GO
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [Level], [Semester], [Final], [YearWork], [Oral], [Practical]) VALUES (57, N'MATH 203', N'جبر خطي', 3, 3, 0, 1, 0, 2, 1, 105, 37, 8, 0)
GO
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [Level], [Semester], [Final], [YearWork], [Oral], [Practical]) VALUES (58, N'MATH 204', N'تحليل حقيقى', 3, 3, 0, 1, 1, 2, 2, 105, 37, 8, 0)
GO
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [Level], [Semester], [Final], [YearWork], [Oral], [Practical]) VALUES (59, N'MATH 205', N'نظرية الأعداد', 3, 3, 0, 1, 0, 2, 1, 105, 37, 8, 0)
GO
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [Level], [Semester], [Final], [YearWork], [Oral], [Practical]) VALUES (60, N'MATH 206', N'نظرية الألعاب', 2, 2, 0, 0, 1, 2, 2, 70, 25, 5, 0)
GO
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [Level], [Semester], [Final], [YearWork], [Oral], [Practical]) VALUES (61, N'MATH 208', N'البرمجة الخطية', 2, 2, 0, 0, 1, 2, 2, 70, 25, 5, 0)
GO
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [Level], [Semester], [Final], [YearWork], [Oral], [Practical]) VALUES (62, N'MATH 222', N'المنطق الرياضى', 2, 2, 0, 0, 1, 2, 2, 70, 25, 5, 0)
GO
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [Level], [Semester], [Final], [YearWork], [Oral], [Practical]) VALUES (63, N'MATH 301', N'الجبر المجرد (1) نظرية الزمر', 3, 3, 0, 1, 0, 3, 1, 105, 37, 8, 0)
GO
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [Level], [Semester], [Final], [YearWork], [Oral], [Practical]) VALUES (64, N'MATH 302', N'التوبولوجى العام', 3, 3, 0, 0, 1, 3, 2, 105, 37, 8, 0)
GO
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [Level], [Semester], [Final], [YearWork], [Oral], [Practical]) VALUES (65, N'MATH 303', N'التحليل العددي', 3, 3, 0, 1, 0, 3, 1, 105, 37, 8, 0)
GO
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [Level], [Semester], [Final], [YearWork], [Oral], [Practical]) VALUES (66, N'MATH 304', N'نظرية القياس', 3, 3, 0, 0, 1, 3, 2, 105, 37, 8, 0)
GO
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [Level], [Semester], [Final], [YearWork], [Oral], [Practical]) VALUES (67, N'MATH 305', N'الهندسة التفاضلية', 2, 2, 0, 0, 0, 3, 1, 70, 25, 5, 0)
GO
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [Level], [Semester], [Final], [YearWork], [Oral], [Practical]) VALUES (68, N'MATH 306', N'بحوث العمليات', 2, 2, 0, 0, 1, 3, 2, 70, 25, 5, 0)
GO
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [Level], [Semester], [Final], [YearWork], [Oral], [Practical]) VALUES (69, N'MATH 307', N'نظرية الخوارزميات', 2, 2, 0, 0, 0, 3, 1, 70, 25, 5, 0)
GO
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [Level], [Semester], [Final], [YearWork], [Oral], [Practical]) VALUES (70, N'MATH 319', N'مبادئ نمذجة رياضية', 2, 2, 0, 0, 0, 3, 1, 70, 25, 5, 0)
GO
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [Level], [Semester], [Final], [YearWork], [Oral], [Practical]) VALUES (71, N'MATH 331', N'مبادئ حساب التغيرات', 3, 2, 0, 2, 0, 3, 1, 105, 37, 8, 0)
GO
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [Level], [Semester], [Final], [YearWork], [Oral], [Practical]) VALUES (72, N'MATH 333', N'الجبر المجرد لعلوم الحاسب', 3, 2, 0, 2, 0, 3, 1, 105, 37, 8, 0)
GO
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [Level], [Semester], [Final], [YearWork], [Oral], [Practical]) VALUES (73, N'MATH 401', N'التحليل الدالى', 3, 3, 0, 0, 0, 4, 1, 105, 37, 8, 0)
GO
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [Level], [Semester], [Final], [YearWork], [Oral], [Practical]) VALUES (74, N'MATH 402', N'الجبر المجرد (2) (الحلقات و الحقول)', 3, 3, 0, 1, 1, 4, 2, 105, 37, 8, 0)
GO
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [Level], [Semester], [Final], [YearWork], [Oral], [Practical]) VALUES (75, N'MATH 403', N'التحليل المركب', 3, 3, 0, 0, 0, 4, 1, 105, 37, 8, 0)
GO
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [Level], [Semester], [Final], [YearWork], [Oral], [Practical]) VALUES (76, N'MATH 404', N'المعادلات التفاضلية الجزئية', 3, 3, 0, 0, 1, 4, 2, 105, 37, 8, 0)
GO
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [Level], [Semester], [Final], [YearWork], [Oral], [Practical]) VALUES (77, N'MATH 406', N'جبر خطى متقدم', 3, 2, 2, 0, 1, 4, 2, 105, 37, 8, 0)
GO
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [Level], [Semester], [Final], [YearWork], [Oral], [Practical]) VALUES (78, N'MATH 407', N'الهندسة الجبرية', 2, 2, 0, 0, 0, 4, 1, 70, 25, 5, 0)
GO
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [Level], [Semester], [Final], [YearWork], [Oral], [Practical]) VALUES (79, N'MATH 408', N'موضوعات مختارة فى الرياضيات البحتة', 3, 3, 0, 0, 1, 4, 2, 105, 37, 8, 0)
GO
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [Level], [Semester], [Final], [YearWork], [Oral], [Practical]) VALUES (80, N'MATH 409', N'نظرية الرسوم', 2, 2, 0, 0, 0, 4, 1, 70, 25, 5, 0)
GO
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [Level], [Semester], [Final], [YearWork], [Oral], [Practical]) VALUES (81, N'MATH 421', N'جبر خطى عددى', 2, 2, 0, 0, 0, 4, 1, 70, 25, 5, 0)
GO
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [Level], [Semester], [Final], [YearWork], [Oral], [Practical]) VALUES (82, N'MATH 423', N'مشروع بحثى رياضيات بحتة', 1, 0, 0, 3, 0, 4, 1, 0, 25, 25, 0)
GO
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [Level], [Semester], [Final], [YearWork], [Oral], [Practical]) VALUES (83, N'PHYS 101', N'فيزياء 1', 4, 3, 3, 0, 0, 1, 1, 120, 20, 10, 50)
GO
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [Level], [Semester], [Final], [YearWork], [Oral], [Practical]) VALUES (84, N'SAFS 101', N'الامن والسلامة', 1, 1, 0, 0, 0, 1, 1, 50, 0, 0, 0)
GO
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [Level], [Semester], [Final], [YearWork], [Oral], [Practical]) VALUES (85, N'SCTH 301', N'التفكير العلمي', 1, 1, 0, 0, 0, 3, 1, 50, 0, 0, 0)
GO
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [Level], [Semester], [Final], [YearWork], [Oral], [Practical]) VALUES (86, N'SKIL 401', N'مهارات العمل', 1, 1, 0, 0, 0, 4, 1, 50, 0, 0, 0)
GO
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [Level], [Semester], [Final], [YearWork], [Oral], [Practical]) VALUES (87, N'STAT 101', N'مقدمة في الاحصاء', 3, 3, 0, 1, 0, 1, 1, 105, 37, 8, 0)
GO
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [Level], [Semester], [Final], [YearWork], [Oral], [Practical]) VALUES (88, N'STAT 102', N'نظرية الاحتمالات 1', 3, 3, 0, 1, 1, 1, 2, 105, 37, 8, 0)
GO
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [Level], [Semester], [Final], [YearWork], [Oral], [Practical]) VALUES (89, N'STAT 201', N'(1) نظرية الإحصاء', 3, 3, 0, 1, 0, 2, 1, 105, 37, 8, 0)
GO
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [Level], [Semester], [Final], [YearWork], [Oral], [Practical]) VALUES (90, N'STAT 202', N'(2) نظرية الإحصاء', 3, 3, 0, 1, 1, 2, 2, 105, 37, 8, 0)
GO
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [Level], [Semester], [Final], [YearWork], [Oral], [Practical]) VALUES (91, N'STAT 203', N'(1) طرق إحصائية', 3, 2, 3, 0, 0, 2, 1, 90, 15, 8, 37)
GO
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [Level], [Semester], [Final], [YearWork], [Oral], [Practical]) VALUES (92, N'STAT 204', N'(1) طرق إحتمالية فى بحوث العمليات', 3, 3, 0, 1, 1, 2, 2, 105, 37, 8, 0)
GO
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [Level], [Semester], [Final], [YearWork], [Oral], [Practical]) VALUES (93, N'STAT 205', N'رياضيات إحصائية', 3, 3, 0, 1, 0, 2, 1, 105, 37, 8, 0)
GO
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [Level], [Semester], [Final], [YearWork], [Oral], [Practical]) VALUES (94, N'STAT 206', N'(2) طرق إحصائية', 3, 2, 3, 0, 1, 2, 2, 90, 15, 8, 37)
GO
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [Level], [Semester], [Final], [YearWork], [Oral], [Practical]) VALUES (95, N'STAT 208', N'مبادئ تحاليل الانحدار', 3, 3, 1, 0, 1, 2, 2, 105, 37, 8, 0)
GO
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [Level], [Semester], [Final], [YearWork], [Oral], [Practical]) VALUES (96, N'STAT 218', N'مقدمة في نظرية الاحتمالات', 3, 3, 0, 1, 1, 2, 2, 105, 37, 8, 0)
GO
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [Level], [Semester], [Final], [YearWork], [Oral], [Practical]) VALUES (97, N'STAT 301', N'(1) استدلال إحصائى', 3, 3, 0, 1, 0, 3, 1, 105, 37, 8, 0)
GO
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [Level], [Semester], [Final], [YearWork], [Oral], [Practical]) VALUES (98, N'STAT 302', N'(2) استدلال إحصائى', 3, 3, 0, 1, 1, 3, 2, 105, 37, 8, 0)
GO
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [Level], [Semester], [Final], [YearWork], [Oral], [Practical]) VALUES (99, N'STAT 303', N'(1) عمليات عشوائية', 3, 3, 0, 1, 0, 3, 1, 105, 37, 8, 0)
GO
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [Level], [Semester], [Final], [YearWork], [Oral], [Practical]) VALUES (100, N'STAT 304', N'طرق المعاينة', 3, 3, 0, 0, 1, 3, 2, 105, 37, 8, 0)
GO
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [Level], [Semester], [Final], [YearWork], [Oral], [Practical]) VALUES (101, N'STAT 305', N'إحصاءات مرتبة', 3, 3, 0, 1, 0, 3, 1, 105, 37, 8, 0)
GO
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [Level], [Semester], [Final], [YearWork], [Oral], [Practical]) VALUES (102, N'STAT 311', N'محاكاة ونمذجة', 3, 3, 0, 1, 0, 3, 1, 105, 37, 8, 0)
GO
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [Level], [Semester], [Final], [YearWork], [Oral], [Practical]) VALUES (103, N'STAT 314', N'نظرية الصلاحية', 2, 2, 0, 0, 1, 3, 2, 70, 25, 5, 0)
GO
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [Level], [Semester], [Final], [YearWork], [Oral], [Practical]) VALUES (104, N'STAT 315', N'(2) طرق إحتمالية فى بحوث العمليات', 3, 3, 0, 1, 0, 3, 1, 105, 37, 8, 0)
GO
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [Level], [Semester], [Final], [YearWork], [Oral], [Practical]) VALUES (105, N'STAT 405', N'تصميم و تحليل التجارب', 4, 3, 2, 0, 0, 4, 1, 120, 20, 10, 50)
GO
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [Level], [Semester], [Final], [YearWork], [Oral], [Practical]) VALUES (106, N'STAT 408', N'سلاسل زمنية', 3, 3, 0, 0, 1, 4, 2, 105, 37, 8, 0)
GO
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [Level], [Semester], [Final], [YearWork], [Oral], [Practical]) VALUES (107, N'STAT 411', N'التحليل التتابعى', 2, 2, 0, 0, 0, 4, 1, 70, 25, 5, 0)
GO
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [Level], [Semester], [Final], [YearWork], [Oral], [Practical]) VALUES (108, N'STAT 412', N'نظرية الطوابير', 2, 2, 0, 0, 1, 4, 2, 70, 25, 5, 0)
GO
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [Level], [Semester], [Final], [YearWork], [Oral], [Practical]) VALUES (109, N'STAT 415', N'تحليل إحصائى متعدد', 2, 2, 0, 1, 0, 4, 1, 70, 25, 5, 0)
GO
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [Level], [Semester], [Final], [YearWork], [Oral], [Practical]) VALUES (110, N'STAT 416', N'نظرية التجديد', 2, 2, 0, 0, 1, 4, 2, 70, 25, 5, 0)
GO
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [Level], [Semester], [Final], [YearWork], [Oral], [Practical]) VALUES (111, N'STAT 417', N'نظرية اتخاذ القرار', 2, 2, 0, 0, 0, 4, 1, 70, 25, 5, 0)
GO
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [Level], [Semester], [Final], [YearWork], [Oral], [Practical]) VALUES (112, N'STAT 418', N'(2) عمليات عشوائية', 2, 2, 0, 0, 1, 4, 2, 70, 25, 5, 0)
GO
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [Level], [Semester], [Final], [YearWork], [Oral], [Practical]) VALUES (113, N'STAT 424', N'مشروع بحثى فى الإحصاء', 2, 0, 2, 2, 1, 4, 2, 70, 25, 5, 0)
GO
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [Level], [Semester], [Final], [YearWork], [Oral], [Practical]) VALUES (114, N'COMP 212', N'برمجة حاسب متقدم', 3, 2, 2, 0, 1, 2, 2, 90, 15, 8, 37)
GO
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [Level], [Semester], [Final], [YearWork], [Oral], [Practical]) VALUES (115, N'COMP 313', N'حزم برمجية', 1, 0, 3, 0, 0, 3, 1, 0, 12, 3, 35)
GO
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [Level], [Semester], [Final], [YearWork], [Oral], [Practical]) VALUES (116, N'kyk 2022', N'fs', 4, 2, 2, 2, 1, 0, 0, 0, 0, 0, 0)
GO
SET IDENTITY_INSERT [dbo].[Course] OFF
GO
INSERT [dbo].[CoursePrerequisites] ([ProgramID], [CourseID], [PrerequisiteCourseID]) VALUES (6, 47, 46)
GO
INSERT [dbo].[CoursePrerequisites] ([ProgramID], [CourseID], [PrerequisiteCourseID]) VALUES (6, 56, 52)
GO
INSERT [dbo].[CoursePrerequisites] ([ProgramID], [CourseID], [PrerequisiteCourseID]) VALUES (6, 56, 53)
GO
INSERT [dbo].[CoursePrerequisites] ([ProgramID], [CourseID], [PrerequisiteCourseID]) VALUES (6, 7, 4)
GO
INSERT [dbo].[CoursePrerequisites] ([ProgramID], [CourseID], [PrerequisiteCourseID]) VALUES (6, 114, 4)
GO
INSERT [dbo].[CoursePrerequisites] ([ProgramID], [CourseID], [PrerequisiteCourseID]) VALUES (6, 11, 4)
GO
INSERT [dbo].[CoursePrerequisites] ([ProgramID], [CourseID], [PrerequisiteCourseID]) VALUES (6, 66, 58)
GO
INSERT [dbo].[CoursePrerequisites] ([ProgramID], [CourseID], [PrerequisiteCourseID]) VALUES (6, 18, 114)
GO
INSERT [dbo].[CoursePrerequisites] ([ProgramID], [CourseID], [PrerequisiteCourseID]) VALUES (6, 20, 114)
GO
INSERT [dbo].[CoursePrerequisites] ([ProgramID], [CourseID], [PrerequisiteCourseID]) VALUES (6, 75, 58)
GO
INSERT [dbo].[CoursePrerequisites] ([ProgramID], [CourseID], [PrerequisiteCourseID]) VALUES (6, 81, 57)
GO
INSERT [dbo].[CoursePrerequisites] ([ProgramID], [CourseID], [PrerequisiteCourseID]) VALUES (6, 34, 114)
GO
INSERT [dbo].[CoursePrerequisites] ([ProgramID], [CourseID], [PrerequisiteCourseID]) VALUES (6, 38, 6)
GO
INSERT [dbo].[CoursePrerequisites] ([ProgramID], [CourseID], [PrerequisiteCourseID]) VALUES (6, 38, 114)
GO
INSERT [dbo].[CoursePrerequisites] ([ProgramID], [CourseID], [PrerequisiteCourseID]) VALUES (6, 40, 6)
GO
INSERT [dbo].[CoursePrerequisites] ([ProgramID], [CourseID], [PrerequisiteCourseID]) VALUES (6, 74, 63)
GO
INSERT [dbo].[CoursePrerequisites] ([ProgramID], [CourseID], [PrerequisiteCourseID]) VALUES (6, 76, 56)
GO
INSERT [dbo].[CoursePrerequisites] ([ProgramID], [CourseID], [PrerequisiteCourseID]) VALUES (6, 77, 57)
GO
INSERT [dbo].[CoursePrerequisites] ([ProgramID], [CourseID], [PrerequisiteCourseID]) VALUES (6, 29, 6)
GO
INSERT [dbo].[CoursePrerequisites] ([ProgramID], [CourseID], [PrerequisiteCourseID]) VALUES (6, 29, 114)
GO
INSERT [dbo].[CoursePrerequisites] ([ProgramID], [CourseID], [PrerequisiteCourseID]) VALUES (6, 39, 22)
GO
INSERT [dbo].[CoursePrerequisites] ([ProgramID], [CourseID], [PrerequisiteCourseID]) VALUES (6, 41, 114)
GO
INSERT [dbo].[CoursePrerequisites] ([ProgramID], [CourseID], [PrerequisiteCourseID]) VALUES (6, 43, 12)
GO
INSERT [dbo].[CoursePrerequisites] ([ProgramID], [CourseID], [PrerequisiteCourseID]) VALUES (7, 47, 46)
GO
INSERT [dbo].[CoursePrerequisites] ([ProgramID], [CourseID], [PrerequisiteCourseID]) VALUES (7, 89, 88)
GO
INSERT [dbo].[CoursePrerequisites] ([ProgramID], [CourseID], [PrerequisiteCourseID]) VALUES (7, 91, 87)
GO
INSERT [dbo].[CoursePrerequisites] ([ProgramID], [CourseID], [PrerequisiteCourseID]) VALUES (7, 90, 88)
GO
INSERT [dbo].[CoursePrerequisites] ([ProgramID], [CourseID], [PrerequisiteCourseID]) VALUES (7, 7, 4)
GO
INSERT [dbo].[CoursePrerequisites] ([ProgramID], [CourseID], [PrerequisiteCourseID]) VALUES (7, 114, 4)
GO
INSERT [dbo].[CoursePrerequisites] ([ProgramID], [CourseID], [PrerequisiteCourseID]) VALUES (7, 11, 4)
GO
INSERT [dbo].[CoursePrerequisites] ([ProgramID], [CourseID], [PrerequisiteCourseID]) VALUES (7, 97, 90)
GO
INSERT [dbo].[CoursePrerequisites] ([ProgramID], [CourseID], [PrerequisiteCourseID]) VALUES (7, 99, 93)
GO
INSERT [dbo].[CoursePrerequisites] ([ProgramID], [CourseID], [PrerequisiteCourseID]) VALUES (7, 101, 90)
GO
INSERT [dbo].[CoursePrerequisites] ([ProgramID], [CourseID], [PrerequisiteCourseID]) VALUES (7, 102, 90)
GO
INSERT [dbo].[CoursePrerequisites] ([ProgramID], [CourseID], [PrerequisiteCourseID]) VALUES (7, 104, 92)
GO
INSERT [dbo].[CoursePrerequisites] ([ProgramID], [CourseID], [PrerequisiteCourseID]) VALUES (7, 98, 90)
GO
INSERT [dbo].[CoursePrerequisites] ([ProgramID], [CourseID], [PrerequisiteCourseID]) VALUES (7, 18, 13)
GO
INSERT [dbo].[CoursePrerequisites] ([ProgramID], [CourseID], [PrerequisiteCourseID]) VALUES (7, 18, 114)
GO
INSERT [dbo].[CoursePrerequisites] ([ProgramID], [CourseID], [PrerequisiteCourseID]) VALUES (7, 20, 114)
GO
INSERT [dbo].[CoursePrerequisites] ([ProgramID], [CourseID], [PrerequisiteCourseID]) VALUES (7, 105, 98)
GO
INSERT [dbo].[CoursePrerequisites] ([ProgramID], [CourseID], [PrerequisiteCourseID]) VALUES (7, 109, 93)
GO
INSERT [dbo].[CoursePrerequisites] ([ProgramID], [CourseID], [PrerequisiteCourseID]) VALUES (7, 107, 98)
GO
INSERT [dbo].[CoursePrerequisites] ([ProgramID], [CourseID], [PrerequisiteCourseID]) VALUES (7, 111, 97)
GO
INSERT [dbo].[CoursePrerequisites] ([ProgramID], [CourseID], [PrerequisiteCourseID]) VALUES (7, 34, 114)
GO
INSERT [dbo].[CoursePrerequisites] ([ProgramID], [CourseID], [PrerequisiteCourseID]) VALUES (7, 38, 6)
GO
INSERT [dbo].[CoursePrerequisites] ([ProgramID], [CourseID], [PrerequisiteCourseID]) VALUES (7, 38, 114)
GO
INSERT [dbo].[CoursePrerequisites] ([ProgramID], [CourseID], [PrerequisiteCourseID]) VALUES (7, 40, 6)
GO
INSERT [dbo].[CoursePrerequisites] ([ProgramID], [CourseID], [PrerequisiteCourseID]) VALUES (7, 106, 98)
GO
INSERT [dbo].[CoursePrerequisites] ([ProgramID], [CourseID], [PrerequisiteCourseID]) VALUES (7, 112, 99)
GO
INSERT [dbo].[CoursePrerequisites] ([ProgramID], [CourseID], [PrerequisiteCourseID]) VALUES (7, 108, 99)
GO
INSERT [dbo].[CoursePrerequisites] ([ProgramID], [CourseID], [PrerequisiteCourseID]) VALUES (7, 110, 93)
GO
INSERT [dbo].[CoursePrerequisites] ([ProgramID], [CourseID], [PrerequisiteCourseID]) VALUES (7, 29, 6)
GO
INSERT [dbo].[CoursePrerequisites] ([ProgramID], [CourseID], [PrerequisiteCourseID]) VALUES (7, 29, 114)
GO
INSERT [dbo].[CoursePrerequisites] ([ProgramID], [CourseID], [PrerequisiteCourseID]) VALUES (7, 31, 114)
GO
INSERT [dbo].[CoursePrerequisites] ([ProgramID], [CourseID], [PrerequisiteCourseID]) VALUES (7, 41, 114)
GO
INSERT [dbo].[CoursePrerequisites] ([ProgramID], [CourseID], [PrerequisiteCourseID]) VALUES (7, 43, 12)
GO
INSERT [dbo].[CoursePrerequisites] ([ProgramID], [CourseID], [PrerequisiteCourseID]) VALUES (5, 47, 46)
GO
INSERT [dbo].[CoursePrerequisites] ([ProgramID], [CourseID], [PrerequisiteCourseID]) VALUES (5, 10, 4)
GO
INSERT [dbo].[CoursePrerequisites] ([ProgramID], [CourseID], [PrerequisiteCourseID]) VALUES (5, 7, 4)
GO
INSERT [dbo].[CoursePrerequisites] ([ProgramID], [CourseID], [PrerequisiteCourseID]) VALUES (5, 11, 4)
GO
INSERT [dbo].[CoursePrerequisites] ([ProgramID], [CourseID], [PrerequisiteCourseID]) VALUES (5, 56, 52)
GO
INSERT [dbo].[CoursePrerequisites] ([ProgramID], [CourseID], [PrerequisiteCourseID]) VALUES (5, 56, 53)
GO
INSERT [dbo].[CoursePrerequisites] ([ProgramID], [CourseID], [PrerequisiteCourseID]) VALUES (5, 15, 10)
GO
INSERT [dbo].[CoursePrerequisites] ([ProgramID], [CourseID], [PrerequisiteCourseID]) VALUES (5, 18, 13)
GO
INSERT [dbo].[CoursePrerequisites] ([ProgramID], [CourseID], [PrerequisiteCourseID]) VALUES (5, 18, 10)
GO
INSERT [dbo].[CoursePrerequisites] ([ProgramID], [CourseID], [PrerequisiteCourseID]) VALUES (5, 24, 11)
GO
INSERT [dbo].[CoursePrerequisites] ([ProgramID], [CourseID], [PrerequisiteCourseID]) VALUES (5, 27, 12)
GO
INSERT [dbo].[CoursePrerequisites] ([ProgramID], [CourseID], [PrerequisiteCourseID]) VALUES (5, 34, 10)
GO
INSERT [dbo].[CoursePrerequisites] ([ProgramID], [CourseID], [PrerequisiteCourseID]) VALUES (5, 36, 9)
GO
INSERT [dbo].[CoursePrerequisites] ([ProgramID], [CourseID], [PrerequisiteCourseID]) VALUES (5, 36, 22)
GO
INSERT [dbo].[CoursePrerequisites] ([ProgramID], [CourseID], [PrerequisiteCourseID]) VALUES (5, 38, 6)
GO
INSERT [dbo].[CoursePrerequisites] ([ProgramID], [CourseID], [PrerequisiteCourseID]) VALUES (5, 38, 10)
GO
INSERT [dbo].[CoursePrerequisites] ([ProgramID], [CourseID], [PrerequisiteCourseID]) VALUES (5, 40, 6)
GO
INSERT [dbo].[CoursePrerequisites] ([ProgramID], [CourseID], [PrerequisiteCourseID]) VALUES (5, 42, 17)
GO
INSERT [dbo].[CoursePrerequisites] ([ProgramID], [CourseID], [PrerequisiteCourseID]) VALUES (5, 42, 18)
GO
INSERT [dbo].[CoursePrerequisites] ([ProgramID], [CourseID], [PrerequisiteCourseID]) VALUES (5, 29, 6)
GO
INSERT [dbo].[CoursePrerequisites] ([ProgramID], [CourseID], [PrerequisiteCourseID]) VALUES (5, 29, 10)
GO
INSERT [dbo].[CoursePrerequisites] ([ProgramID], [CourseID], [PrerequisiteCourseID]) VALUES (5, 31, 10)
GO
INSERT [dbo].[CoursePrerequisites] ([ProgramID], [CourseID], [PrerequisiteCourseID]) VALUES (5, 37, 6)
GO
INSERT [dbo].[CoursePrerequisites] ([ProgramID], [CourseID], [PrerequisiteCourseID]) VALUES (5, 37, 10)
GO
INSERT [dbo].[CoursePrerequisites] ([ProgramID], [CourseID], [PrerequisiteCourseID]) VALUES (5, 41, 10)
GO
INSERT [dbo].[CoursePrerequisites] ([ProgramID], [CourseID], [PrerequisiteCourseID]) VALUES (5, 43, 12)
GO
INSERT [dbo].[Date] ([DateFor], [StartDate], [EndDate]) VALUES (0, CAST(N'2023-02-10T15:57:00' AS SmallDateTime), CAST(N'2023-05-29T00:00:00' AS SmallDateTime))
GO
INSERT [dbo].[Date] ([DateFor], [StartDate], [EndDate]) VALUES (1, CAST(N'2023-03-26T12:47:00' AS SmallDateTime), CAST(N'2023-05-29T00:00:00' AS SmallDateTime))
GO
INSERT [dbo].[Date] ([DateFor], [StartDate], [EndDate]) VALUES (2, CAST(N'2023-02-10T00:00:00' AS SmallDateTime), CAST(N'2023-05-29T00:00:00' AS SmallDateTime))
GO
INSERT [dbo].[Date] ([DateFor], [StartDate], [EndDate]) VALUES (3, CAST(N'2023-03-16T00:00:00' AS SmallDateTime), CAST(N'2023-05-29T00:00:00' AS SmallDateTime))
GO
INSERT [dbo].[Date] ([DateFor], [StartDate], [EndDate]) VALUES (4, CAST(N'2023-03-18T00:00:00' AS SmallDateTime), CAST(N'2023-05-29T00:00:00' AS SmallDateTime))
GO
INSERT [dbo].[Date] ([DateFor], [StartDate], [EndDate]) VALUES (5, CAST(N'2023-03-18T00:00:00' AS SmallDateTime), CAST(N'2023-05-29T00:00:00' AS SmallDateTime))
GO
INSERT [dbo].[Date] ([DateFor], [StartDate], [EndDate]) VALUES (6, CAST(N'2023-03-18T00:00:00' AS SmallDateTime), CAST(N'2023-05-29T00:00:00' AS SmallDateTime))
GO
INSERT [dbo].[Date] ([DateFor], [StartDate], [EndDate]) VALUES (7, CAST(N'2023-03-18T00:00:00' AS SmallDateTime), CAST(N'2023-05-29T00:00:00' AS SmallDateTime))
GO
SET IDENTITY_INSERT [dbo].[Doctor] ON 
GO
INSERT [dbo].[Doctor] ([ID], [GUID], [Name], [Email], [Password], [IsActive], [CreatedOn], [ProgramID], [Type]) VALUES (2, N'A95A4304-E215-46A3-A3C9-3D01F90F0868', N'CS supervisor', N'cssuper@sci.asu.edu.eg', N'0FBC1FB9CDE268DF12C8CE7A0CF5847B9D1246F76D994A335EBBE0068D777BF00641A9CF776BEF92DBBC4A9B9389095D7ABAFECF9560BC8BD42FD5AA3564DE8C', 1, CAST(N'2022-11-27T00:00:00' AS SmallDateTime), 5, 1)
GO
INSERT [dbo].[Doctor] ([ID], [GUID], [Name], [Email], [Password], [IsActive], [CreatedOn], [ProgramID], [Type]) VALUES (3, N'A95A4304-E215-46A3-A3C9-3D01F90F543', N'Math Admin', N'Amath@sci.asu.edu.eg', N'0FBC1FB9CDE268DF12C8CE7A0CF5847B9D1246F76D994A335EBBE0068D777BF00641A9CF776BEF92DBBC4A9B9389095D7ABAFECF9560BC8BD42FD5AA3564DE8C', 1, CAST(N'2022-03-09T00:00:00' AS SmallDateTime), 1, 1)
GO
SET IDENTITY_INSERT [dbo].[Doctor] OFF
GO
INSERT [dbo].[ElectiveCourseDistribution] ([ProgramID], [Level], [Semester], [CourseType], [Category], [Hour]) VALUES (5, 2, 2, 2, 1, 3)
GO
INSERT [dbo].[ElectiveCourseDistribution] ([ProgramID], [Level], [Semester], [CourseType], [Category], [Hour]) VALUES (5, 3, 1, 2, 1, 2)
GO
INSERT [dbo].[ElectiveCourseDistribution] ([ProgramID], [Level], [Semester], [CourseType], [Category], [Hour]) VALUES (5, 3, 1, 2, 2, 3)
GO
INSERT [dbo].[ElectiveCourseDistribution] ([ProgramID], [Level], [Semester], [CourseType], [Category], [Hour]) VALUES (5, 3, 2, 2, 1, 4)
GO
INSERT [dbo].[ElectiveCourseDistribution] ([ProgramID], [Level], [Semester], [CourseType], [Category], [Hour]) VALUES (5, 4, 1, 3, 1, 1)
GO
INSERT [dbo].[ElectiveCourseDistribution] ([ProgramID], [Level], [Semester], [CourseType], [Category], [Hour]) VALUES (5, 4, 1, 2, 1, 6)
GO
INSERT [dbo].[ElectiveCourseDistribution] ([ProgramID], [Level], [Semester], [CourseType], [Category], [Hour]) VALUES (5, 4, 2, 2, 1, 6)
GO
INSERT [dbo].[ElectiveCourseDistribution] ([ProgramID], [Level], [Semester], [CourseType], [Category], [Hour]) VALUES (6, 2, 2, 2, 1, 2)
GO
INSERT [dbo].[ElectiveCourseDistribution] ([ProgramID], [Level], [Semester], [CourseType], [Category], [Hour]) VALUES (6, 2, 2, 2, 2, 3)
GO
INSERT [dbo].[ElectiveCourseDistribution] ([ProgramID], [Level], [Semester], [CourseType], [Category], [Hour]) VALUES (6, 3, 1, 2, 1, 2)
GO
INSERT [dbo].[ElectiveCourseDistribution] ([ProgramID], [Level], [Semester], [CourseType], [Category], [Hour]) VALUES (6, 3, 1, 2, 2, 2)
GO
INSERT [dbo].[ElectiveCourseDistribution] ([ProgramID], [Level], [Semester], [CourseType], [Category], [Hour]) VALUES (6, 3, 1, 2, 3, 1)
GO
INSERT [dbo].[ElectiveCourseDistribution] ([ProgramID], [Level], [Semester], [CourseType], [Category], [Hour]) VALUES (6, 3, 2, 2, 2, 3)
GO
INSERT [dbo].[ElectiveCourseDistribution] ([ProgramID], [Level], [Semester], [CourseType], [Category], [Hour]) VALUES (6, 4, 1, 3, 1, 1)
GO
INSERT [dbo].[ElectiveCourseDistribution] ([ProgramID], [Level], [Semester], [CourseType], [Category], [Hour]) VALUES (6, 4, 1, 2, 1, 2)
GO
INSERT [dbo].[ElectiveCourseDistribution] ([ProgramID], [Level], [Semester], [CourseType], [Category], [Hour]) VALUES (6, 4, 1, 2, 2, 3)
GO
INSERT [dbo].[ElectiveCourseDistribution] ([ProgramID], [Level], [Semester], [CourseType], [Category], [Hour]) VALUES (6, 4, 2, 2, 1, 3)
GO
INSERT [dbo].[ElectiveCourseDistribution] ([ProgramID], [Level], [Semester], [CourseType], [Category], [Hour]) VALUES (6, 4, 2, 2, 2, 3)
GO
INSERT [dbo].[ElectiveCourseDistribution] ([ProgramID], [Level], [Semester], [CourseType], [Category], [Hour]) VALUES (7, 2, 2, 2, 1, 3)
GO
INSERT [dbo].[ElectiveCourseDistribution] ([ProgramID], [Level], [Semester], [CourseType], [Category], [Hour]) VALUES (7, 2, 2, 2, 2, 3)
GO
INSERT [dbo].[ElectiveCourseDistribution] ([ProgramID], [Level], [Semester], [CourseType], [Category], [Hour]) VALUES (7, 3, 1, 2, 1, 3)
GO
INSERT [dbo].[ElectiveCourseDistribution] ([ProgramID], [Level], [Semester], [CourseType], [Category], [Hour]) VALUES (7, 3, 1, 2, 2, 2)
GO
INSERT [dbo].[ElectiveCourseDistribution] ([ProgramID], [Level], [Semester], [CourseType], [Category], [Hour]) VALUES (7, 3, 2, 2, 2, 3)
GO
INSERT [dbo].[ElectiveCourseDistribution] ([ProgramID], [Level], [Semester], [CourseType], [Category], [Hour]) VALUES (7, 4, 1, 3, 1, 1)
GO
INSERT [dbo].[ElectiveCourseDistribution] ([ProgramID], [Level], [Semester], [CourseType], [Category], [Hour]) VALUES (7, 4, 1, 2, 1, 2)
GO
INSERT [dbo].[ElectiveCourseDistribution] ([ProgramID], [Level], [Semester], [CourseType], [Category], [Hour]) VALUES (7, 4, 1, 2, 2, 3)
GO
INSERT [dbo].[ElectiveCourseDistribution] ([ProgramID], [Level], [Semester], [CourseType], [Category], [Hour]) VALUES (7, 4, 2, 2, 1, 2)
GO
INSERT [dbo].[ElectiveCourseDistribution] ([ProgramID], [Level], [Semester], [CourseType], [Category], [Hour]) VALUES (7, 4, 2, 2, 2, 3)
GO
SET IDENTITY_INSERT [dbo].[Program] ON 
GO
INSERT [dbo].[Program] ([ID], [Name], [Semester], [Percentage], [IsRegular], [IsGeneral], [TotalHours], [EnglishName], [ArabicName], [SuperProgramID]) VALUES (1, N'برنامج الرياضيات (عام)', 1, 1, 1, 1, 16, N'General Math Program', N'برنامج الرياضيات', NULL)
GO
INSERT [dbo].[Program] ([ID], [Name], [Semester], [Percentage], [IsRegular], [IsGeneral], [TotalHours], [EnglishName], [ArabicName], [SuperProgramID]) VALUES (2, N'برنامج علوم الحاسب (عام)', 2, 0.35, 1, 1, 17, N'Computer Science', N'برنامج علوم الحاسب', 1)
GO
INSERT [dbo].[Program] ([ID], [Name], [Semester], [Percentage], [IsRegular], [IsGeneral], [TotalHours], [EnglishName], [ArabicName], [SuperProgramID]) VALUES (3, N'برنامج الإحصاء الرياضى (عام)', 2, 0.35, 1, 1, 17, N'Statistics', N'برنامج الإحصاء الرياضى', 1)
GO
INSERT [dbo].[Program] ([ID], [Name], [Semester], [Percentage], [IsRegular], [IsGeneral], [TotalHours], [EnglishName], [ArabicName], [SuperProgramID]) VALUES (4, N'برنامج الرياضيات', 2, 0.3, 1, 0, 134, N'Pure Mathmatics', N'برنامج الرياضيات', 1)
GO
INSERT [dbo].[Program] ([ID], [Name], [Semester], [Percentage], [IsRegular], [IsGeneral], [TotalHours], [EnglishName], [ArabicName], [SuperProgramID]) VALUES (5, N'برنامج علوم الحاسب', 3, 0.6, 1, 0, 134, N'Pure Computer Science', N'برنامج علوم الحاسب', 2)
GO
INSERT [dbo].[Program] ([ID], [Name], [Semester], [Percentage], [IsRegular], [IsGeneral], [TotalHours], [EnglishName], [ArabicName], [SuperProgramID]) VALUES (6, N'برنامج الرياضيات البحتة وعلوم الحاسب', 3, 0.4, 1, 0, 140, N'Mathmathic & Computer Science', N'برنامج الرياضيات البحتة وعلوم الحاسب', 2)
GO
INSERT [dbo].[Program] ([ID], [Name], [Semester], [Percentage], [IsRegular], [IsGeneral], [TotalHours], [EnglishName], [ArabicName], [SuperProgramID]) VALUES (7, N'برنامج الإحصاء الرياضى وعلوم الحاسب', 3, 1, 1, 0, 140, N'Statistics & Computer Science', N'برنامج الإحصاء الرياضى وعلوم الحاسب', 3)
GO
INSERT [dbo].[Program] ([ID], [Name], [Semester], [Percentage], [IsRegular], [IsGeneral], [TotalHours], [EnglishName], [ArabicName], [SuperProgramID]) VALUES (8, N'برنامج الإحصاء الرياضى منفرد', 3, 1, 1, 0, 134, N'Pure Statisstics', N'برنامج الإحصاء الرياضى منفرد', 3)
GO
INSERT [dbo].[Program] ([ID], [Name], [Semester], [Percentage], [IsRegular], [IsGeneral], [TotalHours], [EnglishName], [ArabicName], [SuperProgramID]) VALUES (9, N'برنامج الإحصاء الرياضى والرياضات البحته', 3, 1, 1, 0, 140, N'Statistics & Mathmatics', N'برنامج الإحصاء الرياضى والرياضات البحته', 3)
GO
INSERT [dbo].[Program] ([ID], [Name], [Semester], [Percentage], [IsRegular], [IsGeneral], [TotalHours], [EnglishName], [ArabicName], [SuperProgramID]) VALUES (10, N'برنامج الكيمياء', 1, 0.2, 1, 1, 140, N'Chemistry', N'برنامج الكيمياء', NULL)
GO
SET IDENTITY_INSERT [dbo].[Program] OFF
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [PrerequisiteRelationID], [CourseType], [Category]) VALUES (5, 1, 0, 1, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [PrerequisiteRelationID], [CourseType], [Category]) VALUES (5, 2, 0, 1, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [PrerequisiteRelationID], [CourseType], [Category]) VALUES (5, 3, 0, 1, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [PrerequisiteRelationID], [CourseType], [Category]) VALUES (5, 4, 0, 1, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [PrerequisiteRelationID], [CourseType], [Category]) VALUES (5, 5, 0, 1, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [PrerequisiteRelationID], [CourseType], [Category]) VALUES (5, 6, 0, 1, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [PrerequisiteRelationID], [CourseType], [Category]) VALUES (5, 7, 1, 1, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [PrerequisiteRelationID], [CourseType], [Category]) VALUES (5, 8, 0, 1, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [PrerequisiteRelationID], [CourseType], [Category]) VALUES (5, 9, 0, 1, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [PrerequisiteRelationID], [CourseType], [Category]) VALUES (5, 10, 1, 1, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [PrerequisiteRelationID], [CourseType], [Category]) VALUES (5, 11, 1, 1, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [PrerequisiteRelationID], [CourseType], [Category]) VALUES (5, 12, 1, 1, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [PrerequisiteRelationID], [CourseType], [Category]) VALUES (5, 13, 0, 1, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [PrerequisiteRelationID], [CourseType], [Category]) VALUES (5, 14, 0, 1, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [PrerequisiteRelationID], [CourseType], [Category]) VALUES (5, 15, 1, 1, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [PrerequisiteRelationID], [CourseType], [Category]) VALUES (5, 16, 0, 1, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [PrerequisiteRelationID], [CourseType], [Category]) VALUES (5, 17, 0, 1, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [PrerequisiteRelationID], [CourseType], [Category]) VALUES (5, 18, 2, 1, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [PrerequisiteRelationID], [CourseType], [Category]) VALUES (5, 19, 0, 1, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [PrerequisiteRelationID], [CourseType], [Category]) VALUES (5, 20, 1, 1, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [PrerequisiteRelationID], [CourseType], [Category]) VALUES (5, 21, 0, 1, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [PrerequisiteRelationID], [CourseType], [Category]) VALUES (5, 22, 0, 1, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [PrerequisiteRelationID], [CourseType], [Category]) VALUES (5, 23, 0, 2, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [PrerequisiteRelationID], [CourseType], [Category]) VALUES (5, 24, 1, 2, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [PrerequisiteRelationID], [CourseType], [Category]) VALUES (5, 25, 0, 2, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [PrerequisiteRelationID], [CourseType], [Category]) VALUES (5, 26, 0, 2, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [PrerequisiteRelationID], [CourseType], [Category]) VALUES (5, 27, 1, 2, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [PrerequisiteRelationID], [CourseType], [Category]) VALUES (5, 28, 0, 1, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [PrerequisiteRelationID], [CourseType], [Category]) VALUES (5, 29, 2, 1, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [PrerequisiteRelationID], [CourseType], [Category]) VALUES (5, 30, 0, 1, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [PrerequisiteRelationID], [CourseType], [Category]) VALUES (5, 31, 1, 1, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [PrerequisiteRelationID], [CourseType], [Category]) VALUES (5, 32, 0, 1, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [PrerequisiteRelationID], [CourseType], [Category]) VALUES (5, 33, 0, 1, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [PrerequisiteRelationID], [CourseType], [Category]) VALUES (5, 34, 1, 1, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [PrerequisiteRelationID], [CourseType], [Category]) VALUES (5, 35, 0, 2, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [PrerequisiteRelationID], [CourseType], [Category]) VALUES (5, 36, 2, 2, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [PrerequisiteRelationID], [CourseType], [Category]) VALUES (5, 37, 2, 2, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [PrerequisiteRelationID], [CourseType], [Category]) VALUES (5, 38, 2, 2, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [PrerequisiteRelationID], [CourseType], [Category]) VALUES (5, 39, 0, 2, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [PrerequisiteRelationID], [CourseType], [Category]) VALUES (5, 40, 1, 2, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [PrerequisiteRelationID], [CourseType], [Category]) VALUES (5, 41, 1, 2, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [PrerequisiteRelationID], [CourseType], [Category]) VALUES (5, 42, 3, 2, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [PrerequisiteRelationID], [CourseType], [Category]) VALUES (5, 43, 1, 2, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [PrerequisiteRelationID], [CourseType], [Category]) VALUES (5, 45, 0, 3, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [PrerequisiteRelationID], [CourseType], [Category]) VALUES (5, 46, 0, 3, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [PrerequisiteRelationID], [CourseType], [Category]) VALUES (5, 47, 1, 3, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [PrerequisiteRelationID], [CourseType], [Category]) VALUES (5, 48, 0, 3, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [PrerequisiteRelationID], [CourseType], [Category]) VALUES (5, 49, 0, 3, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [PrerequisiteRelationID], [CourseType], [Category]) VALUES (5, 50, 0, 3, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [PrerequisiteRelationID], [CourseType], [Category]) VALUES (5, 51, 0, 3, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [PrerequisiteRelationID], [CourseType], [Category]) VALUES (5, 52, 0, 1, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [PrerequisiteRelationID], [CourseType], [Category]) VALUES (5, 53, 0, 1, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [PrerequisiteRelationID], [CourseType], [Category]) VALUES (5, 54, 0, 1, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [PrerequisiteRelationID], [CourseType], [Category]) VALUES (5, 56, 3, 2, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [PrerequisiteRelationID], [CourseType], [Category]) VALUES (5, 57, 0, 1, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [PrerequisiteRelationID], [CourseType], [Category]) VALUES (5, 65, 0, 2, 2)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [PrerequisiteRelationID], [CourseType], [Category]) VALUES (5, 72, 0, 2, 2)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [PrerequisiteRelationID], [CourseType], [Category]) VALUES (5, 83, 0, 1, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [PrerequisiteRelationID], [CourseType], [Category]) VALUES (5, 84, 0, 3, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [PrerequisiteRelationID], [CourseType], [Category]) VALUES (5, 85, 0, 3, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [PrerequisiteRelationID], [CourseType], [Category]) VALUES (5, 86, 0, 3, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [PrerequisiteRelationID], [CourseType], [Category]) VALUES (5, 87, 0, 1, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [PrerequisiteRelationID], [CourseType], [Category]) VALUES (5, 96, 0, 2, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [PrerequisiteRelationID], [CourseType], [Category]) VALUES (6, 44, 0, 1, 2)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [PrerequisiteRelationID], [CourseType], [Category]) VALUES (6, 52, 0, 1, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [PrerequisiteRelationID], [CourseType], [Category]) VALUES (6, 83, 0, 1, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [PrerequisiteRelationID], [CourseType], [Category]) VALUES (6, 1, 0, 1, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [PrerequisiteRelationID], [CourseType], [Category]) VALUES (6, 2, 0, 1, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [PrerequisiteRelationID], [CourseType], [Category]) VALUES (6, 87, 0, 1, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [PrerequisiteRelationID], [CourseType], [Category]) VALUES (6, 84, 0, 3, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [PrerequisiteRelationID], [CourseType], [Category]) VALUES (6, 50, 0, 3, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [PrerequisiteRelationID], [CourseType], [Category]) VALUES (6, 46, 0, 3, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [PrerequisiteRelationID], [CourseType], [Category]) VALUES (6, 51, 0, 3, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [PrerequisiteRelationID], [CourseType], [Category]) VALUES (6, 53, 0, 1, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [PrerequisiteRelationID], [CourseType], [Category]) VALUES (6, 54, 0, 1, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [PrerequisiteRelationID], [CourseType], [Category]) VALUES (6, 3, 0, 1, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [PrerequisiteRelationID], [CourseType], [Category]) VALUES (6, 4, 0, 1, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [PrerequisiteRelationID], [CourseType], [Category]) VALUES (6, 5, 0, 1, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [PrerequisiteRelationID], [CourseType], [Category]) VALUES (6, 47, 1, 3, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [PrerequisiteRelationID], [CourseType], [Category]) VALUES (6, 55, 0, 1, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [PrerequisiteRelationID], [CourseType], [Category]) VALUES (6, 57, 0, 1, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [PrerequisiteRelationID], [CourseType], [Category]) VALUES (6, 59, 0, 1, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [PrerequisiteRelationID], [CourseType], [Category]) VALUES (6, 6, 0, 1, 2)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [PrerequisiteRelationID], [CourseType], [Category]) VALUES (6, 12, 0, 1, 2)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [PrerequisiteRelationID], [CourseType], [Category]) VALUES (6, 56, 3, 1, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [PrerequisiteRelationID], [CourseType], [Category]) VALUES (6, 58, 0, 1, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [PrerequisiteRelationID], [CourseType], [Category]) VALUES (6, 60, 0, 2, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [PrerequisiteRelationID], [CourseType], [Category]) VALUES (6, 61, 0, 2, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [PrerequisiteRelationID], [CourseType], [Category]) VALUES (6, 62, 0, 2, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [PrerequisiteRelationID], [CourseType], [Category]) VALUES (6, 7, 1, 1, 2)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [PrerequisiteRelationID], [CourseType], [Category]) VALUES (6, 114, 1, 1, 2)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [PrerequisiteRelationID], [CourseType], [Category]) VALUES (6, 9, 0, 2, 2)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [PrerequisiteRelationID], [CourseType], [Category]) VALUES (6, 11, 1, 2, 2)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [PrerequisiteRelationID], [CourseType], [Category]) VALUES (6, 13, 0, 2, 2)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [PrerequisiteRelationID], [CourseType], [Category]) VALUES (6, 85, 0, 3, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [PrerequisiteRelationID], [CourseType], [Category]) VALUES (6, 63, 0, 1, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [PrerequisiteRelationID], [CourseType], [Category]) VALUES (6, 65, 0, 1, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [PrerequisiteRelationID], [CourseType], [Category]) VALUES (6, 67, 0, 2, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [PrerequisiteRelationID], [CourseType], [Category]) VALUES (6, 69, 0, 2, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [PrerequisiteRelationID], [CourseType], [Category]) VALUES (6, 70, 0, 2, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [PrerequisiteRelationID], [CourseType], [Category]) VALUES (6, 71, 0, 2, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [PrerequisiteRelationID], [CourseType], [Category]) VALUES (6, 19, 0, 1, 2)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [PrerequisiteRelationID], [CourseType], [Category]) VALUES (6, 21, 0, 1, 2)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [PrerequisiteRelationID], [CourseType], [Category]) VALUES (6, 17, 0, 2, 2)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [PrerequisiteRelationID], [CourseType], [Category]) VALUES (6, 23, 0, 2, 2)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [PrerequisiteRelationID], [CourseType], [Category]) VALUES (6, 25, 0, 2, 2)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [PrerequisiteRelationID], [CourseType], [Category]) VALUES (6, 115, 0, 2, 3)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [PrerequisiteRelationID], [CourseType], [Category]) VALUES (6, 48, 0, 3, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [PrerequisiteRelationID], [CourseType], [Category]) VALUES (6, 64, 0, 1, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [PrerequisiteRelationID], [CourseType], [Category]) VALUES (6, 66, 1, 1, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [PrerequisiteRelationID], [CourseType], [Category]) VALUES (6, 68, 0, 1, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [PrerequisiteRelationID], [CourseType], [Category]) VALUES (6, 16, 0, 1, 2)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [PrerequisiteRelationID], [CourseType], [Category]) VALUES (6, 22, 0, 1, 2)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [PrerequisiteRelationID], [CourseType], [Category]) VALUES (6, 18, 1, 2, 2)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [PrerequisiteRelationID], [CourseType], [Category]) VALUES (6, 20, 1, 2, 2)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [PrerequisiteRelationID], [CourseType], [Category]) VALUES (6, 86, 0, 3, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [PrerequisiteRelationID], [CourseType], [Category]) VALUES (6, 45, 0, 3, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [PrerequisiteRelationID], [CourseType], [Category]) VALUES (6, 49, 0, 3, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [PrerequisiteRelationID], [CourseType], [Category]) VALUES (6, 73, 0, 1, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [PrerequisiteRelationID], [CourseType], [Category]) VALUES (6, 75, 1, 1, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [PrerequisiteRelationID], [CourseType], [Category]) VALUES (6, 82, 0, 1, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [PrerequisiteRelationID], [CourseType], [Category]) VALUES (6, 78, 0, 2, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [PrerequisiteRelationID], [CourseType], [Category]) VALUES (6, 80, 0, 2, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [PrerequisiteRelationID], [CourseType], [Category]) VALUES (6, 81, 1, 2, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [PrerequisiteRelationID], [CourseType], [Category]) VALUES (6, 28, 0, 1, 2)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [PrerequisiteRelationID], [CourseType], [Category]) VALUES (6, 30, 0, 1, 2)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [PrerequisiteRelationID], [CourseType], [Category]) VALUES (6, 34, 1, 2, 2)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [PrerequisiteRelationID], [CourseType], [Category]) VALUES (6, 38, 2, 2, 2)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [PrerequisiteRelationID], [CourseType], [Category]) VALUES (6, 40, 1, 2, 2)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [PrerequisiteRelationID], [CourseType], [Category]) VALUES (6, 74, 1, 1, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [PrerequisiteRelationID], [CourseType], [Category]) VALUES (6, 76, 1, 1, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [PrerequisiteRelationID], [CourseType], [Category]) VALUES (6, 77, 1, 2, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [PrerequisiteRelationID], [CourseType], [Category]) VALUES (6, 79, 0, 2, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [PrerequisiteRelationID], [CourseType], [Category]) VALUES (6, 29, 2, 1, 2)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [PrerequisiteRelationID], [CourseType], [Category]) VALUES (6, 39, 1, 2, 2)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [PrerequisiteRelationID], [CourseType], [Category]) VALUES (6, 41, 1, 2, 2)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [PrerequisiteRelationID], [CourseType], [Category]) VALUES (6, 43, 1, 2, 2)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [PrerequisiteRelationID], [CourseType], [Category]) VALUES (7, 52, 0, 1, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [PrerequisiteRelationID], [CourseType], [Category]) VALUES (7, 83, 0, 1, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [PrerequisiteRelationID], [CourseType], [Category]) VALUES (7, 1, 0, 1, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [PrerequisiteRelationID], [CourseType], [Category]) VALUES (7, 2, 0, 1, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [PrerequisiteRelationID], [CourseType], [Category]) VALUES (7, 87, 0, 1, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [PrerequisiteRelationID], [CourseType], [Category]) VALUES (7, 84, 0, 3, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [PrerequisiteRelationID], [CourseType], [Category]) VALUES (7, 50, 0, 3, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [PrerequisiteRelationID], [CourseType], [Category]) VALUES (7, 46, 0, 3, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [PrerequisiteRelationID], [CourseType], [Category]) VALUES (7, 51, 0, 3, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [PrerequisiteRelationID], [CourseType], [Category]) VALUES (7, 53, 0, 1, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [PrerequisiteRelationID], [CourseType], [Category]) VALUES (7, 54, 0, 1, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [PrerequisiteRelationID], [CourseType], [Category]) VALUES (7, 3, 0, 1, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [PrerequisiteRelationID], [CourseType], [Category]) VALUES (7, 4, 0, 1, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [PrerequisiteRelationID], [CourseType], [Category]) VALUES (7, 88, 0, 1, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [PrerequisiteRelationID], [CourseType], [Category]) VALUES (7, 47, 1, 3, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [PrerequisiteRelationID], [CourseType], [Category]) VALUES (7, 89, 1, 1, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [PrerequisiteRelationID], [CourseType], [Category]) VALUES (7, 91, 1, 1, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [PrerequisiteRelationID], [CourseType], [Category]) VALUES (7, 93, 0, 1, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [PrerequisiteRelationID], [CourseType], [Category]) VALUES (7, 6, 0, 1, 2)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [PrerequisiteRelationID], [CourseType], [Category]) VALUES (7, 12, 0, 1, 2)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [PrerequisiteRelationID], [CourseType], [Category]) VALUES (7, 90, 1, 1, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [PrerequisiteRelationID], [CourseType], [Category]) VALUES (7, 92, 0, 1, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [PrerequisiteRelationID], [CourseType], [Category]) VALUES (7, 94, 0, 2, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [PrerequisiteRelationID], [CourseType], [Category]) VALUES (7, 95, 0, 2, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [PrerequisiteRelationID], [CourseType], [Category]) VALUES (7, 7, 1, 1, 2)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [PrerequisiteRelationID], [CourseType], [Category]) VALUES (7, 114, 1, 1, 2)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [PrerequisiteRelationID], [CourseType], [Category]) VALUES (7, 9, 0, 2, 2)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [PrerequisiteRelationID], [CourseType], [Category]) VALUES (7, 11, 1, 2, 2)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [PrerequisiteRelationID], [CourseType], [Category]) VALUES (7, 13, 0, 2, 2)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [PrerequisiteRelationID], [CourseType], [Category]) VALUES (7, 85, 0, 3, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [PrerequisiteRelationID], [CourseType], [Category]) VALUES (7, 97, 1, 1, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [PrerequisiteRelationID], [CourseType], [Category]) VALUES (7, 99, 1, 1, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [PrerequisiteRelationID], [CourseType], [Category]) VALUES (7, 101, 1, 2, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [PrerequisiteRelationID], [CourseType], [Category]) VALUES (7, 102, 1, 2, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [PrerequisiteRelationID], [CourseType], [Category]) VALUES (7, 104, 1, 2, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [PrerequisiteRelationID], [CourseType], [Category]) VALUES (7, 19, 0, 1, 2)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [PrerequisiteRelationID], [CourseType], [Category]) VALUES (7, 21, 0, 1, 2)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [PrerequisiteRelationID], [CourseType], [Category]) VALUES (7, 17, 0, 2, 2)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [PrerequisiteRelationID], [CourseType], [Category]) VALUES (7, 23, 0, 2, 2)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [PrerequisiteRelationID], [CourseType], [Category]) VALUES (7, 25, 0, 2, 2)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [PrerequisiteRelationID], [CourseType], [Category]) VALUES (7, 48, 0, 3, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [PrerequisiteRelationID], [CourseType], [Category]) VALUES (7, 98, 1, 1, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [PrerequisiteRelationID], [CourseType], [Category]) VALUES (7, 100, 0, 1, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [PrerequisiteRelationID], [CourseType], [Category]) VALUES (7, 103, 0, 1, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [PrerequisiteRelationID], [CourseType], [Category]) VALUES (7, 16, 0, 1, 2)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [PrerequisiteRelationID], [CourseType], [Category]) VALUES (7, 22, 0, 1, 2)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [PrerequisiteRelationID], [CourseType], [Category]) VALUES (7, 18, 2, 2, 2)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [PrerequisiteRelationID], [CourseType], [Category]) VALUES (7, 20, 1, 2, 2)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [PrerequisiteRelationID], [CourseType], [Category]) VALUES (7, 86, 0, 3, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [PrerequisiteRelationID], [CourseType], [Category]) VALUES (7, 45, 0, 3, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [PrerequisiteRelationID], [CourseType], [Category]) VALUES (7, 49, 0, 3, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [PrerequisiteRelationID], [CourseType], [Category]) VALUES (7, 105, 1, 1, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [PrerequisiteRelationID], [CourseType], [Category]) VALUES (7, 109, 1, 1, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [PrerequisiteRelationID], [CourseType], [Category]) VALUES (7, 107, 1, 2, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [PrerequisiteRelationID], [CourseType], [Category]) VALUES (7, 111, 1, 2, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [PrerequisiteRelationID], [CourseType], [Category]) VALUES (7, 28, 0, 1, 2)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [PrerequisiteRelationID], [CourseType], [Category]) VALUES (7, 30, 0, 1, 2)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [PrerequisiteRelationID], [CourseType], [Category]) VALUES (7, 34, 1, 2, 2)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [PrerequisiteRelationID], [CourseType], [Category]) VALUES (7, 38, 2, 2, 2)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [PrerequisiteRelationID], [CourseType], [Category]) VALUES (7, 40, 1, 2, 2)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [PrerequisiteRelationID], [CourseType], [Category]) VALUES (7, 106, 1, 1, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [PrerequisiteRelationID], [CourseType], [Category]) VALUES (7, 112, 1, 1, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [PrerequisiteRelationID], [CourseType], [Category]) VALUES (7, 113, 0, 1, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [PrerequisiteRelationID], [CourseType], [Category]) VALUES (7, 108, 1, 2, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [PrerequisiteRelationID], [CourseType], [Category]) VALUES (7, 110, 1, 2, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [PrerequisiteRelationID], [CourseType], [Category]) VALUES (7, 29, 2, 1, 2)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [PrerequisiteRelationID], [CourseType], [Category]) VALUES (7, 44, 0, 1, 2)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [PrerequisiteRelationID], [CourseType], [Category]) VALUES (7, 31, 1, 2, 2)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [PrerequisiteRelationID], [CourseType], [Category]) VALUES (7, 41, 1, 2, 2)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [PrerequisiteRelationID], [CourseType], [Category]) VALUES (7, 43, 1, 2, 2)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [PrerequisiteRelationID], [CourseType], [Category]) VALUES (1, 1, 0, 1, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [PrerequisiteRelationID], [CourseType], [Category]) VALUES (1, 2, 0, 1, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [PrerequisiteRelationID], [CourseType], [Category]) VALUES (1, 52, 0, 1, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [PrerequisiteRelationID], [CourseType], [Category]) VALUES (1, 83, 0, 1, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [PrerequisiteRelationID], [CourseType], [Category]) VALUES (1, 87, 0, 1, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [PrerequisiteRelationID], [CourseType], [Category]) VALUES (1, 50, 0, 3, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [PrerequisiteRelationID], [CourseType], [Category]) VALUES (1, 84, 0, 3, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [PrerequisiteRelationID], [CourseType], [Category]) VALUES (2, 3, 0, 1, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [PrerequisiteRelationID], [CourseType], [Category]) VALUES (2, 4, 0, 1, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [PrerequisiteRelationID], [CourseType], [Category]) VALUES (2, 5, 0, 1, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [PrerequisiteRelationID], [CourseType], [Category]) VALUES (2, 53, 0, 1, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [PrerequisiteRelationID], [CourseType], [Category]) VALUES (2, 54, 0, 1, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [PrerequisiteRelationID], [CourseType], [Category]) VALUES (2, 46, 0, 3, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [PrerequisiteRelationID], [CourseType], [Category]) VALUES (2, 51, 0, 3, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [PrerequisiteRelationID], [CourseType], [Category]) VALUES (3, 3, 0, 1, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [PrerequisiteRelationID], [CourseType], [Category]) VALUES (3, 4, 0, 1, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [PrerequisiteRelationID], [CourseType], [Category]) VALUES (3, 53, 0, 1, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [PrerequisiteRelationID], [CourseType], [Category]) VALUES (3, 54, 0, 1, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [PrerequisiteRelationID], [CourseType], [Category]) VALUES (3, 88, 0, 1, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [PrerequisiteRelationID], [CourseType], [Category]) VALUES (3, 46, 0, 3, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [PrerequisiteRelationID], [CourseType], [Category]) VALUES (3, 51, 0, 3, 1)
GO
INSERT [dbo].[ProgramDistribution] ([ProgramID], [Level], [Semester], [NumberOfHours]) VALUES (1, 1, 1, 16)
GO
INSERT [dbo].[ProgramDistribution] ([ProgramID], [Level], [Semester], [NumberOfHours]) VALUES (2, 1, 2, 17)
GO
INSERT [dbo].[ProgramDistribution] ([ProgramID], [Level], [Semester], [NumberOfHours]) VALUES (3, 1, 2, 17)
GO
INSERT [dbo].[ProgramDistribution] ([ProgramID], [Level], [Semester], [NumberOfHours]) VALUES (4, 1, 1, 16)
GO
INSERT [dbo].[ProgramDistribution] ([ProgramID], [Level], [Semester], [NumberOfHours]) VALUES (4, 1, 2, 17)
GO
INSERT [dbo].[ProgramDistribution] ([ProgramID], [Level], [Semester], [NumberOfHours]) VALUES (4, 2, 1, 18)
GO
INSERT [dbo].[ProgramDistribution] ([ProgramID], [Level], [Semester], [NumberOfHours]) VALUES (4, 2, 2, 16)
GO
INSERT [dbo].[ProgramDistribution] ([ProgramID], [Level], [Semester], [NumberOfHours]) VALUES (4, 3, 1, 17)
GO
INSERT [dbo].[ProgramDistribution] ([ProgramID], [Level], [Semester], [NumberOfHours]) VALUES (4, 3, 2, 17)
GO
INSERT [dbo].[ProgramDistribution] ([ProgramID], [Level], [Semester], [NumberOfHours]) VALUES (4, 4, 1, 17)
GO
INSERT [dbo].[ProgramDistribution] ([ProgramID], [Level], [Semester], [NumberOfHours]) VALUES (4, 4, 2, 16)
GO
INSERT [dbo].[ProgramDistribution] ([ProgramID], [Level], [Semester], [NumberOfHours]) VALUES (5, 1, 1, 16)
GO
INSERT [dbo].[ProgramDistribution] ([ProgramID], [Level], [Semester], [NumberOfHours]) VALUES (5, 1, 2, 17)
GO
INSERT [dbo].[ProgramDistribution] ([ProgramID], [Level], [Semester], [NumberOfHours]) VALUES (5, 2, 1, 17)
GO
INSERT [dbo].[ProgramDistribution] ([ProgramID], [Level], [Semester], [NumberOfHours]) VALUES (5, 2, 2, 17)
GO
INSERT [dbo].[ProgramDistribution] ([ProgramID], [Level], [Semester], [NumberOfHours]) VALUES (5, 3, 1, 17)
GO
INSERT [dbo].[ProgramDistribution] ([ProgramID], [Level], [Semester], [NumberOfHours]) VALUES (5, 3, 2, 16)
GO
INSERT [dbo].[ProgramDistribution] ([ProgramID], [Level], [Semester], [NumberOfHours]) VALUES (5, 4, 1, 18)
GO
INSERT [dbo].[ProgramDistribution] ([ProgramID], [Level], [Semester], [NumberOfHours]) VALUES (5, 4, 2, 16)
GO
INSERT [dbo].[ProgramDistribution] ([ProgramID], [Level], [Semester], [NumberOfHours]) VALUES (6, 1, 1, 16)
GO
INSERT [dbo].[ProgramDistribution] ([ProgramID], [Level], [Semester], [NumberOfHours]) VALUES (6, 1, 2, 17)
GO
INSERT [dbo].[ProgramDistribution] ([ProgramID], [Level], [Semester], [NumberOfHours]) VALUES (6, 2, 1, 18)
GO
INSERT [dbo].[ProgramDistribution] ([ProgramID], [Level], [Semester], [NumberOfHours]) VALUES (6, 2, 2, 17)
GO
INSERT [dbo].[ProgramDistribution] ([ProgramID], [Level], [Semester], [NumberOfHours]) VALUES (6, 3, 1, 18)
GO
INSERT [dbo].[ProgramDistribution] ([ProgramID], [Level], [Semester], [NumberOfHours]) VALUES (6, 3, 2, 17)
GO
INSERT [dbo].[ProgramDistribution] ([ProgramID], [Level], [Semester], [NumberOfHours]) VALUES (6, 4, 1, 19)
GO
INSERT [dbo].[ProgramDistribution] ([ProgramID], [Level], [Semester], [NumberOfHours]) VALUES (6, 4, 2, 18)
GO
INSERT [dbo].[ProgramDistribution] ([ProgramID], [Level], [Semester], [NumberOfHours]) VALUES (7, 1, 1, 16)
GO
INSERT [dbo].[ProgramDistribution] ([ProgramID], [Level], [Semester], [NumberOfHours]) VALUES (7, 1, 2, 17)
GO
INSERT [dbo].[ProgramDistribution] ([ProgramID], [Level], [Semester], [NumberOfHours]) VALUES (7, 2, 1, 18)
GO
INSERT [dbo].[ProgramDistribution] ([ProgramID], [Level], [Semester], [NumberOfHours]) VALUES (7, 2, 2, 18)
GO
INSERT [dbo].[ProgramDistribution] ([ProgramID], [Level], [Semester], [NumberOfHours]) VALUES (7, 3, 1, 18)
GO
INSERT [dbo].[ProgramDistribution] ([ProgramID], [Level], [Semester], [NumberOfHours]) VALUES (7, 3, 2, 17)
GO
INSERT [dbo].[ProgramDistribution] ([ProgramID], [Level], [Semester], [NumberOfHours]) VALUES (7, 4, 1, 18)
GO
INSERT [dbo].[ProgramDistribution] ([ProgramID], [Level], [Semester], [NumberOfHours]) VALUES (7, 4, 2, 18)
GO
INSERT [dbo].[ProgramDistribution] ([ProgramID], [Level], [Semester], [NumberOfHours]) VALUES (8, 1, 1, 16)
GO
INSERT [dbo].[ProgramDistribution] ([ProgramID], [Level], [Semester], [NumberOfHours]) VALUES (8, 1, 2, 17)
GO
INSERT [dbo].[ProgramDistribution] ([ProgramID], [Level], [Semester], [NumberOfHours]) VALUES (8, 2, 1, 17)
GO
INSERT [dbo].[ProgramDistribution] ([ProgramID], [Level], [Semester], [NumberOfHours]) VALUES (8, 2, 2, 17)
GO
INSERT [dbo].[ProgramDistribution] ([ProgramID], [Level], [Semester], [NumberOfHours]) VALUES (8, 3, 1, 16)
GO
INSERT [dbo].[ProgramDistribution] ([ProgramID], [Level], [Semester], [NumberOfHours]) VALUES (8, 3, 2, 16)
GO
INSERT [dbo].[ProgramDistribution] ([ProgramID], [Level], [Semester], [NumberOfHours]) VALUES (8, 4, 1, 18)
GO
INSERT [dbo].[ProgramDistribution] ([ProgramID], [Level], [Semester], [NumberOfHours]) VALUES (8, 4, 2, 17)
GO
INSERT [dbo].[ProgramDistribution] ([ProgramID], [Level], [Semester], [NumberOfHours]) VALUES (9, 1, 1, 16)
GO
INSERT [dbo].[ProgramDistribution] ([ProgramID], [Level], [Semester], [NumberOfHours]) VALUES (9, 1, 2, 17)
GO
INSERT [dbo].[ProgramDistribution] ([ProgramID], [Level], [Semester], [NumberOfHours]) VALUES (9, 2, 1, 18)
GO
INSERT [dbo].[ProgramDistribution] ([ProgramID], [Level], [Semester], [NumberOfHours]) VALUES (9, 2, 2, 17)
GO
INSERT [dbo].[ProgramDistribution] ([ProgramID], [Level], [Semester], [NumberOfHours]) VALUES (9, 3, 1, 18)
GO
INSERT [dbo].[ProgramDistribution] ([ProgramID], [Level], [Semester], [NumberOfHours]) VALUES (9, 3, 2, 17)
GO
INSERT [dbo].[ProgramDistribution] ([ProgramID], [Level], [Semester], [NumberOfHours]) VALUES (9, 4, 1, 19)
GO
INSERT [dbo].[ProgramDistribution] ([ProgramID], [Level], [Semester], [NumberOfHours]) VALUES (9, 4, 2, 18)
GO
SET IDENTITY_INSERT [dbo].[Student] ON 
GO
INSERT [dbo].[Student] ([ID], [GUID], [Name], [SSN], [PhoneNumber], [BirthDate], [Address], [Gender], [Nationality], [Email], [Password], [AcademicCode], [SeatNumber], [AvailableCredits], [SupervisorID], [CreatedOn], [IsCrossStudent], [SemestersNumberInProgram], [Rank], [IsActive], [CurrentProgramID], [AvailableWithdraws], [AvailableEnhancementCredits]) VALUES (5, N'94A552CF-AF8D-402A-AB9D-F37D11220E97', N'مؤمن عصام عرفه', N'30105050106293', N'01021179969', CAST(N'2001-05-05' AS Date), N'26 شارع راضى سليم الاول - الزيتون - القاهره', N'1', N'مصرى', N'30105050106293@sci.asu.edu.eg', N'0FBC1FB9CDE268DF12C8CE7A0CF5847B9D1246F76D994A335EBBE0068D777BF00641A9CF776BEF92DBBC4A9B9389095D7ABAFECF9560BC8BD42FD5AA3564DE8C', N'190691', N'190691', 9, 2, CAST(N'2022-11-27T00:00:00' AS SmallDateTime), 0, 8, 3, 1, 5, 8, 8)
GO
INSERT [dbo].[Student] ([ID], [GUID], [Name], [SSN], [PhoneNumber], [BirthDate], [Address], [Gender], [Nationality], [Email], [Password], [AcademicCode], [SeatNumber], [AvailableCredits], [SupervisorID], [CreatedOn], [IsCrossStudent], [SemestersNumberInProgram], [Rank], [IsActive], [CurrentProgramID], [AvailableWithdraws], [AvailableEnhancementCredits]) VALUES (8, N'5A0F826F-770A-44FA-BE66-62721E55D5F1', N'جرجس اشرف فكرى', N'30109272102534', N'01033916944', CAST(N'2001-09-27' AS Date), N'11 شارع كمال احمد منصور - ارض اللواء  العجوزة - الجيزة', N'1', N'مصرى', N'30109272102534@sci.asu.edu.eg', N'113407A1FFA2461A74B42B7078589B87EB6B66EEAEF67778FFF0A3DE3DD09A460B2D17BFBA9AB924CBB3060E97B684DC4DBCE353462B0C1464F9EC55324580EC', N'190114', N'190114', 12, 2, CAST(N'2022-11-27T00:00:00' AS SmallDateTime), 0, 8, 1, 1, 5, 8, 8)
GO
INSERT [dbo].[Student] ([ID], [GUID], [Name], [SSN], [PhoneNumber], [BirthDate], [Address], [Gender], [Nationality], [Email], [Password], [AcademicCode], [SeatNumber], [AvailableCredits], [SupervisorID], [CreatedOn], [IsCrossStudent], [SemestersNumberInProgram], [Rank], [IsActive], [CurrentProgramID], [AvailableWithdraws], [AvailableEnhancementCredits]) VALUES (11, N'03CBB008-52E8-4904-BDC4-70AD821E4388', N'جوفانى نادى ذكرى', N'30105120101332', N'01227901024', CAST(N'2001-05-12' AS Date), N'عين شمس', N'1', N'مصرى', N'30105120101332@sci.asu.edu.eg', N'0FBC1FB9CDE268DF12C8CE7A0CF5847B9D1246F76D994A335EBBE0068D777BF00641A9CF776BEF92DBBC4A9B9389095D7ABAFECF9560BC8BD42FD5AA3564DE8C', N'190552', N'190552', 8, 2, CAST(N'2022-11-27T00:00:00' AS SmallDateTime), 0, 8, NULL, 1, 5, 8, 8)
GO
INSERT [dbo].[Student] ([ID], [GUID], [Name], [SSN], [PhoneNumber], [BirthDate], [Address], [Gender], [Nationality], [Email], [Password], [AcademicCode], [SeatNumber], [AvailableCredits], [SupervisorID], [CreatedOn], [IsCrossStudent], [SemestersNumberInProgram], [Rank], [IsActive], [CurrentProgramID], [AvailableWithdraws], [AvailableEnhancementCredits]) VALUES (12, N'2B6289DA-B16C-49B2-BF48-CCF5D5B5B433', N'يوسف طارق مسعود', N'30101150105477', N'01278552284', CAST(N'2001-01-15' AS Date), N'7916 شارع المدينة المنورة متفرع من شارع 9 المقطم', N'1', N'مصرى', N'30101150105477@sci.asu.edu.eg', N'0FBC1FB9CDE268DF12C8CE7A0CF5847B9D1246F76D994A335EBBE0068D777BF00641A9CF776BEF92DBBC4A9B9389095D7ABAFECF9560BC8BD42FD5AA3564DE8C', N'190823', N'190823', 9, 2, CAST(N'2022-11-28T00:00:00' AS SmallDateTime), 0, 8, 3, 1, 5, 8, 8)
GO
INSERT [dbo].[Student] ([ID], [GUID], [Name], [SSN], [PhoneNumber], [BirthDate], [Address], [Gender], [Nationality], [Email], [Password], [AcademicCode], [SeatNumber], [AvailableCredits], [SupervisorID], [CreatedOn], [IsCrossStudent], [SemestersNumberInProgram], [Rank], [IsActive], [CurrentProgramID], [AvailableWithdraws], [AvailableEnhancementCredits]) VALUES (13, N'FFEDC23A-8946-423D-AAFB-34D19EC18C64', N'ملك محمد عبدالحميد', N'30106190104688', N'01023883386', CAST(N'2001-06-19' AS Date), N'الزاوية', N'2', N'مصرى', N'30106190104688@sci.asu.edu.eg', N'0FBC1FB9CDE268DF12C8CE7A0CF5847B9D1246F76D994A335EBBE0068D777BF00641A9CF776BEF92DBBC4A9B9389095D7ABAFECF9560BC8BD42FD5AA3564DE8C', N'190787', N'190787', 0, 2, CAST(N'2022-11-28T00:00:00' AS SmallDateTime), 0, 8, 1, 1, 6, 8, 8)
GO
INSERT [dbo].[Student] ([ID], [GUID], [Name], [SSN], [PhoneNumber], [BirthDate], [Address], [Gender], [Nationality], [Email], [Password], [AcademicCode], [SeatNumber], [AvailableCredits], [SupervisorID], [CreatedOn], [IsCrossStudent], [SemestersNumberInProgram], [Rank], [IsActive], [CurrentProgramID], [AvailableWithdraws], [AvailableEnhancementCredits]) VALUES (14, N'D0CCA8BC-0736-4298-98D6-994E01EF3EDE', N'جنه محمود حميده', N'30010282102447', N'01141733612', CAST(N'2000-10-28' AS Date), N'الهرم', N'2', N'مصرى', N'30010282102447@sci.asu.edu.eg', N'0FBC1FB9CDE268DF12C8CE7A0CF5847B9D1246F76D994A335EBBE0068D777BF00641A9CF776BEF92DBBC4A9B9389095D7ABAFECF9560BC8BD42FD5AA3564DE8C', N'190111', N'190111', 2, 2, CAST(N'2022-11-28T00:00:00' AS SmallDateTime), 0, 8, 1, 1, 7, 8, 8)
GO
INSERT [dbo].[Student] ([ID], [GUID], [Name], [SSN], [PhoneNumber], [BirthDate], [Address], [Gender], [Nationality], [Email], [Password], [AcademicCode], [SeatNumber], [AvailableCredits], [SupervisorID], [CreatedOn], [IsCrossStudent], [SemestersNumberInProgram], [Rank], [IsActive], [CurrentProgramID], [AvailableWithdraws], [AvailableEnhancementCredits]) VALUES (18, N'98F9F7E1-59DE-4AE0-B52A-FFC731D02253', N'محمود سالم فاروق', N'29612121014574', N'01000000013', CAST(N'1996-12-12' AS Date), N'القاهرة', N'1', N'مصرى', N'29612121014574@sci.asu.edu.eg', N'0FBC1FB9CDE268DF12C8CE7A0CF5847B9D1246F76D994A335EBBE0068D777BF00641A9CF776BEF92DBBC4A9B9389095D7ABAFECF9560BC8BD42FD5AA3564DE8C', N'150123', N'150123', 0, 2, CAST(N'2022-11-29T00:00:00' AS SmallDateTime), 0, 13, 5, 1, 5, 8, 8)
GO
INSERT [dbo].[Student] ([ID], [GUID], [Name], [SSN], [PhoneNumber], [BirthDate], [Address], [Gender], [Nationality], [Email], [Password], [AcademicCode], [SeatNumber], [AvailableCredits], [SupervisorID], [CreatedOn], [IsCrossStudent], [SemestersNumberInProgram], [Rank], [IsActive], [CurrentProgramID], [AvailableWithdraws], [AvailableEnhancementCredits]) VALUES (19, N'44B6F0C0-550C-4501-982E-5ABFB287BE3B', N'طالب مستوى اول', N'22222214562145', N'01000000014', CAST(N'2005-05-05' AS Date), N'القاهرة', N'1', N'مصرى', N'22222214562145@sci.asu.edu.eg', N'0FBC1FB9CDE268DF12C8CE7A0CF5847B9D1246F76D994A335EBBE0068D777BF00641A9CF776BEF92DBBC4A9B9389095D7ABAFECF9560BC8BD42FD5AA3564DE8C', N'140140', N'140140', 12, 2, CAST(N'2022-12-06T00:00:00' AS SmallDateTime), 0, 2, NULL, 1, 1, 8, 8)
GO
INSERT [dbo].[Student] ([ID], [GUID], [Name], [SSN], [PhoneNumber], [BirthDate], [Address], [Gender], [Nationality], [Email], [Password], [AcademicCode], [SeatNumber], [AvailableCredits], [SupervisorID], [CreatedOn], [IsCrossStudent], [SemestersNumberInProgram], [Rank], [IsActive], [CurrentProgramID], [AvailableWithdraws], [AvailableEnhancementCredits]) VALUES (27, N'bd5d3e03-5f3c-423e-8338-126106db5b3d', N'احمد محمد شاكر', N'30101012145214', N'12345678912', CAST(N'2001-01-01' AS Date), N'Address', N'1', N'مصرى', N'30101012145214@sci.asu.edu.eg', N'0FBC1FB9CDE268DF12C8CE7A0CF5847B9D1246F76D994A335EBBE0068D777BF00641A9CF776BEF92DBBC4A9B9389095D7ABAFECF9560BC8BD42FD5AA3564DE8C', N'152025', N'33333', 1, 2, CAST(N'2023-02-10T16:15:00' AS SmallDateTime), 0, 0, NULL, 1, 5, 8, 8)
GO
INSERT [dbo].[Student] ([ID], [GUID], [Name], [SSN], [PhoneNumber], [BirthDate], [Address], [Gender], [Nationality], [Email], [Password], [AcademicCode], [SeatNumber], [AvailableCredits], [SupervisorID], [CreatedOn], [IsCrossStudent], [SemestersNumberInProgram], [Rank], [IsActive], [CurrentProgramID], [AvailableWithdraws], [AvailableEnhancementCredits]) VALUES (28, N'b7b60b00-f697-4b9b-8ac6-983b331ed08f', N'علي سعيد علي عبد الجليل', N'30204021235412', N'12345678912', CAST(N'2002-04-02' AS Date), N'Address', N'1', N'مصرى', N'30204021235412@sci.asu.edu.eg', N'0FBC1FB9CDE268DF12C8CE7A0CF5847B9D1246F76D994A335EBBE0068D777BF00641A9CF776BEF92DBBC4A9B9389095D7ABAFECF9560BC8BD42FD5AA3564DE8C', N'125423', N'11111', 1, 2, CAST(N'2023-02-10T16:31:00' AS SmallDateTime), 0, 0, NULL, 1, 5, 8, 8)
GO
INSERT [dbo].[Student] ([ID], [GUID], [Name], [SSN], [PhoneNumber], [BirthDate], [Address], [Gender], [Nationality], [Email], [Password], [AcademicCode], [SeatNumber], [AvailableCredits], [SupervisorID], [CreatedOn], [IsCrossStudent], [SemestersNumberInProgram], [Rank], [IsActive], [CurrentProgramID], [AvailableWithdraws], [AvailableEnhancementCredits]) VALUES (29, N'52d2752d-bdc6-470f-bb11-310932ed51e4', N'A', N'30101092101478', N'12345678912', CAST(N'2001-01-09' AS Date), N'Address', N'1', N'مصرى', N'30101092101478@sci.asu.edu.eg', N'0FBC1FB9CDE268DF12C8CE7A0CF5847B9D1246F76D994A335EBBE0068D777BF00641A9CF776BEF92DBBC4A9B9389095D7ABAFECF9560BC8BD42FD5AA3564DE8C', N'124957', N'11201', 0, NULL, CAST(N'2023-02-10T19:59:00' AS SmallDateTime), 0, 0, NULL, 1, 5, 8, 8)
GO
INSERT [dbo].[Student] ([ID], [GUID], [Name], [SSN], [PhoneNumber], [BirthDate], [Address], [Gender], [Nationality], [Email], [Password], [AcademicCode], [SeatNumber], [AvailableCredits], [SupervisorID], [CreatedOn], [IsCrossStudent], [SemestersNumberInProgram], [Rank], [IsActive], [CurrentProgramID], [AvailableWithdraws], [AvailableEnhancementCredits]) VALUES (30, N'CFE18760-3020-40D2-BDF3-865D847A373B', N'اسلام امير بدوى ابوالحمد', N'30201130105335', N'01125036756', CAST(N'2002-01-13' AS Date), N'شبرا الخيمه', N'1', N'مصرى', N'30201130105335@sci.asu.edu.eg', N'0FBC1FB9CDE268DF12C8CE7A0CF5847B9D1246F76D994A335EBBE0068D777BF00641A9CF776BEF92DBBC4A9B9389095D7ABAFECF9560BC8BD42FD5AA3564DE8C', N'147201', N'332011', 2, 2, CAST(N'2023-02-11T00:00:00' AS SmallDateTime), 0, 8, NULL, 1, 7, 8, 8)
GO
SET IDENTITY_INSERT [dbo].[Student] OFF
GO
INSERT [dbo].[StudentCourseRequest] ([RequestID], [RequestTypeID], [StudentID], [CourseID], [IsApproved], [CourseOperationID]) VALUES (N'8787', 1, 8, 72, 1, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (5, 28, 119, NULL, NULL, NULL, NULL, N'B', 3, 1, 1, 1, 1, 0, 19, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (5, 30, 116, NULL, NULL, NULL, NULL, N'B', 3, 1, 1, 1, 1, 0, 19, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (5, 34, 124, NULL, NULL, NULL, NULL, N'B+', 3.33, 1, 1, 1, 1, 0, 19, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (5, 32, 88, NULL, NULL, NULL, NULL, N'A-', 3.67, 1, 1, 1, 1, 0, 19, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (5, 36, 111, NULL, NULL, NULL, NULL, N'C+', 2.67, 1, 1, 1, 1, 0, 19, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (5, 38, 116, NULL, NULL, NULL, NULL, N'B', 3, 1, 1, 1, 1, 0, 19, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (5, 86, 42, NULL, NULL, NULL, NULL, N'B+', 3.33, 1, 1, 1, 1, 0, 19, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (8, 28, 125, NULL, NULL, NULL, NULL, N'B+', 3.33, 1, 1, 1, 1, 0, 19, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (8, 30, 134, NULL, NULL, NULL, NULL, N'A-', 3.67, 1, 1, 1, 1, 0, 19, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (8, 34, 136, NULL, NULL, NULL, NULL, N'A', 4, 1, 1, 1, 1, 0, 19, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (8, 32, 91, NULL, NULL, NULL, NULL, N'A', 4, 1, 1, 1, 1, 0, 19, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (8, 36, 137, NULL, NULL, NULL, NULL, N'A', 4, 1, 1, 1, 1, 0, 19, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (8, 38, 123, NULL, NULL, NULL, NULL, N'B+', 3.33, 1, 1, 1, 1, 0, 19, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (8, 86, 47, NULL, NULL, NULL, NULL, N'A', 4, 1, 1, 1, 1, 0, 19, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (5, 29, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, 1, 1, 0, 20, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (5, 1, 119, NULL, NULL, NULL, NULL, N'B', 3, 1, 1, 1, 1, 0, 10, 1, NULL, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (5, 2, 49, NULL, NULL, NULL, NULL, N'A', 4, 1, 1, 1, 1, 0, 10, 1, NULL, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (5, 50, 37, NULL, NULL, NULL, NULL, N'P', 0, 1, 0, 1, 1, 0, 10, 1, NULL, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (5, 52, 148, NULL, NULL, NULL, NULL, N'C+', 2.67, 1, 1, 1, 1, 0, 10, 1, NULL, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (5, 83, 147, NULL, NULL, NULL, NULL, N'C+', 2.67, 1, 1, 1, 1, 0, 10, 1, NULL, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (5, 84, 38, NULL, NULL, NULL, NULL, N'B', 3, 1, 1, 1, 1, 0, 10, 1, NULL, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (5, 87, 138, NULL, NULL, NULL, NULL, N'A', 4, 1, 1, 1, 1, 0, 10, 1, NULL, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (5, 3, NULL, NULL, NULL, NULL, NULL, N'P', 0, 1, 0, 1, 1, 0, 11, 1, NULL, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (5, 4, NULL, NULL, NULL, NULL, NULL, N'P', 0, 1, 0, 1, 1, 0, 11, 1, NULL, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (5, 5, NULL, NULL, NULL, NULL, NULL, N'P', 0, 1, 0, 1, 1, 0, 11, 1, NULL, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (5, 46, NULL, NULL, NULL, NULL, NULL, N'P', 0, 1, 0, 1, 1, 0, 11, 1, NULL, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (5, 51, NULL, NULL, NULL, NULL, NULL, N'P', 0, 1, 0, 1, 1, 0, 11, 1, NULL, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (5, 53, NULL, NULL, NULL, NULL, NULL, N'P', 0, 1, 0, 1, 1, 0, 11, 1, NULL, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (5, 54, NULL, NULL, NULL, NULL, NULL, N'P', 0, 1, 0, 1, 1, 0, 11, 1, NULL, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (5, 6, 103, NULL, NULL, NULL, NULL, N'C', 2.33, 1, 1, 1, 1, 0, 13, 1, NULL, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (5, 8, 68, NULL, NULL, NULL, NULL, N'C', 2.33, 1, 1, 1, 1, 0, 13, 1, NULL, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (5, 10, 138, NULL, NULL, NULL, NULL, N'A', 4, 1, 1, 1, 1, 0, 13, 1, NULL, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (5, 12, 152, NULL, NULL, NULL, NULL, N'B', 3, 1, 1, 1, 1, 0, 13, 1, NULL, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (5, 47, 84, NULL, NULL, NULL, NULL, N'B+', 3.33, 1, 1, 1, 1, 0, 13, 1, NULL, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (5, 57, 90, NULL, NULL, NULL, NULL, N'D', 2, 1, 1, 1, 1, 0, 13, 1, NULL, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (5, 85, 41, NULL, NULL, NULL, NULL, N'B+', 3.33, 1, 1, 1, 1, 0, 13, 1, NULL, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (5, 7, 119, NULL, NULL, NULL, NULL, N'B', 3, 1, 1, 1, 1, 0, 14, 1, NULL, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (5, 9, 89, NULL, NULL, NULL, NULL, N'F', 0, 1, 1, 1, 1, 0, 14, 1, NULL, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (5, 11, 138, NULL, NULL, NULL, NULL, N'A', 4, 1, 1, 1, 1, 0, 14, 1, NULL, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (5, 13, 138, NULL, NULL, NULL, NULL, N'A', 4, 1, 1, 1, 1, 0, 14, 1, NULL, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (5, 14, 80, NULL, NULL, NULL, NULL, N'B+', 3.33, 1, 1, 1, 1, 0, 14, 1, NULL, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (5, 48, 44, NULL, NULL, NULL, NULL, N'A-', 3.67, 1, 1, 1, 1, 0, 14, 1, NULL, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (5, 56, 138, NULL, NULL, NULL, NULL, N'A', 4, 1, 1, 1, 1, 0, 14, 1, NULL, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (5, 15, 119, NULL, NULL, NULL, NULL, N'B', 3, 1, 1, 1, 1, 0, 16, 1, NULL, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (5, 17, 72, NULL, NULL, NULL, NULL, N'C+', 2.67, 1, 1, 1, 1, 0, 16, 1, NULL, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (5, 19, 96, NULL, NULL, NULL, NULL, N'D', 2, 1, 1, 1, 1, 0, 16, 1, NULL, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (5, 21, 119, NULL, NULL, NULL, NULL, N'B', 3, 1, 1, 1, 1, 0, 16, 1, NULL, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (5, 23, 68, NULL, NULL, NULL, NULL, N'C', 2.33, 1, 1, 1, 1, 0, 16, 1, NULL, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (5, 72, 119, NULL, NULL, NULL, NULL, N'B', 3, 1, 1, 1, 1, 0, 16, 1, NULL, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (5, 18, 112, NULL, NULL, NULL, NULL, N'C+', 2.67, 1, 1, 1, 1, 0, 17, 1, NULL, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (5, 20, 112, NULL, NULL, NULL, NULL, N'C+', 2.67, 1, 1, 1, 1, 0, 17, 1, NULL, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (5, 22, 119, NULL, NULL, NULL, NULL, N'B', 3, 1, 1, 1, 1, 0, 17, 1, NULL, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (5, 24, 92, NULL, NULL, NULL, NULL, N'A', 4, 1, 1, 1, 1, 0, 17, 1, NULL, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (5, 27, 92, NULL, NULL, NULL, NULL, N'A', 4, 1, 1, 1, 1, 0, 17, 1, NULL, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (5, 9, 119, NULL, NULL, NULL, NULL, N'B', 3, 1, 1, 1, 2, 0, 17, 1, NULL, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (5, 16, 72, NULL, NULL, NULL, NULL, N'C+', 2.67, 1, 1, 1, 1, 0, 18, 1, NULL, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (8, 1, 108, NULL, NULL, NULL, NULL, N'C+', 2.67, 1, 1, 1, 1, 0, 10, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (8, 2, 45, NULL, NULL, NULL, NULL, N'A', 4, 1, 1, 1, 1, 0, 10, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (8, 50, 35, NULL, NULL, NULL, NULL, N'P', 0, 1, 0, 1, 1, 0, 10, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (8, 52, 141, NULL, NULL, NULL, NULL, N'C+', 2.67, 1, 1, 1, 1, 0, 10, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (8, 83, 149, NULL, NULL, NULL, NULL, N'C+', 2.67, 1, 1, 1, 1, 0, 10, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (8, 84, 45, NULL, NULL, NULL, NULL, N'A', 4, 1, 1, 1, 1, 0, 10, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (8, 87, 122, NULL, NULL, NULL, NULL, N'B+', 3.33, 1, 1, 1, 1, 0, 10, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (8, 3, NULL, NULL, NULL, NULL, NULL, N'P', 0, 1, 0, 1, 1, 0, 11, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (8, 4, NULL, NULL, NULL, NULL, NULL, N'P', 0, 1, 0, 1, 1, 0, 11, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (8, 5, NULL, NULL, NULL, NULL, NULL, N'P', 0, 1, 0, 1, 1, 0, 11, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (8, 46, NULL, NULL, NULL, NULL, NULL, N'P', 0, 1, 0, 1, 1, 0, 11, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (8, 51, NULL, NULL, NULL, NULL, NULL, N'P', 0, 1, 0, 1, 1, 0, 11, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (8, 53, NULL, NULL, NULL, NULL, NULL, N'P', 0, 1, 0, 1, 1, 0, 11, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (8, 54, NULL, NULL, NULL, NULL, NULL, N'P', 0, 1, 0, 1, 1, 0, 11, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (8, 6, 102, NULL, NULL, NULL, NULL, N'C', 2.33, 1, 1, 1, 1, 0, 13, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (8, 8, 68, NULL, NULL, NULL, NULL, N'C', 2.33, 1, 1, 1, 1, 0, 13, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (8, 10, 149, NULL, NULL, NULL, NULL, N'A', 4, 1, 1, 1, 1, 0, 13, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (8, 12, 150, NULL, NULL, NULL, NULL, N'B', 3, 1, 1, 1, 1, 0, 13, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (8, 47, 88, NULL, NULL, NULL, NULL, N'A-', 3.67, 1, 1, 1, 1, 0, 13, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (8, 57, 95, NULL, NULL, NULL, NULL, N'D', 2, 1, 1, 1, 1, 0, 13, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (8, 7, 133, NULL, NULL, NULL, NULL, N'A-', 3.67, 1, 1, 1, 1, 0, 14, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (8, 9, 119, NULL, NULL, NULL, NULL, N'B', 3, 1, 1, 1, 1, 0, 14, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (8, 11, 131, NULL, NULL, NULL, NULL, N'A-', 3.67, 1, 1, 1, 1, 0, 14, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (8, 13, 141, NULL, NULL, NULL, NULL, N'A', 4, 1, 1, 1, 1, 0, 14, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (8, 14, 76, NULL, NULL, NULL, NULL, N'B', 3, 1, 1, 1, 1, 0, 14, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (8, 56, 139, NULL, NULL, NULL, NULL, N'A', 4, 1, 1, 1, 1, 0, 14, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (8, 15, 144, NULL, NULL, NULL, NULL, N'A', 4, 1, 1, 1, 1, 0, 16, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (8, 17, 71, NULL, NULL, NULL, NULL, N'C+', 2.67, 1, 1, 1, 1, 0, 16, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (8, 19, 106, NULL, NULL, NULL, NULL, N'C+', 2.67, 1, 1, 1, 1, 0, 16, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (8, 21, 119, NULL, NULL, NULL, NULL, N'B', 3, 1, 1, 1, 1, 0, 16, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (8, 23, 72, NULL, NULL, NULL, NULL, N'C+', 2.67, 1, 1, 1, 1, 0, 16, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (8, 72, 71, NULL, NULL, NULL, NULL, N'F', 0, 1, 1, 1, 1, 0, 16, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (8, 85, 48, NULL, NULL, NULL, NULL, N'A', 4, 1, 1, 1, 1, 0, 16, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (8, 18, 92, NULL, NULL, NULL, NULL, N'D', 2, 1, 1, 1, 1, 0, 17, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (8, 20, 117, NULL, NULL, NULL, NULL, N'B', 3, 1, 1, 1, 1, 0, 17, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (8, 22, 111, NULL, NULL, NULL, NULL, N'C+', 2.67, 1, 1, 1, 1, 0, 17, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (8, 24, 91, NULL, NULL, NULL, NULL, N'A', 4, 1, 1, 1, 1, 0, 17, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (8, 27, 90, NULL, NULL, NULL, NULL, N'A', 4, 1, 1, 1, 1, 0, 17, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (8, 48, 50, NULL, NULL, NULL, NULL, N'A', 4, 1, 1, 1, 1, 0, 17, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (8, 31, 127, NULL, NULL, NULL, NULL, N'B+', 3.33, 1, 1, 1, 1, 0, 18, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (13, 1, NULL, NULL, NULL, NULL, NULL, N'F', 0, 1, 1, 1, 1, 0, 10, 1, NULL, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (13, 2, NULL, NULL, NULL, NULL, NULL, N'A', 4, 1, 1, 1, 1, 0, 10, 1, NULL, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (13, 50, NULL, NULL, NULL, NULL, NULL, N'P', 0, 1, 0, 1, 1, 0, 10, 1, NULL, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (13, 52, NULL, NULL, NULL, NULL, NULL, N'D', 2, 1, 1, 1, 1, 0, 10, 1, NULL, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (13, 83, NULL, NULL, NULL, NULL, NULL, N'D', 2, 1, 1, 1, 1, 0, 10, 1, NULL, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (13, 84, NULL, NULL, NULL, NULL, NULL, N'C', 2.33, 1, 1, 1, 1, 0, 10, 1, NULL, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (13, 87, NULL, NULL, NULL, NULL, NULL, N'C', 2.33, 1, 1, 1, 1, 0, 10, 1, NULL, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (13, 3, NULL, NULL, NULL, NULL, NULL, N'P', 0, 1, 0, 1, 1, 0, 11, 1, NULL, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (13, 4, NULL, NULL, NULL, NULL, NULL, N'P', 0, 1, 0, 1, 1, 0, 11, 1, NULL, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (13, 46, NULL, NULL, NULL, NULL, NULL, N'P', 0, 1, 0, 1, 1, 0, 11, 1, NULL, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (13, 51, NULL, NULL, NULL, NULL, NULL, N'P', 0, 1, 0, 1, 1, 0, 11, 1, NULL, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (13, 53, NULL, NULL, NULL, NULL, NULL, N'P', 0, 1, 0, 1, 1, 0, 11, 1, NULL, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (13, 54, NULL, NULL, NULL, NULL, NULL, N'P', 0, 1, 0, 1, 1, 0, 11, 1, NULL, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (13, 1, NULL, NULL, NULL, NULL, NULL, N'B+', 3.33, 1, 1, 1, 2, 0, 12, 1, NULL, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (13, 6, NULL, NULL, NULL, NULL, NULL, N'F', 0, 1, 1, 1, 1, 0, 13, 1, NULL, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (13, 12, NULL, NULL, NULL, NULL, NULL, N'F', 0, 1, 1, 1, 1, 0, 13, 1, NULL, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (13, 47, NULL, NULL, NULL, NULL, NULL, N'B', 3, 1, 1, 1, 1, 0, 13, 1, NULL, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (13, 55, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, 1, 1, 0, 13, 1, NULL, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (13, 57, NULL, NULL, NULL, NULL, NULL, N'F', 0, 1, 1, 1, 1, 0, 13, 1, NULL, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (13, 59, NULL, NULL, NULL, NULL, NULL, N'F', 0, 1, 1, 1, 1, 0, 13, 1, NULL, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (13, 7, NULL, NULL, NULL, NULL, NULL, N'F', 0, 1, 1, 1, 1, 0, 14, 1, NULL, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (13, 114, NULL, NULL, NULL, NULL, NULL, N'C+', 2.67, 1, 1, 1, 1, 0, 14, 1, NULL, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (13, 56, NULL, NULL, NULL, NULL, NULL, N'A', 4, 1, 1, 1, 1, 0, 14, 1, NULL, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (13, 58, NULL, NULL, NULL, NULL, NULL, N'B', 3, 1, 1, 1, 1, 0, 14, 1, NULL, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (13, 6, NULL, NULL, NULL, NULL, NULL, N'C', 2.33, 1, 1, 1, 2, 0, 15, 1, NULL, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (13, 7, NULL, NULL, NULL, NULL, NULL, N'A-', 3.67, 1, 1, 1, 2, 0, 15, 1, NULL, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (13, 19, NULL, NULL, NULL, NULL, NULL, N'B', 3, 1, 1, 1, 1, 0, 16, 1, NULL, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (13, 23, NULL, NULL, NULL, NULL, NULL, N'F', 0, 1, 1, 1, 1, 0, 16, 1, NULL, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (13, 115, NULL, NULL, NULL, NULL, NULL, N'D', 2, 1, 1, 1, 1, 0, 16, 1, NULL, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (13, 63, NULL, NULL, NULL, NULL, NULL, N'F', 0, 1, 1, 1, 1, 0, 16, 1, NULL, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (13, 67, NULL, NULL, NULL, NULL, NULL, N'D', 2, 1, 1, 1, 1, 0, 16, 1, NULL, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (13, 85, NULL, NULL, NULL, NULL, NULL, N'B+', 3.33, 1, 1, 1, 1, 0, 16, 1, NULL, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (13, 13, NULL, NULL, NULL, NULL, NULL, N'B', 3, 1, 1, 1, 1, 0, 17, 1, NULL, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (13, 16, NULL, NULL, NULL, NULL, NULL, N'C', 2.33, 1, 1, 1, 1, 0, 17, 1, NULL, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (13, 20, NULL, NULL, NULL, NULL, NULL, N'B', 3, 1, 1, 1, 1, 0, 17, 1, NULL, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (13, 48, NULL, NULL, NULL, NULL, NULL, N'A', 4, 1, 1, 1, 1, 0, 17, 1, NULL, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (13, 64, NULL, NULL, NULL, NULL, NULL, N'C+', 2.67, 1, 1, 1, 1, 0, 17, 1, NULL, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (13, 22, NULL, NULL, NULL, NULL, NULL, N'C+', 2.67, 1, 1, 1, 1, 0, 18, 1, NULL, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (13, 57, NULL, NULL, NULL, NULL, NULL, N'B', 3, 1, 1, 1, 2, 0, 18, 1, NULL, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (14, 1, NULL, NULL, NULL, NULL, NULL, N'F', 0, 1, 1, 1, 1, 0, 10, 1, NULL, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (14, 2, NULL, NULL, NULL, NULL, NULL, N'A', 4, 1, 1, 1, 1, 0, 10, 1, NULL, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (14, 50, NULL, NULL, NULL, NULL, NULL, N'P', 0, 1, 0, 1, 1, 0, 10, 1, NULL, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (14, 52, NULL, NULL, NULL, NULL, NULL, N'D', 2, 1, 1, 1, 1, 0, 10, 1, NULL, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (14, 83, NULL, NULL, NULL, NULL, NULL, N'F', 0, 1, 1, 1, 1, 0, 10, 1, NULL, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (14, 84, NULL, NULL, NULL, NULL, NULL, N'B', 3, 1, 1, 1, 1, 0, 10, 1, NULL, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (14, 87, NULL, NULL, NULL, NULL, NULL, N'C+', 2.67, 1, 1, 1, 1, 0, 10, 1, NULL, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (14, 3, NULL, NULL, NULL, NULL, NULL, N'P', 0, 1, 0, 1, 1, 0, 11, 1, NULL, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (14, 4, NULL, NULL, NULL, NULL, NULL, N'P', 0, 1, 0, 1, 1, 0, 11, 1, NULL, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (14, 46, NULL, NULL, NULL, NULL, NULL, N'P', 0, 1, 0, 1, 1, 0, 11, 1, NULL, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (14, 51, NULL, NULL, NULL, NULL, NULL, N'P', 0, 1, 0, 1, 1, 0, 11, 1, NULL, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (14, 53, NULL, NULL, NULL, NULL, NULL, N'P', 0, 1, 0, 1, 1, 0, 11, 1, NULL, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (14, 54, NULL, NULL, NULL, NULL, NULL, N'P', 0, 1, 0, 1, 1, 0, 11, 1, NULL, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (14, 88, NULL, NULL, NULL, NULL, NULL, N'P', 0, 1, 0, 1, 1, 0, 11, 1, NULL, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (14, 1, NULL, NULL, NULL, NULL, NULL, N'C', 2.33, 1, 1, 1, 2, 0, 12, 1, NULL, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (14, 83, NULL, NULL, NULL, NULL, NULL, N'B', 3, 1, 1, 1, 2, 0, 12, 1, NULL, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (14, 6, NULL, NULL, NULL, NULL, NULL, N'D', 2, 1, 1, 1, 1, 0, 13, 1, NULL, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (14, 12, NULL, NULL, NULL, NULL, NULL, N'C+', 2.67, 1, 1, 1, 1, 0, 13, 1, NULL, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (14, 47, NULL, NULL, NULL, NULL, NULL, N'A', 4, 1, 1, 1, 1, 0, 13, 1, NULL, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (14, 89, NULL, NULL, NULL, NULL, NULL, N'F', 0, 1, 1, 1, 1, 0, 13, 1, NULL, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (14, 91, NULL, NULL, NULL, NULL, NULL, N'B+', 3.33, 1, 1, 1, 1, 0, 13, 1, NULL, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (14, 93, NULL, NULL, NULL, NULL, NULL, N'C+', 2.67, 1, 1, 1, 1, 0, 13, 1, NULL, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (14, 7, NULL, NULL, NULL, NULL, NULL, N'B', 3, 1, 1, 1, 1, 0, 14, 1, NULL, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (14, 13, NULL, NULL, NULL, NULL, NULL, N'A-', 3.67, 1, 1, 1, 1, 0, 14, 1, NULL, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (14, 114, NULL, NULL, NULL, NULL, NULL, N'A', 4, 1, 1, 1, 1, 0, 14, 1, NULL, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (14, 90, NULL, NULL, NULL, NULL, NULL, N'F', 0, 1, 1, 1, 1, 0, 14, 1, NULL, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (14, 92, NULL, NULL, NULL, NULL, NULL, N'B+', 3.33, 1, 1, 1, 1, 0, 14, 1, NULL, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (14, 95, NULL, NULL, NULL, NULL, NULL, N'F', 0, 1, 1, 1, 1, 0, 14, 1, NULL, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (14, 19, NULL, NULL, NULL, NULL, NULL, N'D', 2, 1, 1, 1, 1, 0, 16, 1, NULL, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (14, 21, NULL, NULL, NULL, NULL, NULL, N'D', 2, 1, 1, 1, 1, 0, 16, 1, NULL, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (14, 23, NULL, NULL, NULL, NULL, NULL, N'F', 0, 1, 1, 1, 1, 0, 16, 1, NULL, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (14, 85, NULL, NULL, NULL, NULL, NULL, N'B', 3, 1, 1, 1, 1, 0, 16, 1, NULL, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (14, 89, NULL, NULL, NULL, NULL, NULL, N'F', 0, 1, 1, 1, 2, 0, 16, 1, NULL, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (14, 99, NULL, NULL, NULL, NULL, NULL, N'F', 0, 1, 1, 1, 1, 0, 16, 1, NULL, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (14, 28, NULL, NULL, NULL, NULL, NULL, N'C', 2.33, 1, 1, 1, 1, 0, 16, 1, NULL, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (14, 16, NULL, NULL, NULL, NULL, NULL, N'D', 2, 1, 1, 1, 1, 0, 17, 1, NULL, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (14, 20, NULL, NULL, NULL, NULL, NULL, N'B', 3, 1, 1, 1, 1, 0, 17, 1, NULL, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (14, 48, NULL, NULL, NULL, NULL, NULL, N'A', 4, 1, 1, 1, 1, 0, 17, 1, NULL, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (14, 98, NULL, NULL, NULL, NULL, NULL, N'D', 2, 1, 1, 1, 1, 0, 17, 1, NULL, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (14, 103, NULL, NULL, NULL, NULL, NULL, N'C+', 2.67, 1, 1, 1, 1, 0, 17, 1, NULL, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (14, 22, NULL, NULL, NULL, NULL, NULL, N'B', 3, 1, 1, 1, 1, 0, 18, 1, NULL, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (14, 31, NULL, NULL, NULL, NULL, NULL, N'A-', 3.67, 1, 1, 1, 1, 0, 18, 1, NULL, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (8, 29, NULL, 100, 30, 5, NULL, NULL, NULL, 1, 1, 1, 1, 0, 20, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (8, 33, NULL, NULL, 60, 70, 70, NULL, NULL, 1, 1, 1, 1, 0, 20, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (8, 35, NULL, 100, 30, 5, NULL, NULL, NULL, 1, 1, 1, 1, 0, 20, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (12, 28, 113, NULL, NULL, NULL, NULL, N'B', 3, 1, 1, 1, 1, 0, 19, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (12, 30, 119, NULL, NULL, NULL, NULL, N'B', 3, 1, 1, 1, 1, 0, 19, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (12, 32, 84, NULL, NULL, NULL, NULL, N'B+', 3.33, 1, 1, 1, 1, 0, 19, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (12, 34, 132, NULL, NULL, NULL, NULL, N'A-', 3.67, 1, 1, 1, 1, 0, 19, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (12, 36, 129, NULL, NULL, NULL, NULL, N'A-', 3.67, 1, 1, 1, 1, 0, 19, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (12, 38, 125, NULL, NULL, NULL, NULL, N'B+', 3.33, 1, 1, 1, 1, 0, 19, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (12, 86, 39, NULL, NULL, NULL, NULL, N'B', 3, 1, 1, 1, 1, 0, 19, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (18, 1, 85, NULL, NULL, NULL, NULL, N'F', 0, 1, 1, 1, 1, 0, 1, 1, NULL, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (18, 2, 45, NULL, NULL, NULL, NULL, N'A', 4, 1, 1, 1, 1, 0, 1, 1, NULL, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (18, 50, 32, NULL, NULL, NULL, NULL, N'P', 0, 1, 0, 1, 1, 0, 1, 1, NULL, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (18, 52, 137, NULL, NULL, NULL, NULL, N'C', 2.33, 1, 1, 1, 1, 0, 1, 1, NULL, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (18, 83, 143, NULL, NULL, NULL, NULL, N'C+', 2.67, 1, 1, 1, 1, 0, 1, 1, NULL, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (18, 84, 41, NULL, NULL, NULL, NULL, N'B+', 3.33, 1, 1, 1, 1, 0, 1, 1, NULL, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (18, 87, 108, NULL, NULL, NULL, NULL, N'C+', 2.67, 1, 1, 1, 1, 0, 1, 1, NULL, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (18, 3, 114, NULL, NULL, NULL, NULL, N'B', 3, 1, 1, 1, 1, 0, 2, 1, NULL, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (18, 4, 107, NULL, NULL, NULL, NULL, N'C+', 2.67, 1, 1, 1, 1, 0, 2, 1, NULL, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (18, 46, 70, NULL, NULL, NULL, NULL, N'C+', 2.67, 1, 1, 1, 1, 0, 2, 1, NULL, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (18, 51, 32, NULL, NULL, NULL, NULL, N'P', 0, 1, 0, 1, 1, 0, 2, 1, NULL, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (18, 53, 67, NULL, NULL, NULL, NULL, N'F', 0, 1, 1, 1, 1, 0, 2, 1, NULL, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (18, 54, 92, NULL, NULL, NULL, NULL, N'D', 2, 1, 1, 1, 1, 0, 2, 1, NULL, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (18, 53, 57, NULL, NULL, NULL, NULL, N'F', 0, 1, 1, 1, 2, 0, 3, 1, NULL, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (18, 6, 81, NULL, NULL, NULL, NULL, N'F', 0, 1, 1, 1, 1, 0, 4, 1, NULL, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (18, 10, 90, NULL, NULL, NULL, NULL, N'D', 2, 1, 1, 1, 1, 0, 4, 1, NULL, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (18, 12, 128, NULL, NULL, NULL, NULL, N'D', 2, 1, 1, 1, 1, 0, 4, 1, NULL, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (18, 47, 77, NULL, NULL, NULL, NULL, N'B', 3, 1, 1, 1, 1, 0, 4, 1, NULL, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (18, 7, 90, NULL, NULL, NULL, NULL, N'D', 2, 1, 1, 1, 1, 0, 5, 1, NULL, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (18, 9, 116, NULL, NULL, NULL, NULL, N'B', 3, 1, 1, 1, 1, 0, 5, 1, NULL, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (18, 1, 82, NULL, NULL, NULL, NULL, N'F', 0, 1, 1, 1, 2, 0, 6, 1, NULL, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (18, 6, 104, NULL, NULL, NULL, NULL, N'C', 2.33, 1, 1, 1, 2, 0, 6, 1, NULL, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (18, 17, 0, NULL, NULL, NULL, NULL, N'F', 0, 1, 1, 1, 1, 0, 7, 1, NULL, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (18, 19, 0, NULL, NULL, NULL, NULL, N'F', 0, 1, 1, 1, 1, 0, 7, 1, NULL, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (18, 21, 82, NULL, NULL, NULL, NULL, N'F', 0, 1, 1, 1, 1, 0, 7, 1, NULL, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (18, 85, 28, NULL, NULL, NULL, NULL, N'F', 0, 1, 1, 1, 1, 0, 7, 1, NULL, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (18, 11, 92, NULL, NULL, NULL, NULL, N'D', 2, 1, 1, 1, 1, 0, 8, 1, NULL, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (18, 13, 94, NULL, NULL, NULL, NULL, N'D', 2, 1, 1, 1, 1, 0, 8, 1, NULL, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (18, 14, 48, NULL, NULL, NULL, NULL, N'F', 0, 1, 1, 1, 1, 0, 8, 1, NULL, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (18, 16, 53, NULL, NULL, NULL, NULL, N'F', 0, 1, 1, 1, 1, 0, 8, 1, NULL, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (18, 27, 53, NULL, NULL, NULL, NULL, N'F', 0, 1, 1, 1, 1, 0, 8, 1, NULL, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (18, 5, 109, NULL, NULL, NULL, NULL, N'C+', 2.67, 1, 1, 1, 1, 0, 9, 1, NULL, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (18, 17, 60, NULL, NULL, NULL, NULL, N'D', 2, 1, 1, 1, 2, 0, 9, 1, NULL, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (18, 85, 40, NULL, NULL, NULL, NULL, N'B+', 3.33, 1, 1, 1, 2, 0, 9, 1, NULL, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (18, 15, 107, NULL, NULL, NULL, NULL, N'C+', 2.67, 1, 1, 1, 1, 0, 10, 1, NULL, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (18, 23, 83, NULL, NULL, NULL, NULL, N'B+', 3.33, 1, 1, 1, 1, 0, 10, 1, NULL, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (18, 28, 125, NULL, NULL, NULL, NULL, N'B+', 3.33, 1, 1, 1, 1, 0, 10, 1, NULL, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (18, 34, 129, NULL, NULL, NULL, NULL, N'A-', 3.67, 1, 1, 1, 1, 0, 10, 1, NULL, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (18, 86, 35, NULL, NULL, NULL, NULL, N'C+', 2.67, 1, 1, 1, 1, 0, 10, 1, NULL, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (18, 18, 76, NULL, NULL, NULL, NULL, N'F', 0, 1, 1, 1, 1, 0, 11, 1, NULL, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (18, 26, 72, NULL, NULL, NULL, NULL, N'C+', 2.67, 1, 1, 1, 1, 0, 11, 1, NULL, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (18, 29, 119, NULL, NULL, NULL, NULL, N'B', 3, 1, 1, 1, 1, 0, 11, 1, NULL, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (18, 31, 129, NULL, NULL, NULL, NULL, N'A-', 3.67, 1, 1, 1, 1, 0, 11, 1, NULL, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (18, 35, 116, NULL, NULL, NULL, NULL, N'B', 3, 1, 1, 1, 1, 0, 11, 1, NULL, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (18, 43, 132, NULL, NULL, NULL, NULL, N'A-', 3.67, 1, 1, 1, 1, 0, 11, 1, NULL, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (18, 14, NULL, NULL, NULL, NULL, NULL, N'P', 0, 1, 0, 1, 2, 0, 11, 0, NULL, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (18, 53, 96, NULL, NULL, NULL, NULL, N'D', 2, 1, 1, 1, 3, 1, 12, 0, NULL, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (18, 8, 71, NULL, NULL, NULL, NULL, N'C+', 2.67, 1, 1, 1, 1, 0, 13, 1, NULL, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (18, 30, 116, NULL, NULL, NULL, NULL, N'B', 3, 1, 1, 1, 1, 0, 13, 1, NULL, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (18, 32, 80, NULL, NULL, NULL, NULL, N'B+', 3.33, 1, 1, 1, 1, 0, 13, 1, NULL, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (18, 42, 25, NULL, NULL, NULL, NULL, N'F', 0, 1, 1, 1, 1, 0, 13, 1, NULL, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (18, 72, 107, NULL, NULL, NULL, NULL, N'C+', 2.67, 1, 1, 1, 1, 0, 13, 1, NULL, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (18, 19, 85, NULL, NULL, NULL, NULL, N'F', 0, 1, 1, 1, 2, 0, 13, 0, NULL, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (18, 21, 95, NULL, NULL, NULL, NULL, N'D', 2, 1, 1, 1, 2, 0, 13, 0, NULL, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (18, 20, 116, NULL, NULL, NULL, NULL, N'B', 3, 1, 1, 1, 1, 0, 14, 1, NULL, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (18, 22, 73, NULL, NULL, NULL, NULL, N'F', 0, 1, 1, 1, 1, 0, 14, 1, NULL, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (18, 24, 56, NULL, NULL, NULL, NULL, N'F', 0, 1, 1, 1, 1, 0, 14, 1, NULL, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (18, 33, 180, NULL, NULL, NULL, NULL, N'A', 4, 1, 1, 1, 1, 0, 14, 1, NULL, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (18, 56, NULL, NULL, NULL, NULL, NULL, N'P', 0, 1, 0, 1, 1, 0, 14, 1, NULL, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (18, 18, 107, NULL, NULL, NULL, NULL, N'D', 2, 1, 1, 1, 2, 0, 14, 0, NULL, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (18, 22, 113, NULL, NULL, NULL, NULL, N'D', 2, 1, 1, 1, 2, 0, 15, 0, NULL, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (18, 36, 127, NULL, NULL, NULL, NULL, N'B+', 3.33, 1, 1, 1, 1, 0, 16, 1, NULL, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (18, 38, 133, NULL, NULL, NULL, NULL, N'A-', 3.67, 1, 1, 1, 1, 0, 16, 1, NULL, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (18, 57, 6, NULL, NULL, NULL, NULL, N'F', 0, 1, 1, 1, 1, 0, 16, 1, NULL, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (18, 19, 100, NULL, NULL, NULL, NULL, N'D', 2, 1, 1, 1, 3, 1, 16, 0, NULL, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (18, 48, 49, NULL, NULL, NULL, NULL, N'A', 4, 1, 1, 1, 1, 0, 17, 1, NULL, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (18, 1, 109, NULL, NULL, NULL, NULL, N'D', 2, 1, 1, 1, 3, 1, 17, 0, NULL, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (18, 16, 58, NULL, NULL, NULL, NULL, N'F', 0, 1, 1, 1, 2, 0, 17, 0, NULL, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (18, 24, 70, NULL, NULL, NULL, NULL, N'D', 2, 1, 1, 1, 2, 0, 17, 0, NULL, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (18, 57, 102, NULL, NULL, NULL, NULL, N'D', 2, 1, 1, 1, 2, 0, 17, 0, NULL, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (18, 16, 64, NULL, NULL, NULL, NULL, N'D', 2, 1, 1, 1, 3, 1, 18, 0, NULL, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (12, 1, 103, NULL, NULL, NULL, NULL, N'C', 2.33, 1, 1, 1, 1, 0, 10, 1, NULL, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (12, 2, 49, NULL, NULL, NULL, NULL, N'A', 4, 1, 1, 1, 1, 0, 10, 1, NULL, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (12, 50, 35, NULL, NULL, NULL, NULL, N'P', 0, 1, 0, 1, 1, 0, 10, 1, NULL, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (12, 52, 120, NULL, NULL, NULL, NULL, N'D', 2, 1, 1, 1, 1, 0, 10, 1, NULL, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (12, 83, 152, NULL, NULL, NULL, NULL, N'B', 3, 1, 1, 1, 1, 0, 10, 1, NULL, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (12, 84, 35, NULL, NULL, NULL, NULL, N'C+', 2.67, 1, 1, 1, 1, 0, 10, 1, NULL, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (12, 87, 132, NULL, NULL, NULL, NULL, N'A-', 3.67, 1, 1, 1, 1, 0, 10, 1, NULL, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (12, 3, NULL, NULL, NULL, NULL, NULL, N'P', 0, 1, 0, 1, 1, 0, 11, 1, NULL, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (12, 4, NULL, NULL, NULL, NULL, NULL, N'P', 0, 1, 0, 1, 1, 0, 11, 1, NULL, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (12, 5, NULL, NULL, NULL, NULL, NULL, N'P', 0, 1, 0, 1, 1, 0, 11, 1, NULL, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (12, 46, NULL, NULL, NULL, NULL, NULL, N'P', 0, 1, 0, 1, 1, 0, 11, 1, NULL, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (12, 51, NULL, NULL, NULL, NULL, NULL, N'P', 0, 1, 0, 1, 1, 0, 11, 1, NULL, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (12, 53, NULL, NULL, NULL, NULL, NULL, N'P', 0, 1, 0, 1, 1, 0, 11, 1, NULL, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (12, 54, NULL, NULL, NULL, NULL, NULL, N'P', 0, 1, 0, 1, 1, 0, 11, 1, NULL, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (12, 6, 103, NULL, NULL, NULL, NULL, N'C', 2.33, 1, 1, 1, 1, 0, 13, 1, NULL, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (12, 8, 68, NULL, NULL, NULL, NULL, N'C', 2.33, 1, 1, 1, 1, 0, 13, 1, NULL, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (12, 10, 138, NULL, NULL, NULL, NULL, N'A', 4, 1, 1, 1, 1, 0, 13, 1, NULL, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (12, 12, 132, NULL, NULL, NULL, NULL, N'C', 2.33, 1, 1, 1, 1, 0, 13, 1, NULL, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (12, 47, 92, NULL, NULL, NULL, NULL, N'A', 4, 1, 1, 1, 1, 0, 13, 1, NULL, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (12, 57, 103, NULL, NULL, NULL, NULL, N'C', 2.33, 1, 1, 1, 1, 0, 13, 1, NULL, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (12, 7, 103, NULL, NULL, NULL, NULL, N'C', 2.33, 1, 1, 1, 1, 0, 14, 1, NULL, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (12, 9, 112, NULL, NULL, NULL, NULL, N'C+', 2.67, 1, 1, 1, 1, 0, 14, 1, NULL, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (12, 11, 133, NULL, NULL, NULL, NULL, N'A-', 3.67, 1, 1, 1, 1, 0, 14, 1, NULL, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (12, 13, 125, NULL, NULL, NULL, NULL, N'B+', 3.33, 1, 1, 1, 1, 0, 14, 1, NULL, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (12, 14, 77, NULL, NULL, NULL, NULL, N'B', 3, 1, 1, 1, 1, 0, 14, 1, NULL, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (12, 56, 112, NULL, NULL, NULL, NULL, N'C+', 2.67, 1, 1, 1, 1, 0, 14, 1, NULL, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (12, 15, 103, NULL, NULL, NULL, NULL, N'C', 2.33, 1, 1, 1, 1, 0, 16, 1, NULL, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (12, 17, 68, NULL, NULL, NULL, NULL, N'C', 2.33, 1, 1, 1, 1, 0, 16, 1, NULL, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (12, 19, 112, NULL, NULL, NULL, NULL, N'C+', 2.67, 1, 1, 1, 1, 0, 16, 1, NULL, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (12, 21, 112, NULL, NULL, NULL, NULL, N'C+', 2.67, 1, 1, 1, 1, 0, 16, 1, NULL, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (12, 23, 77, NULL, NULL, NULL, NULL, N'B', 3, 1, 1, 1, 1, 0, 16, 1, NULL, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (12, 72, 0, NULL, NULL, NULL, NULL, N'F', 0, 1, 1, 1, 1, 0, 16, 1, NULL, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (12, 85, 44, NULL, NULL, NULL, NULL, N'A-', 3.67, 1, 1, 1, 1, 0, 16, 1, NULL, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (12, 16, 68, NULL, NULL, NULL, NULL, N'C', 2.33, 1, 1, 1, 1, 0, 17, 1, NULL, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (12, 18, 103, NULL, NULL, NULL, NULL, N'C', 2.33, 1, 1, 1, 1, 0, 17, 1, NULL, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (12, 20, 119, NULL, NULL, NULL, NULL, N'B', 3, 1, 1, 1, 1, 0, 17, 1, NULL, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (12, 22, 88, NULL, NULL, NULL, NULL, N'F', 0, 1, 1, 1, 1, 0, 17, 1, NULL, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (12, 24, 60, NULL, NULL, NULL, NULL, N'D', 2, 1, 1, 1, 1, 0, 17, 1, NULL, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (12, 27, 80, NULL, NULL, NULL, NULL, N'B+', 3.33, 1, 1, 1, 1, 0, 17, 1, NULL, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (12, 48, 49, NULL, NULL, NULL, NULL, N'A', 4, 1, 1, 1, 1, 0, 17, 1, NULL, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (12, 31, 149, NULL, NULL, NULL, NULL, N'A', 4, 1, 1, 1, 1, 0, 18, 1, NULL, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (12, 22, 119, NULL, NULL, NULL, NULL, N'B', 3, 1, 1, 1, 2, 0, 18, 1, NULL, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (27, 1, 95, NULL, NULL, NULL, NULL, N'D', 2, 1, 1, 1, 1, 0, 1, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (27, 2, 47, NULL, NULL, NULL, NULL, N'A', 4, 1, 1, 1, 1, 0, 1, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (27, 50, 34, NULL, NULL, NULL, NULL, N'P', 0, 1, 0, 1, 1, 0, 1, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (27, 52, 159, NULL, NULL, NULL, NULL, N'B', 3, 1, 1, 1, 1, 0, 1, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (27, 83, 130, NULL, NULL, NULL, NULL, N'C', 2.33, 1, 1, 1, 1, 0, 1, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (27, 84, 30, NULL, NULL, NULL, NULL, N'D', 2, 1, 1, 1, 1, 0, 1, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (27, 87, 108, NULL, NULL, NULL, NULL, N'C+', 2.67, 1, 1, 1, 1, 0, 1, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (27, 3, 77, NULL, NULL, NULL, NULL, N'F', 0, 1, 1, 1, 1, 0, 2, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (27, 4, 84, NULL, NULL, NULL, NULL, N'F', 0, 1, 1, 1, 1, 0, 2, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (27, 5, 142, NULL, NULL, NULL, NULL, N'A', 4, 1, 1, 1, 1, 0, 2, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (27, 46, 44, NULL, NULL, NULL, NULL, N'F', 0, 1, 1, 1, 1, 0, 2, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (27, 51, 31, NULL, NULL, NULL, NULL, N'P', 0, 1, 0, 1, 1, 0, 2, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (27, 53, 100, NULL, NULL, NULL, NULL, N'C', 2.33, 1, 1, 1, 1, 0, 2, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (27, 54, 122, NULL, NULL, NULL, NULL, N'B+', 3.33, 1, 1, 1, 1, 0, 2, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (27, 3, 118, NULL, NULL, NULL, NULL, N'B', 3, 1, 1, 1, 2, 0, 3, 1, 1, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (27, 4, 140, NULL, NULL, NULL, NULL, N'A', 4, 1, 1, 1, 2, 0, 3, 1, 1, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (27, 6, 0, NULL, NULL, NULL, NULL, N'F', 0, 1, 1, 1, 1, 0, 4, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (27, 8, 69, NULL, NULL, NULL, NULL, N'C', 2.33, 1, 1, 1, 1, 0, 4, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (27, 10, 120, NULL, NULL, NULL, NULL, N'B+', 3.33, 1, 1, 1, 1, 0, 4, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (27, 12, 140, NULL, NULL, NULL, NULL, N'C+', 2.67, 1, 1, 1, 1, 0, 4, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (27, 57, 109, NULL, NULL, NULL, NULL, N'C+', 2.67, 1, 1, 1, 1, 0, 4, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (27, 7, 0, NULL, NULL, NULL, NULL, N'F', 0, 1, 1, 1, 1, 0, 5, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (27, 9, 57, NULL, NULL, NULL, NULL, N'F', 0, 1, 1, 1, 1, 0, 5, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (27, 11, 0, NULL, NULL, NULL, NULL, N'F', 0, 1, 1, 1, 1, 0, 5, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (27, 13, 90, NULL, NULL, NULL, NULL, N'D', 2, 1, 1, 1, 1, 0, 5, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (27, 14, 57, NULL, NULL, NULL, NULL, N'F', 0, 1, 1, 1, 1, 0, 5, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (27, 46, 43, NULL, NULL, NULL, NULL, N'F', 0, 1, 1, 1, 2, 0, 5, 1, 1, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (27, 56, 0, NULL, NULL, NULL, NULL, N'F', 0, 1, 1, 1, 1, 0, 5, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (27, 15, 68, NULL, NULL, NULL, NULL, N'F', 0, 1, 1, 1, 1, 0, 7, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (27, 17, 0, NULL, NULL, NULL, NULL, N'F', 0, 1, 1, 1, 1, 0, 7, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (27, 19, 0, NULL, NULL, NULL, NULL, N'F', 0, 1, 1, 1, 1, 0, 7, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (27, 21, 0, NULL, NULL, NULL, NULL, N'F', 0, 1, 1, 1, 1, 0, 7, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (27, 23, 0, NULL, NULL, NULL, NULL, N'F', 0, 1, 1, 1, 1, 0, 7, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (27, 72, 0, NULL, NULL, NULL, NULL, N'F', 0, 1, 1, 1, 1, 0, 7, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (27, 9, 76, NULL, NULL, NULL, NULL, N'F', 0, 1, 1, 1, 2, 0, 8, 1, 1, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (27, 11, 95, NULL, NULL, NULL, NULL, N'D', 2, 1, 1, 1, 2, 0, 8, 0, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (27, 46, 55, NULL, NULL, NULL, NULL, N'F', 0, 1, 1, 1, 3, 1, 8, 0, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (27, 48, 39, NULL, NULL, NULL, NULL, N'B', 3, 1, 1, 1, 1, 0, 8, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (27, 56, 96, NULL, NULL, NULL, NULL, N'D', 2, 1, 1, 1, 2, 0, 8, 0, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (27, 17, 55, NULL, NULL, NULL, NULL, N'F', 0, 1, 1, 1, 2, 0, 9, 0, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (27, 85, 31, NULL, NULL, NULL, NULL, N'D', 2, 1, 1, 1, 1, 0, 9, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (27, 28, 129, NULL, NULL, NULL, NULL, N'A-', 3.67, 1, 1, 1, 1, 0, 10, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (27, 30, 99, NULL, NULL, NULL, NULL, N'C', 2.33, 1, 1, 1, 1, 0, 10, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (27, 32, 92, NULL, NULL, NULL, NULL, N'A', 4, 1, 1, 1, 1, 0, 10, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (27, 34, 119, NULL, NULL, NULL, NULL, N'B', 3, 1, 1, 1, 1, 0, 10, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (27, 86, 34, NULL, NULL, NULL, NULL, N'C', 2.33, 1, 1, 1, 1, 0, 10, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (27, 26, 72, NULL, NULL, NULL, NULL, N'C+', 2.67, 1, 1, 1, 1, 0, 11, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (27, 33, 182, NULL, NULL, NULL, NULL, N'A', 4, 1, 1, 1, 1, 0, 11, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (27, 35, 111, NULL, NULL, NULL, NULL, N'C+', 2.67, 1, 1, 1, 1, 0, 11, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (27, 43, 126, NULL, NULL, NULL, NULL, N'B+', 3.33, 1, 1, 1, 1, 0, 11, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (27, 6, 96, NULL, NULL, NULL, NULL, N'D', 2, 1, 1, 1, 2, 0, 12, 0, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (27, 15, 103, NULL, NULL, NULL, NULL, N'D', 2, 1, 1, 1, 2, 0, 13, 0, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (27, 17, 72, NULL, NULL, NULL, NULL, N'D', 2, 1, 1, 1, 3, 1, 13, 0, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (27, 19, 99, NULL, NULL, NULL, NULL, N'D', 2, 1, 1, 1, 2, 0, 13, 0, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (27, 72, 102, NULL, NULL, NULL, NULL, N'D', 2, 1, 1, 1, 2, 0, 13, 0, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (27, 20, 122, NULL, NULL, NULL, NULL, N'B+', 3.33, 1, 1, 1, 1, 0, 14, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (27, 24, 66, NULL, NULL, NULL, NULL, N'C', 2.33, 1, 1, 1, 1, 0, 14, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (27, 29, 132, NULL, NULL, NULL, NULL, N'A-', 3.67, 1, 1, 1, 1, 0, 14, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (27, 31, 101, NULL, NULL, NULL, NULL, N'C', 2.33, 1, 1, 1, 1, 0, 14, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (27, 21, 96, NULL, NULL, NULL, NULL, N'D', 2, 1, 1, 1, 2, 0, 16, 0, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (27, 23, 74, NULL, NULL, NULL, NULL, N'D', 2, 1, 1, 1, 2, 0, 16, 0, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (27, 38, 141, NULL, NULL, NULL, NULL, N'A', 4, 1, 1, 1, 1, 0, 16, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (27, 47, 79, NULL, NULL, NULL, NULL, N'B', 3, 1, 1, 1, 1, 0, 16, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (27, 7, 87, NULL, NULL, NULL, NULL, N'F', 0, 1, 1, 1, 2, 0, 17, 0, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (27, 9, 96, NULL, NULL, NULL, NULL, N'D', 2, 1, 1, 1, 3, 1, 17, 0, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (27, 16, 57, NULL, NULL, NULL, NULL, N'F', 0, 1, 1, 1, 1, 0, 17, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (27, 22, 93, NULL, NULL, NULL, NULL, N'D', 2, 1, 1, 1, 1, 0, 17, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (28, 1, 94, NULL, NULL, NULL, NULL, N'D', 2, 1, 1, 1, 1, 0, 4, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (28, 2, 41, NULL, NULL, NULL, NULL, N'B+', 3.33, 1, 1, 1, 1, 0, 4, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (28, 50, 36, NULL, NULL, NULL, NULL, N'P', 0, 1, 0, 1, 1, 0, 4, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (28, 52, 120, NULL, NULL, NULL, NULL, N'D', 2, 1, 1, 1, 1, 0, 4, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (28, 83, 138, NULL, NULL, NULL, NULL, N'C', 2.33, 1, 1, 1, 1, 0, 4, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (28, 84, 32, NULL, NULL, NULL, NULL, N'D', 2, 1, 1, 1, 1, 0, 4, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (28, 87, 92, NULL, NULL, NULL, NULL, N'D', 2, 1, 1, 1, 1, 0, 4, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (28, 3, 110, NULL, NULL, NULL, NULL, N'C+', 2.67, 1, 1, 1, 1, 0, 5, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (28, 4, 90, NULL, NULL, NULL, NULL, N'D', 2, 1, 1, 1, 1, 0, 5, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (28, 5, 95, NULL, NULL, NULL, NULL, N'D', 2, 1, 1, 1, 1, 0, 5, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (28, 46, 71, NULL, NULL, NULL, NULL, N'C+', 2.67, 1, 1, 1, 1, 0, 5, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (28, 51, 40, NULL, NULL, NULL, NULL, N'P', 0, 1, 0, 1, 1, 0, 5, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (28, 53, 106, NULL, NULL, NULL, NULL, N'C+', 2.67, 1, 1, 1, 1, 0, 5, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (28, 54, 112, NULL, NULL, NULL, NULL, N'C+', 2.67, 1, 1, 1, 1, 0, 5, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (28, 6, 85, NULL, NULL, NULL, NULL, N'F', 0, 1, 1, 1, 1, 0, 7, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (28, 12, 104, NULL, NULL, NULL, NULL, N'F', 0, 1, 1, 1, 1, 0, 7, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (28, 47, 82, NULL, NULL, NULL, NULL, N'B+', 3.33, 1, 1, 1, 1, 0, 7, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (28, 57, 70, NULL, NULL, NULL, NULL, N'F', 0, 1, 1, 1, 1, 0, 7, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (28, 9, 94, NULL, NULL, NULL, NULL, N'D', 2, 1, 1, 1, 1, 0, 8, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (28, 11, 90, NULL, NULL, NULL, NULL, N'D', 2, 1, 1, 1, 1, 0, 8, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (28, 13, 90, NULL, NULL, NULL, NULL, N'D', 2, 1, 1, 1, 1, 0, 8, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (28, 14, 69, NULL, NULL, NULL, NULL, N'C', 2.33, 1, 1, 1, 1, 0, 8, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (28, 10, 126, NULL, NULL, NULL, NULL, N'B+', 3.33, 1, 1, 1, 1, 0, 9, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (28, 12, 176, NULL, NULL, NULL, NULL, N'A-', 3.67, 1, 1, 1, 2, 0, 9, 1, 1, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (28, 8, 0, NULL, NULL, NULL, NULL, N'F', 0, 1, 1, 1, 1, 0, 10, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (28, 15, 74, NULL, NULL, NULL, NULL, N'F', 0, 1, 1, 1, 1, 0, 10, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (28, 17, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 1, 1, 0, 10, 1, 0, 1, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (28, 19, 72, NULL, NULL, NULL, NULL, N'F', 0, 1, 1, 1, 1, 0, 10, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (28, 21, 60, NULL, NULL, NULL, NULL, N'F', 0, 1, 1, 1, 1, 0, 10, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (28, 23, 55, NULL, NULL, NULL, NULL, N'F', 0, 1, 1, 1, 1, 0, 10, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (28, 72, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 1, 1, 0, 10, 1, 0, 1, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (28, 85, 32, NULL, NULL, NULL, NULL, N'D', 2, 1, 1, 1, 1, 0, 10, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (28, 16, 74, NULL, NULL, NULL, NULL, N'C+', 2.67, 1, 1, 1, 1, 0, 11, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (28, 26, 75, NULL, NULL, NULL, NULL, N'B', 3, 1, 1, 1, 1, 0, 11, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (28, 43, 118, NULL, NULL, NULL, NULL, N'B', 3, 1, 1, 1, 1, 0, 11, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (28, 48, 0, NULL, NULL, NULL, NULL, N'F', 0, 1, 1, 1, 1, 0, 11, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (28, 56, NULL, NULL, NULL, NULL, NULL, N'P', NULL, 1, 0, 1, 1, 0, 11, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (28, 15, 93, NULL, NULL, NULL, NULL, N'D', 2, 1, 1, 1, 2, 0, 13, 1, 1, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (28, 19, 71, NULL, NULL, NULL, NULL, N'F', 0, 1, 1, 1, 2, 0, 13, 1, 1, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (28, 21, 94, NULL, NULL, NULL, NULL, N'D', 2, 1, 1, 1, 2, 0, 13, 0, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (28, 72, 83, NULL, NULL, NULL, NULL, N'F', 0, 1, 1, 1, 2, 0, 13, 0, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (28, 18, 100, NULL, NULL, NULL, NULL, N'C', 2.33, 1, 1, 1, 1, 0, 14, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (28, 20, 108, NULL, NULL, NULL, NULL, N'C+', 2.67, 1, 1, 1, 1, 0, 14, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (28, 22, 86, NULL, NULL, NULL, NULL, N'F', 0, 1, 1, 1, 1, 0, 14, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (28, 24, 80, NULL, NULL, NULL, NULL, N'B+', 3.33, 1, 1, 1, 1, 0, 14, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (28, 48, 46, NULL, NULL, NULL, NULL, N'A', 4, 1, 1, 1, 2, 0, 14, 1, 1, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (28, 34, 104, NULL, NULL, NULL, NULL, N'C', 2.33, 1, 1, 1, 1, 0, 15, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (28, 28, 118, NULL, NULL, NULL, NULL, N'B', 3, 1, 1, 1, 1, 0, 16, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (28, 30, 120, NULL, NULL, NULL, NULL, N'B+', 3.33, 1, 1, 1, 1, 0, 16, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (28, 32, 86, NULL, NULL, NULL, NULL, N'A-', 3.67, 1, 1, 1, 1, 0, 16, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (28, 36, 130, NULL, NULL, NULL, NULL, N'A-', 3.67, 1, 1, 1, 1, 0, 16, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (28, 86, 33, NULL, NULL, NULL, NULL, N'C', 2.33, 1, 1, 1, 1, 0, 16, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (28, 29, 85, NULL, NULL, NULL, NULL, N'F', 0, 1, 1, 1, 1, 0, 17, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (28, 31, 104, NULL, NULL, NULL, NULL, N'C', 2.33, 1, 1, 1, 1, 0, 17, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (28, 33, 176, NULL, NULL, NULL, NULL, N'A-', 3.67, 1, 1, 1, 1, 0, 17, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (28, 35, 109, NULL, NULL, NULL, NULL, N'C+', 2.67, 1, 1, 1, 1, 0, 17, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (28, 19, 126, NULL, NULL, NULL, NULL, N'D', 2, 1, 1, 1, 3, 1, 18, 0, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (28, 57, 108, NULL, NULL, NULL, NULL, N'D', 2, 1, 1, 1, 2, 0, 18, 0, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (30, 1, 69, NULL, NULL, NULL, NULL, N'F', 0, 1, 1, 1, 1, 0, 10, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (30, 2, 45, NULL, NULL, NULL, NULL, N'A', 4, 1, 1, 1, 1, 0, 10, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (30, 50, 30, NULL, NULL, NULL, NULL, N'P', 0, 1, 0, 1, 1, 0, 10, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (30, 52, 123, NULL, NULL, NULL, NULL, N'D', 2, 1, 1, 1, 1, 0, 10, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (30, 83, 85, NULL, NULL, NULL, NULL, N'F', 0, 1, 1, 1, 1, 0, 10, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (30, 84, 35, NULL, NULL, NULL, NULL, N'C+', 2.67, 1, 1, 1, 1, 0, 10, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (30, 87, 116, NULL, NULL, NULL, NULL, N'B', 3, 1, 1, 1, 1, 0, 10, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (30, 3, NULL, NULL, NULL, NULL, NULL, N'P', NULL, 1, 0, 1, 1, 0, 11, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (30, 4, NULL, NULL, NULL, NULL, NULL, N'P', NULL, 1, 0, 1, 1, 0, 11, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (30, 46, NULL, NULL, NULL, NULL, NULL, N'P', NULL, 1, 0, 1, 1, 0, 11, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (30, 51, NULL, NULL, NULL, NULL, NULL, N'P', NULL, 1, 0, 1, 1, 0, 11, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (30, 53, NULL, NULL, NULL, NULL, NULL, N'P', NULL, 1, 0, 1, 1, 0, 11, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (30, 54, NULL, NULL, NULL, NULL, NULL, N'P', NULL, 1, 0, 1, 1, 0, 11, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (30, 88, NULL, NULL, NULL, NULL, NULL, N'P', NULL, 1, 0, 1, 1, 0, 11, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (30, 1, 94, NULL, NULL, NULL, NULL, N'D', 2, 1, 1, 1, 2, 0, 12, 1, 1, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (30, 83, 0, NULL, NULL, NULL, NULL, N'F', 0, 1, 1, 1, 2, 0, 12, 1, 1, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (30, 6, 79, NULL, NULL, NULL, NULL, N'F', 0, 1, 1, 1, 1, 0, 13, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (30, 12, 133, NULL, NULL, NULL, NULL, N'C', 2.33, 1, 1, 1, 1, 0, 13, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (30, 47, 74, NULL, NULL, NULL, NULL, N'C+', 2.67, 1, 1, 1, 1, 0, 13, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (30, 89, 80, NULL, NULL, NULL, NULL, N'F', 0, 1, 1, 1, 1, 0, 13, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (30, 91, 128, NULL, NULL, NULL, NULL, N'A-', 3.67, 1, 1, 1, 1, 0, 13, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (30, 93, 128, NULL, NULL, NULL, NULL, N'A-', 3.67, 1, 1, 1, 1, 0, 13, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (30, 114, 126, NULL, NULL, NULL, NULL, N'B+', 3.33, 1, 1, 1, 1, 0, 14, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (30, 90, 95, NULL, NULL, NULL, NULL, N'D', 2, 1, 1, 1, 1, 0, 14, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (30, 92, 112, NULL, NULL, NULL, NULL, N'C+', 2.67, 1, 1, 1, 1, 0, 14, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (30, 95, 101, NULL, NULL, NULL, NULL, N'C', 2.33, 1, 1, 1, 1, 0, 14, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (30, 6, 106, NULL, NULL, NULL, NULL, N'C+', 2.67, 1, 1, 1, 2, 0, 15, 1, 1, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (30, 21, 97, NULL, NULL, NULL, NULL, N'D', 2, 1, 1, 1, 1, 0, 16, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (30, 23, 67, NULL, NULL, NULL, NULL, N'C', 2.33, 1, 1, 1, 1, 0, 16, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (30, 85, 33, NULL, NULL, NULL, NULL, N'C', 2.33, 1, 1, 1, 1, 0, 16, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (30, 97, 104, NULL, NULL, NULL, NULL, N'C', 2.33, 1, 1, 1, 1, 0, 16, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (30, 99, 82, NULL, NULL, NULL, NULL, N'F', 0, 1, 1, 1, 1, 0, 16, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (30, 13, 109, NULL, NULL, NULL, NULL, N'C+', 2.67, 1, 1, 1, 1, 0, 17, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (30, 20, 113, NULL, NULL, NULL, NULL, N'B', 3, 1, 1, 1, 1, 0, 17, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (30, 48, 49, NULL, NULL, NULL, NULL, N'A', 4, 1, 1, 1, 1, 0, 17, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (30, 98, 122, NULL, NULL, NULL, NULL, N'B+', 3.33, 1, 1, 1, 1, 0, 17, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (30, 103, 88, NULL, NULL, NULL, NULL, N'A-', 3.67, 1, 1, 1, 1, 0, 17, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (30, 16, 63, NULL, NULL, NULL, NULL, N'D', 2, 1, 1, 1, 1, 0, 18, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (30, 19, 108, NULL, NULL, NULL, NULL, N'C+', 2.67, 1, 1, 1, 1, 0, 18, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (30, 28, 93, NULL, NULL, NULL, NULL, N'D', 2, 1, 1, 1, 1, 0, 19, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (30, 30, 90, NULL, NULL, NULL, NULL, N'D', 2, 1, 1, 1, 1, 0, 19, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (30, 38, 122, NULL, NULL, NULL, NULL, N'B+', 3.33, 1, 1, 1, 1, 0, 19, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (30, 86, 37, NULL, NULL, NULL, NULL, N'C+', 2.67, 1, 1, 1, 1, 0, 19, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (30, 101, 111, NULL, NULL, NULL, NULL, N'C+', 2.67, 1, 1, 1, 1, 0, 19, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (30, 105, 168, NULL, NULL, NULL, NULL, N'B+', 3.33, 1, 1, 1, 1, 0, 19, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (30, 109, 99, NULL, NULL, NULL, NULL, N'A', 4, 1, 1, 1, 1, 0, 19, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (11, 1, 90, NULL, NULL, NULL, NULL, N'D', 2, 1, 1, 1, 1, 0, 10, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (11, 2, 45, NULL, NULL, NULL, NULL, N'A', 4, 1, 1, 1, 1, 0, 10, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (11, 50, 40, NULL, NULL, NULL, NULL, N'P', 0, 1, 0, 1, 1, 0, 10, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (11, 52, 107, NULL, NULL, NULL, NULL, N'F', 0, 1, 1, 1, 1, 0, 10, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (11, 83, 126, NULL, NULL, NULL, NULL, N'D', 2, 1, 1, 1, 1, 0, 10, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (11, 84, 46, NULL, NULL, NULL, NULL, N'A', 4, 1, 1, 1, 1, 0, 10, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (11, 87, 131, NULL, NULL, NULL, NULL, N'A-', 3.67, 1, 1, 1, 1, 0, 10, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (11, 3, NULL, NULL, NULL, NULL, NULL, N'P', NULL, 1, 0, 1, 1, 0, 11, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (11, 4, NULL, NULL, NULL, NULL, NULL, N'P', NULL, 1, 0, 1, 1, 0, 11, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (11, 5, NULL, NULL, NULL, NULL, NULL, N'P', NULL, 1, 0, 1, 1, 0, 11, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (11, 46, NULL, NULL, NULL, NULL, NULL, N'P', NULL, 1, 0, 1, 1, 0, 11, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (11, 51, NULL, NULL, NULL, NULL, NULL, N'P', NULL, 1, 0, 1, 1, 0, 11, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (11, 53, NULL, NULL, NULL, NULL, NULL, N'P', NULL, 1, 0, 1, 1, 0, 11, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (11, 54, NULL, NULL, NULL, NULL, NULL, N'P', NULL, 1, 0, 1, 1, 0, 11, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (11, 52, 167, NULL, NULL, NULL, NULL, N'B+', 3.33, 1, 1, 1, 2, 0, 12, 1, 1, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (11, 6, 113, NULL, NULL, NULL, NULL, N'B', 3, 1, 1, 1, 1, 0, 13, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (11, 8, 74, NULL, NULL, NULL, NULL, N'C+', 2.67, 1, 1, 1, 1, 0, 13, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (11, 10, 137, NULL, NULL, NULL, NULL, N'A', 4, 1, 1, 1, 1, 0, 13, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (11, 12, 130, NULL, NULL, NULL, NULL, N'C', 2.33, 1, 1, 1, 1, 0, 13, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (11, 47, 79, NULL, NULL, NULL, NULL, N'B', 3, 1, 1, 1, 1, 0, 13, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (11, 57, 115, NULL, NULL, NULL, NULL, N'B', 3, 1, 1, 1, 1, 0, 13, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (11, 7, 113, NULL, NULL, NULL, NULL, N'B', 3, 1, 1, 1, 1, 0, 14, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (11, 9, 105, NULL, NULL, NULL, NULL, N'C+', 2.67, 1, 1, 1, 1, 0, 14, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (11, 11, 121, NULL, NULL, NULL, NULL, N'B+', 3.33, 1, 1, 1, 1, 0, 14, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (11, 13, 140, NULL, NULL, NULL, NULL, N'A', 4, 1, 1, 1, 1, 0, 14, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (11, 14, 72, NULL, NULL, NULL, NULL, N'C+', 2.67, 1, 1, 1, 1, 0, 14, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (11, 56, 142, NULL, NULL, NULL, NULL, N'A', 4, 1, 1, 1, 1, 0, 14, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (11, 15, 120, NULL, NULL, NULL, NULL, N'B+', 3.33, 1, 1, 1, 1, 0, 16, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (11, 17, 62, NULL, NULL, NULL, NULL, N'D', 2, 1, 1, 1, 1, 0, 16, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (11, 19, 111, NULL, NULL, NULL, NULL, N'C+', 2.67, 1, 1, 1, 1, 0, 16, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (11, 21, 119, NULL, NULL, NULL, NULL, N'B', 3, 1, 1, 1, 1, 0, 16, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (11, 23, 76, NULL, NULL, NULL, NULL, N'B', 3, 1, 1, 1, 1, 0, 16, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (11, 72, 111, NULL, NULL, NULL, NULL, N'C+', 2.67, 1, 1, 1, 1, 0, 16, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (11, 85, 47, NULL, NULL, NULL, NULL, N'A', 4, 1, 1, 1, 1, 0, 16, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (11, 16, 80, NULL, NULL, NULL, NULL, N'B+', 3.33, 1, 1, 1, 1, 0, 17, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (11, 18, 91, NULL, NULL, NULL, NULL, N'D', 2, 1, 1, 1, 1, 0, 17, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (11, 20, 123, NULL, NULL, NULL, NULL, N'B+', 3.33, 1, 1, 1, 1, 0, 17, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (11, 22, 119, NULL, NULL, NULL, NULL, N'B', 3, 1, 1, 1, 1, 0, 17, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (11, 24, 88, NULL, NULL, NULL, NULL, N'A-', 3.67, 1, 1, 1, 1, 0, 17, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (11, 27, 87, NULL, NULL, NULL, NULL, N'A-', 3.67, 1, 1, 1, 1, 0, 17, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (11, 48, 50, NULL, NULL, NULL, NULL, N'A', 4, 1, 1, 1, 1, 0, 17, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (11, 31, 124, NULL, NULL, NULL, NULL, N'B+', 3.33, 1, 1, 1, 1, 0, 18, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (11, 28, 117, NULL, NULL, NULL, NULL, N'B', 3, 1, 1, 1, 1, 0, 19, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (11, 30, 126, NULL, NULL, NULL, NULL, N'B+', 3.33, 1, 1, 1, 1, 0, 19, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (11, 32, 87, NULL, NULL, NULL, NULL, N'A-', 3.67, 1, 1, 1, 1, 0, 19, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (11, 34, 115, NULL, NULL, NULL, NULL, N'B', 3, 1, 1, 1, 1, 0, 19, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (11, 36, 132, NULL, NULL, NULL, NULL, N'A-', 3.67, 1, 1, 1, 1, 0, 19, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (11, 38, 127, NULL, NULL, NULL, NULL, N'B+', 3.33, 1, 1, 1, 1, 0, 19, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (11, 86, 45, NULL, NULL, NULL, NULL, N'A', 4, 1, 1, 1, 1, 0, 19, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (30, 29, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, 1, 1, 0, 20, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (29, 1, 85, NULL, NULL, NULL, NULL, N'F', 0, 1, 1, 1, 1, 0, 1, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (29, 2, 45, NULL, NULL, NULL, NULL, N'A', 4, 1, 1, 1, 1, 0, 1, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (29, 50, 32, NULL, NULL, NULL, NULL, N'P', 0, 1, 0, 1, 1, 0, 1, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (29, 52, 137, NULL, NULL, NULL, NULL, N'C', 2.33, 1, 1, 1, 1, 0, 1, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (29, 83, 143, NULL, NULL, NULL, NULL, N'C+', 2.67, 1, 1, 1, 1, 0, 1, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (29, 84, 41, NULL, NULL, NULL, NULL, N'B+', 3.33, 1, 1, 1, 1, 0, 1, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (29, 87, 108, NULL, NULL, NULL, NULL, N'C+', 2.67, 1, 1, 1, 1, 0, 1, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (29, 3, 114, NULL, NULL, NULL, NULL, N'B', 3, 1, 1, 1, 1, 0, 2, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (29, 4, 107, NULL, NULL, NULL, NULL, N'C+', 2.67, 1, 1, 1, 1, 0, 2, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (29, 46, 70, NULL, NULL, NULL, NULL, N'C+', 2.67, 1, 1, 1, 1, 0, 2, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (29, 51, 32, NULL, NULL, NULL, NULL, N'P', 0, 1, 0, 1, 1, 0, 2, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (29, 53, 67, NULL, NULL, NULL, NULL, N'F', 0, 1, 1, 1, 1, 0, 2, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (29, 54, 92, NULL, NULL, NULL, NULL, N'D', 2, 1, 1, 1, 1, 0, 2, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (29, 53, 57, NULL, NULL, NULL, NULL, N'F', 0, 1, 1, 1, 2, 0, 3, 1, 1, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (29, 6, 81, NULL, NULL, NULL, NULL, N'F', 0, 1, 1, 1, 1, 0, 4, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (29, 10, 90, NULL, NULL, NULL, NULL, N'D', 2, 1, 1, 1, 1, 0, 4, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (29, 12, 128, NULL, NULL, NULL, NULL, N'D', 2, 1, 1, 1, 1, 0, 4, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (29, 47, 77, NULL, NULL, NULL, NULL, N'B', 3, 1, 1, 1, 1, 0, 4, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (29, 7, 90, NULL, NULL, NULL, NULL, N'D', 2, 1, 1, 1, 1, 0, 5, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (29, 9, 116, NULL, NULL, NULL, NULL, N'B', 3, 1, 1, 1, 1, 0, 5, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (29, 1, 82, NULL, NULL, NULL, NULL, N'F', 0, 1, 1, 1, 2, 0, 6, 1, 1, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (29, 6, 104, NULL, NULL, NULL, NULL, N'C', 2.33, 1, 1, 1, 2, 0, 6, 1, 1, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (29, 17, 0, NULL, NULL, NULL, NULL, N'F', 0, 1, 1, 1, 1, 0, 7, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (29, 19, 0, NULL, NULL, NULL, NULL, N'F', 0, 1, 1, 1, 1, 0, 7, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (29, 21, 82, NULL, NULL, NULL, NULL, N'F', 0, 1, 1, 1, 1, 0, 7, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (29, 85, 28, NULL, NULL, NULL, NULL, N'F', 0, 1, 1, 1, 1, 0, 7, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (29, 11, 92, NULL, NULL, NULL, NULL, N'D', 2, 1, 1, 1, 1, 0, 8, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (29, 13, 94, NULL, NULL, NULL, NULL, N'D', 2, 1, 1, 1, 1, 0, 8, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (29, 14, 48, NULL, NULL, NULL, NULL, N'F', 0, 1, 1, 1, 1, 0, 8, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (29, 16, 53, NULL, NULL, NULL, NULL, N'F', 0, 1, 1, 1, 1, 0, 8, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (29, 27, 53, NULL, NULL, NULL, NULL, N'F', 0, 1, 1, 1, 1, 0, 8, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (29, 5, 109, NULL, NULL, NULL, NULL, N'C+', 2.67, 1, 1, 1, 1, 0, 9, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (29, 17, 60, NULL, NULL, NULL, NULL, N'D', 2, 1, 1, 1, 2, 0, 9, 1, 1, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (29, 85, 40, NULL, NULL, NULL, NULL, N'B+', 3.33, 1, 1, 1, 2, 0, 9, 1, 1, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (29, 15, 107, NULL, NULL, NULL, NULL, N'C+', 2.67, 1, 1, 1, 1, 0, 10, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (29, 23, 83, NULL, NULL, NULL, NULL, N'B+', 3.33, 1, 1, 1, 1, 0, 10, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (29, 28, 125, NULL, NULL, NULL, NULL, N'B+', 3.33, 1, 1, 1, 1, 0, 10, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (29, 34, 129, NULL, NULL, NULL, NULL, N'A-', 3.67, 1, 1, 1, 1, 0, 10, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (29, 86, 35, NULL, NULL, NULL, NULL, N'C+', 2.67, 1, 1, 1, 1, 0, 10, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (29, 14, NULL, NULL, NULL, NULL, NULL, N'P', NULL, 1, 0, 1, 2, 0, 11, 0, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (29, 18, 76, NULL, NULL, NULL, NULL, N'F', 0, 1, 1, 1, 1, 0, 11, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (29, 26, 72, NULL, NULL, NULL, NULL, N'C+', 2.67, 1, 1, 1, 1, 0, 11, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (29, 29, 119, NULL, NULL, NULL, NULL, N'B', 3, 1, 1, 1, 1, 0, 11, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (29, 31, 129, NULL, NULL, NULL, NULL, N'A-', 3.67, 1, 1, 1, 1, 0, 11, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (29, 35, 116, NULL, NULL, NULL, NULL, N'B', 3, 1, 1, 1, 1, 0, 11, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (29, 43, 132, NULL, NULL, NULL, NULL, N'A-', 3.67, 1, 1, 1, 1, 0, 11, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (29, 53, 96, NULL, NULL, NULL, NULL, N'D', 2, 1, 1, 1, 3, 1, 12, 0, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (29, 8, 71, NULL, NULL, NULL, NULL, N'C+', 2.67, 1, 1, 1, 1, 0, 13, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (29, 19, 85, NULL, NULL, NULL, NULL, N'F', 0, 1, 1, 1, 2, 0, 13, 0, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (29, 21, 95, NULL, NULL, NULL, NULL, N'D', 2, 1, 1, 1, 2, 0, 13, 0, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (29, 30, 116, NULL, NULL, NULL, NULL, N'B', 3, 1, 1, 1, 1, 0, 13, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (29, 32, 80, NULL, NULL, NULL, NULL, N'B+', 3.33, 1, 1, 1, 1, 0, 13, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (29, 42, 25, NULL, NULL, NULL, NULL, N'F', 0, 1, 1, 1, 1, 0, 13, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (29, 72, 107, NULL, NULL, NULL, NULL, N'C+', 2.67, 1, 1, 1, 1, 0, 13, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (29, 18, 107, NULL, NULL, NULL, NULL, N'D', 2, 1, 1, 1, 2, 0, 14, 0, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (29, 20, 116, NULL, NULL, NULL, NULL, N'B', 3, 1, 1, 1, 1, 0, 14, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (29, 22, 73, NULL, NULL, NULL, NULL, N'F', 0, 1, 1, 1, 1, 0, 14, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (29, 24, 56, NULL, NULL, NULL, NULL, N'F', 0, 1, 1, 1, 1, 0, 14, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (29, 33, 180, NULL, NULL, NULL, NULL, N'A', 4, 1, 1, 1, 1, 0, 14, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (29, 56, NULL, NULL, NULL, NULL, NULL, N'P', NULL, 1, 0, 1, 1, 0, 14, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (29, 22, 113, NULL, NULL, NULL, NULL, N'D', 2, 1, 1, 1, 2, 0, 15, 0, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (29, 19, 100, NULL, NULL, NULL, NULL, N'D', 2, 1, 1, 1, 3, 1, 16, 0, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (29, 36, 127, NULL, NULL, NULL, NULL, N'B+', 3.33, 1, 1, 1, 1, 0, 16, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (29, 38, 133, NULL, NULL, NULL, NULL, N'A-', 3.67, 1, 1, 1, 1, 0, 16, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (29, 57, 6, NULL, NULL, NULL, NULL, N'F', 0, 1, 1, 1, 1, 0, 16, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (29, 1, 109, NULL, NULL, NULL, NULL, N'D', 2, 1, 1, 1, 3, 1, 17, 0, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (29, 16, 58, NULL, NULL, NULL, NULL, N'F', 0, 1, 1, 1, 2, 0, 17, 0, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (29, 24, 70, NULL, NULL, NULL, NULL, N'D', 2, 1, 1, 1, 2, 0, 17, 0, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (29, 48, 49, NULL, NULL, NULL, NULL, N'A', 4, 1, 1, 1, 1, 0, 17, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (29, 57, 102, NULL, NULL, NULL, NULL, N'D', 2, 1, 1, 1, 2, 0, 17, 0, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (29, 16, 64, NULL, NULL, NULL, NULL, N'D', 2, 1, 1, 1, 3, 1, 18, 0, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (13, 29, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, 1, 1, 0, 20, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (14, 29, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, 1, 1, 0, 20, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (29, 43, 143, NULL, NULL, NULL, NULL, N'A', 4, 1, 1, 1, 2, 0, 19, 1, 0, 0, 1, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (29, 38, 132, NULL, NULL, NULL, NULL, N'A-', 3.67, 1, 1, 1, 2, 0, 19, 1, 0, 0, 1, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (11, 29, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, 1, 1, 0, 20, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (12, 29, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, 1, 1, 0, 20, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (8, 43, NULL, 100, 30, 5, NULL, NULL, NULL, 1, 1, 1, 1, 0, 20, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Final], [YearWork], [Oral], [Practical], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID], [WillTakeFullCredit], [TookFromCredits], [HasExcuse], [IsEnhancementCourse], [HasWithdrawn], [TookFromEnhancementCredits]) VALUES (8, 16, 91, NULL, NULL, NULL, NULL, N'A', 4, 1, 1, 1, 1, 0, 17, 1, 0, 0, 0, 0, 0)
GO
INSERT [dbo].[StudentDesires] ([ProgramID], [StudentID], [DesireNumber], [StudentCurrentProgramID]) VALUES (4, 19, 1, 1)
GO
INSERT [dbo].[StudentDesires] ([ProgramID], [StudentID], [DesireNumber], [StudentCurrentProgramID]) VALUES (3, 19, 2, 1)
GO
INSERT [dbo].[StudentDesires] ([ProgramID], [StudentID], [DesireNumber], [StudentCurrentProgramID]) VALUES (2, 19, 3, 1)
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
INSERT [dbo].[StudentPrograms] ([ProgramID], [StudentID], [AcademicYear]) VALUES (1, 18, 1)
GO
INSERT [dbo].[StudentPrograms] ([ProgramID], [StudentID], [AcademicYear]) VALUES (2, 18, 2)
GO
INSERT [dbo].[StudentPrograms] ([ProgramID], [StudentID], [AcademicYear]) VALUES (5, 18, 4)
GO
INSERT [dbo].[StudentPrograms] ([ProgramID], [StudentID], [AcademicYear]) VALUES (1, 19, 19)
GO
INSERT [dbo].[StudentPrograms] ([ProgramID], [StudentID], [AcademicYear]) VALUES (1, 27, 1)
GO
INSERT [dbo].[StudentPrograms] ([ProgramID], [StudentID], [AcademicYear]) VALUES (5, 27, 4)
GO
INSERT [dbo].[StudentPrograms] ([ProgramID], [StudentID], [AcademicYear]) VALUES (1, 28, 4)
GO
INSERT [dbo].[StudentPrograms] ([ProgramID], [StudentID], [AcademicYear]) VALUES (5, 28, 7)
GO
INSERT [dbo].[StudentPrograms] ([ProgramID], [StudentID], [AcademicYear]) VALUES (1, 29, 1)
GO
INSERT [dbo].[StudentPrograms] ([ProgramID], [StudentID], [AcademicYear]) VALUES (5, 29, 4)
GO
INSERT [dbo].[StudentPrograms] ([ProgramID], [StudentID], [AcademicYear]) VALUES (1, 30, 10)
GO
INSERT [dbo].[StudentPrograms] ([ProgramID], [StudentID], [AcademicYear]) VALUES (3, 30, 11)
GO
INSERT [dbo].[StudentPrograms] ([ProgramID], [StudentID], [AcademicYear]) VALUES (7, 30, 13)
GO
INSERT [dbo].[StudentPrograms] ([ProgramID], [StudentID], [AcademicYear]) VALUES (1, 11, 10)
GO
INSERT [dbo].[StudentPrograms] ([ProgramID], [StudentID], [AcademicYear]) VALUES (2, 11, 11)
GO
INSERT [dbo].[StudentPrograms] ([ProgramID], [StudentID], [AcademicYear]) VALUES (5, 11, 13)
GO
INSERT [dbo].[StudentPrograms] ([ProgramID], [StudentID], [AcademicYear]) VALUES (2, 27, 2)
GO
INSERT [dbo].[StudentProgramTransferRequest] ([StudentID], [ToProgramID], [ReasonForTransfer], [IsApproved]) VALUES (8, 5, N'string', 0)
GO
INSERT [dbo].[TeacherCourses] ([DoctorID], [CourseID], [AcademicYearID]) VALUES (2, 1, 20)
GO
INSERT [dbo].[TeacherCourses] ([DoctorID], [CourseID], [AcademicYearID]) VALUES (3, 1, 20)
GO
INSERT [dbo].[TeacherCourses] ([DoctorID], [CourseID], [AcademicYearID]) VALUES (2, 43, 20)
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [K_GUID]    Script Date: 2023-03-31 10:44:14 PM ******/
CREATE UNIQUE NONCLUSTERED INDEX [K_GUID] ON [dbo].[Student]
(
	[GUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Course] ADD  CONSTRAINT [DF_Course_Final]  DEFAULT ((0)) FOR [Final]
GO
ALTER TABLE [dbo].[Course] ADD  CONSTRAINT [DF_Course_YearWork]  DEFAULT ((0)) FOR [YearWork]
GO
ALTER TABLE [dbo].[Course] ADD  CONSTRAINT [DF_Course_Oral]  DEFAULT ((0)) FOR [Oral]
GO
ALTER TABLE [dbo].[Course] ADD  CONSTRAINT [DF_Course_Practical]  DEFAULT ((0)) FOR [Practical]
GO
ALTER TABLE [dbo].[Doctor] ADD  CONSTRAINT [DF_Doctor_Type]  DEFAULT ((1)) FOR [Type]
GO
ALTER TABLE [dbo].[Program] ADD  CONSTRAINT [DF_Program_TotalHours]  DEFAULT ((140)) FOR [TotalHours]
GO
ALTER TABLE [dbo].[ProgramCourses] ADD  CONSTRAINT [DF_ProgramCourses_PrerequisiteRelationID]  DEFAULT ((0)) FOR [PrerequisiteRelationID]
GO
ALTER TABLE [dbo].[ProgramCourses] ADD  CONSTRAINT [DF_ProgramCourses_Category]  DEFAULT ((1)) FOR [Category]
GO
ALTER TABLE [dbo].[Student] ADD  CONSTRAINT [DF_Student_Gender]  DEFAULT ((1)) FOR [Gender]
GO
ALTER TABLE [dbo].[Student] ADD  CONSTRAINT [DF_Student_AvailableCredits]  DEFAULT ((12)) FOR [AvailableCredits]
GO
ALTER TABLE [dbo].[Student] ADD  CONSTRAINT [DF_Student_SemestersNumberInProgram]  DEFAULT ((0)) FOR [SemestersNumberInProgram]
GO
ALTER TABLE [dbo].[Student] ADD  CONSTRAINT [DF_Student_IsActive]  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [dbo].[Student] ADD  CONSTRAINT [DF_Student_AvailableWithdraws]  DEFAULT ((8)) FOR [AvailableWithdraws]
GO
ALTER TABLE [dbo].[Student] ADD  CONSTRAINT [DF_Student_AvailableEnhancementCredits]  DEFAULT ((8)) FOR [AvailableEnhancementCredits]
GO
ALTER TABLE [dbo].[StudentCourses] ADD  CONSTRAINT [DF_StudentCourses_IsApproved]  DEFAULT ((1)) FOR [IsApproved]
GO
ALTER TABLE [dbo].[StudentCourses] ADD  CONSTRAINT [DF_StudentCourses_IsIncluded]  DEFAULT ((1)) FOR [IsIncluded]
GO
ALTER TABLE [dbo].[StudentCourses] ADD  CONSTRAINT [DF_StudentCourses_TookFromCredits]  DEFAULT ((0)) FOR [TookFromCredits]
GO
ALTER TABLE [dbo].[StudentCourses] ADD  CONSTRAINT [DF_StudentCourses_HasExcuse]  DEFAULT ((0)) FOR [HasExcuse]
GO
ALTER TABLE [dbo].[StudentCourses] ADD  CONSTRAINT [DF_StudentCourses_IsEnhancementCourse]  DEFAULT ((0)) FOR [IsEnhancementCourse]
GO
ALTER TABLE [dbo].[StudentCourses] ADD  CONSTRAINT [DF_StudentCourses_HasWithdrawn]  DEFAULT ((0)) FOR [HasWithdrawn]
GO
ALTER TABLE [dbo].[StudentCourses] ADD  CONSTRAINT [DF_StudentCourses_TookFromEnhancementCredits]  DEFAULT ((0)) FOR [TookFromEnhancementCredits]
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
ALTER TABLE [dbo].[CoursePrerequisites]  WITH CHECK ADD  CONSTRAINT [FK_CoursePrerequisites_Program] FOREIGN KEY([ProgramID])
REFERENCES [dbo].[Program] ([ID])
GO
ALTER TABLE [dbo].[CoursePrerequisites] CHECK CONSTRAINT [FK_CoursePrerequisites_Program]
GO
ALTER TABLE [dbo].[Doctor]  WITH CHECK ADD  CONSTRAINT [FK_Supervisor_Program] FOREIGN KEY([ProgramID])
REFERENCES [dbo].[Program] ([ID])
GO
ALTER TABLE [dbo].[Doctor] CHECK CONSTRAINT [FK_Supervisor_Program]
GO
ALTER TABLE [dbo].[ElectiveCourseDistribution]  WITH CHECK ADD  CONSTRAINT [FK_OptionalCourse_Program] FOREIGN KEY([ProgramID])
REFERENCES [dbo].[Program] ([ID])
GO
ALTER TABLE [dbo].[ElectiveCourseDistribution] CHECK CONSTRAINT [FK_OptionalCourse_Program]
GO
ALTER TABLE [dbo].[Program]  WITH CHECK ADD  CONSTRAINT [FK_Program_Program] FOREIGN KEY([SuperProgramID])
REFERENCES [dbo].[Program] ([ID])
GO
ALTER TABLE [dbo].[Program] CHECK CONSTRAINT [FK_Program_Program]
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
ALTER TABLE [dbo].[Student]  WITH CHECK ADD  CONSTRAINT [FK_Student_Doctor] FOREIGN KEY([SupervisorID])
REFERENCES [dbo].[Doctor] ([ID])
GO
ALTER TABLE [dbo].[Student] CHECK CONSTRAINT [FK_Student_Doctor]
GO
ALTER TABLE [dbo].[Student]  WITH CHECK ADD  CONSTRAINT [FK_Student_Program] FOREIGN KEY([CurrentProgramID])
REFERENCES [dbo].[Program] ([ID])
GO
ALTER TABLE [dbo].[Student] CHECK CONSTRAINT [FK_Student_Program]
GO
ALTER TABLE [dbo].[StudentCourseRequest]  WITH CHECK ADD  CONSTRAINT [FK_StudentCourseRequest_Course] FOREIGN KEY([CourseID])
REFERENCES [dbo].[Course] ([ID])
GO
ALTER TABLE [dbo].[StudentCourseRequest] CHECK CONSTRAINT [FK_StudentCourseRequest_Course]
GO
ALTER TABLE [dbo].[StudentCourseRequest]  WITH CHECK ADD  CONSTRAINT [FK_StudentCourseRequest_Student] FOREIGN KEY([StudentID])
REFERENCES [dbo].[Student] ([ID])
GO
ALTER TABLE [dbo].[StudentCourseRequest] CHECK CONSTRAINT [FK_StudentCourseRequest_Student]
GO
ALTER TABLE [dbo].[StudentCourses]  WITH NOCHECK ADD  CONSTRAINT [FK_StudentCourses_AcademicYear] FOREIGN KEY([AcademicYearID])
REFERENCES [dbo].[AcademicYear] ([ID])
GO
ALTER TABLE [dbo].[StudentCourses] CHECK CONSTRAINT [FK_StudentCourses_AcademicYear]
GO
ALTER TABLE [dbo].[StudentCourses]  WITH NOCHECK ADD  CONSTRAINT [FK_StudentCourses_Course] FOREIGN KEY([CourseID])
REFERENCES [dbo].[Course] ([ID])
GO
ALTER TABLE [dbo].[StudentCourses] CHECK CONSTRAINT [FK_StudentCourses_Course]
GO
ALTER TABLE [dbo].[StudentCourses]  WITH NOCHECK ADD  CONSTRAINT [FK_StudentCourses_Student] FOREIGN KEY([StudentID])
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
ALTER TABLE [dbo].[StudentProgramTransferRequest]  WITH CHECK ADD  CONSTRAINT [FK_StudentProgramTransferRequest_Program] FOREIGN KEY([ToProgramID])
REFERENCES [dbo].[Program] ([ID])
GO
ALTER TABLE [dbo].[StudentProgramTransferRequest] CHECK CONSTRAINT [FK_StudentProgramTransferRequest_Program]
GO
ALTER TABLE [dbo].[StudentProgramTransferRequest]  WITH CHECK ADD  CONSTRAINT [FK_StudentProgramTransferRequest_Student] FOREIGN KEY([StudentID])
REFERENCES [dbo].[Student] ([ID])
GO
ALTER TABLE [dbo].[StudentProgramTransferRequest] CHECK CONSTRAINT [FK_StudentProgramTransferRequest_Student]
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
ALTER TABLE [dbo].[TeacherCourses]  WITH CHECK ADD  CONSTRAINT [FK_TeacherCourses_Supervisor] FOREIGN KEY([DoctorID])
REFERENCES [dbo].[Doctor] ([ID])
GO
ALTER TABLE [dbo].[TeacherCourses] CHECK CONSTRAINT [FK_TeacherCourses_Supervisor]
GO
/****** Object:  StoredProcedure [dbo].[AddCommonQuestions]    Script Date: 2023-03-31 10:44:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[AddCommonQuestions]
@Questions CommonQuestionsType READONLY
AS
BEGIN
	INSERT INTO CommonQuestion(Question,Answer) 
		SELECT Question,Answer
		FROM @Questions;
END
GO
/****** Object:  StoredProcedure [dbo].[AddCourse]    Script Date: 2023-03-31 10:44:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[AddCourse]
@Courses CourseType READONLY
AS
BEGIN
INSERT INTO [dbo].[Course]
           ([CourseCode],[CourseName],[CreditHours]
           ,[LectureHours],[LabHours],[SectionHours]
           ,[IsActive],[Level],[Semester])

           SELECT CourseCode,CourseName,CreditHours
           ,LectureHours,LabHours,SectionHours
           ,IsActive,Level,Semester
		   FROM @Courses
END
GO
/****** Object:  StoredProcedure [dbo].[AddDoctor]    Script Date: 2023-03-31 10:44:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[AddDoctor]
@GUID NVARCHAR(MAX),
@Name NVARCHAR(MAX),
@Email NVARCHAR(MAX),
@Password NVARCHAR(MAX),
@ProgramId INT,
@Type TINYINT,
@CreatedOn SMALLDATETIME
AS
BEGIN
	INSERT INTO [dbo].[Doctor]
           ([GUID],[Name],[Email]
           ,[Password],[IsActive],[CreatedOn]
           ,[ProgramID],[Type])
     VALUES
           (@GUID,@Name,@Email,
           @Password,1,@CreatedOn,
           @ProgramID,@Type);
END
GO
/****** Object:  StoredProcedure [dbo].[AddProgram]    Script Date: 2023-03-31 10:44:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[AddProgram]
@Name NVARCHAR(MAX),
@Semester TINYINT,
@Percentage FLOAT,
@IsRegular BIT,
@IsGeneral BIT,
@TotalHours TINYINT,
@EnglishName VARCHAR(MAX),
@ArabicName NVARCHAR(MAX),
@SuperProgramID INT = NULL,
@CoursesList ProgramCoursesType READONLY,
@PrerequisiteCoursesList PrerequisiteCoursesType READONLY,
@ProgramDistributionList ProgramDistributionType READONLY,
@ElectiveCourseDistributionList ElectiveCourseDistributionType READONLY
AS
BEGIN
	INSERT INTO Program(Name,Semester,Percentage,IsRegular,IsGeneral,TotalHours,EnglishName,ArabicName,SuperProgramID)
	VALUES (@Name,@Semester,@Percentage,@IsRegular,@IsGeneral,@TotalHours,@EnglishName,@ArabicName,@SuperProgramID);
	DECLARE @ProgramID INT = SCOPE_IDENTITY();
	---------------------------------------------
	INSERT INTO ProgramCourses(ProgramID,CourseID,CourseType,PrerequisiteRelationID,Category)
		SELECT @ProgramID,CourseID,CourseType,PrerequisiteRelationID,Category
		FROM @CoursesList;
	---------------------------------------------
	INSERT INTO CoursePrerequisites(ProgramID,CourseID,PrerequisiteCourseID)
		SELECT @ProgramID,CourseID,PrerequisiteCourseID
		FROM @PrerequisiteCoursesList;
	---------------------------------------------
	INSERT INTO ProgramDistribution(ProgramID,Level,Semester,NumberOfHours)
		SELECT @ProgramID,Level,Semester,NumberOfHours
		FROM @ProgramDistributionList;
	---------------------------------------------
	INSERT INTO ElectiveCourseDistribution(ProgramID,Level,Semester,CourseType,Category,Hour)
		SELECT @ProgramID,Level,Semester,CourseType,Category,Hour
		FROM @ElectiveCourseDistributionList;
END
GO
/****** Object:  StoredProcedure [dbo].[AddStudent]    Script Date: 2023-03-31 10:44:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[AddStudent]
@GUID varchar(60),
@Name nvarchar(max),
@SSN varchar(20),
@PhoneNumber varchar(12),
@BirthDate date,
@Address nvarchar(max),
@Gender char(1),
@Nationality nvarchar(max),
@Email nvarchar(max),
@Password nvarchar(max),
@AcademicCode varchar(10),
@SeatNumber varchar(10),
@SupervisorID int = NULL,
@CreatedOn smalldatetime,
@CurrentProgramID int = NULL
AS
BEGIN
INSERT INTO [dbo].[Student]
           ([GUID],[Name],[SSN],[PhoneNumber]
			,[BirthDate],[Address],[Gender],[Nationality]
			,[Email],[Password],[AcademicCode],[SeatNumber],[SupervisorID]
			,[CreatedOn],[CurrentProgramID])
     VALUES
           (@GUID, @Name, @SSN, @PhoneNumber, 
		   @BirthDate, @Address, @Gender, @Nationality, 
		   @Email, @Password, @AcademicCode, @SeatNumber, @SupervisorID,
		   @CreatedOn,@CurrentProgramID);
		DECLARE @Id INT = SCOPE_IDENTITY();
		SELECT * FROM Student WHERE ID = @Id;
END
GO
/****** Object:  StoredProcedure [dbo].[AddStudentCourses]    Script Date: 2023-03-31 10:44:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[AddStudentCourses]
@StudentID INT,
@Query NVARCHAR(MAX)
AS 
BEGIN
	UPDATE StudentCourses
	SET IsIncluded = 0
	WHERE CourseID NOT IN(SELECT CourseID FROM ProgramCourses WHERE ProgramID = [dbo].[GetStudentProgram](@StudentID));
	EXECUTE sp_executesql @Query;
END
GO
/****** Object:  StoredProcedure [dbo].[AddStudentDesires]    Script Date: 2023-03-31 10:44:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[AddStudentDesires]
@Desires StudentDesiresType READONLY,
@StudentID INT,
@CurrentProgramID INT
AS 
BEGIN
	BEGIN TRANSACTION
	BEGIN TRY
	DELETE FROM [dbo].[StudentDesires]
	WHERE [StudentID] = @StudentID;

		INSERT INTO [dbo].[StudentDesires]
			([StudentCurrentProgramID] ,[ProgramID], [StudentID], [DesireNumber])
		SELECT @CurrentProgramID,[ProgramID], @StudentID, [DesireNumber] FROM @Desires;
	END TRY
	BEGIN CATCH
		IF @@ERROR <> 0
			ROLLBACK;
	END CATCH
	COMMIT;
END
GO
/****** Object:  StoredProcedure [dbo].[AddStudentsToPrograms]    Script Date: 2023-03-31 10:44:14 PM ******/
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
		DECLARE @StudentID INT;
		
		SELECT TOP(1) @StudentID = StudentID FROM @StudentProgram;

		UPDATE Student
			SET CurrentProgramID = [dbo].[GetStudentProgram](@StudentID);
	END TRY
	BEGIN CATCH
		IF @@ERROR <> 0
			ROLLBACK;
	END CATCH
	COMMIT;
END
GO
/****** Object:  StoredProcedure [dbo].[AssignDoctorsToCourse]    Script Date: 2023-03-31 10:44:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[AssignDoctorsToCourse]
@Doctors DoctorsGuidType READONLY,
@CourseID INT
AS 
BEGIN
	BEGIN TRANSACTION
	BEGIN TRY
	DECLARE @YearID SMALLINT = [dbo].[GetCurrentYearID]();
	DELETE FROM [dbo].[TeacherCourses]
	WHERE CourseID = @CourseID AND AcademicYearID = @YearID;
		INSERT INTO [dbo].[TeacherCourses]
			([CourseID], [DoctorID], AcademicYearID)
		SELECT @CourseID, [dbo].[GetDoctorIDFromGuid](DoctorGuid), @YearID FROM @Doctors;
	END TRY
	BEGIN CATCH
		IF @@ERROR <> 0
			ROLLBACK;
	END CATCH
	COMMIT;
END
GO
/****** Object:  StoredProcedure [dbo].[BackUpDatabase]    Script Date: 2023-03-31 10:44:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[BackUpDatabase]
@DbName NVARCHAR(MAX),
@Path NVARCHAR(MAX)
AS
BEGIN
	DECLARE @Sql NVARCHAR(MAX);
	SET @Sql = N'BACKUP DATABASE '+ @DbName+' TO DISK = '''+@Path+'''';
	PRINT @Sql;
	EXECUTE sp_executesql @Sql;
END
GO
/****** Object:  StoredProcedure [dbo].[ChangeDoctorPassword]    Script Date: 2023-03-31 10:44:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[ChangeDoctorPassword]
@Guid NVARCHAR(MAX),
@Password NVARCHAR(MAX)
AS
BEGIN
	UPDATE Doctor SET Password = @Password
	WHERE GUID = @Guid;
END
GO
/****** Object:  StoredProcedure [dbo].[ConfirmMarks]    Script Date: 2023-03-31 10:44:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[ConfirmMarks]
AS
BEGIN
DECLARE @CurrentYear INT = [dbo].[GetCurrentYearID](),
@StudentID INT,
@CourseID INT

DECLARE MarkUpdateConfirmalCursor CURSOR FOR  
		SELECT StudentID,CourseID
		FROM StudentCourses
		WHERE AcademicYearID = @CurrentYear AND HasExcuse = 0 AND HasWithdrawn = 0;

	OPEN MarkUpdateConfirmalCursor;  
	FETCH NEXT FROM MarkUpdateConfirmalCursor 
	INTO @StudentID,@CourseID;
		WHILE @@FETCH_STATUS = 0 
			BEGIN
				UPDATE StudentCourses
				SET Mark = ISNULL(Final,0) + ISNULL(YearWork,0) + ISNULL(Oral,0) + ISNULL(Practical,0)
				WHERE StudentID = @StudentID AND
				CourseID = @CourseID AND
				AcademicYearID = @CurrentYear;
				FETCH NEXT FROM MarkUpdateConfirmalCursor 
				INTO @StudentID,@CourseID;
			END;  
		CLOSE MarkUpdateConfirmalCursor;  
	DEALLOCATE MarkUpdateConfirmalCursor;
END
GO
/****** Object:  StoredProcedure [dbo].[CoursesActivation]    Script Date: 2023-03-31 10:44:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[CoursesActivation]
@IsActive BIT,
@CourseLst NVARCHAR(MAX)
AS
BEGIN
	DECLARE @SqlStatment NVARCHAR(MAX) = N'';
	SET @SqlStatment += N'UPDATE Course SET IsActive = '+CAST(@IsActive AS nvarchar(1)) + ' WHERE ID IN '+@CourseLst+';';
	EXECUTE sp_executesql 
	@SqlStatment
END
GO
/****** Object:  StoredProcedure [dbo].[GetAcademicYears]    Script Date: 2023-03-31 10:44:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetAcademicYears]
@GetCurrentYear BIT = 0
AS
BEGIN
	DECLARE @Query NVARCHAR(MAX);
	SET @Query = N'SELECT ID,AcademicYear AS [AcademicYear1],Semester FROM AcademicYear ';
	IF @GetCurrentYear = 1
	BEGIN
		SET @Query+=N' WHERE ID = [dbo].[GetCurrentYearID]()';
	END
	EXECUTE sp_executesql @Query;
END
GO
/****** Object:  StoredProcedure [dbo].[GetAllStudentCourses]    Script Date: 2023-03-31 10:44:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetAllStudentCourses]
@StudentID INT
AS
BEGIN
	SELECT sc.*,c.*
	FROM StudentCourses sc JOIN Course c ON c.ID = sc.CourseID
	JOIN AcademicYear ay ON ay.ID = sc.AcademicYearID
	WHERE StudentID = @StudentID;
END
GO
/****** Object:  StoredProcedure [dbo].[GetAllStudentsDesires]    Script Date: 2023-03-31 10:44:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetAllStudentsDesires]
AS
BEGIN
	SELECT 
		p.id AS [ProgramID],
		p.Name AS [ProgramName],
		p.Percentage AS [ProgramPercentage],
		sd.StudentCurrentProgramID,
		sd.StudentID,
		s.CGPA
	FROM StudentDesires sd JOIN Program p ON p.ID = sd.ProgramID
	JOIN Student s ON s.ID = sd.StudentID
	ORDER BY s.CGPA DESC,sd.DesireNumber ASC;
END
GO
/****** Object:  StoredProcedure [dbo].[GetAllSubPrograms]    Script Date: 2023-03-31 10:44:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetAllSubPrograms]
@ProgramID INT = NULL
AS
BEGIN
IF @ProgramID IS NULL
	BEGIN
		SELECT p.* FROM Program p
	END
ELSE
	BEGIN
		WITH ParentChilds AS (
			SELECT *
			FROM Program
			WHERE ID = @ProgramID
		UNION ALL
			SELECT child.*
			FROM Program child
			JOIN ParentChilds pc
			  ON pc.ID = child.superProgramID
							)
		SELECT *
		FROM ParentChilds;
	END
END
GO
/****** Object:  StoredProcedure [dbo].[GetAvailableCoursesToRegister]    Script Date: 2023-03-31 10:44:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetAvailableCoursesToRegister]
@StudentID INT,
@IsCourseAddtionOrOverload BIT = 0
AS
BEGIN
DECLARE @Statement NVARCHAR(MAX) = N'';
SET @Statement +=N'
DECLARE @StudentLevel  int = [dbo].[CalculateStudentLevel]('+ CAST(@StudentID AS NVARCHAR(MAX))+'); 
DECLARE @StudentProgram  int = [dbo].[GetStudentProgram]('+CAST(@StudentID AS NVARCHAR(MAX))+');
	SELECT pc.*,c.*
	FROM Course c,ProgramCourses pc
	WHERE c.ID = pc.CourseID 
		AND pc.ProgramID = CAST(@StudentProgram AS NVARCHAR(MAX))
		AND c.ID NOT IN(SELECT sc.CourseID FROM StudentCourses sc WHERE sc.Grade <> ''F'' AND StudentID ='+CAST(@StudentID AS NVARCHAR(MAX))+')
		AND [dbo].GetPrequisteNumber('+CAST(@StudentID AS NVARCHAR(MAX))+',c.ID) = (SELECT COUNT(cp.CourseID) FROM CoursePrerequisites cp WHERE cp.CourseID =  c.id AND cp.ProgramID = CAST(@StudentProgram AS NVARCHAR(MAX)))
		AND (c.[Level] = @StudentLevel OR c.[Level] = @StudentLevel + 1 OR c.[Level] < @StudentLevel)
		AND c.IsActive = 1
		AND (pc.CourseType = 1 OR [dbo].[CanRegisterThisCourse](@StudentProgram,'+CAST(@StudentID AS NVARCHAR(MAX))+',c.Level,c.Semester,pc.CourseType,pc.Category,c.CreditHours) = 1)
	UNION
	SELECT pc.*,c.*
	FROM StudentCourses sc JOIN Course c ON c.ID = sc.CourseID JOIN ProgramCourses pc ON sc.CourseID = pc.CourseID
	WHERE sc.Grade = ''F'' AND
		StudentID ='+ CAST(@StudentID AS NVARCHAR(MAX)) +'
		AND pc.ProgramID = CAST(@StudentProgram AS NVARCHAR(MAX))
		AND c.IsActive = 1
		AND sc.CourseID NOT IN(SELECT sc.CourseID FROM StudentCourses sc WHERE sc.Grade <> ''F'' AND StudentID ='+CAST(@StudentID AS NVARCHAR(MAX))+')
		AND (pc.CourseType = 1 OR [dbo].[CanRegisterThisCourse](CAST(@StudentProgram AS NVARCHAR(MAX)),'+CAST(@StudentID AS NVARCHAR(MAX))+',c.Level,c.Semester,pc.CourseType,pc.Category,c.CreditHours) = 1)';
	IF @IsCourseAddtionOrOverload = 1
		BEGIN
		SET @Statement +=N' 
		EXCEPT
			SELECT pc.*,c.*
			FROM StudentCourses sc JOIN Course c ON c.ID = sc.CourseID JOIN ProgramCourses pc ON sc.CourseID = pc.CourseID
			WHERE sc.StudentID = '+CAST(@StudentID AS NVARCHAR(MAX))+' AND pc.ProgramID = CAST(@StudentProgram AS NVARCHAR(MAX)) AND sc.AcademicYearID ='+ CAST([dbo].[GetCurrentYearID]() AS NVARCHAR(MAX))+';';
		END
	EXECUTE sp_executesql @Statement;
END
GO
/****** Object:  StoredProcedure [dbo].[GetCommonQuestions]    Script Date: 2023-03-31 10:44:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetCommonQuestions]
@ID INT = NULL,
@Question NVARCHAR(MAX) = NULL,
@Answer NVARCHAR(MAX) = NULL,
@PageNumber INT = 1,
@PageSize INT = 20,
@OrderBy NVARCHAR(MAX) = N'ID',
@OrderDirection NVARCHAR(MAX) = 'DESC',
@TotalCount INT OUTPUT
AS
BEGIN
	DECLARE @SqlSt nvarchar(max)=N'',
	@SelectSt nvarchar(max) =N'',
	@FromSt nvarchar(max)=N'',
	@WhereSt nvarchar(max)=N'',
	@ParamsDefinition nvarchar(max)=N'',
	@OrderByStatement nvarchar(MAX)=N''

	SET @SelectSt = N'SELECT * ';
	SET @FromSt = N' FROM CommonQuestion ';
	SET @WhereSt = N' WHERE 1=1 ';
	IF @Question IS NOT NULL
		BEGIN
			SET @WhereSt += N' AND Question LIKE N''%'+@Question+'%''';
		END
	IF @Answer IS NOT NULL
		BEGIN
			SET @WhereSt += N' AND Answer LIKE N''%'+@Answer+'%''';
		END
	SET @OrderByStatement =N' ORDER BY '+@OrderBy+' '+@OrderDirection
	+' OFFSET ' + CAST((@PageSize*(@PageNumber-1)) AS VARCHAR(5)) +' ROWS'
	+' FETCH NEXT ' + CAST(@PageSize AS VARCHAR(5)) + ' ROWS ONLY; ' ;
	SET @SqlSt =
	@SelectSt + @FromSt + @WhereSt + @OrderByStatement
	SET @SqlSt += ' SELECT @TotalCountParam = COUNT(ID) ' + @FromSt + @WhereSt;
	SET @ParamsDefinition = N'@TotalCountParam INT OUTPUT';
	EXECUTE sp_executesql 
	@SqlSt,
	@ParamsDefinition,
	@TotalCountParam = @TotalCount output
END
GO
/****** Object:  StoredProcedure [dbo].[GetCourseDetails]    Script Date: 2023-03-31 10:44:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetCourseDetails] 
@CourseID INT
AS
BEGIN
	SELECT * FROM Course WHERE ID = @CourseID;

	SELECT d.Name 
	FROM Doctor d
	JOIN TeacherCourses tc ON (d.[ID] = tc.[DoctorID])
	WHERE tc.CourseID = @CourseID AND tc.AcademicYearID = [dbo].[GetCurrentYearID]()
	AND d.Name IS NOT NULL;

	SELECT p.ArabicName
	FROM Program p
	JOIN ProgramCourses pc ON (p.ID = pc.ProgramID)
	WHERE pc.CourseID = @CourseID;
END
GO
/****** Object:  StoredProcedure [dbo].[GetCourses]    Script Date: 2023-03-31 10:44:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetCourses]
@ProgramID INT = NULL,
@CourseProgramID INT = NULL,
@CourseCode NVARCHAR(MAX) = NULL,
@CourseName NVARCHAR(MAX) = NULL,
@CreditHours TINYINT = NULL,
@LectureHours TINYINT = NULL,
@LabHours TINYINT = NULL,
@SectionHours TINYINT = NULL,
@IsActive BIT = NULL,
@Level TINYINT = NULL,
@Semester TINYINT = NULL,
@DoctorID NVARCHAR(MAX) = NULL,
@PageNumber INT = 1,
@PageSize INT = 20,
@OrderBy VARCHAR(50) = 'c.ID',
@OrderDirection VARCHAR(4) = 'DESC',
@TotalCount INT OUTPUT
AS
BEGIN
DECLARE @SqlStatment nvarchar(max)=N'',
@SelectStatment nvarchar(max) =N'',
@FromStatment nvarchar(max) =N'',
@WhereStatment nvarchar(max)=N'',
@ParamsDefinition nvarchar(max)=N'',
@OrderByStatement nvarchar(MAX)=N'',
@RecursionStatement NVARCHAR(MAX) = N'';

IF @ProgramID IS NOT NULL
	BEGIN
		SET @RecursionStatement = N'
		WITH ParentChilds AS (
			SELECT *
			FROM Program
			WHERE ID ='+ CAST(@ProgramID AS VARCHAR(10))+
		' UNION ALL
			SELECT child.*
			FROM Program child
			JOIN ParentChilds pc
			  ON pc.ID = child.superProgramID)';
	END
	SET @SelectStatment =@RecursionStatement + N' SELECT DISTINCT(c.[ID])
      ,c.[CourseCode]
      ,c.[CourseName]
      ,c.[CreditHours]
      ,c.[LectureHours]
      ,c.[LabHours]
      ,c.[SectionHours]
      ,c.[IsActive]
      ,c.[Level]
      ,c.[Semester]';
	SET @FromStatment = N' FROM Course c LEFT JOIN ProgramCourses sc ON sc.CourseID = c.id ';
	SET @WhereStatment = N' WHERE 1 = 1 ';
	IF @DoctorID IS NOT NULL
	BEGIN
	SET @FromStatment += N' LEFT JOIN TeacherCourses tc ON tc.CourseID = c.ID '
		SET @WhereStatment+=N' AND tc.DoctorID = (SELECT TOP 1 ID FROM Doctor WHERE GUID = '''+@DoctorID+''') AND tc.AcademicYearID = [dbo].[GetCurrentYearID]()';
	END
	IF @ProgramID IS NOT NULL
		BEGIN
			SET @WhereStatment += N' AND sc.ProgramID IN (SELECT id FROM ParentChilds) '
		END
	IF @CourseProgramID IS NOT NULL
		BEGIN
			SET @WhereStatment += N' AND sc.ProgramID = ' + CAST(@CourseProgramID AS NVARCHAR(5));
		END
	IF @CourseCode IS NOT NULL
		BEGIN
			SET @WhereStatment += N' AND c.CourseCode LIKE N''%' + @CourseCode +'%''';
		END
	IF @CourseName IS NOT NULL
		BEGIN
			SET @WhereStatment += N' AND c.CourseName LIKE N''%' + @CourseName +'%''';
		END
	IF @CreditHours IS NOT NULL
		BEGIN
			SET @WhereStatment += N' AND c.CreditHours =' + CAST(@CreditHours AS VARCHAR(2));
		END
	IF @LectureHours IS NOT NULL
		BEGIN
			SET @WhereStatment += N' AND c.LectureHours =' + CAST(@LectureHours AS VARCHAR(2));
		END
	IF @LabHours IS NOT NULL
		BEGIN
			SET @WhereStatment += N' AND c.LabHours =' + CAST(@LabHours AS VARCHAR(2));
		END
	IF @SectionHours IS NOT NULL
		BEGIN
			SET @WhereStatment += N' AND c.SectionHours =' + CAST(@SectionHours AS VARCHAR(2));
		END
	IF @Level IS NOT NULL
		BEGIN
			SET @WhereStatment += N' AND c.Level =' + CAST(@Level AS VARCHAR(1));
		END
	IF @Semester IS NOT NULL
		BEGIN
			SET @WhereStatment += N' AND c.Semester =' + CAST(@Semester AS VARCHAR(1));
		END
	IF @IsActive IS NOT NULL
		BEGIN
			SET @WhereStatment += N' AND c.IsActive =' + CAST(@IsActive AS VARCHAR(1));
		END
SET @OrderByStatement =N' ORDER BY '+@OrderBy+' '+@OrderDirection
+' OFFSET ' + CAST((@PageSize*(@PageNumber-1)) AS VARCHAR(5)) +' ROWS'
+' FETCH NEXT ' + CAST(@PageSize AS VARCHAR(5)) + ' ROWS ONLY; ' ;

	SET @SqlStatment =
	@SelectStatment + @FromStatment + @WhereStatment + @OrderByStatement
SET @SqlStatment += @RecursionStatement +' SELECT @TotalCountParam = COUNT(DISTINCT(c.ID)) ' + @FromStatment +@WhereStatment;
PRINT @SqlStatment;
	SET @ParamsDefinition = N'@TotalCountParam INT OUTPUT';
	EXECUTE sp_executesql 
	@SqlStatment,
	@ParamsDefinition,
	@TotalCountParam = @TotalCount output
END
GO
/****** Object:  StoredProcedure [dbo].[GetCoursesForAddAndDelete]    Script Date: 2023-03-31 10:44:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetCoursesForAddAndDelete]
@StudentID INT
AS
BEGIN
	DECLARE @ProgramID INT = [dbo].[GetStudentProgram](@StudentID);
	EXEC [dbo].[GetElectiveCoursesDistribution] @StudentID,1
	EXEC [dbo].[GetAvailableCoursesToRegister] @StudentID,1
	EXEC [dbo].[GetCoursesForDeletionOrWithdraw] @StudentID
END
GO
/****** Object:  StoredProcedure [dbo].[GetCoursesForDeletionOrWithdraw]    Script Date: 2023-03-31 10:44:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetCoursesForDeletionOrWithdraw]
@StudentID INT
AS
BEGIN
DECLARE @StudentProgram INT = [dbo].[GetStudentProgram](@StudentID);
		SELECT pc.*,c.*
		FROM StudentCourses sc JOIN Course c ON c.ID = sc.CourseID 
		JOIN ProgramCourses pc ON sc.CourseID = pc.CourseID
		WHERE sc.StudentID = @StudentID AND 
		pc.ProgramID = @StudentProgram AND
		sc.AcademicYearID =[dbo].[GetCurrentYearID]();	
END
GO
/****** Object:  StoredProcedure [dbo].[GetCoursesForEnhancement]    Script Date: 2023-03-31 10:44:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetCoursesForEnhancement]
@StudentID INT
AS
BEGIN
	DECLARE @StudentProgram INT = [dbo].[GetStudentProgram](@StudentID);
		SELECT pc.*,c.*
		FROM Course c JOIN ProgramCourses pc ON c.ID = pc.CourseID
		WHERE pc.ProgramID = @StudentProgram AND
		pc.CourseType = 2 AND c.Level IN(3,4) ;
		EXEC [dbo].[GetElectiveCoursesDistribution] @StudentID,0,1 ;
END
GO
/****** Object:  StoredProcedure [dbo].[GetCoursesForGraduation]    Script Date: 2023-03-31 10:44:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetCoursesForGraduation]
@StudentID INT
AS
BEGIN
DECLARE @StudentLevel  int = [dbo].[CalculateStudentLevel](@StudentID); 
DECLARE @StudentProgram  int = [dbo].[GetStudentProgram](@StudentID);
DECLARE @CurrentSemester TINYINT;
	SELECT @CurrentSemester = Semester FROM AcademicYear WHERE ID = [dbo].[GetCurrentYearID]();
	SELECT pc.*,c.*
	FROM Course c,ProgramCourses pc
	WHERE c.ID = pc.CourseID 
		AND pc.ProgramID = @StudentProgram
		AND c.ID NOT IN(SELECT sc.CourseID FROM StudentCourses sc WHERE sc.Grade <> 'F' AND StudentID =@StudentID)
		AND [dbo].GetPrequisteNumber(@StudentID,c.ID) = (SELECT COUNT(cp.CourseID) FROM CoursePrerequisites cp WHERE cp.CourseID =  c.id AND cp.ProgramID = @StudentProgram)
		AND (c.[Level] = @StudentLevel OR c.[Level] = @StudentLevel + 1)
		AND c.Semester <> @CurrentSemester
		AND (pc.CourseType = 1 OR [dbo].[CanRegisterThisCourse](@StudentProgram,@StudentID,c.Level,c.Semester,pc.CourseType,pc.Category,c.CreditHours) = 1)
	UNION
	SELECT pc.*,c.*
	FROM StudentCourses sc JOIN Course c ON c.ID = sc.CourseID JOIN ProgramCourses pc ON sc.CourseID = pc.CourseID
	WHERE sc.Grade = 'F' AND
		StudentID =@StudentID
		AND pc.ProgramID = @StudentProgram 
		AND c.Semester <> @CurrentSemester
		AND sc.CourseID NOT IN(SELECT sc.CourseID FROM StudentCourses sc WHERE sc.Grade <> 'F' AND StudentID =@StudentID)
		AND (pc.CourseType = 1 OR [dbo].[CanRegisterThisCourse](@StudentProgram,@StudentID,c.Level,c.Semester,pc.CourseType,pc.Category,c.CreditHours) = 1)
	UNION
	SELECT pc.*,c.*
	FROM Course c JOIN ProgramCourses pc ON c.ID = pc.CourseID
	WHERE 
		 pc.ProgramID = @StudentProgram 
		AND c.Semester <> @CurrentSemester
		AND c.ID NOT IN(SELECT sc.CourseID FROM StudentCourses sc WHERE sc.Grade <> 'F' AND StudentID =@StudentID)
		AND [dbo].GetPrequisteNumber(@StudentID,c.ID) = (SELECT COUNT(cp.CourseID) FROM CoursePrerequisites cp WHERE cp.CourseID =  c.id AND cp.ProgramID = @StudentProgram)
		AND (pc.CourseType = 1 OR [dbo].[CanRegisterThisCourse](@StudentProgram,@StudentID,c.Level,c.Semester,pc.CourseType,pc.Category,c.CreditHours) = 1)
	EXEC [dbo].[GetElectiveCoursesDistribution] @StudentID,0,0
END
GO
/****** Object:  StoredProcedure [dbo].[GetCoursesForOverload]    Script Date: 2023-03-31 10:44:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetCoursesForOverload]
@StudentID INT
AS
BEGIN
SELECT SUM(c.creditHours) AS [RegisteredHours] FROM Course c JOIN StudentCourses sc ON sc.CourseID = c.ID
WHERE sc.StudentID = @StudentID AND sc.AcademicYearID = [dbo].[GetCurrentYearID]();
EXEC [dbo].[GetAvailableCoursesToRegister] @StudentID,1
EXEC [dbo].[GetElectiveCoursesDistribution] @StudentID,1
END
GO
/****** Object:  StoredProcedure [dbo].[GetCoursesListExceptPassed]    Script Date: 2023-03-31 10:44:14 PM ******/
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
/****** Object:  StoredProcedure [dbo].[GetCoursesRequests]    Script Date: 2023-03-31 10:44:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetCoursesRequests]
@StudentID INT = NULL,
@RequestTypeID INT = NULL,
@RequestID NVARCHAR(MAX) = NULL,
@IsApproved BIT = NULL
AS
BEGIN
DECLARE @SelectStatement NVARCHAR(MAX), @FromStatement NVARCHAR(MAX), @WhereStatement NVARCHAR(MAX);
	SET @SelectStatement = N'SELECT c.CourseCode,
			c.CourseName,
			c.CreditHours,
			scr.[RequestID],
			scr.[RequestTypeID],
			scr.[CourseID],
			scr.[IsApproved],
			scr.[CourseOperationID]';
	SET @FromStatement =N' FROM StudentCourseRequest scr JOIN Course c ON scr.CourseID = c.ID';
	SET @WhereStatement = N' 
	WHERE 1 = 1';
	IF @StudentID IS NOT NULL
	BEGIN
		SET @WhereStatement +=N' 
		AND scr.StudentID = ' + CAST(@StudentID AS NVARCHAR(MAX));
	END
	IF @RequestTypeID IS NOT NULL
	BEGIN
		SET @WhereStatement +=N' 
		AND scr.RequestTypeID = ' +CAST(@RequestTypeID AS NVARCHAR(MAX));
	END
	IF @RequestID IS NOT NULL
	BEGIN
		SET @WhereStatement +=N' 
		AND scr.RequestID = ''' + @RequestID+'''';
	END
	IF @IsApproved IS NOT NULL
	BEGIN
		SET @WhereStatement +=N' 
		AND scr.IsApproved = ' +CAST(@IsApproved AS NVARCHAR(MAX)); 
	END
	DECLARE @SqlStatement NVARCHAR(MAX) = @SelectStatement + @FromStatement + @WhereStatement;
	PRINT @SqlStatement;
EXECUTE sp_executesql @SqlStatement;
END
GO
/****** Object:  StoredProcedure [dbo].[GetDates]    Script Date: 2023-03-31 10:44:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetDates]
@DateFor INT = NULL
AS
BEGIN
	DECLARE @SqlSt NVARCHAR(MAX);
	SET @SqlSt = N'SELECT * FROM Date ';
	IF @DateFor IS NOT NULL
	BEGIN
		SET @SqlSt +=N'
		WHERE DateFor ='+CAST(@DateFor AS NVARCHAR(MAX));
	END
	EXECUTE sp_executesql @SqlSt;
END
GO
/****** Object:  StoredProcedure [dbo].[GetDoctorByGuid]    Script Date: 2023-03-31 10:44:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetDoctorByGuid]
@GUID NVARCHAR(MAX),
@IsActive BIT = 1
AS
BEGIN
SELECT Guid,
		d.Name,
		Email,
		p.Name AS[ProgramName],
		d.IsActive,
		d.Type,
		p.id AS [ProgramID]
		FROM Doctor d JOIN Program p ON p.ID = d.ProgramID
		WHERE GUID = @GUID AND IsActive = @IsActive;
END
GO
/****** Object:  StoredProcedure [dbo].[GetDoctors]    Script Date: 2023-03-31 10:44:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetDoctors]
@Name NVARCHAR(MAX) = NULL,
@Email NVARCHAR(MAX)= NULL,
@ProgramID INT= NULL,
@Type TINYINT = NULL,
@IsActive BIT = NULL,
@PageNumber INT = 1,
@PageSize INT = 20,
@OrderBy NVARCHAR(MAX) = N'd.ID',
@OrderDirection NVARCHAR(MAX) = 'DESC',
@TotalCount INT OUTPUT
AS
BEGIN
	DECLARE @SqlSt nvarchar(max)=N'',
	@SelectSt nvarchar(max) =N'',
	@FromSt nvarchar(max)=N'',
	@WhereSt nvarchar(max)=N'',
	@ParamsDefinition nvarchar(max)=N'',
	@OrderByStatement nvarchar(MAX)=N''

	SET @SelectSt = N'SELECT Guid,
		d.Name,
		Email,
		p.Name AS[ProgramName],
		d.IsActive,
		d.Type,
		p.id AS [ProgramID]'
	SET @FromSt = N'
		FROM Doctor d JOIN Program p ON p.ID = d.ProgramID
		';
	SET @WhereSt = N' WHERE 1=1 ';
	IF @Name IS NOT NULL
		BEGIN
			SET @WhereSt += N' AND d.Name LIKE N''%'+@Name+'%''';
		END
	IF @Email IS NOT NULL
		BEGIN
			SET @WhereSt += N' AND d.Email LIKE N''%'+@Email+'%''';
		END
	IF @ProgramID IS NOT NULL
		BEGIN
			SET @WhereSt += N' AND p.id ='+CAST(@ProgramID AS NVARCHAR(MAX));
		END
	IF @Type IS NOT NULL
		BEGIN
			SET @WhereSt += N' AND d.Type ='+CAST(@Type AS NVARCHAR(MAX));
		END
	IF @IsActive IS NOT NULL
		BEGIN
			SET @WhereSt += N' AND d.IsActive ='+CAST(@IsActive AS NVARCHAR(MAX));
		END

	
	SET @OrderByStatement =N' ORDER BY '+@OrderBy+' '+@OrderDirection
	+' OFFSET ' + CAST((@PageSize*(@PageNumber-1)) AS VARCHAR(5)) +' ROWS'
	+' FETCH NEXT ' + CAST(@PageSize AS VARCHAR(5)) + ' ROWS ONLY; ' ;
	SET @SqlSt =
	@SelectSt + @FromSt + @WhereSt + @OrderByStatement
	SET @SqlSt += ' SELECT @TotalCountParam = COUNT(*) ' + @FromSt + @WhereSt;
	SET @ParamsDefinition = N'@TotalCountParam INT OUTPUT';
	PRINT @SqlSt;
	EXECUTE sp_executesql 
	@SqlSt,
	@ParamsDefinition,
	@TotalCountParam = @TotalCount output
END
GO
/****** Object:  StoredProcedure [dbo].[GetElectiveCoursesDistribution]    Script Date: 2023-03-31 10:44:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetElectiveCoursesDistribution]
@StudentID INT,
@IsForOverload BIT = 0,
@IsForEnhancement BIT = 0
AS
BEGIN
	DECLARE @ProgramID INT = [dbo].[GetStudentProgram](@StudentID);
	IF @IsForEnhancement = 0
	BEGIN
		SELECT ec.ProgramID,
		ec.Level,
		ec.Semester,
		ec.Category,
		ec.CourseType,
		(ec.Hour - (SELECT [dbo].[GetSumOfElectivePassedHours](@ProgramID,@StudentID,ec.Level,ec.Semester,ec.CourseType,ec.Category,@IsForOverload))) AS Hour
		FROM ElectiveCourseDistribution ec
		WHERE ec.ProgramID = @ProgramID
	END
	ELSE
	BEGIN
		SELECT ec.ProgramID,
		ec.Level,
		ec.Semester,
		ec.Category,
		ec.CourseType,
		ec.Hour
		FROM ElectiveCourseDistribution ec
		WHERE ec.ProgramID = @ProgramID
	END
END
GO
/****** Object:  StoredProcedure [dbo].[GetFailedCoursesList]    Script Date: 2023-03-31 10:44:14 PM ******/
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
/****** Object:  StoredProcedure [dbo].[GetPassedCoursesList]    Script Date: 2023-03-31 10:44:14 PM ******/
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
/****** Object:  StoredProcedure [dbo].[GetProgramByID]    Script Date: 2023-03-31 10:44:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetProgramByID]
@ID INT
AS
BEGIN
	SELECT sub.ID,
	sub.Name,
	sub.Semester,
	sub.Percentage,
	sub.IsRegular,
	sub.IsGeneral,
	sub.TotalHours,
	sub.EnglishName,
	sub.ArabicName,
	sub.SuperProgramID,
	sup.Name AS [SuperProgramName]
	FROM Program sub LEFT JOIN Program sup on sup.ID = sub.SuperProgramID
	WHERE sub.ID = @ID;
END
GO
/****** Object:  StoredProcedure [dbo].[GetPrograms]    Script Date: 2023-03-31 10:44:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetPrograms]
@Name NVARCHAR(MAX) = NULL,
@Semester TINYINT = NULL,
@Percentage FLOAT = NULL,
@IsRegular BIT = NULL,
@IsGeneral BIT = NULL,
@TotalHours TINYINT = NULL,
@EnglishName NVARCHAR(MAX) = NULL,
@ArabicName NVARCHAR(MAX) = NULL,
@SuperProgramID INT = NULL,
@PageNumber INT = 1,
@PageSize INT = 20,
@OrderBy NVARCHAR(MAX) = N'sub.ID',
@OrderDirection NVARCHAR(MAX) = 'DESC',
@TotalCount INT OUTPUT
AS
BEGIN
	DECLARE @SqlSt nvarchar(max)=N'',
	@SelectSt nvarchar(max) =N'',
	@FromSt nvarchar(max)=N'',
	@WhereSt nvarchar(max)=N'',
	@ParamsDefinition nvarchar(max)=N'',
	@OrderByStatement nvarchar(MAX)=N''
	SET @SelectSt = N'SELECT sub.ID,
	sub.Name,
	sub.Semester,
	sub.Percentage,
	sub.IsRegular,
	sub.IsGeneral,
	sub.TotalHours,
	sub.EnglishName,
	sub.ArabicName,
	sub.SuperProgramID,
	sup.Name AS [SuperProgramName]';
	SET @FromSt = N'
	FROM Program sub LEFT JOIN Program sup on sup.ID = sub.SuperProgramID';
	SET @WhereSt = N' 
	WHERE 1=1 ';
	IF @Name IS NOT NULL
	BEGIN
		SET @WhereSt += N' AND sub.Name LIKE N''%'+@Name+'%''';
	END
	IF @EnglishName IS NOT NULL
	BEGIN
		SET @WhereSt += N' AND sub.EnglishName LIKE N''%'+@EnglishName+'%''';
	END
	IF @ArabicName IS NOT NULL
	BEGIN
		SET @WhereSt += N' AND sub.ArabicName LIKE N''%'+@ArabicName+'%''';
	END
	IF @SuperProgramID IS NOT NULL
	BEGIN
		SET @WhereSt += N' AND sub.SuperProgramID ='+CAST(@SuperProgramID AS NVARCHAR(MAX));
	END
	IF @Semester IS NOT NULL
	BEGIN
		SET @WhereSt += N' AND sub.Semester ='+CAST(@Semester AS NVARCHAR(MAX));
	END
	IF @Percentage IS NOT NULL
	BEGIN
		SET @WhereSt += N' AND sub.Percentage ='+CAST(@Percentage AS NVARCHAR(MAX));
	END
	IF @IsRegular IS NOT NULL
	BEGIN
		SET @WhereSt += N' AND sub.IsRegular ='+CAST(@IsRegular AS NVARCHAR(MAX));
	END
	IF @IsGeneral IS NOT NULL
	BEGIN
		SET @WhereSt += N' AND sub.IsGeneral ='+CAST(@IsGeneral AS NVARCHAR(MAX));
	END
	IF @TotalHours IS NOT NULL
	BEGIN
		SET @WhereSt += N' AND sub.TotalHours ='+CAST(@TotalHours AS NVARCHAR(MAX));
	END
	SET @OrderByStatement =N' ORDER BY '+@OrderBy+' '+@OrderDirection
+' OFFSET ' + CAST((@PageSize*(@PageNumber-1)) AS VARCHAR(5)) +' ROWS'
+' FETCH NEXT ' + CAST(@PageSize AS VARCHAR(5)) + ' ROWS ONLY; ' ;

	SET @SqlSt =
	@SelectSt + @FromSt + @WhereSt + @OrderByStatement
	SET @SqlSt += ' SELECT @TotalCountParam = COUNT(*) ' + @FromSt + @WhereSt;
	SET @ParamsDefinition = N'@TotalCountParam INT OUTPUT';
	EXECUTE sp_executesql 
	@SqlSt,
	@ParamsDefinition,
	@TotalCountParam = @TotalCount output
END
GO
/****** Object:  StoredProcedure [dbo].[GetProgramsListForProgramTransfer]    Script Date: 2023-03-31 10:44:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetProgramsListForProgramTransfer]
@ProgramID INT
AS
BEGIN
	WITH ParentChilds AS (
				SELECT *
				FROM Program
				WHERE ID = @ProgramID
			UNION ALL
				SELECT child.*
				FROM Program child
				JOIN ParentChilds pc
				  ON pc.SuperProgramID = child.ID
								)
	SELECT ID,Name 
	FROM Program
	WHERE IsGeneral = 0 AND ID NOT IN(
			SELECT ID
			FROM ParentChilds
	);
END
GO
/****** Object:  StoredProcedure [dbo].[GetProgramTransferRequests]    Script Date: 2023-03-31 10:44:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetProgramTransferRequests]
@StudentID INT = NULL,
@ToProgramID INT = NULL,
@IsApproved INT = NULL
AS
BEGIN
DECLARE @SelectSt NVARCHAR(MAX),@FromSt NVARCHAR(MAX),@WhereSt NVARCHAR(MAX),@Sql NVARCHAR(MAX);
	SET @SelectSt = N'SELECT 
	s.Name AS [StudentName],
	s.CGPA AS [StudentGPA],
	s.Level AS [StudentLevel],
	s.GUID,
	sptr.IsApproved,
	sptr.ReasonForTransfer,
	toProg.Name AS [ToProgramName],
	fromProg.Name AS [CurrentProgramName]';
	SET @FromSt = N'
	FROM [StudentProgramTransferRequest] sptr JOIN Student s ON sptr.StudentID = s.ID 
	JOIN Program fromProg ON fromProg.ID = s.CurrentProgramID
	JOIN Program toProg ON toProg.ID = sptr.ToProgramID';
	SET @WhereSt = N' WHERE 1=1'
	IF @StudentID IS NOT NULL
	BEGIN
		SET @WhereSt += N' AND StudentID = '+CAST(@StudentID AS NVARCHAR(MAX));
	END
	IF @ToProgramID IS NOT NULL
	BEGIN
		SET @WhereSt += N' AND ToProgramID = '+CAST(@ToProgramID AS NVARCHAR(MAX));
	END
	IF @IsApproved IS NOT NULL
	BEGIN
		SET @WhereSt += N' AND IsAPproved = '+CAST(@IsApproved AS NVARCHAR(MAX));
	END
	SET @Sql = @SelectSt + @FromSt + @WhereSt;
	EXECUTE sp_executesql @Sql;
END
GO
/****** Object:  StoredProcedure [dbo].[GetStudent]    Script Date: 2023-03-31 10:44:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetStudent]
@SSN NVARCHAR(25) = NULL,
@GUID NVARCHAR(MAX) = NULL,
@IncludeProgram BIT = 0,
@IncludeSupervisor BIT = 0
AS
BEGIN
	DECLARE @SqlStatment NVARCHAR(MAX) = N'',
	@SelectStatement NVARCHAR(MAX) = N'',
	@FROMStatement NVARCHAR(MAX) = N'',
	@WhereStatement NVARCHAR(MAX) = N'';

	SET @SelectStatement =N'SELECT s.*';
	SET @FROMStatement =N' FROM Student s ';
	SET @WhereStatement = N' WHERE 1 = 1 ';
	IF @SSN IS NOT NULL
		BEGIN
			SET @WhereStatement +=N' AND s.SSN = '''+ @SSN +'''';
		END
	IF @GUID IS NOT NULL
		BEGIN
			SET @WhereStatement +=N' AND s.GUID = '''+ @GUID + '''; ';
		END
	IF @IncludeProgram = 1
		BEGIN
			SET @SelectStatement += N',p.Name AS [ProgramName]';
			SET @FROMStatement +=N' LEFT JOIN Program p ON p.id = s.CurrentProgramID ';
		END
	IF @IncludeSupervisor = 1
		BEGIN
			SET @SelectStatement += N',d.Name AS [SupervisorName]';
			SET @FROMStatement +=N' LEFT JOIN Doctor d ON d.id = s.SupervisorID ';
		END
		SET @SqlStatment = @SelectStatement + @FROMStatement + @WhereStatement;
		PRINT @SqlStatment;
	EXECUTE sp_executesql @SqlStatment
END
GO
/****** Object:  StoredProcedure [dbo].[GetStudentAcademicYearsSummary]    Script Date: 2023-03-31 10:44:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetStudentAcademicYearsSummary]
@StudentID INT
AS
BEGIN
	SELECT 
			sc.AcademicYearID AS [ID],
			ay.AcademicYear,
			ay.Semester,
			ROUND(SUM(sc.points * c.CreditHours)/SUM(c.CreditHours),4) AS [SGPA],
			(Select ROUND(SUM(ic.CreditHours * isc.points)/SUM(ic.CreditHours),4)
			 FROM studentCourses isc,Course ic
			 WHERE 
			 ic.ID = isc.CourseID AND isc.IsIncluded =1 AND
			 isc.grade IS NOT NULL AND isc.IsGPAIncluded = 1 AND
			 isc.StudentID=@StudentID AND isc.AcademicYearID <=sc.AcademicYearID) AS [CGPA],
			 [dbo].[GetStudentProgramNameAtAcademicYear](@StudentID,sc.AcademicYearID) AS [ProgramName]
	FROM StudentCourses sc 
		JOIN Course c ON c.ID = sc.CourseID 
		JOIN AcademicYear ay ON ay.ID = sc.AcademicYearID
	WHERE StudentID = @StudentID AND
			 c.ID = sc.CourseID AND
			 sc.IsIncluded =1 AND
			 sc.grade IS NOT NULL
	GROUP BY AcademicYearID,
			ay.AcademicYear,
			ay.Semester
END
GO
/****** Object:  StoredProcedure [dbo].[GetStudentCoursesByAcademicYear]    Script Date: 2023-03-31 10:44:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetStudentCoursesByAcademicYear]
@StudentID INT,
@AcademicYearID INT
AS
BEGIN
SELECT 
      c.CourseCode
	  ,c.CourseName
	  ,c.CreditHours
	  ,c.Final
	  ,c.YearWork
	  ,c.Oral
	  ,c.Practical
      ,sc.[Mark]
      ,sc.[Grade]
      ,sc.[points]
      ,sc.[IsApproved]
      ,sc.[IsGPAIncluded]
      ,sc.[IsIncluded]
      ,sc.[CourseEntringNumber]
      ,sc.[AcademicYearID]
      ,sc.[WillTakeFullCredit]
      ,sc.[TookFromCredits]
      ,sc.[HasExcuse]
      ,sc.[IsEnhancementCourse]
	  ,sc.Final AS [SFinal]
	  ,sc.YearWork AS [SYearWork]
	  ,sc.Oral AS [SOral]
	  ,sc.Practical AS [SPractical]
  FROM Course c JOIN StudentCourses sc ON c.ID = sc.CourseID
  WHERE sc.StudentID = @StudentID AND sc.AcademicYearID = @AcademicYearID
END
GO
/****** Object:  StoredProcedure [dbo].[GetStudentDesires]    Script Date: 2023-03-31 10:44:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetStudentDesires]
@ID INT
AS
BEGIN
	IF EXISTS ( SELECT 1 FROM StudentDesires WHERE StudentID = @ID)
	BEGIN
		SELECT 
		sd.ProgramID,sd.DesireNumber,p.Name AS [ProgramName]
		FROM StudentDesires sd JOIN Program p ON p.ID = sd.ProgramID
		WHERE StudentID = @ID;
	END
	ELSE
	BEGIN
		DECLARE @StudentProgramID INT, @SemesterCount TINYINT,@CurrentSemester TINYINT;
		SET @StudentProgramID = [dbo].[GetStudentProgram](@ID);
		SELECT @SemesterCount =s.SemestersNumberInProgram FROM Student s WHERE ID = @ID;
		SELECT @CurrentSemester = Semester FROM AcademicYear WHERE ID = [dbo].[GetCurrentYearID]();

		IF @StudentProgramID IS NULL
		BEGIN
			SELECT p.Name AS [ProgramName],
			p.ID AS [ProgramID],
			ROW_NUMBER() OVER(ORDER BY p.id DESC) AS [DesireNumber]
			FROM Program p
			WHERE SuperProgramID IS NULL AND 
			p.Semester = @SemesterCount AND
			p.Semester % 2 = @CurrentSemester % 2;
		END
	ELSE
		BEGIN
		 	SELECT p.Name AS [ProgramName],
			p.ID AS [ProgramID],
			ROW_NUMBER() OVER(ORDER BY p.id DESC) AS [DesireNumber]
			FROM Program p
			WHERE SuperProgramID = @StudentProgramID AND 
			p.Semester = @SemesterCount AND
			p.Semester % 2 = @CurrentSemester % 2;
		END
	END
END
GO
/****** Object:  StoredProcedure [dbo].[GetStudents]    Script Date: 2023-03-31 10:44:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetStudents]
@ProgramID INT = NULL,
@AcademicCode NVARCHAR(MAX) = NULL,
@SeatNumber NVARCHAR(MAX) = NULL,
@WarningsNumber TINYINT = NULL,
@WarningsOp NVARCHAR(2) = '=',
@SupervisorID INT = NULL,
@CGPA FLOAT = NULL,
@PassedHours TINYINT = NULL,
@Level TINYINT = NULL,
@Gender TINYINT = NULL,
@IsGraduated BIT = NULL,
@IsActive BIT = NULL,
@CurrentProgramID INT = NULL,
@Name NVARCHAR(MAX) = NULL,
@SSN NVARCHAR(MAX) = NULL,
@PhoneNumber NVARCHAR(MAX) = NULL,
@Address NVARCHAR(MAX) = NULL,
@IncludeRegistrationDetails BIT = 0,
@GetCoursesRequestsOnly BIT = 0,
@IsApprovedCourseRequest BIT = 0,
@PageNumber INT = 1,
@PageSize INT = 20,
@OrderBy VARCHAR(50) = 's.id',
@OrderDirection VARCHAR(4) = 'DESC',
@TotalCount INT OUTPUT
AS
BEGIN
DECLARE @SqlStatment nvarchar(max)=N'',
@SelectStatment nvarchar(max) =N'',
@FromStatment nvarchar(max)=N'',
@WhereStatment nvarchar(max)=N'',
@ParamsDefinition nvarchar(max)=N'',
@OrderByStatement nvarchar(MAX)=N'',
@RecursionStatement NVARCHAR(MAX) = N'';
IF @ProgramID IS NOT NULL
	BEGIN
		SET @RecursionStatement = N'
		WITH ParentChilds AS (
			SELECT *
			FROM Program
			WHERE ID ='+ CAST(@ProgramID AS VARCHAR(10))+
		' UNION ALL
			SELECT child.*
			FROM Program child
			JOIN ParentChilds pc
			  ON pc.ID = child.superProgramID)';
	END
	SET @SelectStatment =@RecursionStatement + N' SELECT DISTINCT s.[GUID],
      s.id,
	  s.[Name],
      s.[SSN],
      s.[PhoneNumber],
      s.[AcademicCode],
      s.[SeatNumber],
      s.[AvailableCredits],
      s.[WarningsNumber],
      s.[SupervisorID],
      s.[IsCrossStudent],
      s.[CGPA],
      s.[PassedHours],
      s.[Level],
      s.[IsGraduated],
	  ISNULL(ISNULL(s.[CalculatedRank],s.[Rank]),0) AS [Rank],
      s.[IsActive],
	  s.[Gender],
	  s.[Address],
      s.[CurrentProgramID] AS ProgramID,
	  p.[Name] AS ProgramName,
	  d.[Name] AS SupervisorName';
	SET @FromStatment = N' FROM Student s LEFT JOIN Program p ON p.ID = s.CurrentProgramID LEFT JOIN Doctor d ON d.ID = s.SupervisorID ';
	IF @IncludeRegistrationDetails = 1
		BEGIN
		SET @SelectStatment +=N'
		,ISNULL(SQ.RegisteredHours,0) AS [RegisteredHours]
	    ,ISNULL(SQ.CoursesCount ,0) AS [CoursesCount]';
		SET @FromStatment +=N' LEFT OUTER JOIN
							(SELECT sc.StudentID,SUM(c.CreditHours) AS [RegisteredHours],COUNT(sc.CourseID) AS [CoursesCount]
							FROM StudentCourses sc JOIN Course c ON c.ID = sc.CourseID 
							WHERE sc.AcademicYearID = [dbo].[GetCurrentYearID]()
							GROUP BY sc.StudentID
							) AS SQ ON SQ.StudentID = s.ID '
		END
	SET @WhereStatment = N' WHERE 1 = 1 ';
	IF @GetCoursesRequestsOnly = 1
	BEGIN
		SET @FromStatment+=N' JOIN StudentCourseRequest scr ON scr.StudentID = s.ID ';
		IF @IsApprovedCourseRequest IS NULL
		BEGIN
			SET @WhereStatment = N' AND scr.IsApproved IS NULL ';
		END
		ELSE
		BEGIN
			SET @WhereStatment = N' AND scr.IsApproved = '+CAST(@IsApprovedCourseRequest AS NVARCHAR(MAX));
		END
	END
	IF @ProgramID IS NOT NULL
		BEGIN
			SET @WhereStatment += N' AND s.CurrentProgramID IN (SELECT id FROM ParentChilds) '
		END
	IF @AcademicCode IS NOT NULL
		BEGIN
			SET @WhereStatment += N' AND s.AcademicCode LIKE N''%' + @AcademicCode +'%''';
		END
	IF @SeatNumber IS NOT NULL
		BEGIN
			SET @WhereStatment += N' AND s.SeatNumber LIKE N''%' + @SeatNumber +'%''';
		END
	IF @WarningsNumber IS NOT NULL
		BEGIN
			SET @WhereStatment += N' AND s.WarningsNumber '+ @WarningsOp + CAST(@WarningsNumber AS VARCHAR(3));
		END
	IF @Gender IS NOT NULL
		BEGIN
			SET @WhereStatment += N' AND s.Gender =' + CAST(@Gender AS VARCHAR(1));
		END
	IF @SupervisorID IS NOT NULL
		BEGIN
			SET @WhereStatment += N' AND s.SupervisorID =' + CAST(@SupervisorID AS VARCHAR(3));
		END
	IF @CGPA IS NOT NULL
		BEGIN
			SET @WhereStatment += N' AND s.CGPA LIKE N''%' + CAST(@CGPA AS VARCHAR(10)) +'%''';
		END
	IF @PassedHours IS NOT NULL
		BEGIN
			SET @WhereStatment += N' AND s.PassedHours =' + CAST(@PassedHours AS VARCHAR(10));
		END
	IF @Level IS NOT NULL
		BEGIN
			SET @WhereStatment += N' AND s.Level =' + CAST(@Level AS VARCHAR(10));
		END
	IF @IsGraduated IS NOT NULL
		BEGIN
			SET @WhereStatment += N' AND s.IsGraduated =' + CAST(@IsGraduated AS VARCHAR(1));
		END
	IF @IsActive IS NOT NULL
		BEGIN
			SET @WhereStatment += N' AND s.IsActive =' + CAST(@IsActive AS VARCHAR(1));
		END
	IF @CurrentProgramID IS NOT NULL
		BEGIN
			SET @WhereStatment += N' AND s.CurrentProgramID =' + CAST(@CurrentProgramID AS VARCHAR(10));
		END
	IF @Name IS NOT NULL
		BEGIN
			SET @WhereStatment += N' AND s.Name LIKE N''%'+@Name+'%'''
		END
	IF @SSN IS NOT NULL
		BEGIN
			SET @WhereStatment += N' AND s.SSN LIKE N''%'+@SSN+'%'''
		END
	IF @PhoneNumber IS NOT NULL
		BEGIN
			SET @WhereStatment += N' AND s.PhoneNumber LIKE N''%'+@PhoneNumber+'%'''
		END
	IF @Address IS NOT NULL
		BEGIN
			SET @WhereStatment += N' AND s.Address LIKE N''%'+@Address+'%'''
		END
SET @OrderByStatement =N' ORDER BY '+@OrderBy+' '+@OrderDirection
+' OFFSET ' + CAST((@PageSize*(@PageNumber-1)) AS VARCHAR(5)) +' ROWS'
+' FETCH NEXT ' + CAST(@PageSize AS VARCHAR(5)) + ' ROWS ONLY; ' ;

	SET @SqlStatment =
	@SelectStatment + @FromStatment + @WhereStatment + @OrderByStatement
SET @SqlStatment += @RecursionStatement +' SELECT @TotalCountParam = COUNT(DISTINCT(s.guid)) ' + @FromStatment + @WhereStatment;
PRINT @SqlStatment;
	SET @ParamsDefinition = N'@TotalCountParam INT OUTPUT';
	EXECUTE sp_executesql 
	@SqlStatment,
	@ParamsDefinition,
	@TotalCountParam = @TotalCount output
END
GO
/****** Object:  StoredProcedure [dbo].[GetSubPrograms]    Script Date: 2023-03-31 10:44:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetSubPrograms]
@ProgramID INT NULL
AS
BEGIN
	IF @ProgramID IS NULL
		BEGIN
			SELECT * FROM Program WHERE SuperProgramID IS NULL;
		END
	ELSE
		BEGIN
			SELECT * FROM Program WHERE SuperProgramID = @ProgramID;
		END
END
GO
/****** Object:  StoredProcedure [dbo].[GetSuperAdmin]    Script Date: 2023-03-31 10:44:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetSuperAdmin]
@Guid NVARCHAR(MAX)
AS
BEGIN
	SELECT s.Email,s.Name,s.GUID 
	FROM SuperAdmin s WHERE GUID = @Guid
END
GO
/****** Object:  StoredProcedure [dbo].[Login_Doctor]    Script Date: 2023-03-31 10:44:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Login_Doctor]
@Email VARCHAR(MAX),
@Password VARCHAR(MAX)
AS
	BEGIN
		SELECT * FROM Doctor WHERE Email = @Email AND Password = @Password AND IsActive = 1;
	END
GO
/****** Object:  StoredProcedure [dbo].[Login_Student]    Script Date: 2023-03-31 10:44:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Login_Student]
@Email VARCHAR(MAX),
@Password VARCHAR(MAX)
AS
	BEGIN
		SELECT * FROM Student WHERE Email = @Email AND Password = @Password AND IsActive = 1;
	END
GO
/****** Object:  StoredProcedure [dbo].[Login_SuperAdmin]    Script Date: 2023-03-31 10:44:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Login_SuperAdmin]
@Email VARCHAR(MAX),
@Password VARCHAR(MAX)
AS
	BEGIN
		SELECT * FROM SuperAdmin WHERE Email = @Email AND Password = @Password;
	END
GO
/****** Object:  StoredProcedure [dbo].[ProgramSwitchingForStudent]    Script Date: 2023-03-31 10:44:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[ProgramSwitchingForStudent]
@StudentID INT,
@FromProgram INT,
@ToProgram INT
AS
	BEGIN
		--To exclude courses which are in FromProgram and not in ToProgram 
		UPDATE StudentCourses
		SET IsIncluded = 0
		WHERE CourseID NOT IN(
			SELECT pc.CourseID FROM ProgramCourses pc
			WHERE pc.ProgramID = @ToProgram
			) AND StudentID = @StudentID;
		UPDATE StudentCourses
		SET IsIncluded = 1
		WHERE CourseID IN(
			SELECT pc.CourseID FROM ProgramCourses pc
			WHERE pc.ProgramID = @ToProgram
			) AND StudentID = @StudentID;

		DECLARE @CurrentAcademicYearProgCount BIT;
		DECLARE @CurrentAcademicYear SMALLINT = (SELECT MAX(ID) FROM AcademicYear);
	
		--Check if there's a record for current academic year
		SELECT @CurrentAcademicYearProgCount = COUNT(*)
		FROM StudentPrograms
		WHERE StudentID = @StudentID AND AcademicYear = @CurrentAcademicYear

		--If no record exists then insert a new one which new program
		IF(@CurrentAcademicYearProgCount = 0)
			BEGIN
				INSERT INTO StudentPrograms (AcademicYear,ProgramID,StudentID)
					VALUES(@CurrentAcademicYear,@ToProgram,@StudentID);
			END
		ELSE --Update existing record
			BEGIN
				UPDATE StudentPrograms
				SET ProgramID = @ToProgram
				WHERE StudentID = @StudentID AND ProgramID = @FromProgram;
			END
		--Give back credit hours of courses that took from student's credits and is not in current student program
		UPDATE Student
			SET AvailableCredits = AvailableCredits + 
			ISNULL((SELECT SUM(c.CreditHours) FROM Course c JOIN StudentCourses sc ON c.ID = sc.CourseID
			WHERE sc.IsIncluded = 0 AND sc.TookFromCredits = 1 AND sc.StudentID = @StudentID),0);
		
		UPDATE StudentCourses
			SET TookFromCredits = 0
			WHERE StudentID = @StudentID AND IsIncluded = 0;
	END
GO
/****** Object:  StoredProcedure [dbo].[QueryExecuter]    Script Date: 2023-03-31 10:44:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[QueryExecuter]
@Query NVARCHAR(MAX)
AS 
BEGIN
	EXECUTE sp_executesql @Query;
END
GO
/****** Object:  StoredProcedure [dbo].[Report_CourseGradesSheet]    Script Date: 2023-03-31 10:44:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Report_CourseGradesSheet]
@CourseID INT,
@MarkTypeID TINYINT
AS
BEGIN
	DECLARE @CurrentYearID TINYINT = [dbo].[GetCurrentYearID]();
	SELECT CourseCode,CourseName,CreditHours,Final,YearWork,Oral,Practical FROM Course WHERE ID = @CourseID;
	SELECT AcademicYear AS [Year], Semester FROM AcademicYear WHERE ID = @CurrentYearID;
	DECLARE @Sql NVARCHAR(MAX) = N'';
	SET @Sql = N'
	SELECT s.AcademicCode,
	s.Name,
	s.Level,
	p.Name AS [ProgramName],';
	IF @MarkTypeID = 1
		BEGIN
			SET @Sql +=N'sc.Final AS [Mark]';
		END
	ELSE IF @MarkTypeID = 2
		BEGIN
			SET @Sql +=N'sc.YearWork AS [Mark]';
		END
	ELSE IF @MarkTypeID = 3
		BEGIN
			SET @Sql +=N'sc.Oral AS [Mark]';
		END
	ELSE
		BEGIN
			SET @Sql +=N'sc.Practical AS [Mark]';
		END
	SET @Sql +=N'
	FROM Student s JOIN Program p ON p.ID = s.CurrentProgramID JOIN StudentCourses sc ON s.ID = sc.StudentID
	WHERE sc.CourseID ='+ CAST(@CourseID AS NVARCHAR(MAX)) 
	+' AND sc.AcademicYearID ='+CAST(@CurrentYearID AS NVARCHAR(MAX))
	+' AND s.IsActive = 1;';
	EXECUTE sp_executesql @Sql;
END
GO
/****** Object:  StoredProcedure [dbo].[Report_ExamCommitteeStudents]    Script Date: 2023-03-31 10:44:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Report_ExamCommitteeStudents]
@CourseID INT
AS
BEGIN
	SELECT 
	c.CourseName,
	c.CourseCode,
	c.Final,
	c.YearWork,
	c.Oral,
	c.Practical
	FROM Course c
	WHERE ID = @CourseID;

	SELECT s.Name,
	s.AcademicCode,
	s.Level,
	p.Name AS ProgramName
	FROM Student s JOIN StudentCourses sc ON sc.StudentID = s.ID JOIN Program p ON p.ID = s.CurrentProgramID
	WHERE sc.CourseID = @CourseID AND
	sc.AcademicYearID = [dbo].[GetCurrentYearID]();
END
GO
/****** Object:  StoredProcedure [dbo].[Report_GetStruggledStudents]    Script Date: 2023-03-31 10:44:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Report_GetStruggledStudents]
@ProgramID INT = NULL,
@IsActive INT = NULL,
@WarningsNumber INT = NULL
AS
BEGIN
DECLARE @SelectStatement NVARCHAR(MAX)= N'',
		@FromStatement NVARCHAR(MAX)= N'',
		@WhereStatement NVARCHAR(MAX)= N'',
		@SqlStatement NVARCHAR(MAX)= N'',
		@RecursionStatement NVARCHAR(MAX) = N'';
IF @ProgramID IS NOT NULL
	BEGIN
		SET @RecursionStatement = N'
		WITH ParentChilds AS (
			SELECT *
			FROM Program
			WHERE ID ='+CAST(@ProgramID AS VARCHAR(10)) +' UNION ALL
			SELECT child.*
			FROM Program child
			JOIN ParentChilds pc
			  ON pc.ID = child.superProgramID)';
	END
	SET @SelectStatement =@RecursionStatement + N'SELECT s.Name,
	s.AcademicCode,
	s.PhoneNumber,
	s.AvailableCredits,
	s.WarningsNumber,
	s.CGPA,
	s.Level,
	s.PassedHours,
	p.Name AS [ProgramName]';
	SET @FromStatement =N' FROM Student s JOIN Program p ON p.ID = s.CurrentProgramID ';
	SET @WhereStatement = N' WHERE 1 = 1 AND IsActive = '+CAST(ISNULL(@IsActive,1)AS nvarchar(1));
	IF @WarningsNumber IS NOT NULL
		BEGIN
			SET @WhereStatement +=N' AND WarningsNumber >='+CAST(@WarningsNumber AS NVARCHAR(3));
		END
	IF @ProgramID IS NOT NULL
		BEGIN
			SET @WhereStatement += N' AND s.CurrentProgramID IN (SELECT id FROM ParentChilds)';
		END
		SET @SqlStatement = @SelectStatement + @FromStatement + @WhereStatement;
	EXECUTE sp_executesql
		@SqlStatement
END
GO
/****** Object:  StoredProcedure [dbo].[Report_StudentAcademicReport]    Script Date: 2023-03-31 10:44:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Report_StudentAcademicReport]
@StudentID INT,
@ForDoctorView BIT = 0
AS
BEGIN
	SELECT c.ID,
	c.CourseCode,
	c.CourseName,
	c.CreditHours,
	sc.Mark,
	sc.Final,
	sc.YearWork,
	sc.Oral,
	sc.Practical,
	sc.Grade,
	sc.Points,
	sc.IsGPAIncluded,
	sc.AcademicYearID,
	sc.CourseEntringNumber,
	sc.AffectReEntringCourses,
	sc.HasExcuse,
	sc.IsEnhancementCourse
	FROM StudentCourses sc JOIN Course c ON c.ID = sc.CourseID
	WHERE StudentID = @StudentID AND (@ForDoctorView = 1 OR sc.Grade IS NOT NULL)
	ORDER BY sc.AcademicYearID

	EXEC [dbo].[GetStudentAcademicYearsSummary] @StudentID
END
GO
/****** Object:  StoredProcedure [dbo].[Report_StudentCoursesSummary]    Script Date: 2023-03-31 10:44:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Report_StudentCoursesSummary]
@StudentID INT
AS
BEGIN
	SELECT s.AcademicCode,
	s.Name,s.PhoneNumber,
	s.Level,s.PassedHours,
	p.Name AS [ProgramName],p.TotalHours,
	(p.TotalHours - s.PassedHours) AS [RemaningHours]
	FROM Student s JOIN Program p ON s.CurrentProgramID = p.ID WHERE s.ID = @StudentID;

	SELECT pc.CourseType,
	pc.Category,
	ISNULL((SELECT ecd.Hour 
	FROM ElectiveCourseDistribution ecd 
	WHERE ecd.ProgramID = [dbo].[GetStudentProgram](@StudentID) 
	AND ecd.Level = c.Level AND ecd.Semester = c.Semester AND 
	ecd.Category = pc.Category AND ecd.CourseType = pc.CourseType),c.CreditHours) AS [Hours],
	c.CourseCode,
	c.CourseName,
	[dbo].[CheckIfPassedCourse](@StudentID,c.ID) AS [IsPassedCourse],
	[dbo].[CountRegistrationTimes](@StudentID,c.ID) AS [RegistrationTimes],
	[dbo].[GetStudentGradeInCourse](@StudentID,c.ID) AS [Grade],
	c.CreditHours,
	c.ID,
	c.Level,
	c.Semester
	FROM ProgramCourses pc
	LEFT JOIN Course c ON pc.CourseID = c.ID
	WHERE pc.ProgramID = [dbo].[GetStudentProgram](@StudentID)
	ORDER BY c.Level,c.Semester,pc.CourseType,pc.Category;
END
GO
/****** Object:  StoredProcedure [dbo].[Report_StudentCoursesSummaryAsTree]    Script Date: 2023-03-31 10:44:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Script for SelectTopNRows command from SSMS  ******/
CREATE PROCEDURE [dbo].[Report_StudentCoursesSummaryAsTree]
@StudentID INT
AS
BEGIN
	DECLARE @ProgID INT;
	SELECT @ProgID= currentProgramID FROM Student WHERE ID = @StudentID;
	
	SELECT c.ID,
			c.CourseName,
			c.CourseCode,
			c.CreditHours
	  FROM ProgramCourses pc LEFT JOIN Course c ON pc.CourseID = c.ID
	  WHERE pc.ProgramID = @ProgID
	  ORDER BY Level,Semester,pc.CourseType,pc.Category
	
	SELECT sc.CourseID,sc.Mark,sc.Grade,sc.AcademicYearID,ay.AcademicYear,ay.Semester
		FROM StudentCourses sc join AcademicYear ay on sc.AcademicYearID = ay.ID
		WHERE StudentID = @StudentID
END
GO
/****** Object:  StoredProcedure [dbo].[StartNewAcademicYear]    Script Date: 2023-03-31 10:44:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[StartNewAcademicYear]
@AcademicYear NVARCHAR(MAX),
@Semester TINYINT
AS
BEGIN
INSERT INTO [dbo].[AcademicYear]
           ([AcademicYear],[Semester])
     VALUES
           (@AcademicYear,@Semester)
DELETE FROM StudentDesires;
DELETE FROM StudentCourseRequest;
DELETE FROM StudentProgramTransferRequest;
END
GO
/****** Object:  StoredProcedure [dbo].[Statistics_CourseGrades]    Script Date: 2023-03-31 10:44:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Statistics_CourseGrades]
@CourseID INT = NULL,
@AcademicYearID INT = NULL
AS
BEGIN
DECLARE @SelectStatement NVARCHAR(MAX) = N'',
		@FromStatement NVARCHAR(MAX) = N'',
		@WhereStatement NVARCHAR(MAX) = N'',
		@SqlStatement NVARCHAR(MAX) = N'';
	SET @SelectStatement = N'SELECT COUNT(*) AS [Value],Grade AS [Key] '; 
	SET @FromStatement = N'FROM StudentCourses ';
	SET @WhereStatement = N' WHERE CourseID = '+CAST(@CourseID AS VARCHAR(3));
	IF @AcademicYearID IS NOT NULL
		BEGIN
			SET @WhereStatement += N' AND AcademicYearID = '+CAST(@AcademicYearID AS VARCHAR(3));
		END
	 
	SET @WhereStatement+=N' GROUP BY Grade;';
	
	SET @SqlStatement = @SelectStatement + @FromStatement + @WhereStatement;
	PRINT @SqlStatement;
	EXECUTE sp_executesql 
		@SqlStatement
END
GO
/****** Object:  StoredProcedure [dbo].[Statistics_Programs]    Script Date: 2023-03-31 10:44:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Statistics_Programs] 
AS
BEGIN
	SELECT p.Name AS [Key], COUNT(s.id) AS [Value]
	  FROM Student s join Program p ON s.CurrentProgramID = p.ID
	  WHERE s.IsGraduated = 0
	  GROUP BY p.Name,p.ArabicName
END
GO
/****** Object:  StoredProcedure [dbo].[Statistics_StudentGrades]    Script Date: 2023-03-31 10:44:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Statistics_StudentGrades]
@ProgramID INT = NULL,
@IsGraduated BIT = 0,
@IsActive BIT = 1
AS
BEGIN
	DECLARE @SqlStatement NVARCHAR(MAX)= N'',
	@RecursionStatement NVARCHAR(MAX) = N'';
	IF @ProgramID IS NOT NULL
		BEGIN
			SET @RecursionStatement = N'
			WITH ParentChilds AS (
				SELECT *
				FROM Program
				WHERE ID ='+ CAST(@ProgramID AS VARCHAR(10))+'
			 UNION ALL
				SELECT child.*
				FROM Program child
				JOIN ParentChilds pc
				  ON pc.ID = child.superProgramID) ';
		END
	SET @SqlStatement = @RecursionStatement +N'
		SELECT t.range AS [Key], count(*) AS [Value]
		FROM (
			SELECT CGPA,
					CASE 
					WHEN CGPA >= 0 AND CGPA < 2 THEN ''F''
					WHEN CGPA >= 2 AND CGPA < 2.33 THEN ''D''
					WHEN CGPA >= 2.33 AND CGPA < 2.67 THEN ''C''
					WHEN CGPA >= 2.67 AND CGPA < 3 THEN ''C+''
					WHEN CGPA >= 3 AND CGPA < 3.33 THEN ''B''
					WHEN CGPA >= 3.33 AND CGPA < 3.67 THEN ''B+''
					WHEN CGPA >= 3.67 AND CGPA < 4 THEN ''A-''
					WHEN CGPA >= 4 AND CGPA < =4 THEN ''A''
					ELSE ''None'' END AS range
			FROM Student
			WHERE IsActive = ' +CAST(@IsActive AS NVARCHAR(1)) 
			+ ' AND IsGraduated = '+ CAST(@IsGraduated AS NVARCHAR(1)); 
			IF @ProgramID IS NOT NULL
			BEGIN
				SET @SqlStatement += N' AND CurrentProgramID IN (SELECT id FROM ParentChilds)';
			END
			SET @SqlStatement += ') t GROUP BY t.range ';
		EXECUTE sp_executesql 
		@SqlStatement
	
END
GO
/****** Object:  StoredProcedure [dbo].[StudentCoursesRegistration]    Script Date: 2023-03-31 10:44:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[StudentCoursesRegistration]
@Query NVARCHAR(MAX),
@StudentID INT,
@CurrentAcademicYearID TINYINT
AS 
BEGIN
	DECLARE @CourseID INT;
	
	DECLARE Delete_Courses_Cursor CURSOR FOR  
		SELECT CourseID FROM [dbo].StudentCourses
		WHERE [StudentID] = @StudentID AND AcademicYearID = @CurrentAcademicYearID;
	OPEN Delete_Courses_Cursor;  
	FETCH NEXT FROM Delete_Courses_Cursor INTO @CourseID;
	WHILE @@FETCH_STATUS = 0
	BEGIN
		DELETE FROM StudentCourses 
		WHERE StudentID = @StudentID AND
		AcademicYearID = @CurrentAcademicYearID AND
		CourseID = @CourseID;
		FETCH NEXT FROM Delete_Courses_Cursor INTO @CourseID;
	END;  
	CLOSE Delete_Courses_Cursor;  
	DEALLOCATE Delete_Courses_Cursor;

	EXECUTE sp_executesql @Query;
END
GO
/****** Object:  StoredProcedure [dbo].[SubmitStudentProgramTransferRequest]    Script Date: 2023-03-31 10:44:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SubmitStudentProgramTransferRequest]
@StudentID INT,
@ProgramID INT,
@ReasonForTransfer NVARCHAR(MAX)
AS
BEGIN
	DELETE FROM StudentProgramTransferRequest
	WHERE StudentID = @StudentID;

	INSERT INTO StudentProgramTransferRequest(StudentID,ToProgramID,ReasonForTransfer)
	VALUES(@StudentID,@ProgramID,@ReasonForTransfer)
END
GO
/****** Object:  StoredProcedure [dbo].[ToggleDoctorAccount]    Script Date: 2023-03-31 10:44:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[ToggleDoctorAccount]
@GUID NVARCHAR(MAX),
@IsActive BIT
AS
BEGIN
	UPDATE Doctor SET IsActive = @IsActive WHERE GUID = ''+@GUID+'';
END
GO
/****** Object:  StoredProcedure [dbo].[UpdateCommonQuestion]    Script Date: 2023-03-31 10:44:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UpdateCommonQuestion]
@ID INT,
@Question NVARCHAR(MAX),
@Answer NVARCHAR(MAX)
AS
BEGIN
	UPDATE CommonQuestion
		SET Answer = @Answer,
			Question = @Question
	WHERE ID = @ID;
END
GO
/****** Object:  StoredProcedure [dbo].[UpdateCourse]    Script Date: 2023-03-31 10:44:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UpdateCourse]
@ID INT,
@CourseCode nvarchar(max),
@CourseName nvarchar(max),
@CreditHours tinyint,
@LectureHours tinyint,
@LabHours tinyint,
@SectionHours tinyint,
@IsActive bit,
@Level tinyint,
@Semester tinyint
AS
BEGIN
	UPDATE [dbo].[Course]
	   SET [CourseCode]  = @CourseCode
		  ,[CourseName]  = @CourseName
		  ,[CreditHours] = @CreditHours
		  ,[LectureHours] = @LectureHours
		  ,[LabHours] = @LabHours
		  ,[SectionHours] = @SectionHours
		  ,[IsActive] = @IsActive
		  ,[Level] = @Level
		  ,[Semester] = @Semester
	 WHERE ID = @ID;
END
GO
/****** Object:  StoredProcedure [dbo].[UpdateDoctor]    Script Date: 2023-03-31 10:44:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UpdateDoctor]
@Guid NVARCHAR(MAX),
@Name NVARCHAR(MAX),
@Email NVARCHAR(MAX),
@ProgramID INT,
@Type TINYINT
AS
BEGIN
	UPDATE [dbo].[Doctor]
	   SET 
		  [Name] = @Name
		  ,[Email] = @Email
		  ,[ProgramID] = @ProgramID
		  ,[Type] = @Type
	 WHERE [GUID] = @Guid;
END
GO
/****** Object:  StoredProcedure [dbo].[UpdateProgramBasicData]    Script Date: 2023-03-31 10:44:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UpdateProgramBasicData]
@ID INT,
@Name NVARCHAR(MAX),
@Semester TINYINT,
@Percentage FLOAT,
@IsRegular BIT,
@IsGeneral BIT,
@TotalHours TINYINT,
@ArabicName NVARCHAR(MAX),
@EnglishName NVARCHAR(MAX),
@SuperProgramId INT = NULL
AS
BEGIN
UPDATE [dbo].[Program]
   SET [Name] = @Name
      ,[Semester] = @Semester
      ,[Percentage] = @Percentage
      ,[IsRegular] = @IsRegular
      ,[IsGeneral] = @IsGeneral
      ,[TotalHours] = @TotalHours
      ,[EnglishName] = @EnglishName
      ,[ArabicName] = @ArabicName
      ,[SuperProgramID] = @SuperProgramId
 WHERE ID = @ID
END
GO
/****** Object:  StoredProcedure [dbo].[UpdateStudent]    Script Date: 2023-03-31 10:44:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UpdateStudent]
@ID INT,
@Name nvarchar(max),
@SSN varchar(20),
@PhoneNumber varchar(12),
@BirthDate date,
@Address nvarchar(max),
@Gender char(1),
@Nationality nvarchar(max),
@Email nvarchar(max),
@Password nvarchar(max),
@SeatNumber varchar(10),
@SupervisorID int,
@IsCrossStudent bit,
@CurrentProgramID int
AS
BEGIN
UPDATE [dbo].[Student]
   SET [Name] = @Name
      ,[SSN] =  @SSN
      ,[PhoneNumber] =@PhoneNumber
      ,[BirthDate] = @BirthDate 
      ,[Address] =  @Address
      ,[Gender] =  @Gender
      ,[Nationality] =  @Nationality
      ,[Email] =  @Email
      ,[Password] =  @Password
      ,[SeatNumber] =  @SeatNumber
      ,[SupervisorID] =  @SupervisorID
      ,[IsCrossStudent] =  @IsCrossStudent
      ,[CurrentProgramID] =  @CurrentProgramID
 WHERE ID = @ID;
END
GO
/****** Object:  StoredProcedure [dbo].[UpdateSuperAdminPassword]    Script Date: 2023-03-31 10:44:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UpdateSuperAdminPassword]
@Guid NVARCHAR(MAX),
@Password NVARCHAR(MAX)
AS
BEGIN
	UPDATE SuperAdmin SET Password = @Password
	WHERE GUID = @Guid;
END
GO
/****** Object:  Trigger [dbo].[IncreaseNumberOfSemestersInProgramForStudent]    Script Date: 2023-03-31 10:44:14 PM ******/
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
/****** Object:  Trigger [dbo].[SetActiveCoursesBySemester]    Script Date: 2023-03-31 10:44:15 PM ******/
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
/****** Object:  Trigger [dbo].[CalculateProgramTotalHours]    Script Date: 2023-03-31 10:44:15 PM ******/
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
/****** Object:  Trigger [dbo].[CalculateProgramTotalHoursIfAnyDeleted]    Script Date: 2023-03-31 10:44:15 PM ******/
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

	IF @TotalHours IS NULL
		SET @TotalHours = 0;

	UPDATE Program 
		SET TotalHours = @TotalHours
		WHERE ID = @ProgramID;

END
GO
ALTER TABLE [dbo].[ProgramDistribution] ENABLE TRIGGER [CalculateProgramTotalHoursIfAnyDeleted]
GO
/****** Object:  Trigger [dbo].[RankUpdater]    Script Date: 2023-03-31 10:44:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[RankUpdater]
    ON [dbo].[Student]
    AFTER UPDATE
AS
SET NOCOUNT ON;
IF UPDATE (Rank) 
BEGIN
DECLARE @OldVal SMALLINT;
DECLARE @NewVal SMALLINT;
DECLARE @StudentID INT;
	SELECT @OldVal = old.CalculatedRank,@StudentID = old.ID
	FROM deleted old;
	SELECT @NewVal = new.CalculatedRank
	FROM inserted new;
	
	IF @NewVal IS NOT NULL
		BEGIN
			UPDATE Student SET Rank = @NewVal WHERE ID = @StudentID;
		END
END;
GO
ALTER TABLE [dbo].[Student] ENABLE TRIGGER [RankUpdater]
GO
/****** Object:  Trigger [dbo].[SupervisorRemovalForGraduates]    Script Date: 2023-03-31 10:44:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[SupervisorRemovalForGraduates]
    ON [dbo].[Student]
    AFTER UPDATE,INSERT
AS
SET NOCOUNT ON;

	DECLARE @StudentID INT,@IsGraduated BIT;
	SELECT @IsGraduated = new.IsGraduated,@StudentID = new.ID
	FROM inserted new;
	IF @IsGraduated = 1
		BEGIN
			UPDATE Student SET SupervisorID = NULL WHERE ID = @StudentID;
		END
GO
ALTER TABLE [dbo].[Student] ENABLE TRIGGER [SupervisorRemovalForGraduates]
GO
/****** Object:  Trigger [dbo].[HandleRequest]    Script Date: 2023-03-31 10:44:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[HandleRequest]
ON [dbo].[StudentCourseRequest]
AFTER UPDATE
AS
SET NOCOUNT ON;
DECLARE @CourseID INT,@StudentID INT,@IsApproved BIT,@CourseOperationID BIT,@RequestTypeID TINYINT;
SELECT 
@CourseID= d.CourseID,
@CourseOperationID = d.CourseOperationID,
@IsApproved = d.IsApproved,
@StudentID = d.StudentID,
@RequestTypeID = d.RequestTypeID
FROM INSERTED d;
IF @IsApproved = 1
BEGIN
	IF @RequestTypeID = 2
		BEGIN
			UPDATE StudentCourses
			SET HasWithdrawn = 1
			WHERE StudentID = @StudentID AND CourseID = @CourseID AND AcademicYearID = [dbo].[GetCurrentYearID]();
		END
	ELSE
		BEGIN
			IF @CourseOperationID = 1
				BEGIN
					INSERT INTO StudentCourses(StudentID,CourseID,AcademicYearID,IsApproved,IsGPAIncluded,IsIncluded)
					VALUES(@StudentID,@CourseID,[dbo].[GetCurrentYearID](),1,1,1);
				END
			ELSE
				BEGIN
					DELETE FROM StudentCourses 
					WHERE StudentID = @StudentID AND
					CourseID = @CourseID AND
					AcademicYearID = [dbo].[GetCurrentYearID]();
				END
		END
END
GO
ALTER TABLE [dbo].[StudentCourseRequest] ENABLE TRIGGER [HandleRequest]
GO
/****** Object:  Trigger [dbo].[EntringStudentCourse]    Script Date: 2023-03-31 10:44:15 PM ******/
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
	@HasExcuse bit = 0,
	@IsEnhancementCourse bit = 0,
	@TookFromEnhancementCredits BIT = 0
	SELECT
	@StudentID= INSERTED.StudentID,
	@AcademicYearID = INSERTED.AcademicYearID,
	@IsGpaIncluded = INSERTED.IsGPAIncluded,
	@CourseID= INSERTED.CourseID,
	@Mark =INSERTED.Mark,
	@Points =inserted.points,
	@Grade = inserted.Grade,
	@HasExcuse =inserted.HasExcuse,
	@TookFromEnhancementCredits = inserted.TookFromEnhancementCredits
	FROM INSERTED;

		SELECT @StudentProgramTotalHours =TotalHours FROM Program WHERE ID = [dbo].[GetStudentProgram](@StudentID);
		SELECT @StudentCGPA = CGPA,@StudentPassedHours =PassedHours FROM Student WHERE ID = @StudentID;

		IF(@StudentCGPA <= 2.0 AND @StudentPassedHours >= @StudentProgramTotalHours)
			BEGIN
				SET @IsEnhancementCourse = 1;
			END

		IF @HasExcuse IS NULL
			BEGIN
				SET @HasExcuse=0;
			END
		--Get Course CreditHours
		SELECT @CreditHours=CreditHours 
		FROM Course
		WHERE id=@CourseID;

		--Calculate number of Course entring times
		SELECT @CourseEntringNo=Count(courseID)+1
		FROM StudentCourses 
		WHERE StudentID=@StudentID AND CourseID=@CourseID AND @HasExcuse <> 1 AND AcademicYearID <> @AcademicYearID;
	
		--If it's not the first time to enter the course
		--it will take from student available credits
		IF(@CourseEntringNo > 1)
		BEGIN
			SELECT @AvailableCredits = AvailableCredits FROM Student WHERE ID = @StudentID;
			IF (@AvailableCredits - @CreditHours >=0 AND @HasExcuse = 0) -- course credits must be greater than or equal available credits
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
							IF @TookFromEnhancementCredits = 0
								BEGIN
									UPDATE Student 
									SET AvailableEnhancementCredits = AvailableEnhancementCredits - @CreditHours
									WHERE ID = @StudentID;
									SET @TookFromEnhancementCredits = 1;
								END
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
			IF @IsGpaIncluded = 1
				BEGIN
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
					IF @MarkPer >=50.0
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
				SET @Points =NULL;
			END

			UPDATE StudentCourses WITH (TABLOCK)
			SET CourseEntringNumber =@CourseEntringNo,
			AffectReEntringCourses = @AffectCourseReEntring,
			IsGPAIncluded =@IsGpaIncluded,
			Grade=@Grade,
			Points = @Points,
			WillTakeFullCredit =@WillTakeFullCredit,
			TookFromCredits = @TookFromCredits,
			HasExcuse = @HasExcuse,
			IsEnhancementCourse =@IsEnhancementCourse,
			TookFromEnhancementCredits = @TookFromEnhancementCredits
			WHERE StudentID=@StudentID AND CourseID =@CourseID AND AcademicYearID = @AcademicYearID;
END
GO
ALTER TABLE [dbo].[StudentCourses] ENABLE TRIGGER [EntringStudentCourse]
GO
/****** Object:  Trigger [dbo].[GiveBackCredits]    Script Date: 2023-03-31 10:44:15 PM ******/
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
	@TookFromCredits bit,
	@TookFromEnhancementCredit bit
	-- Get deleted record
	SELECT 
	@StudentID= DELETED.StudentID,
	@IsGpaIncluded = DELETED.IsGPAIncluded,
	@CourseID= DELETED.CourseID,
	@IsIncluded=DELETED.IsIncluded,
	@AcademicYearID =DELETED.AcademicYearID,
	@TookFromCredits = DELETED.TookFromCredits,
	@TookFromEnhancementCredit = deleted.TookFromEnhancementCredits
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
	IF(@TookFromEnhancementCredit = 1)
	BEGIN 
		UPDATE Student SET AvailableEnhancementCredits = AvailableEnhancementCredits + @CreditHours WHERE ID = @StudentID;
	END
END
GO
ALTER TABLE [dbo].[StudentCourses] ENABLE TRIGGER [GiveBackCredits]
GO
/****** Object:  Trigger [dbo].[UpdateStudentCourse]    Script Date: 2023-03-31 10:44:15 PM ******/
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
	@HasExcuse bit
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
	@HasExcuse =INSERTED.HasExcuse
	FROM INSERTED;

			SELECT @CreditHours=CreditHours 
			FROM Course
			WHERE id=@CourseID;		

			IF (@TookFromCredits = 1 AND @HasExcuse =1)
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
						IF @MarkPer >=50.0
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
					ELSE IF (@Mark IS NULL AND (@Grade IS NULL OR @Grade <> 'P'))
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
/****** Object:  Trigger [dbo].[UpdateStudentCurrentProgram]    Script Date: 2023-03-31 10:44:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[UpdateStudentCurrentProgram]
   ON [dbo].[StudentPrograms]
   AFTER INSERT,UPDATE
AS 
	BEGIN
		SET NOCOUNT ON;
		DECLARE @ProgramID INT,@StudentID INT;
		SELECT @StudentID = inserted.StudentID,@ProgramID = inserted.ProgramID FROM inserted;
		UPDATE Student SET CurrentProgramID = @ProgramID WHERE ID = @StudentID;
	END
GO
ALTER TABLE [dbo].[StudentPrograms] ENABLE TRIGGER [UpdateStudentCurrentProgram]
GO
/****** Object:  Trigger [dbo].[UpdateStudentCurrentProgramAfterDelete]    Script Date: 2023-03-31 10:44:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[UpdateStudentCurrentProgramAfterDelete]
   ON [dbo].[StudentPrograms]
   AFTER DELETE
AS 
	BEGIN
		SET NOCOUNT ON;
		DECLARE @StudentID INT;
		SELECT @StudentID = deleted.StudentID FROM deleted;
		UPDATE Student SET CurrentProgramID = [dbo].[GetStudentProgram](@StudentID) WHERE ID = @StudentID;
	END
GO
ALTER TABLE [dbo].[StudentPrograms] ENABLE TRIGGER [UpdateStudentCurrentProgramAfterDelete]
GO
/****** Object:  Trigger [dbo].[StudentProgramHandleTransferRequest]    Script Date: 2023-03-31 10:44:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[StudentProgramHandleTransferRequest]
   ON  [dbo].[StudentProgramTransferRequest]
   AFTER UPDATE
AS 
BEGIN
	SET NOCOUNT ON;
	DECLARE @StudentID INT,@ToProgram INT, @IsApproved BIT;
	SELECT @StudentID = d.StudentID,
	@ToProgram = d.ToProgramID,
	@IsApproved = d.IsApproved 
	FROM inserted d;
	IF @IsApproved = 1
	BEGIN
		DECLARE @StudentProgram INT = [dbo].[GetStudentProgram](@StudentID);
		EXEC [dbo].[ProgramSwitchingForStudent] @StudentID,@StudentProgram,@ToProgram;
	END
END

GO
ALTER TABLE [dbo].[StudentProgramTransferRequest] ENABLE TRIGGER [StudentProgramHandleTransferRequest]
GO
USE [master]
GO
ALTER DATABASE [FOS] SET  READ_WRITE 
GO
