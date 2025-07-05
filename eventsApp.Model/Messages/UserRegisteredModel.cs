using System;

namespace eventsApp.Model.Messages
{
    public class UserRegisteredModel
    {
        public string Email { get; set; }
        public string Ime { get; set; }

        public UserRegisteredModel(string email, string ime)
        {
            Email = email;
            Ime = ime;
        }
    }
}
