USE [FOS]
GO
/****** Object:  Table [dbo].[AcademicYear]    Script Date: 2022-11-28 12:45:31 AM ******/
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
/****** Object:  Table [dbo].[CommonQuestion]    Script Date: 2022-11-28 12:45:31 AM ******/
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
/****** Object:  Table [dbo].[Course]    Script Date: 2022-11-28 12:45:31 AM ******/
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
	[Level] [tinyint] NULL,
	[Semester] [tinyint] NULL,
 CONSTRAINT [PK_Course] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CoursePrerequisites]    Script Date: 2022-11-28 12:45:31 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CoursePrerequisites](
	[CourseID] [int] NOT NULL,
	[PrerequisiteCourseID] [int] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Date]    Script Date: 2022-11-28 12:45:31 AM ******/
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
/****** Object:  Table [dbo].[Program]    Script Date: 2022-11-28 12:45:31 AM ******/
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
 CONSTRAINT [PK_Program] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ProgramCourses]    Script Date: 2022-11-28 12:45:31 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ProgramCourses](
	[ProgramID] [int] NULL,
	[CourseID] [int] NULL,
	[CourseType] [tinyint] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ProgramDistribution]    Script Date: 2022-11-28 12:45:31 AM ******/
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
/****** Object:  Table [dbo].[Student]    Script Date: 2022-11-28 12:45:31 AM ******/
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
	[Level] [tinyint] NOT NULL,
	[CGPA] [float] NULL,
	[AcademicCode] [varchar](10) NULL,
	[PassedHours] [tinyint] NOT NULL,
	[SeatNumber] [varchar](10) NULL,
	[AvailableCredits] [tinyint] NOT NULL,
	[WarningsNumber] [tinyint] NOT NULL,
	[Rank] [smallint] NULL,
	[IsInSpecialProgram] [bit] NOT NULL,
	[SupervisorID] [int] NOT NULL,
	[CreatedOn] [datetime] NOT NULL,
	[IsCrossStudent] [bit] NOT NULL,
	[SemestersNumberInProgram] [tinyint] NOT NULL,
 CONSTRAINT [PK_Student] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[StudentCourses]    Script Date: 2022-11-28 12:45:31 AM ******/
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
	[CourseEntringNumber] [tinyint] NOT NULL,
	[AffectReEntringCourses] [bit] NOT NULL,
	[AcademicYearID] [smallint] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[StudentDesires]    Script Date: 2022-11-28 12:45:31 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[StudentDesires](
	[ProgramID] [int] NULL,
	[StudentID] [int] NULL,
	[DesireNumber] [tinyint] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[StudentPrograms]    Script Date: 2022-11-28 12:45:31 AM ******/
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
/****** Object:  Table [dbo].[SuperAdmin]    Script Date: 2022-11-28 12:45:31 AM ******/
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
/****** Object:  Table [dbo].[Supervisor]    Script Date: 2022-11-28 12:45:31 AM ******/
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
/****** Object:  Table [dbo].[TeacherCourses]    Script Date: 2022-11-28 12:45:31 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TeacherCourses](
	[SupervisorID] [int] NULL,
	[CourseID] [int] NULL,
	[AcademicYearID] [smallint] NOT NULL
) ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[AcademicYear] ON 

INSERT [dbo].[AcademicYear] ([ID], [AcademicYear], [Semester]) VALUES (1, N'2016/2017', 1)
INSERT [dbo].[AcademicYear] ([ID], [AcademicYear], [Semester]) VALUES (2, N'2016/2017', 2)
INSERT [dbo].[AcademicYear] ([ID], [AcademicYear], [Semester]) VALUES (3, N'2016/2017', 3)
INSERT [dbo].[AcademicYear] ([ID], [AcademicYear], [Semester]) VALUES (4, N'2017/2018', 1)
INSERT [dbo].[AcademicYear] ([ID], [AcademicYear], [Semester]) VALUES (5, N'2017/2018', 2)
INSERT [dbo].[AcademicYear] ([ID], [AcademicYear], [Semester]) VALUES (6, N'2017/2018', 3)
INSERT [dbo].[AcademicYear] ([ID], [AcademicYear], [Semester]) VALUES (7, N'2018/2019', 1)
INSERT [dbo].[AcademicYear] ([ID], [AcademicYear], [Semester]) VALUES (8, N'2018/2019', 2)
INSERT [dbo].[AcademicYear] ([ID], [AcademicYear], [Semester]) VALUES (9, N'2018/2019', 3)
INSERT [dbo].[AcademicYear] ([ID], [AcademicYear], [Semester]) VALUES (10, N'2019/2020', 1)
INSERT [dbo].[AcademicYear] ([ID], [AcademicYear], [Semester]) VALUES (11, N'2019/2020', 2)
INSERT [dbo].[AcademicYear] ([ID], [AcademicYear], [Semester]) VALUES (12, N'2019/2020', 3)
INSERT [dbo].[AcademicYear] ([ID], [AcademicYear], [Semester]) VALUES (13, N'2020/2021', 1)
INSERT [dbo].[AcademicYear] ([ID], [AcademicYear], [Semester]) VALUES (14, N'2020/2021', 2)
INSERT [dbo].[AcademicYear] ([ID], [AcademicYear], [Semester]) VALUES (15, N'2020/2021', 3)
INSERT [dbo].[AcademicYear] ([ID], [AcademicYear], [Semester]) VALUES (16, N'2021/2022', 1)
INSERT [dbo].[AcademicYear] ([ID], [AcademicYear], [Semester]) VALUES (17, N'2021/2022', 2)
INSERT [dbo].[AcademicYear] ([ID], [AcademicYear], [Semester]) VALUES (18, N'2021/2022', 3)
INSERT [dbo].[AcademicYear] ([ID], [AcademicYear], [Semester]) VALUES (19, N'2022/2023', 1)
SET IDENTITY_INSERT [dbo].[AcademicYear] OFF
GO
SET IDENTITY_INSERT [dbo].[CommonQuestion] ON 

INSERT [dbo].[CommonQuestion] ([ID], [Question], [Answer]) VALUES (1, N'Q1', N'A1')
INSERT [dbo].[CommonQuestion] ([ID], [Question], [Answer]) VALUES (2, N'Q2', N'A2')
INSERT [dbo].[CommonQuestion] ([ID], [Question], [Answer]) VALUES (3, N'Q3', N'A3')
INSERT [dbo].[CommonQuestion] ([ID], [Question], [Answer]) VALUES (4, N'Q4', N'A4')
INSERT [dbo].[CommonQuestion] ([ID], [Question], [Answer]) VALUES (5, N'Q5', N'A5')
INSERT [dbo].[CommonQuestion] ([ID], [Question], [Answer]) VALUES (6, N'Q6', N'A6')
INSERT [dbo].[CommonQuestion] ([ID], [Question], [Answer]) VALUES (7, N'Q7', N'A7')
INSERT [dbo].[CommonQuestion] ([ID], [Question], [Answer]) VALUES (8, N'Q8', N'A8')
INSERT [dbo].[CommonQuestion] ([ID], [Question], [Answer]) VALUES (9, N'Q9', N'A9')
INSERT [dbo].[CommonQuestion] ([ID], [Question], [Answer]) VALUES (10, N'Q10', N'A10')
SET IDENTITY_INSERT [dbo].[CommonQuestion] OFF
GO
SET IDENTITY_INSERT [dbo].[Course] ON 

INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [PrerequisiteRelation], [Level], [Semester]) VALUES (1, N'CHEM 101', N'كيمياء عامة 1', 3, 3, 0, 0, 0, 0, 1, 1)
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [PrerequisiteRelation], [Level], [Semester]) VALUES (2, N'CHEM 103', N'عملي كيمياء عامة 1', 1, 0, 3, 0, 0, 0, 1, 1)
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [PrerequisiteRelation], [Level], [Semester]) VALUES (3, N'COMP 102', N'مقدمة في الحاسب الالي', 3, 2, 2, 0, 0, 0, 1, 2)
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [PrerequisiteRelation], [Level], [Semester]) VALUES (4, N'COMP 104', N'برمجة حاسب 1', 3, 2, 2, 0, 0, 0, 1, 2)
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [PrerequisiteRelation], [Level], [Semester]) VALUES (5, N'COMP 106', N'تصميم منطق', 3, 2, 0, 2, 0, 0, 1, 2)
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [PrerequisiteRelation], [Level], [Semester]) VALUES (6, N'COMP 201', N'تصميم وتحليل الخوارزميات', 3, 3, 0, 0, 0, 0, 2, 1)
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [PrerequisiteRelation], [Level], [Semester]) VALUES (7, N'COMP 202', N'تراكيب البيانات', 3, 2, 2, 0, 0, 0, 2, 2)
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [PrerequisiteRelation], [Level], [Semester]) VALUES (8, N'COMP 203', N'نظرية الحسابات', 2, 2, 0, 0, 0, 0, 2, 1)
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [PrerequisiteRelation], [Level], [Semester]) VALUES (9, N'COMP 204', N'شبكات الحاسب', 3, 2, 2, 0, 0, 0, 2, 2)
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [PrerequisiteRelation], [Level], [Semester]) VALUES (10, N'COMP 205', N'برمجة حاسب 2', 3, 2, 2, 0, 0, 0, 2, 1)
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [PrerequisiteRelation], [Level], [Semester]) VALUES (11, N'COMP 206', N'برمجة الويب', 3, 2, 3, 0, 0, 0, 2, 2)
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [PrerequisiteRelation], [Level], [Semester]) VALUES (12, N'COMP 207', N'نظم قواعد البيانات', 4, 3, 2, 0, 0, 0, 2, 1)
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [PrerequisiteRelation], [Level], [Semester]) VALUES (13, N'COMP 208', N'نظرية الاليات الذاتية', 3, 2, 0, 2, 0, 0, 2, 2)
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [PrerequisiteRelation], [Level], [Semester]) VALUES (14, N'COMP 210', N'خورزميات الرسوم', 2, 2, 0, 0, 0, 0, 2, 2)
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [PrerequisiteRelation], [Level], [Semester]) VALUES (15, N'COMP 301', N'برمجة متقدمة', 3, 2, 3, 0, 0, 0, 3, 1)
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [PrerequisiteRelation], [Level], [Semester]) VALUES (16, N'COMP 302', N'تاليفات خوارزمية', 2, 2, 0, 1, 0, 0, 3, 2)
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [PrerequisiteRelation], [Level], [Semester]) VALUES (17, N'COMP 303', N'قواعد ودلالات لغات البرمجة', 2, 2, 0, 0, 0, 0, 3, 1)
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [PrerequisiteRelation], [Level], [Semester]) VALUES (18, N'COMP 304', N'تصميم مؤلفات', 3, 2, 2, 0, 0, 0, 3, 2)
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [PrerequisiteRelation], [Level], [Semester]) VALUES (19, N'COMP 305', N'نظرية التعقيد', 3, 3, 0, 0, 0, 0, 3, 1)
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [PrerequisiteRelation], [Level], [Semester]) VALUES (20, N'COMP 306', N'رسومات الحاسب', 3, 2, 2, 0, 0, 0, 3, 2)
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [PrerequisiteRelation], [Level], [Semester]) VALUES (21, N'COMP 307', N'نظم التشغيل', 3, 3, 0, 0, 0, 0, 3, 1)
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [PrerequisiteRelation], [Level], [Semester]) VALUES (22, N'COMP 308', N'تشفير', 3, 3, 0, 0, 0, 0, 3, 2)
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [PrerequisiteRelation], [Level], [Semester]) VALUES (23, N'COMP 309', N'نظم الوسائط المتعددة', 2, 2, 1, 0, 0, 0, 3, 1)
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [PrerequisiteRelation], [Level], [Semester]) VALUES (24, N'COMP 310', N'برمجة ويب متقدمة', 2, 1, 3, 0, 0, 0, 3, 2)
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [PrerequisiteRelation], [Level], [Semester]) VALUES (25, N'COMP 311', N'اللغات التصريحية', 2, 2, 1, 0, 0, 0, 3, 1)
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [PrerequisiteRelation], [Level], [Semester]) VALUES (26, N'COMP 312', N'تنظيم الملفات', 2, 2, 0, 0, 0, 0, 3, 2)
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [PrerequisiteRelation], [Level], [Semester]) VALUES (27, N'COMP 314', N'نظم قواعد بيانات متقدمة', 2, 2, 0, 0, 0, 0, 3, 2)
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [PrerequisiteRelation], [Level], [Semester]) VALUES (28, N'COMP 401', N'ذكاء اصطناعي', 3, 3, 0, 0, 0, 0, 4, 1)
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [PrerequisiteRelation], [Level], [Semester]) VALUES (29, N'COMP 402', N'المعلومات الحيوية', 3, 3, 0, 0, 0, 0, 4, 2)
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [PrerequisiteRelation], [Level], [Semester]) VALUES (30, N'COMP 403', N'المعالجة المتوازية الموزعة', 3, 3, 1, 0, 0, 0, 4, 1)
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [PrerequisiteRelation], [Level], [Semester]) VALUES (31, N'COMP 404', N'هندسة البرمجيات', 3, 2, 2, 0, 0, 0, 4, 2)
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [PrerequisiteRelation], [Level], [Semester]) VALUES (32, N'COMP 405', N'مشروع حاسب (أ)', 2, 0, 3, 2, 0, 0, 4, 1)
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [PrerequisiteRelation], [Level], [Semester]) VALUES (33, N'COMP 406', N'مشروع حاسب (ب)', 4, 0, 4, 4, 0, 0, 4, 2)
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [PrerequisiteRelation], [Level], [Semester]) VALUES (34, N'COMP 407', N'معالجة الصور', 3, 3, 1, 0, 0, 0, 4, 1)
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [PrerequisiteRelation], [Level], [Semester]) VALUES (35, N'COMP 408', N'موضوعات متقدمة في الذكاء الاصطناعي', 3, 3, 0, 0, 0, 0, 4, 2)
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [PrerequisiteRelation], [Level], [Semester]) VALUES (36, N'COMP 409', N'امن شبكات', 3, 3, 0, 0, 0, 0, 4, 1)
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [PrerequisiteRelation], [Level], [Semester]) VALUES (37, N'COMP 410', N'الرؤية بالحاسب', 3, 3, 0, 0, 0, 0, 4, 2)
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [PrerequisiteRelation], [Level], [Semester]) VALUES (38, N'COMP 411', N'الهندسة الحسابية', 3, 3, 0, 0, 0, 0, 4, 1)
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [PrerequisiteRelation], [Level], [Semester]) VALUES (39, N'COMP 412', N'موضوعات مختارة في امن المعلومات', 3, 3, 0, 0, 0, 0, 4, 2)
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [PrerequisiteRelation], [Level], [Semester]) VALUES (40, N'COMP 413', N'موضوعات مختارة في الخوارزميات', 3, 3, 0, 0, 0, 0, 4, 1)
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [PrerequisiteRelation], [Level], [Semester]) VALUES (41, N'COMP 414', N'موضوعات مختارة في الحوسبة', 3, 3, 0, 0, 0, 0, 4, 2)
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [PrerequisiteRelation], [Level], [Semester]) VALUES (42, N'COMP 415', N'مؤلفات متقدمة', 3, 2, 2, 0, 0, 0, 4, 1)
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [PrerequisiteRelation], [Level], [Semester]) VALUES (43, N'COMP 416', N'استخلاص البيانات والويب', 3, 3, 0, 0, 0, 0, 4, 2)
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [PrerequisiteRelation], [Level], [Semester]) VALUES (44, N'COMP 418', N'مشروع حاسب ( لمزدوج التخصص )', 3, 0, 4, 2, 0, 0, 4, 2)
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [PrerequisiteRelation], [Level], [Semester]) VALUES (45, N'ENCU 401', N'ثقافة بينية', 1, 1, 0, 0, 0, 0, 4, 1)
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [PrerequisiteRelation], [Level], [Semester]) VALUES (46, N'ENGL 102', N'لغة انجليزية 1', 2, 2, 0, 0, 0, 0, 1, 2)
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [PrerequisiteRelation], [Level], [Semester]) VALUES (47, N'ENGL 201', N'لغة انجليزية 2', 2, 2, 0, 0, 0, 0, 2, 1)
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [PrerequisiteRelation], [Level], [Semester]) VALUES (48, N'ETHR 302', N'اخلاقيات البحث العلمي', 1, 1, 0, 0, 0, 0, 3, 2)
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [PrerequisiteRelation], [Level], [Semester]) VALUES (49, N'GHDS 401', N'نشاة تاريخ وتطور العالم', 1, 1, 0, 0, 0, 0, 4, 1)
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [PrerequisiteRelation], [Level], [Semester]) VALUES (50, N'HURI 101', N'حقوق الانسان', 0, 1, 0, 0, 0, 0, 1, 1)
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [PrerequisiteRelation], [Level], [Semester]) VALUES (51, N'INCO 102', N'مدخل في الحاسب الالي', 0, 1, 0, 0, 0, 0, 1, 2)
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [PrerequisiteRelation], [Level], [Semester]) VALUES (52, N'MATH 101', N'تفاضل وتكامل 1', 4, 3, 0, 2, 0, 0, 1, 1)
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [PrerequisiteRelation], [Level], [Semester]) VALUES (53, N'MATH 102', N'تفاضل وتكامل 2', 3, 3, 0, 1, 0, 0, 1, 2)
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [PrerequisiteRelation], [Level], [Semester]) VALUES (54, N'MATH 104', N'مفاهيم اساسية في الرياضيات', 3, 3, 0, 1, 0, 0, 1, 2)
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [PrerequisiteRelation], [Level], [Semester]) VALUES (55, N'MATH 201', N'التحليل الرياضى', 3, 3, 0, 1, 0, 0, 2, 1)
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [PrerequisiteRelation], [Level], [Semester]) VALUES (56, N'MATH 202', N'معادلات تفاضلية عادية', 3, 3, 0, 1, 0, 0, 2, 2)
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [PrerequisiteRelation], [Level], [Semester]) VALUES (57, N'MATH 203', N'جبر خطي', 3, 3, 0, 1, 0, 0, 2, 1)
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [PrerequisiteRelation], [Level], [Semester]) VALUES (58, N'MATH 204', N'تحليل حقيقى', 3, 3, 0, 1, 0, 0, 2, 2)
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [PrerequisiteRelation], [Level], [Semester]) VALUES (59, N'MATH 205', N'نظرية الأعداد', 3, 3, 0, 1, 0, 0, 2, 1)
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [PrerequisiteRelation], [Level], [Semester]) VALUES (60, N'MATH 206', N'نظرية الألعاب', 2, 2, 0, 0, 0, 0, 2, 2)
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [PrerequisiteRelation], [Level], [Semester]) VALUES (61, N'MATH 208', N'البرمجة الخطية', 2, 2, 0, 0, 0, 0, 2, 2)
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [PrerequisiteRelation], [Level], [Semester]) VALUES (62, N'MATH 222', N'المنطق الرياضى', 2, 2, 0, 0, 0, 0, 2, 2)
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [PrerequisiteRelation], [Level], [Semester]) VALUES (63, N'MATH 301', N'الجبر المجرد (1) نظرية الزمر', 3, 3, 0, 1, 0, 0, 3, 1)
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [PrerequisiteRelation], [Level], [Semester]) VALUES (64, N'MATH 302', N'التوبولوجى العام', 3, 3, 0, 0, 0, 0, 3, 2)
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [PrerequisiteRelation], [Level], [Semester]) VALUES (65, N'MATH 303', N'التحليل العددي', 3, 3, 0, 1, 0, 0, 3, 1)
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [PrerequisiteRelation], [Level], [Semester]) VALUES (66, N'MATH 304', N'نظرية القياس', 3, 3, 0, 0, 0, 0, 3, 2)
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [PrerequisiteRelation], [Level], [Semester]) VALUES (67, N'MATH 305', N'الهندسة التفاضلية', 2, 2, 0, 0, 0, 0, 3, 1)
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [PrerequisiteRelation], [Level], [Semester]) VALUES (68, N'MATH 306', N'بحوث العمليات', 2, 2, 0, 0, 0, 0, 3, 2)
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [PrerequisiteRelation], [Level], [Semester]) VALUES (69, N'MATH 307', N'نظرية الخوارزميات', 2, 2, 0, 0, 0, 0, 3, 1)
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [PrerequisiteRelation], [Level], [Semester]) VALUES (70, N'MATH 319', N'مبادئ نمذجة رياضية', 2, 2, 0, 0, 0, 0, 3, 1)
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [PrerequisiteRelation], [Level], [Semester]) VALUES (71, N'MATH 331', N'مبادئ حساب التغيرات', 3, 2, 0, 2, 0, 0, 3, 1)
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [PrerequisiteRelation], [Level], [Semester]) VALUES (72, N'MATH 333', N'الجبر المجرد لعلوم الحاسب', 3, 2, 0, 2, 0, 0, 3, 1)
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [PrerequisiteRelation], [Level], [Semester]) VALUES (73, N'MATH 401', N'التحليل الدالى', 3, 3, 0, 0, 0, 0, 4, 1)
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [PrerequisiteRelation], [Level], [Semester]) VALUES (74, N'MATH 402', N'الجبر المجرد (2) (الحلقات و الحقول)', 3, 3, 0, 1, 0, 0, 4, 2)
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [PrerequisiteRelation], [Level], [Semester]) VALUES (75, N'MATH 403', N'التحليل المركب', 3, 3, 0, 0, 0, 0, 4, 1)
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [PrerequisiteRelation], [Level], [Semester]) VALUES (76, N'MATH 404', N'المعادلات التفاضلية الجزئية', 3, 3, 0, 0, 0, 0, 4, 2)
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [PrerequisiteRelation], [Level], [Semester]) VALUES (77, N'MATH 406', N'جبر خطى متقدم', 3, 2, 2, 0, 0, 0, 4, 2)
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [PrerequisiteRelation], [Level], [Semester]) VALUES (78, N'MATH 407', N'الهندسة الجبرية', 2, 2, 0, 0, 0, 0, 4, 1)
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [PrerequisiteRelation], [Level], [Semester]) VALUES (79, N'MATH 408', N'موضوعات مختارة فى الرياضيات البحتة', 3, 3, 0, 0, 0, 0, 4, 2)
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [PrerequisiteRelation], [Level], [Semester]) VALUES (80, N'MATH 409', N'نظرية الرسوم', 2, 2, 0, 0, 0, 0, 4, 1)
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [PrerequisiteRelation], [Level], [Semester]) VALUES (81, N'MATH 421', N'جبر خطى عددى', 2, 2, 0, 0, 0, 0, 4, 1)
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [PrerequisiteRelation], [Level], [Semester]) VALUES (82, N'MATH 423', N'مشروع بحثى رياضيات بحتة', 1, 0, 0, 3, 0, 0, 4, 1)
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [PrerequisiteRelation], [Level], [Semester]) VALUES (83, N'PHYS 101', N'فيزياء 1', 4, 3, 3, 0, 0, 0, 1, 1)
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [PrerequisiteRelation], [Level], [Semester]) VALUES (84, N'SAFS 101', N'الامن والسلامة', 1, 1, 0, 0, 0, 0, 1, 1)
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [PrerequisiteRelation], [Level], [Semester]) VALUES (85, N'SCTH 301', N'التفكير العلمي', 1, 1, 0, 0, 0, 0, 3, 1)
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [PrerequisiteRelation], [Level], [Semester]) VALUES (86, N'SKIL 401', N'مهارات العمل', 1, 1, 0, 0, 0, 0, 4, 1)
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [PrerequisiteRelation], [Level], [Semester]) VALUES (87, N'STAT 101', N'مقدمة في الاحصاء', 3, 3, 0, 1, 0, 0, 1, 1)
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [PrerequisiteRelation], [Level], [Semester]) VALUES (88, N'STAT 102', N'نظرية الاحتمالات 1', 3, 3, 0, 1, 0, 0, 1, 2)
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [PrerequisiteRelation], [Level], [Semester]) VALUES (89, N'STAT 201', N'(1) نظرية الإحصاء', 3, 3, 0, 1, 0, 0, 2, 1)
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [PrerequisiteRelation], [Level], [Semester]) VALUES (90, N'STAT 202', N'(2) نظرية الإحصاء', 3, 3, 0, 1, 0, 0, 2, 2)
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [PrerequisiteRelation], [Level], [Semester]) VALUES (91, N'STAT 203', N'(1) طرق إحصائية', 3, 2, 3, 0, 0, 0, 2, 1)
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [PrerequisiteRelation], [Level], [Semester]) VALUES (92, N'STAT 204', N'(1) طرق إحتمالية فى بحوث العمليات', 3, 3, 0, 1, 1, 0, 2, 2)
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [PrerequisiteRelation], [Level], [Semester]) VALUES (93, N'STAT 205', N'رياضيات إحصائية', 3, 3, 0, 1, 0, 0, 2, 1)
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [PrerequisiteRelation], [Level], [Semester]) VALUES (94, N'STAT 206', N'(2) طرق إحصائية', 3, 2, 3, 0, 0, 0, 2, 2)
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [PrerequisiteRelation], [Level], [Semester]) VALUES (95, N'STAT 208', N'مبادئ تحاليل الانحدار', 3, 3, 1, 0, 0, 0, 2, 2)
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [PrerequisiteRelation], [Level], [Semester]) VALUES (96, N'STAT 218', N'مقدمة في نظرية الاحتمالات', 3, 3, 0, 1, 0, 0, 2, 2)
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [PrerequisiteRelation], [Level], [Semester]) VALUES (97, N'STAT 301', N'(1) استدلال إحصائى', 3, 3, 0, 1, 0, 0, 3, 1)
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [PrerequisiteRelation], [Level], [Semester]) VALUES (98, N'STAT 302', N'(2) استدلال إحصائى', 3, 3, 0, 1, 0, 0, 3, 2)
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [PrerequisiteRelation], [Level], [Semester]) VALUES (99, N'STAT 303', N'(1) عمليات عشوائية', 3, 3, 0, 1, 0, 0, 3, 1)
GO
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [PrerequisiteRelation], [Level], [Semester]) VALUES (100, N'STAT 304', N'طرق المعاينة', 3, 3, 0, 0, 0, 0, 3, 2)
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [PrerequisiteRelation], [Level], [Semester]) VALUES (101, N'STAT 305', N'إحصاءات مرتبة', 3, 3, 0, 1, 0, 0, 3, 1)
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [PrerequisiteRelation], [Level], [Semester]) VALUES (102, N'STAT 311', N'محاكاة ونمذجة', 3, 3, 0, 1, 0, 0, 3, 1)
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [PrerequisiteRelation], [Level], [Semester]) VALUES (103, N'STAT 314', N'نظرية الصلاحية', 2, 2, 0, 0, 0, 0, 3, 2)
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [PrerequisiteRelation], [Level], [Semester]) VALUES (104, N'STAT 315', N'(2) طرق إحتمالية فى بحوث العمليات', 3, 3, 0, 1, 0, 0, 3, 1)
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [PrerequisiteRelation], [Level], [Semester]) VALUES (105, N'STAT 405', N'تصميم و تحليل التجارب', 4, 3, 2, 0, 0, 0, 4, 1)
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [PrerequisiteRelation], [Level], [Semester]) VALUES (106, N'STAT 408', N'سلاسل زمنية', 3, 3, 0, 0, 0, 0, 4, 2)
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [PrerequisiteRelation], [Level], [Semester]) VALUES (107, N'STAT 411', N'التحليل التتابعى', 2, 2, 0, 0, 0, 0, 4, 1)
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [PrerequisiteRelation], [Level], [Semester]) VALUES (108, N'STAT 412', N'نظرية الطوابير', 2, 2, 0, 0, 0, 0, 4, 2)
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [PrerequisiteRelation], [Level], [Semester]) VALUES (109, N'STAT 415', N'تحليل إحصائى متعدد', 2, 2, 0, 1, 0, 0, 4, 1)
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [PrerequisiteRelation], [Level], [Semester]) VALUES (110, N'STAT 416', N'نظرية التجديد', 2, 2, 0, 0, 0, 0, 4, 2)
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [PrerequisiteRelation], [Level], [Semester]) VALUES (111, N'STAT 417', N'نظرية اتخاذ القرار', 2, 2, 0, 0, 0, 0, 4, 1)
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [PrerequisiteRelation], [Level], [Semester]) VALUES (112, N'STAT 418', N'(2) عمليات عشوائية', 2, 2, 0, 0, 0, 0, 4, 2)
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [PrerequisiteRelation], [Level], [Semester]) VALUES (113, N'STAT 424', N'مشروع بحثى فى الإحصاء', 2, 0, 2, 2, 0, 0, 4, 2)
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [PrerequisiteRelation], [Level], [Semester]) VALUES (114, N'COMP 212', N'برمجة حاسب متقدم', 3, 2, 2, 0, 0, 0, 2, 2)
INSERT [dbo].[Course] ([ID], [CourseCode], [CourseName], [CreditHours], [LectureHours], [LabHours], [SectionHours], [IsActive], [PrerequisiteRelation], [Level], [Semester]) VALUES (115, N'COMP 313', N'حزم برمجية', 1, 0, 3, 0, 0, 0, 3, 1)
SET IDENTITY_INSERT [dbo].[Course] OFF
GO
INSERT [dbo].[CoursePrerequisites] ([CourseID], [PrerequisiteCourseID]) VALUES (7, 4)
INSERT [dbo].[CoursePrerequisites] ([CourseID], [PrerequisiteCourseID]) VALUES (10, 4)
INSERT [dbo].[CoursePrerequisites] ([CourseID], [PrerequisiteCourseID]) VALUES (11, 4)
INSERT [dbo].[CoursePrerequisites] ([CourseID], [PrerequisiteCourseID]) VALUES (15, 10)
INSERT [dbo].[CoursePrerequisites] ([CourseID], [PrerequisiteCourseID]) VALUES (18, 13)
INSERT [dbo].[CoursePrerequisites] ([CourseID], [PrerequisiteCourseID]) VALUES (19, 9)
INSERT [dbo].[CoursePrerequisites] ([CourseID], [PrerequisiteCourseID]) VALUES (20, 10)
INSERT [dbo].[CoursePrerequisites] ([CourseID], [PrerequisiteCourseID]) VALUES (24, 11)
INSERT [dbo].[CoursePrerequisites] ([CourseID], [PrerequisiteCourseID]) VALUES (27, 12)
INSERT [dbo].[CoursePrerequisites] ([CourseID], [PrerequisiteCourseID]) VALUES (29, 6)
INSERT [dbo].[CoursePrerequisites] ([CourseID], [PrerequisiteCourseID]) VALUES (29, 10)
INSERT [dbo].[CoursePrerequisites] ([CourseID], [PrerequisiteCourseID]) VALUES (31, 10)
INSERT [dbo].[CoursePrerequisites] ([CourseID], [PrerequisiteCourseID]) VALUES (34, 10)
INSERT [dbo].[CoursePrerequisites] ([CourseID], [PrerequisiteCourseID]) VALUES (36, 9)
INSERT [dbo].[CoursePrerequisites] ([CourseID], [PrerequisiteCourseID]) VALUES (36, 22)
INSERT [dbo].[CoursePrerequisites] ([CourseID], [PrerequisiteCourseID]) VALUES (37, 6)
INSERT [dbo].[CoursePrerequisites] ([CourseID], [PrerequisiteCourseID]) VALUES (37, 10)
INSERT [dbo].[CoursePrerequisites] ([CourseID], [PrerequisiteCourseID]) VALUES (38, 6)
INSERT [dbo].[CoursePrerequisites] ([CourseID], [PrerequisiteCourseID]) VALUES (38, 10)
INSERT [dbo].[CoursePrerequisites] ([CourseID], [PrerequisiteCourseID]) VALUES (40, 6)
INSERT [dbo].[CoursePrerequisites] ([CourseID], [PrerequisiteCourseID]) VALUES (41, 10)
INSERT [dbo].[CoursePrerequisites] ([CourseID], [PrerequisiteCourseID]) VALUES (42, 17)
INSERT [dbo].[CoursePrerequisites] ([CourseID], [PrerequisiteCourseID]) VALUES (42, 18)
INSERT [dbo].[CoursePrerequisites] ([CourseID], [PrerequisiteCourseID]) VALUES (43, 12)
INSERT [dbo].[CoursePrerequisites] ([CourseID], [PrerequisiteCourseID]) VALUES (47, 46)
INSERT [dbo].[CoursePrerequisites] ([CourseID], [PrerequisiteCourseID]) VALUES (56, 52)
INSERT [dbo].[CoursePrerequisites] ([CourseID], [PrerequisiteCourseID]) VALUES (56, 53)
INSERT [dbo].[CoursePrerequisites] ([CourseID], [PrerequisiteCourseID]) VALUES (66, 58)
INSERT [dbo].[CoursePrerequisites] ([CourseID], [PrerequisiteCourseID]) VALUES (74, 63)
INSERT [dbo].[CoursePrerequisites] ([CourseID], [PrerequisiteCourseID]) VALUES (75, 58)
INSERT [dbo].[CoursePrerequisites] ([CourseID], [PrerequisiteCourseID]) VALUES (76, 56)
INSERT [dbo].[CoursePrerequisites] ([CourseID], [PrerequisiteCourseID]) VALUES (77, 57)
INSERT [dbo].[CoursePrerequisites] ([CourseID], [PrerequisiteCourseID]) VALUES (81, 57)
INSERT [dbo].[CoursePrerequisites] ([CourseID], [PrerequisiteCourseID]) VALUES (89, 88)
INSERT [dbo].[CoursePrerequisites] ([CourseID], [PrerequisiteCourseID]) VALUES (90, 88)
INSERT [dbo].[CoursePrerequisites] ([CourseID], [PrerequisiteCourseID]) VALUES (91, 87)
INSERT [dbo].[CoursePrerequisites] ([CourseID], [PrerequisiteCourseID]) VALUES (97, 90)
INSERT [dbo].[CoursePrerequisites] ([CourseID], [PrerequisiteCourseID]) VALUES (98, 90)
INSERT [dbo].[CoursePrerequisites] ([CourseID], [PrerequisiteCourseID]) VALUES (99, 93)
INSERT [dbo].[CoursePrerequisites] ([CourseID], [PrerequisiteCourseID]) VALUES (101, 90)
INSERT [dbo].[CoursePrerequisites] ([CourseID], [PrerequisiteCourseID]) VALUES (102, 90)
INSERT [dbo].[CoursePrerequisites] ([CourseID], [PrerequisiteCourseID]) VALUES (104, 92)
INSERT [dbo].[CoursePrerequisites] ([CourseID], [PrerequisiteCourseID]) VALUES (105, 98)
INSERT [dbo].[CoursePrerequisites] ([CourseID], [PrerequisiteCourseID]) VALUES (106, 98)
INSERT [dbo].[CoursePrerequisites] ([CourseID], [PrerequisiteCourseID]) VALUES (107, 98)
INSERT [dbo].[CoursePrerequisites] ([CourseID], [PrerequisiteCourseID]) VALUES (108, 99)
INSERT [dbo].[CoursePrerequisites] ([CourseID], [PrerequisiteCourseID]) VALUES (109, 93)
INSERT [dbo].[CoursePrerequisites] ([CourseID], [PrerequisiteCourseID]) VALUES (110, 93)
INSERT [dbo].[CoursePrerequisites] ([CourseID], [PrerequisiteCourseID]) VALUES (112, 99)
INSERT [dbo].[CoursePrerequisites] ([CourseID], [PrerequisiteCourseID]) VALUES (111, 97)
INSERT [dbo].[CoursePrerequisites] ([CourseID], [PrerequisiteCourseID]) VALUES (114, 4)
GO
SET IDENTITY_INSERT [dbo].[Program] ON 

INSERT [dbo].[Program] ([ID], [Name], [Semester], [Percentage], [IsRegular], [IsGeneral]) VALUES (1, N'Math', 0, 1, 1, 1)
INSERT [dbo].[Program] ([ID], [Name], [Semester], [Percentage], [IsRegular], [IsGeneral]) VALUES (2, N'CS', 1, 0.35, 1, 1)
INSERT [dbo].[Program] ([ID], [Name], [Semester], [Percentage], [IsRegular], [IsGeneral]) VALUES (3, N'Stat', 1, 0.35, 1, 1)
INSERT [dbo].[Program] ([ID], [Name], [Semester], [Percentage], [IsRegular], [IsGeneral]) VALUES (4, N'Pure Math', 1, 0.3, 1, 0)
INSERT [dbo].[Program] ([ID], [Name], [Semester], [Percentage], [IsRegular], [IsGeneral]) VALUES (5, N'Pure CS', 2, 0.6, 1, 0)
INSERT [dbo].[Program] ([ID], [Name], [Semester], [Percentage], [IsRegular], [IsGeneral]) VALUES (6, N'Math CS', 2, 0.4, 1, 0)
INSERT [dbo].[Program] ([ID], [Name], [Semester], [Percentage], [IsRegular], [IsGeneral]) VALUES (7, N'Stat CS', 2, 1, 1, 0)
INSERT [dbo].[Program] ([ID], [Name], [Semester], [Percentage], [IsRegular], [IsGeneral]) VALUES (8, N'Pure Stat', 2, 1, 1, 0)
INSERT [dbo].[Program] ([ID], [Name], [Semester], [Percentage], [IsRegular], [IsGeneral]) VALUES (9, N'Stat Math', 2, 1, 1, 0)
SET IDENTITY_INSERT [dbo].[Program] OFF
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType]) VALUES (5, 1, 1)
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType]) VALUES (5, 2, 1)
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType]) VALUES (5, 3, 1)
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType]) VALUES (5, 4, 1)
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType]) VALUES (5, 5, 1)
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType]) VALUES (5, 6, 1)
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType]) VALUES (5, 7, 1)
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType]) VALUES (5, 8, 1)
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType]) VALUES (5, 9, 1)
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType]) VALUES (5, 10, 1)
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType]) VALUES (5, 11, 1)
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType]) VALUES (5, 12, 1)
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType]) VALUES (5, 13, 1)
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType]) VALUES (5, 14, 1)
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType]) VALUES (5, 15, 1)
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType]) VALUES (5, 16, 1)
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType]) VALUES (5, 17, 1)
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType]) VALUES (5, 18, 1)
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType]) VALUES (5, 19, 1)
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType]) VALUES (5, 20, 1)
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType]) VALUES (5, 21, 1)
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType]) VALUES (5, 22, 1)
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType]) VALUES (5, 23, 2)
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType]) VALUES (5, 24, 2)
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType]) VALUES (5, 25, 2)
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType]) VALUES (5, 26, 2)
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType]) VALUES (5, 27, 2)
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType]) VALUES (5, 28, 1)
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType]) VALUES (5, 29, 1)
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType]) VALUES (5, 30, 1)
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType]) VALUES (5, 31, 1)
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType]) VALUES (5, 32, 1)
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType]) VALUES (5, 33, 1)
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType]) VALUES (5, 34, 1)
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType]) VALUES (5, 35, 2)
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType]) VALUES (5, 36, 2)
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType]) VALUES (5, 37, 2)
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType]) VALUES (5, 38, 2)
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType]) VALUES (5, 39, 2)
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType]) VALUES (5, 40, 2)
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType]) VALUES (5, 41, 2)
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType]) VALUES (5, 42, 2)
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType]) VALUES (5, 43, 2)
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType]) VALUES (5, 45, 3)
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType]) VALUES (5, 46, 3)
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType]) VALUES (5, 47, 3)
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType]) VALUES (5, 48, 3)
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType]) VALUES (5, 49, 3)
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType]) VALUES (5, 50, 3)
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType]) VALUES (5, 51, 3)
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType]) VALUES (5, 52, 1)
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType]) VALUES (5, 53, 1)
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType]) VALUES (5, 54, 1)
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType]) VALUES (5, 56, 2)
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType]) VALUES (5, 57, 1)
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType]) VALUES (5, 65, 2)
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType]) VALUES (5, 72, 2)
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType]) VALUES (5, 83, 1)
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType]) VALUES (5, 84, 3)
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType]) VALUES (5, 85, 3)
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType]) VALUES (5, 86, 3)
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType]) VALUES (5, 87, 1)
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType]) VALUES (5, 96, 2)
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType]) VALUES (6, 44, 1)
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType]) VALUES (6, 52, 1)
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType]) VALUES (6, 83, 1)
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType]) VALUES (6, 1, 1)
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType]) VALUES (6, 2, 1)
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType]) VALUES (6, 87, 1)
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType]) VALUES (6, 84, 3)
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType]) VALUES (6, 50, 3)
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType]) VALUES (6, 46, 3)
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType]) VALUES (6, 51, 3)
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType]) VALUES (6, 53, 1)
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType]) VALUES (6, 54, 1)
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType]) VALUES (6, 3, 1)
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType]) VALUES (6, 4, 1)
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType]) VALUES (6, 5, 1)
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType]) VALUES (6, 47, 3)
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType]) VALUES (6, 55, 1)
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType]) VALUES (6, 57, 1)
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType]) VALUES (6, 59, 1)
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType]) VALUES (6, 6, 1)
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType]) VALUES (6, 12, 1)
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType]) VALUES (6, 56, 1)
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType]) VALUES (6, 58, 1)
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType]) VALUES (6, 60, 2)
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType]) VALUES (6, 61, 2)
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType]) VALUES (6, 62, 2)
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType]) VALUES (6, 7, 1)
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType]) VALUES (6, 114, 1)
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType]) VALUES (6, 9, 2)
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType]) VALUES (6, 11, 2)
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType]) VALUES (6, 13, 2)
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType]) VALUES (6, 85, 3)
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType]) VALUES (6, 63, 1)
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType]) VALUES (6, 65, 1)
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType]) VALUES (6, 67, 2)
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType]) VALUES (6, 69, 2)
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType]) VALUES (6, 70, 2)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType]) VALUES (6, 71, 2)
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType]) VALUES (6, 19, 1)
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType]) VALUES (6, 21, 1)
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType]) VALUES (6, 17, 2)
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType]) VALUES (6, 23, 2)
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType]) VALUES (6, 25, 2)
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType]) VALUES (6, 115, 2)
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType]) VALUES (6, 48, 3)
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType]) VALUES (6, 64, 1)
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType]) VALUES (6, 66, 1)
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType]) VALUES (6, 68, 1)
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType]) VALUES (6, 16, 1)
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType]) VALUES (6, 22, 1)
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType]) VALUES (6, 18, 2)
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType]) VALUES (6, 20, 2)
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType]) VALUES (6, 86, 3)
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType]) VALUES (6, 45, 3)
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType]) VALUES (6, 49, 3)
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType]) VALUES (6, 73, 1)
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType]) VALUES (6, 75, 1)
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType]) VALUES (6, 82, 1)
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType]) VALUES (6, 78, 2)
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType]) VALUES (6, 80, 2)
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType]) VALUES (6, 81, 2)
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType]) VALUES (6, 28, 1)
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType]) VALUES (6, 30, 1)
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType]) VALUES (6, 34, 2)
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType]) VALUES (6, 38, 2)
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType]) VALUES (6, 40, 2)
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType]) VALUES (6, 74, 1)
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType]) VALUES (6, 76, 1)
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType]) VALUES (6, 77, 2)
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType]) VALUES (6, 79, 2)
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType]) VALUES (6, 29, 1)
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType]) VALUES (6, 39, 2)
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType]) VALUES (6, 41, 2)
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType]) VALUES (6, 43, 2)
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType]) VALUES (7, 52, 1)
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType]) VALUES (7, 83, 1)
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType]) VALUES (7, 1, 1)
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType]) VALUES (7, 2, 1)
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType]) VALUES (7, 87, 1)
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType]) VALUES (7, 84, 3)
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType]) VALUES (7, 50, 3)
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType]) VALUES (7, 46, 3)
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType]) VALUES (7, 51, 3)
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType]) VALUES (7, 53, 1)
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType]) VALUES (7, 54, 1)
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType]) VALUES (7, 3, 1)
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType]) VALUES (7, 4, 1)
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType]) VALUES (7, 88, 1)
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType]) VALUES (7, 47, 3)
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType]) VALUES (7, 89, 1)
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType]) VALUES (7, 91, 1)
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType]) VALUES (7, 93, 1)
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType]) VALUES (7, 6, 1)
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType]) VALUES (7, 12, 1)
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType]) VALUES (7, 90, 1)
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType]) VALUES (7, 92, 1)
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType]) VALUES (7, 94, 2)
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType]) VALUES (7, 95, 2)
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType]) VALUES (7, 7, 1)
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType]) VALUES (7, 114, 1)
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType]) VALUES (7, 9, 2)
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType]) VALUES (7, 11, 2)
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType]) VALUES (7, 13, 2)
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType]) VALUES (7, 85, 3)
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType]) VALUES (7, 97, 1)
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType]) VALUES (7, 99, 1)
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType]) VALUES (7, 101, 2)
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType]) VALUES (7, 102, 2)
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType]) VALUES (7, 104, 2)
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType]) VALUES (7, 19, 1)
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType]) VALUES (7, 21, 1)
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType]) VALUES (7, 17, 2)
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType]) VALUES (7, 23, 2)
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType]) VALUES (7, 25, 2)
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType]) VALUES (7, 48, 3)
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType]) VALUES (7, 98, 1)
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType]) VALUES (7, 100, 1)
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType]) VALUES (7, 103, 1)
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType]) VALUES (7, 16, 1)
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType]) VALUES (7, 22, 1)
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType]) VALUES (7, 18, 2)
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType]) VALUES (7, 20, 2)
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType]) VALUES (7, 86, 3)
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType]) VALUES (7, 45, 3)
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType]) VALUES (7, 49, 3)
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType]) VALUES (7, 105, 1)
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType]) VALUES (7, 109, 1)
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType]) VALUES (7, 107, 2)
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType]) VALUES (7, 111, 2)
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType]) VALUES (7, 28, 1)
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType]) VALUES (7, 30, 1)
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType]) VALUES (7, 34, 2)
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType]) VALUES (7, 38, 2)
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType]) VALUES (7, 40, 2)
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType]) VALUES (7, 106, 1)
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType]) VALUES (7, 112, 1)
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType]) VALUES (7, 113, 1)
GO
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType]) VALUES (7, 108, 2)
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType]) VALUES (7, 110, 2)
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType]) VALUES (7, 29, 1)
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType]) VALUES (7, 44, 1)
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType]) VALUES (7, 31, 2)
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType]) VALUES (7, 41, 2)
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType]) VALUES (7, 43, 2)
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType]) VALUES (1, 1, 1)
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType]) VALUES (1, 2, 1)
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType]) VALUES (1, 52, 1)
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType]) VALUES (1, 83, 1)
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType]) VALUES (1, 87, 1)
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType]) VALUES (1, 50, 3)
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType]) VALUES (1, 84, 3)
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType]) VALUES (2, 3, 1)
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType]) VALUES (2, 4, 1)
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType]) VALUES (2, 5, 1)
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType]) VALUES (2, 53, 1)
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType]) VALUES (2, 54, 1)
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType]) VALUES (2, 46, 3)
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType]) VALUES (2, 51, 3)
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType]) VALUES (3, 3, 1)
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType]) VALUES (3, 4, 1)
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType]) VALUES (3, 53, 1)
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType]) VALUES (3, 54, 1)
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType]) VALUES (3, 88, 1)
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType]) VALUES (3, 46, 3)
INSERT [dbo].[ProgramCourses] ([ProgramID], [CourseID], [CourseType]) VALUES (3, 51, 3)
GO
INSERT [dbo].[ProgramDistribution] ([ProgramID], [Semester], [NumberOfHours]) VALUES (1, 1, 16)
INSERT [dbo].[ProgramDistribution] ([ProgramID], [Semester], [NumberOfHours]) VALUES (2, 2, 17)
INSERT [dbo].[ProgramDistribution] ([ProgramID], [Semester], [NumberOfHours]) VALUES (3, 2, 17)
INSERT [dbo].[ProgramDistribution] ([ProgramID], [Semester], [NumberOfHours]) VALUES (4, 1, 16)
INSERT [dbo].[ProgramDistribution] ([ProgramID], [Semester], [NumberOfHours]) VALUES (4, 2, 17)
INSERT [dbo].[ProgramDistribution] ([ProgramID], [Semester], [NumberOfHours]) VALUES (4, 3, 18)
INSERT [dbo].[ProgramDistribution] ([ProgramID], [Semester], [NumberOfHours]) VALUES (4, 4, 16)
INSERT [dbo].[ProgramDistribution] ([ProgramID], [Semester], [NumberOfHours]) VALUES (4, 5, 17)
INSERT [dbo].[ProgramDistribution] ([ProgramID], [Semester], [NumberOfHours]) VALUES (4, 6, 17)
INSERT [dbo].[ProgramDistribution] ([ProgramID], [Semester], [NumberOfHours]) VALUES (4, 7, 17)
INSERT [dbo].[ProgramDistribution] ([ProgramID], [Semester], [NumberOfHours]) VALUES (4, 8, 16)
INSERT [dbo].[ProgramDistribution] ([ProgramID], [Semester], [NumberOfHours]) VALUES (5, 1, 16)
INSERT [dbo].[ProgramDistribution] ([ProgramID], [Semester], [NumberOfHours]) VALUES (5, 2, 17)
INSERT [dbo].[ProgramDistribution] ([ProgramID], [Semester], [NumberOfHours]) VALUES (5, 3, 17)
INSERT [dbo].[ProgramDistribution] ([ProgramID], [Semester], [NumberOfHours]) VALUES (5, 4, 17)
INSERT [dbo].[ProgramDistribution] ([ProgramID], [Semester], [NumberOfHours]) VALUES (5, 5, 17)
INSERT [dbo].[ProgramDistribution] ([ProgramID], [Semester], [NumberOfHours]) VALUES (5, 6, 16)
INSERT [dbo].[ProgramDistribution] ([ProgramID], [Semester], [NumberOfHours]) VALUES (5, 7, 18)
INSERT [dbo].[ProgramDistribution] ([ProgramID], [Semester], [NumberOfHours]) VALUES (5, 8, 16)
INSERT [dbo].[ProgramDistribution] ([ProgramID], [Semester], [NumberOfHours]) VALUES (6, 1, 16)
INSERT [dbo].[ProgramDistribution] ([ProgramID], [Semester], [NumberOfHours]) VALUES (6, 2, 17)
INSERT [dbo].[ProgramDistribution] ([ProgramID], [Semester], [NumberOfHours]) VALUES (6, 3, 18)
INSERT [dbo].[ProgramDistribution] ([ProgramID], [Semester], [NumberOfHours]) VALUES (6, 4, 17)
INSERT [dbo].[ProgramDistribution] ([ProgramID], [Semester], [NumberOfHours]) VALUES (6, 5, 18)
INSERT [dbo].[ProgramDistribution] ([ProgramID], [Semester], [NumberOfHours]) VALUES (6, 6, 17)
INSERT [dbo].[ProgramDistribution] ([ProgramID], [Semester], [NumberOfHours]) VALUES (6, 7, 19)
INSERT [dbo].[ProgramDistribution] ([ProgramID], [Semester], [NumberOfHours]) VALUES (6, 8, 18)
INSERT [dbo].[ProgramDistribution] ([ProgramID], [Semester], [NumberOfHours]) VALUES (7, 1, 16)
INSERT [dbo].[ProgramDistribution] ([ProgramID], [Semester], [NumberOfHours]) VALUES (7, 2, 17)
INSERT [dbo].[ProgramDistribution] ([ProgramID], [Semester], [NumberOfHours]) VALUES (7, 3, 18)
INSERT [dbo].[ProgramDistribution] ([ProgramID], [Semester], [NumberOfHours]) VALUES (7, 4, 18)
INSERT [dbo].[ProgramDistribution] ([ProgramID], [Semester], [NumberOfHours]) VALUES (7, 5, 18)
INSERT [dbo].[ProgramDistribution] ([ProgramID], [Semester], [NumberOfHours]) VALUES (7, 6, 17)
INSERT [dbo].[ProgramDistribution] ([ProgramID], [Semester], [NumberOfHours]) VALUES (7, 7, 18)
INSERT [dbo].[ProgramDistribution] ([ProgramID], [Semester], [NumberOfHours]) VALUES (7, 8, 18)
INSERT [dbo].[ProgramDistribution] ([ProgramID], [Semester], [NumberOfHours]) VALUES (8, 1, 16)
INSERT [dbo].[ProgramDistribution] ([ProgramID], [Semester], [NumberOfHours]) VALUES (8, 2, 17)
INSERT [dbo].[ProgramDistribution] ([ProgramID], [Semester], [NumberOfHours]) VALUES (8, 3, 17)
INSERT [dbo].[ProgramDistribution] ([ProgramID], [Semester], [NumberOfHours]) VALUES (8, 4, 17)
INSERT [dbo].[ProgramDistribution] ([ProgramID], [Semester], [NumberOfHours]) VALUES (8, 5, 16)
INSERT [dbo].[ProgramDistribution] ([ProgramID], [Semester], [NumberOfHours]) VALUES (8, 6, 16)
INSERT [dbo].[ProgramDistribution] ([ProgramID], [Semester], [NumberOfHours]) VALUES (8, 7, 18)
INSERT [dbo].[ProgramDistribution] ([ProgramID], [Semester], [NumberOfHours]) VALUES (8, 8, 17)
INSERT [dbo].[ProgramDistribution] ([ProgramID], [Semester], [NumberOfHours]) VALUES (9, 1, 16)
INSERT [dbo].[ProgramDistribution] ([ProgramID], [Semester], [NumberOfHours]) VALUES (9, 2, 17)
INSERT [dbo].[ProgramDistribution] ([ProgramID], [Semester], [NumberOfHours]) VALUES (9, 3, 18)
INSERT [dbo].[ProgramDistribution] ([ProgramID], [Semester], [NumberOfHours]) VALUES (9, 4, 17)
INSERT [dbo].[ProgramDistribution] ([ProgramID], [Semester], [NumberOfHours]) VALUES (9, 5, 18)
INSERT [dbo].[ProgramDistribution] ([ProgramID], [Semester], [NumberOfHours]) VALUES (9, 6, 17)
INSERT [dbo].[ProgramDistribution] ([ProgramID], [Semester], [NumberOfHours]) VALUES (9, 7, 19)
INSERT [dbo].[ProgramDistribution] ([ProgramID], [Semester], [NumberOfHours]) VALUES (9, 8, 18)
GO
SET IDENTITY_INSERT [dbo].[Student] ON 

INSERT [dbo].[Student] ([ID], [GUID], [FName], [MName], [LName], [SSN], [PhoneNumber], [BirthDate], [Address], [Gender], [Nationality], [Email], [Password], [Level], [CGPA], [AcademicCode], [PassedHours], [SeatNumber], [AvailableCredits], [WarningsNumber], [Rank], [IsInSpecialProgram], [SupervisorID], [CreatedOn], [IsCrossStudent], [SemestersNumberInProgram]) VALUES (5, N'94A552CF-AF8D-402A-AB9D-F37D11220E97', N'Momen', N'Essam', N'Arafa', N'30105050106293', N'01021179969', CAST(N'2001-05-05' AS Date), N'26 شارع راضى سليم الاول - الزيتون - القاهره', N'1', N'مصرى', N'30105050106293@sci.asu.edu.eg', N'ujJTh2rta8ItSm/1PYQGxq2GQZXtFEq1yHYhtsIztUi66uaVbfNG7IwX9eoQ817jy8UUeX7X3dMUVGTioLq0Ew==
', 3, 2.96, N'190691', 100, NULL, 9, 0, NULL, 1, 2, CAST(N'2022-11-27T00:00:00.000' AS DateTime), 0, 7)
INSERT [dbo].[Student] ([ID], [GUID], [FName], [MName], [LName], [SSN], [PhoneNumber], [BirthDate], [Address], [Gender], [Nationality], [Email], [Password], [Level], [CGPA], [AcademicCode], [PassedHours], [SeatNumber], [AvailableCredits], [WarningsNumber], [Rank], [IsInSpecialProgram], [SupervisorID], [CreatedOn], [IsCrossStudent], [SemestersNumberInProgram]) VALUES (8, N'5A0F826F-770A-44FA-BE66-62721E55D5F1', N'Girguis', N'Ashraf', N'Fekry', N'30109272102534', N'01033916944', CAST(N'2001-09-27' AS Date), N'11 شارع كمال احمد منصور - ارض اللواء  العجوزة - الجيزة', N'1', N'مصرى', N'30109272102534', N'ujJTh2rta8ItSm/1PYQGxq2GQZXtFEq1yHYhtsIztUi66uaVbfNG7IwX9eoQ817jy8UUeX7X3dMUVGTioLq0Ew==
', 3, 3.04, N'190114', 100, NULL, 12, 0, NULL, 1, 2, CAST(N'2022-11-27T00:00:00.000' AS DateTime), 0, 7)
INSERT [dbo].[Student] ([ID], [GUID], [FName], [MName], [LName], [SSN], [PhoneNumber], [BirthDate], [Address], [Gender], [Nationality], [Email], [Password], [Level], [CGPA], [AcademicCode], [PassedHours], [SeatNumber], [AvailableCredits], [WarningsNumber], [Rank], [IsInSpecialProgram], [SupervisorID], [CreatedOn], [IsCrossStudent], [SemestersNumberInProgram]) VALUES (11, N'03CBB008-52E8-4904-BDC4-70AD821E4388', N'Giovany', N'Nady', N'Zekry', N'30105120101332', N'01227901024', CAST(N'2001-05-12' AS Date), N'عين شمس', N'1', N'مصرى', N'30105120101332@sci.asu.edu.eg', N'ujJTh2rta8ItSm/1PYQGxq2GQZXtFEq1yHYhtsIztUi66uaVbfNG7IwX9eoQ817jy8UUeX7X3dMUVGTioLq0Ew==
', 4, 2.86, N'190552', 103, NULL, 8, 0, NULL, 1, 2, CAST(N'2022-11-27T00:00:00.000' AS DateTime), 0, 7)
SET IDENTITY_INSERT [dbo].[Student] OFF
GO
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID]) VALUES (8, 1, 108, N'C+', 2.67, 1, 1, 1, 1, 0, 10)
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID]) VALUES (8, 2, 45, N'A', 4, 1, 1, 1, 1, 0, 10)
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID]) VALUES (8, 3, NULL, N'P', 0, 1, 0, 1, 1, 0, 11)
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID]) VALUES (8, 4, NULL, N'P', 0, 1, 0, 1, 1, 0, 11)
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID]) VALUES (8, 5, NULL, N'P', 0, 1, 0, 1, 1, 0, 11)
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID]) VALUES (8, 6, 102, N'C', 2.33, 1, 1, 1, 1, 0, 13)
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID]) VALUES (8, 7, 133, N'A-', 3.67, 1, 1, 1, 1, 0, 14)
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID]) VALUES (8, 8, 68, N'C', 2.33, 1, 1, 1, 1, 0, 13)
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID]) VALUES (8, 9, 119, N'B', 3, 1, 1, 1, 1, 0, 14)
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID]) VALUES (8, 10, 149, N'A', 4, 1, 1, 1, 1, 0, 13)
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID]) VALUES (8, 11, 131, N'A-', 3.67, 1, 1, 1, 1, 0, 14)
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID]) VALUES (8, 12, 150, N'B', 3, 1, 1, 1, 1, 0, 13)
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID]) VALUES (8, 13, 141, N'A', 4, 1, 1, 1, 1, 0, 14)
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID]) VALUES (8, 14, 76, N'B', 3, 1, 1, 1, 1, 0, 14)
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID]) VALUES (8, 15, 144, N'A', 4, 1, 1, 1, 1, 0, 16)
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID]) VALUES (8, 16, 91, N'A', 4, 1, 1, 1, 1, 0, 17)
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID]) VALUES (8, 17, 71, N'C+', 2.67, 1, 1, 1, 1, 0, 16)
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID]) VALUES (8, 18, 92, N'D', 2, 1, 1, 1, 1, 0, 17)
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID]) VALUES (8, 19, 106, N'C+', 2.67, 1, 1, 1, 1, 0, 16)
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID]) VALUES (8, 20, 117, N'B', 3, 1, 1, 1, 1, 0, 17)
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID]) VALUES (8, 21, 119, N'B', 3, 1, 1, 1, 1, 0, 16)
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID]) VALUES (8, 22, 111, N'C+', 2.67, 1, 1, 1, 1, 0, 17)
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID]) VALUES (8, 23, 72, N'C+', 2.67, 1, 1, 1, 1, 0, 16)
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID]) VALUES (8, 24, 91, N'A', 4, 1, 1, 1, 1, 0, 17)
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID]) VALUES (8, 27, 97, N'A', 4, 1, 1, 1, 1, 0, 17)
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID]) VALUES (8, 31, 127, N'B+', 3.33, 1, 1, 1, 1, 0, 18)
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID]) VALUES (8, 46, NULL, N'P', 0, 1, 0, 1, 1, 0, 11)
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID]) VALUES (8, 47, 88, N'A-', 3.67, 1, 1, 1, 1, 0, 13)
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID]) VALUES (8, 48, 50, N'A', 4, 1, 1, 1, 1, 0, 17)
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID]) VALUES (8, 50, 35, N'P', 0, 1, 1, 1, 1, 0, 10)
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID]) VALUES (8, 51, NULL, N'P', 0, 1, 0, 1, 1, 0, 11)
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID]) VALUES (8, 52, 141, N'C+', 2.67, 1, 1, 1, 1, 0, 10)
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID]) VALUES (8, 53, NULL, N'P', 0, 1, 0, 1, 1, 0, 11)
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID]) VALUES (8, 54, NULL, N'P', 0, 1, 0, 1, 1, 0, 11)
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID]) VALUES (8, 56, 139, N'A', 4, 1, 1, 1, 1, 0, 14)
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID]) VALUES (8, 57, 95, N'D', 2, 1, 1, 1, 1, 0, 13)
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID]) VALUES (8, 72, 71, N'F', 0, 1, 1, 1, 1, 0, 16)
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID]) VALUES (8, 83, 149, N'C+', 2.67, 1, 1, 1, 1, 0, 10)
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID]) VALUES (8, 84, 45, N'A', 4, 1, 1, 1, 1, 0, 10)
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID]) VALUES (8, 85, 48, N'A', 4, 1, 1, 1, 1, 0, 16)
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID]) VALUES (8, 87, 122, N'B+', 3.33, 1, 1, 1, 1, 0, 10)
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID]) VALUES (5, 1, 119, N'B', 3, 1, 1, 1, 1, 0, 10)
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID]) VALUES (5, 2, 49, N'A', 4, 1, 1, 1, 1, 0, 10)
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID]) VALUES (5, 3, NULL, N'P', 0, 1, 0, 1, 1, 0, 11)
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID]) VALUES (5, 4, NULL, N'P', 0, 1, 0, 1, 1, 0, 11)
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID]) VALUES (5, 5, NULL, N'P', 0, 1, 0, 1, 1, 0, 11)
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID]) VALUES (5, 6, 103, N'C', 2.33, 1, 1, 1, 1, 0, 13)
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID]) VALUES (5, 7, 119, N'B', 3, 1, 1, 1, 1, 0, 14)
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID]) VALUES (5, 8, 68, N'C', 2.33, 1, 1, 1, 1, 0, 13)
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID]) VALUES (5, 9, 89, N'F', 0, 1, 1, 1, 2, 0, 14)
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID]) VALUES (5, 10, 138, N'A', 4, 1, 1, 1, 1, 0, 13)
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID]) VALUES (5, 11, 138, N'A', 4, 1, 1, 1, 1, 0, 14)
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID]) VALUES (5, 12, 152, N'B', 4, 1, 1, 1, 1, 0, 13)
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID]) VALUES (5, 13, 138, N'A', 4, 1, 1, 1, 1, 0, 14)
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID]) VALUES (5, 14, 80, N'B+', 3.33, 1, 1, 1, 1, 0, 14)
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID]) VALUES (5, 15, 119, N'B', 3, 1, 1, 1, 1, 0, 16)
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID]) VALUES (5, 16, 72, N'C+', 2.67, 1, 1, 1, 1, 0, 18)
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID]) VALUES (5, 17, 72, N'C+', 2.67, 1, 1, 1, 1, 0, 16)
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID]) VALUES (5, 18, 113, N'C+', 2.67, 1, 1, 1, 1, 0, 17)
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID]) VALUES (5, 19, 96, N'D', 2, 1, 1, 1, 1, 0, 16)
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID]) VALUES (5, 20, 113, N'C+', 2.67, 1, 1, 1, 1, 0, 17)
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID]) VALUES (5, 21, 119, N'B', 3, 1, 1, 1, 1, 0, 16)
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID]) VALUES (5, 22, 119, N'B', 3, 1, 1, 1, 1, 0, 17)
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID]) VALUES (5, 23, 68, N'C', 2.33, 1, 1, 1, 1, 0, 16)
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID]) VALUES (5, 24, 92, N'A', 4, 1, 1, 1, 1, 0, 17)
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID]) VALUES (5, 27, 92, N'A', 4, 1, 1, 1, 1, 0, 17)
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID]) VALUES (5, 46, NULL, N'P', 0, 1, 0, 1, 1, 0, 11)
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID]) VALUES (5, 48, 49, N'A-', 3.67, 1, 1, 1, 1, 0, 14)
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID]) VALUES (5, 50, NULL, N'P', 0, 1, 0, 1, 1, 0, 10)
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID]) VALUES (5, 51, NULL, N'P', 0, 1, 0, 1, 1, 0, 11)
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID]) VALUES (5, 52, 150, N'C+', 2.67, 1, 1, 1, 1, 0, 10)
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID]) VALUES (5, 53, NULL, N'P', 0, 1, 0, 1, 1, 0, 11)
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID]) VALUES (5, 54, NULL, N'P', 0, 1, 0, 1, 1, 0, 11)
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID]) VALUES (5, 56, 138, N'A', 4, 1, 1, 1, 1, 0, 14)
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID]) VALUES (5, 57, 90, N'D', 2, 1, 1, 1, 1, 0, 13)
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID]) VALUES (5, 72, 119, N'B', 3, 1, 1, 1, 1, 0, 16)
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID]) VALUES (5, 83, 150, N'C+', 2.67, 1, 1, 1, 1, 0, 10)
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID]) VALUES (5, 84, 37, N'B', 3, 1, 1, 1, 1, 0, 10)
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID]) VALUES (5, 85, 41, N'B+', 3.33, 1, 1, 1, 1, 0, 13)
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID]) VALUES (5, 87, 138, N'A', 4, 1, 1, 1, 1, 0, 10)
INSERT [dbo].[StudentCourses] ([StudentID], [CourseID], [Mark], [Grade], [points], [IsApproved], [IsGPAIncluded], [IsIncluded], [CourseEntringNumber], [AffectReEntringCourses], [AcademicYearID]) VALUES (5, 9, 119, N'B', 3, 1, 1, 1, 2, 0, 17)
GO
INSERT [dbo].[StudentPrograms] ([ProgramID], [StudentID], [AcademicYear]) VALUES (1, 5, 10)
INSERT [dbo].[StudentPrograms] ([ProgramID], [StudentID], [AcademicYear]) VALUES (2, 5, 11)
INSERT [dbo].[StudentPrograms] ([ProgramID], [StudentID], [AcademicYear]) VALUES (5, 5, 13)
INSERT [dbo].[StudentPrograms] ([ProgramID], [StudentID], [AcademicYear]) VALUES (1, 8, 10)
INSERT [dbo].[StudentPrograms] ([ProgramID], [StudentID], [AcademicYear]) VALUES (2, 8, 11)
INSERT [dbo].[StudentPrograms] ([ProgramID], [StudentID], [AcademicYear]) VALUES (5, 8, 13)
GO
SET IDENTITY_INSERT [dbo].[Supervisor] ON 

INSERT [dbo].[Supervisor] ([ID], [GUID], [FName], [MName], [LName], [Email], [Password], [IsActive], [CreatedOn], [ProgramID]) VALUES (2, N'A95A4304-E215-46A3-A3C9-3D01F90F0868', N'CS', N'Supervisor', N'1', N'cssuper@sci.asu.edu.eg', N'thjbjbujb', 1, CAST(N'2022-11-27T00:00:00.000' AS DateTime), 6)
SET IDENTITY_INSERT [dbo].[Supervisor] OFF
GO
ALTER TABLE [dbo].[Student] ADD  CONSTRAINT [DF_Student_Level]  DEFAULT ((1)) FOR [Level]
GO
ALTER TABLE [dbo].[Student] ADD  CONSTRAINT [DF_Student_SemestersNumberInProgram]  DEFAULT ((1)) FOR [SemestersNumberInProgram]
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
