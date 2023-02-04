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
        public virtual DbSet<ElectiveCourseDistribution> ElectiveCourseDistributions { get; set; } = null!;
        public virtual DbSet<Program> Programs { get; set; } = null!;
        public virtual DbSet<ProgramCourse> ProgramCourses { get; set; } = null!;
        public virtual DbSet<ProgramDistribution> ProgramDistributions { get; set; } = null!;
        public virtual DbSet<ProgramRelation> ProgramRelations { get; set; } = null!;
        public virtual DbSet<Student> Students { get; set; } = null!;
        public virtual DbSet<StudentCourse> StudentCourses { get; set; } = null!;
        public virtual DbSet<StudentDesire> StudentDesires { get; set; } = null!;
        public virtual DbSet<StudentProgram> StudentPrograms { get; set; } = null!;
        public virtual DbSet<SuperAdmin> SuperAdmins { get; set; } = null!;
        public virtual DbSet<Supervisor> Supervisors { get; set; } = null!;
        public virtual DbSet<TeacherCourse> TeacherCourses { get; set; } = null!;

        protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
        {
            if (!optionsBuilder.IsConfigured)
            {
#warning To protect potentially sensitive information in your connection string, you should move it out of source code. You can avoid scaffolding the connection string by using the Name= syntax to read it from configuration - see https://go.microsoft.com/fwlink/?linkid=2131148. For more guidance on storing connection strings, see http://go.microsoft.com/fwlink/?LinkId=723263.
                optionsBuilder.UseSqlServer(configuration["FOS:DB"]);
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
            });

            modelBuilder.Entity<Date>(entity =>
            {
                entity.HasNoKey();

                entity.ToTable("Date");

                entity.Property(e => e.EndDate).HasColumnType("datetime");

                entity.Property(e => e.StartDate).HasColumnType("datetime");
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

                entity.Property(e => e.TotalHours).HasDefaultValueSql("((140))");
            });

            modelBuilder.Entity<ProgramCourse>(entity =>
            {
                entity.HasNoKey();

                entity.Property(e => e.CourseId).HasColumnName("CourseID");

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

            modelBuilder.Entity<ProgramRelation>(entity =>
            {
                entity.HasNoKey();

                entity.HasOne(d => d.ProgramNavigation)
                    .WithMany()
                    .HasForeignKey(d => d.Program)
                    .HasConstraintName("FK_ProgramRelations_Program");

                entity.HasOne(d => d.SubProgramNavigation)
                    .WithMany()
                    .HasForeignKey(d => d.SubProgram)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK_ProgramRelations_Program1");
            });

            modelBuilder.Entity<Student>(entity =>
            {
                entity.ToTable("Student");

                entity.Property(e => e.Id).HasColumnName("ID");

                entity.Property(e => e.AcademicCode)
                    .HasMaxLength(10)
                    .IsUnicode(false);

                entity.Property(e => e.BirthDate).HasColumnType("date");

                entity.Property(e => e.CalculatedRank).HasComputedColumnSql("([dbo].[RankStudent]([ID]))", false);

                entity.Property(e => e.Cgpa)
                    .HasColumnType("decimal(5, 4)")
                    .HasColumnName("CGPA")
                    .HasComputedColumnSql("([dbo].[CalculateCGPA]([ID]))", false);

                entity.Property(e => e.CreatedOn).HasColumnType("datetime");

                entity.Property(e => e.Email).IsUnicode(false);

                entity.Property(e => e.Fname).HasColumnName("FName");

                entity.Property(e => e.Gender)
                    .HasMaxLength(1)
                    .IsUnicode(false)
                    .IsFixedLength();

                entity.Property(e => e.Guid)
                    .IsUnicode(false)
                    .HasColumnName("GUID");

                entity.Property(e => e.IsActive)
                    .IsRequired()
                    .HasDefaultValueSql("((1))");

                entity.Property(e => e.Level).HasComputedColumnSql("([dbo].[CalculateStudentLevel]([ID]))", false);

                entity.Property(e => e.Lname).HasColumnName("LName");

                entity.Property(e => e.Mname).HasColumnName("MName");

                entity.Property(e => e.PassedHours).HasComputedColumnSql("([dbo].[CalculatePassedHours]([ID]))", false);

                entity.Property(e => e.Password).IsUnicode(false);

                entity.Property(e => e.PhoneNumber)
                    .HasMaxLength(12)
                    .IsUnicode(false);

                entity.Property(e => e.SeatNumber)
                    .HasMaxLength(10)
                    .IsUnicode(false);

                entity.Property(e => e.Ssn)
                    .HasMaxLength(15)
                    .IsUnicode(false)
                    .HasColumnName("SSN");

                entity.Property(e => e.SupervisorId).HasColumnName("SupervisorID");

                entity.Property(e => e.WarningsNumber).HasComputedColumnSql("([dbo].[GetNumberOfWarnings]([ID]))", false);

                entity.HasOne(d => d.Supervisor)
                    .WithMany(p => p.Students)
                    .HasForeignKey(d => d.SupervisorId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK_Student_Supervisor");
            });

            modelBuilder.Entity<StudentCourse>(entity =>
            {
                entity.HasNoKey();

                entity.Property(e => e.AcademicYearId).HasColumnName("AcademicYearID");

                entity.Property(e => e.CourseId).HasColumnName("CourseID");

                entity.Property(e => e.Grade).HasMaxLength(2);

                entity.Property(e => e.HasExecuse).HasDefaultValueSql("((0))");

                entity.Property(e => e.IsGpaincluded).HasColumnName("IsGPAIncluded");

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

            modelBuilder.Entity<StudentDesire>(entity =>
            {
                entity.HasNoKey();

                entity.Property(e => e.ProgramId).HasColumnName("ProgramID");

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

            modelBuilder.Entity<SuperAdmin>(entity =>
            {
                entity.ToTable("SuperAdmin");

                entity.Property(e => e.Id).HasColumnName("ID");

                entity.Property(e => e.Fname).HasColumnName("FName");

                entity.Property(e => e.Guid)
                    .IsUnicode(false)
                    .HasColumnName("GUID");

                entity.Property(e => e.Lname).HasColumnName("LName");

                entity.Property(e => e.Mname).HasColumnName("MName");
            });

            modelBuilder.Entity<Supervisor>(entity =>
            {
                entity.ToTable("Supervisor");

                entity.Property(e => e.Id).HasColumnName("ID");

                entity.Property(e => e.CreatedOn).HasColumnType("datetime");

                entity.Property(e => e.Fname).HasColumnName("FName");

                entity.Property(e => e.Guid)
                    .IsUnicode(false)
                    .HasColumnName("GUID");

                entity.Property(e => e.Lname).HasColumnName("LName");

                entity.Property(e => e.Mname).HasColumnName("MName");

                entity.Property(e => e.ProgramId).HasColumnName("ProgramID");

                entity.HasOne(d => d.Program)
                    .WithMany(p => p.Supervisors)
                    .HasForeignKey(d => d.ProgramId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("FK_Supervisor_Program");
            });

            modelBuilder.Entity<TeacherCourse>(entity =>
            {
                entity.HasNoKey();

                entity.Property(e => e.AcademicYearId).HasColumnName("AcademicYearID");

                entity.Property(e => e.CourseId).HasColumnName("CourseID");

                entity.Property(e => e.SupervisorId).HasColumnName("SupervisorID");

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

                entity.HasOne(d => d.Supervisor)
                    .WithMany()
                    .HasForeignKey(d => d.SupervisorId)
                    .HasConstraintName("FK_TeacherCourses_Supervisor");
            });

            OnModelCreatingPartial(modelBuilder);
        }

        partial void OnModelCreatingPartial(ModelBuilder modelBuilder);
    }
}
