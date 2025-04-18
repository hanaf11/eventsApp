using eventsApp.Model;
using eventsApp.Model.Requests;
using eventsApp.Model.SearchObjects;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eventsApp.Services
{
    public interface IPracenjeService
    {
        Task<bool> IsFollowing(PracenjeObject search);
        Task<bool> Follow(PracenjeObject insert);
        Task<bool> Unfollow(PracenjeObject request);
        public Task<List<Dictionary<string, object>>> GetMostSubscribedCategories();
    }
}

