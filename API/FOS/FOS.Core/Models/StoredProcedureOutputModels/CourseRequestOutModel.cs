namespace FOS.Core.Models.StoredProcedureOutputModels
{
    public class CourseRequestOutModel
    {
        public string CourseCode { get; set; }
        public string CourseName { get; set; }
        public int CreditHours { get; set; }
        public string RequestID { get; set; }
        public int RequestTypeID { get; set; }
        public string RequestType { get; set; }
        public int CourseID { get; set; }
        public bool? IsApproved { get; set; }
        public bool CourseOperationID { get; set; }
        public string CourseOperation { get; set; }
    }
}
