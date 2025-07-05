using System;

namespace eventsApp.Model.Messages
{
    public class NotifySubscribers
    {
        public Dogadjaji Dogadjaj { get; set; }

        public string SubscriberEmail { get; set; }

        public NotifySubscribers(Dogadjaji dogadjaj, string subscribersEmail)
        {
            Dogadjaj = dogadjaj;
            SubscriberEmail = subscribersEmail;
        }
    }
}
