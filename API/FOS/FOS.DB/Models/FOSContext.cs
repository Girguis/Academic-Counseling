using System;
using System.Collections.Generic;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata;
using Microsoft.Extensions.Configuration;

namespace FOS.DB.Models
{
    public partial class FOSContext : DbContext
    {
        private readonly IConfiguration configuration;

        public FOSContext()
        {
        }

        public FOSContext(DbContextOptions<FOSContext> options,IConfiguration configuration)
            : base(options)
        {
            this.configuration = configuration;
        }

        public virtual DbSet<AcademicYear> AcademicYears { get; set; } = null!;
        public virtual DbSet<CommonQuestion> CommonQuestions { get; set; } = null!;
        public virtual DbSet<Course> Courses { get; set; } = null!;
        public virtual DbSet<CoursePrerequisite> CoursePrerequisites { get; set; } = null!;
        public virtual DbSet<Date> Dates { get; set; } = null!;
        public virtual DbSet<Doctor> Doctors { get; set; } = null!;
        public virtual DbSet<ElectiveCourseDistribution> ElectiveCourseDistributions { get; set; } = null!;
        public virtual DbSet<Program> Programs { get; set; } = null!;
        public virtual DbSet<ProgramCourse> ProgramCourses { get; set; } = null!;
        public virtual DbSet<ProgramDistribution> ProgramDistributions { get; set; } = null!;
        public virtual DbSet<Student> Students { get; set; } = null!;
        public virtual DbSet<StudentCourse> StudentCourses { get; set; } = null!;
        public virtual DbSet<StudentCourseRequest> StudentCourseRequests { get; set; } = null!;
        public virtual DbSet<StudentDesire> StudentDesires { get; set; } = null!;
        public virtual DbSet<StudentProgram> StudentPrograms { get; set; } = null!;
        public virtual DbSet<StudentProgramTransferRequest> StudentProgramTransferRequests { get; set; } = null!;
        public virtual DbSet<SuperAdmin> SuperAdmins { get; set; } = null!;
        public virtual DbSet<TeacherCourse> TeacherCourses { get; set; } = null!;

        protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
        {
            if (!optionsBuilder.IsConfigured)
            {
                optionsBuilder.UseSqlServer(configuration["ConnectionStrings:FosDB"]);
            }
        }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<AcademicYear>(entity =>
            {
                entity.ToTable("AcademicYear");

                entity.Property(e => e.Id).HasColumnName("ID");

                entity.Property(e => e.AcademicYear1).HasColumnName("AcademicYear");
            });

            modelBuilder.Entity<CommonQuestion>(entity =>
            {
                entity.ToTable("CommonQuestion");

                entity.Property(e => e.Id).HasColumnName("ID");
            });

            modelBuilder.Entity<Course>(entity =>
            {
                entity.ToTable("Course");

                entity.Property(e => e.Id).HasColumnName("ID");
            });

