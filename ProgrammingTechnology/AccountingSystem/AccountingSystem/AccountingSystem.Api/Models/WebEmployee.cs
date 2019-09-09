using AccountingSystem.Api.Models.Requests;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Threading.Tasks;

namespace AccountingSystem.Api.Models
{
    /// <summary>
    /// Includes info about employee
    /// </summary>
    public class WebEmployee
    {
        /// <summary>
        /// Employee identifier
        /// </summary>
        public int Id { get; set; }

        /// <summary>
        /// Employee first name
        /// </summary>
        public string FirstName { get; set; }

        /// <summary>
        /// Employee second name
        /// </summary>
        public string SecondName { get; set; }

        /// <summary>
        /// Employee address
        /// </summary>
        public string Address { get; set; }

        /// <summary>
        /// Information about employee tariff rate or salary type
        /// </summary>
        public WebSalaryInfo SalaryInfo { get; set; }

        /// <summary>
        /// Information about employee department
        /// </summary>
        public WebDepartment Department { get; set; }

    }
}
