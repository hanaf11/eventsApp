using eventsApp.Model.Messages;
using System;

namespace MailingService
{
	public interface IEmailService
	{
		Task SendEventInFollowingCategoryEmail(NotifySubscribers notification);
	}
}

