using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eventsApp.Model.Requests
{
    public class PaymentIntentRequest
    {
        [Required]
        public long Amount { get; set; }
        [Required]
        public string Currency { get; set; } = null!;

    }
}
