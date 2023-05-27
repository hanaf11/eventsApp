using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using eventsApp.Model;
using eventsApp.Model.SearchObjects;

namespace eventsApp.Services
{
    public interface IDogadjajiService:ICRUDService<Model.Dogadjaji,DogadjajiSearchObject,Model.Requests.DogadjajiInsertRequest, Model.Requests.DogadjajiUpdateRequest>
    {
        Task<Dogadjaji> Activate(int id);

        Task<Dogadjaji> Cancel(int id);

        Task<List<string>> AllowedActions(int id);
    }
}
