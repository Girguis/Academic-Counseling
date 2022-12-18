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
---------------------------------------------------------------------------------------
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
-------------------------------------------------------------------------------------------
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
------------------------------------------------------------------------------
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
---------------------------------------------------------------------------------
CREATE TRIGGER [dbo].[EntringStudentCourse]
ON [dbo].[StudentCourses]
AFTER INSERT
AS
SET NOCOUNT ON;
BEGIN
/*
This trigger is used to calculate
courseEntringNumber, avaiable credits for student, AffectCourseReEntring,
Points, Grade depening on entered Mark
*/
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
--------------------------------------------------------------------------------------------
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
	@IsIncluded=deleted.IsIncluded,
	@AcademicYearID =deleted.AcademicYearID,
	@TookFromCredits = deleted.TookFromCredits
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
---------------------------------------------------------------------------------------------------
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