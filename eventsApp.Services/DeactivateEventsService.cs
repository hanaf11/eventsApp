using eventsApp.Services.Database;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eventsApp.Services
{
    public class DeactivateEventsService
    {
        ILogger<DeactivateEventsService> _logger;

        private readonly IServiceProvider _serviceProvider;

        protected Timer _timer;

        protected EventsDbContext _context;

        public DeactivateEventsService(ILogger<DeactivateEventsService> logger, IServiceProvider serviceProvider)
        {
            _logger = logger;
            _serviceProvider = serviceProvider;
            _logger.LogInformation("DeactivateEventsService instantiated.");
            HideEventsFirstTime();
            ScheduleDailyTask();
            
        }

        private void ScheduleDailyTask()
        {
            var now = DateTime.Now;
            var targetTime = DateTime.Today.AddDays(1);
            var initialDelay = (targetTime - now).TotalMilliseconds;

            /*var targetTime = DateTime.Today.AddHours(22).AddMinutes(14);
            if (now > targetTime)
            {
                targetTime = targetTime.AddDays(1);
            }
            var initialDelay = (targetTime - now).TotalMilliseconds;*/

            _timer = new Timer(async state =>
            {
                try
                {
                    await HideActiveEvents();
                }
                catch (Exception ex)
                {
                    _logger.LogError($"Error hiding active events: {ex.Message}", ex);
                }
            }, null, (long)initialDelay, TimeSpan.FromDays(1).Milliseconds);
        }

        private async void HideEventsFirstTime()
        {
            try
            {
                await HideActiveEvents();
            }
            catch (Exception ex)
            {
                _logger.LogError($"Error during initial hiding of active events: {ex.Message}", ex);
            }
        }

        public async Task HideActiveEvents()
        {
            _logger.LogInformation("Hiding all active and passed events...");

            using var scope = _serviceProvider.CreateScope();
            var dbContext = scope.ServiceProvider.GetRequiredService<EventsDbContext>();

            var set = dbContext.Set<Database.Dogadjaji>();

            var prosliDogadjaji = set.Where(d => d.Status == "ACTIVE" && d.DatumDo < DateTime.Now).ToList();

            foreach (var d in prosliDogadjaji)
            {
                d.Status = "HIDDEN";
            }

            await dbContext.SaveChangesAsync();

            _logger.LogInformation($"Number of deactivated events: {prosliDogadjaji.Count}");
        }
    }
}
