using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eventsApp.Model.Messages
{
    public class NotifySubscribers
    {
        public Dogadjaji Dogadjaj;

        public string SubscriberEmail;


        public NotifySubscribers(Dogadjaji dogadjaj, string subscribersEmail)
        {
            this.Dogadjaj = dogadjaj;
            this.SubscriberEmail = subscribersEmail;
        }
    }
}
