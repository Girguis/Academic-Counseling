using System.ComponentModel.DataAnnotations;

namespace FOS.Core.SearchModels
{
    /// <summary>
    /// Model used in searching to specify page number and size
    /// </summary>
    public class Pageable
    {
        public int PageNumber { get; set; } = 1;
        public int PageSize { get; set; } = 20;
    }
}
