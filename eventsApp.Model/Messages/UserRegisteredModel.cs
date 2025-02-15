using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eventsApp.Model.Messages
{
    public class UserRegisteredModel
    {
        public string Email;
        public string Ime;

        public UserRegisteredModel(string email, string ime)
        {
            this.Email = email;
            this.Ime = ime;
        }
    }
}
