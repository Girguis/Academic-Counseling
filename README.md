<h1 align="center" id="title">Academic Counseling</h1>

<p id="description">
Is a management system for credit-hour programs at the Faculty of Science at Ain Shams University.</p> 
<p>Currently, this system is in use by some doctors in my program.</p>
<p>It consists of two web API applications (for doctors and students).</p>

<p>
The main purpose of the system is to reduce the load on academic supervisors, ease course registration for students and ease student bifurcation over programs for both doctors and students.</p>

  
<h2>🛠️ Installation Steps:</h2>

<p>1. Download and install Microsoft SQL Server 2019.</p>

<p>2. Open Microsoft SQL Server and restore the database, which is located in the DB folder.</p>

```
https://github.com/Girguis/Academic-Counseling/tree/BackendBranch/DB
```

<p>3. Download and install Visual Studio 2022 with ASP.NET selected.</p>

<p>4. Open the project in VS 2022 (API/FOS/FOS.sln).</p>

<p>5. Open appsetting.json in FOS.Doctors.API and FOS.Student.API projects and modify the connection string with yours.</p>

  <h2>🧐 Features</h2>

Here are some of the project's features:

1. <h3>For Doctors Application</h3>
*   Available User Types
    - System Admin
    - Program Admin
    - Supervisor
    - Doctor
*   Management of students
     - Add or update old students via UMS (Ain Shams University Management System)'s academic report
     - Add new students via an Excel sheet and automatically assign courses to them depending on their program.
    - Generate reports like
       - Academic report in Excel or PDF
       - Academic summary
       - Struggled students (students who exceeded a certain number of warnings)
       - Students or graduates whose GPA is in a certain range (entered by a doctor)
*   Management of faculty programs
     - Modify the program's courses.
     - Acceptance criteria and basic information.
*   Management of courses
     - Add/update/delete
     - Activate or deactivate
     - Generate reports like
        - Students signatures commit PDF (for the available types of course exams: oral, practical, written, and final)
        - Excel grade sheets for available exam types and then upload it again to update students' grades.
*    Management of doctors, common questions, dates
*    Handle special requests sent by students, i.e.
     - Program trasnfer 
     - Course requests like
        - Adding/deleting/overloading
        - Open courses for graduation purposes
        - Withdraw/Excuse/Enhancment
*   Some statistics, like
    - number of students in each program
    - Overall students C-GPA
    - Students performance in a specific course over all semesters or in a certain semester
*    And some other features, like
     - Automatic student bifurcation
     - Starting a new academic semester.
     - Database backup and restore.
     - Confirm exam results.
     - Assign supervisors randomly among students.
     - Modify some settings, like the number of hours to register in the summer semester.
1. <h3>For students application</h3>
* Access information like
   - Student's current rank on the program
   - C-GPA & level
   - Current supervisor
   - Current registered courses with all information about courses and student grade details, if uploaded by the doctor
   - Common questions with their answers
   - Detailed academic history 
     - Semester and cumulative GPA for every semester
     - Grade details for every registered course
* Automatic course registration approval (only courses that the student is eligible to register for will be available to register for)
* Send special requests 
   - Program trasnfer 
    - Courses requests like
        - Adding/deleting/Overloading
        - Open courses for graduation purposes
        - Withdraw/Excuse/Enhancment



<h2>💻 Built with</h2>

Technologies used in the project:

*   .NET 6 Web API
    - Dapper
    - JWT
    - CLosedXML
    - QuestPDF
    - AutoMapper
    - NLog
    - Swagger
*   MS SQL
    - Stored Procedures
    - Functions
    - Triggers
    - Sequences
    - Types