            modelBuilder.Entity<CoursePrerequisite>(entity =>
            {
                entity.HasNoKey();

                entity.Property(e => e.CourseId).HasColumnName("CourseID");

                entity.Property(e => e.PrerequisiteCourseId).HasColumnName("PrerequisiteCourseID");

                entity.Property(e => e.ProgramId).HasColumnName("ProgramID");

                entity.HasOne(d => d.Course)
                    .WithMany()
                    .HasForeignKey(d => d.CourseId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK_CoursePrerequisites_Course");

                entity.HasOne(d => d.PrerequisiteCourse)
                    .WithMany()
                    .HasForeignKey(d => d.PrerequisiteCourseId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK_CoursePrerequisites_Course1");

                entity.HasOne(d => d.Program)
                    .WithMany()
                    .HasForeignKey(d => d.ProgramId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK_CoursePrerequisites_Program");
            });

            modelBuilder.Entity<Date>(entity =>
            {
                entity.HasNoKey();

                entity.ToTable("Date");

                entity.Property(e => e.EndDate).HasColumnType("smalldatetime");

                entity.Property(e => e.StartDate).HasColumnType("smalldatetime");
            });

            modelBuilder.Entity<Doctor>(entity =>
            {
                entity.ToTable("Doctor");

                entity.Property(e => e.Id).HasColumnName("ID");

                entity.Property(e => e.CreatedOn).HasColumnType("smalldatetime");

                entity.Property(e => e.Guid)
                    .IsUnicode(false)
                    .HasColumnName("GUID");

                entity.Property(e => e.ProgramId).HasColumnName("ProgramID");

                entity.Property(e => e.Type).HasDefaultValueSql("((1))");

                entity.HasOne(d => d.Program)
                    .WithMany(p => p.Doctors)
                    .HasForeignKey(d => d.ProgramId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK_Supervisor_Program");
            });

            modelBuilder.Entity<ElectiveCourseDistribution>(entity =>
            {
                entity.HasNoKey();

                entity.ToTable("ElectiveCourseDistribution");

                entity.Property(e => e.ProgramId).HasColumnName("ProgramID");

                entity.HasOne(d => d.Program)
                    .WithMany()
                    .HasForeignKey(d => d.ProgramId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK_OptionalCourse_Program");
            });

            modelBuilder.Entity<Program>(entity =>
            {
                entity.ToTable("Program");

                entity.Property(e => e.Id).HasColumnName("ID");

                entity.Property(e => e.SuperProgramId).HasColumnName("SuperProgramID");

                entity.Property(e => e.TotalHours).HasDefaultValueSql("((140))");

                entity.HasOne(d => d.SuperProgram)
                    .WithMany(p => p.InverseSuperProgram)
                    .HasForeignKey(d => d.SuperProgramId)
                    .HasConstraintName("FK_Program_Program");
            });

            modelBuilder.Entity<ProgramCourse>(entity =>
            {
                entity.HasNoKey();

                entity.Property(e => e.Category).HasDefaultValueSql("((1))");

                entity.Property(e => e.CourseId).HasColumnName("CourseID");

                entity.Property(e => e.PrerequisiteRelationId).HasColumnName("PrerequisiteRelationID");

                entity.Property(e => e.ProgramId).HasColumnName("ProgramID");

                entity.HasOne(d => d.Course)
                    .WithMany()
                    .HasForeignKey(d => d.CourseId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK_ProgramCourses_Course");

                entity.HasOne(d => d.Program)
                    .WithMany()
                    .HasForeignKey(d => d.ProgramId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK_ProgramCourses_Program");
            });

            modelBuilder.Entity<ProgramDistribution>(entity =>
            {
                entity.HasNoKey();

                entity.ToTable("ProgramDistribution");

                entity.Property(e => e.ProgramId).HasColumnName("ProgramID");

                entity.HasOne(d => d.Program)
                    .WithMany()
                    .HasForeignKey(d => d.ProgramId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK_ProgramDistribution_Program");
            });

            modelBuilder.Entity<Student>(entity =>
            {
                entity.ToTable("Student");

                entity.HasIndex(e => e.Guid, "K_GUID")
                    .IsUnique();

                entity.Property(e => e.Id).HasColumnName("ID");

                entity.Property(e => e.AcademicCode)
                    .HasMaxLength(10)
                    .IsUnicode(false);

                entity.Property(e => e.AvailableCredits).HasDefaultValueSql("((12))");

                entity.Property(e => e.AvailableEnhancementCredits).HasDefaultValueSql("((8))");

                entity.Property(e => e.AvailableWithdraws).HasDefaultValueSql("((8))");

                entity.Property(e => e.BirthDate).HasColumnType("date");

                entity.Property(e => e.CalculatedRank).HasComputedColumnSql("([dbo].[RankStudent]([ID]))", false);

                entity.Property(e => e.Cgpa)
                    .HasColumnType("decimal(5, 4)")
                    .HasColumnName("CGPA")
                    .HasComputedColumnSql("([dbo].[CalculateCGPA]([ID]))", false);

                entity.Property(e => e.CreatedOn).HasColumnType("smalldatetime");

                entity.Property(e => e.CurrentProgramId).HasColumnName("CurrentProgramID");

                entity.Property(e => e.Gender)
                    .HasMaxLength(1)
                    .IsUnicode(false)
                    .HasDefaultValueSql("((1))")
                    .IsFixedLength();

                entity.Property(e => e.Guid)
                    .HasMaxLength(60)
                    .IsUnicode(false)
                    .HasColumnName("GUID");

                entity.Property(e => e.IsActive)
                    .IsRequired()
                    .HasDefaultValueSql("((1))");

                entity.Property(e => e.IsGraduated).HasComputedColumnSql("([dbo].[IsGraduatedStudent]([ID]))", false);

                entity.Property(e => e.IsInSpecialProgram).HasComputedColumnSql("([dbo].[IsStudentInSpecialProgram]([ID]))", false);

                entity.Property(e => e.Level).HasComputedColumnSql("([dbo].[CalculateStudentLevel]([ID]))", false);

                entity.Property(e => e.PassedHours).HasComputedColumnSql("([dbo].[CalculatePassedHours]([ID]))", false);

                entity.Property(e => e.PhoneNumber)
                    .HasMaxLength(12)
                    .IsUnicode(false);

                entity.Property(e => e.SeatNumber)
                    .HasMaxLength(10)
                    .IsUnicode(false);

                entity.Property(e => e.Ssn)
                    .HasMaxLength(20)
                    .IsUnicode(false)
                    .HasColumnName("SSN");

                entity.Property(e => e.SupervisorId).HasColumnName("SupervisorID");

                entity.Property(e => e.WarningsNumber).HasComputedColumnSql("([dbo].[GetNumberOfWarnings]([ID]))", false);

                entity.HasOne(d => d.CurrentProgram)
                    .WithMany(p => p.Students)
                    .HasForeignKey(d => d.CurrentProgramId)
                    .HasConstraintName("FK_Student_Program");

                entity.HasOne(d => d.Supervisor)
                    .WithMany(p => p.Students)
                    .HasForeignKey(d => d.SupervisorId)
                    .HasConstraintName("FK_Student_Doctor");
            });

            modelBuilder.Entity<StudentCourse>(entity =>
            {
                entity.HasNoKey();

                entity.Property(e => e.AcademicYearId).HasColumnName("AcademicYearID");

                entity.Property(e => e.CourseId).HasColumnName("CourseID");

                entity.Property(e => e.Grade).HasMaxLength(2);

                entity.Property(e => e.IsApproved)
                    .IsRequired()
                    .HasDefaultValueSql("((1))");

                entity.Property(e => e.IsEnhancementCourse).HasDefaultValueSql("((0))");

                entity.Property(e => e.IsGpaincluded).HasColumnName("IsGPAIncluded");

                entity.Property(e => e.IsIncluded)
                    .IsRequired()
                    .HasDefaultValueSql("((1))");

                entity.Property(e => e.Points).HasColumnName("points");

                entity.Property(e => e.StudentId).HasColumnName("StudentID");

                entity.Property(e => e.TookFromCredits).HasDefaultValueSql("((0))");

                entity.HasOne(d => d.AcademicYear)
                    .WithMany()
                    .HasForeignKey(d => d.AcademicYearId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK_StudentCourses_AcademicYear");

                entity.HasOne(d => d.Course)
                    .WithMany()
                    .HasForeignKey(d => d.CourseId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK_StudentCourses_Course");

                entity.HasOne(d => d.Student)
                    .WithMany()
                    .HasForeignKey(d => d.StudentId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK_StudentCourses_Student");
            });

            modelBuilder.Entity<StudentCourseRequest>(entity =>
            {
                entity.HasNoKey();

                entity.ToTable("StudentCourseRequest");

                entity.Property(e => e.CourseId).HasColumnName("CourseID");

                entity.Property(e => e.CourseOperationId).HasColumnName("CourseOperationID");

                entity.Property(e => e.RequestId).HasColumnName("RequestID");

                entity.Property(e => e.RequestTypeId).HasColumnName("RequestTypeID");

                entity.Property(e => e.StudentId).HasColumnName("StudentID");

                entity.HasOne(d => d.Course)
                    .WithMany()
                    .HasForeignKey(d => d.CourseId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK_StudentCourseRequest_Course");

                entity.HasOne(d => d.Student)
                    .WithMany()
                    .HasForeignKey(d => d.StudentId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK_StudentCourseRequest_Student");
            });

            modelBuilder.Entity<StudentDesire>(entity =>
            {
                entity.HasNoKey();

                entity.Property(e => e.ProgramId).HasColumnName("ProgramID");

                entity.Property(e => e.StudentCurrentProgramId).HasColumnName("StudentCurrentProgramID");

                entity.Property(e => e.StudentId).HasColumnName("StudentID");

                entity.HasOne(d => d.Program)
                    .WithMany()
                    .HasForeignKey(d => d.ProgramId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK_StudentDesires_Program");

                entity.HasOne(d => d.Student)
                    .WithMany()
                    .HasForeignKey(d => d.StudentId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK_StudentDesires_Student");
            });

            modelBuilder.Entity<StudentProgram>(entity =>
            {
                entity.HasNoKey();

                entity.Property(e => e.ProgramId).HasColumnName("ProgramID");

                entity.Property(e => e.StudentId).HasColumnName("StudentID");

                entity.HasOne(d => d.AcademicYearNavigation)
                    .WithMany()
                    .HasForeignKey(d => d.AcademicYear)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK_StudentPrograms_AcademicYear");

                entity.HasOne(d => d.Program)
                    .WithMany()
                    .HasForeignKey(d => d.ProgramId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK_StudentPrograms_Program");

                entity.HasOne(d => d.Student)
                    .WithMany()
                    .HasForeignKey(d => d.StudentId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK_StudentPrograms_Student");
            });

            modelBuilder.Entity<StudentProgramTransferRequest>(entity =>
            {
                entity.HasNoKey();

                entity.ToTable("StudentProgramTransferRequest");

                entity.Property(e => e.StudentId).HasColumnName("StudentID");

                entity.Property(e => e.ToProgramId).HasColumnName("ToProgramID");

                entity.HasOne(d => d.Student)
                    .WithMany()
                    .HasForeignKey(d => d.StudentId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK_StudentProgramTransferRequest_Student");

                entity.HasOne(d => d.ToProgram)
                    .WithMany()
                    .HasForeignKey(d => d.ToProgramId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK_StudentProgramTransferRequest_Program");
            });

            modelBuilder.Entity<SuperAdmin>(entity =>
            {
                entity.ToTable("SuperAdmin");

                entity.Property(e => e.Id).HasColumnName("ID");

                entity.Property(e => e.Guid)
                    .IsUnicode(false)
                    .HasColumnName("GUID");
            });

            modelBuilder.Entity<TeacherCourse>(entity =>
            {
                entity.HasNoKey();

                entity.Property(e => e.AcademicYearId).HasColumnName("AcademicYearID");

                entity.Property(e => e.CourseId).HasColumnName("CourseID");

                entity.Property(e => e.DoctorId).HasColumnName("DoctorID");

                entity.HasOne(d => d.AcademicYear)
                    .WithMany()
                    .HasForeignKey(d => d.AcademicYearId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK_TeacherCourses_AcademicYear");

                entity.HasOne(d => d.Course)
                    .WithMany()
                    .HasForeignKey(d => d.CourseId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK_TeacherCourses_Course");

                entity.HasOne(d => d.Doctor)
                    .WithMany()
                    .HasForeignKey(d => d.DoctorId)
                    .HasConstraintName("FK_TeacherCourses_Supervisor");
            });

            OnModelCreatingPartial(modelBuilder);
        }

        partial void OnModelCreatingPartial(ModelBuilder modelBuilder);
    }
}
