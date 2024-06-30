using eventsApp.Model.Requests;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

using System.Threading.Tasks;

namespace eventsApp.Services
{
    public interface IDobavljaciService:ICRUDService<Model.Dobavljaci, Model.Dobavljaci, Model.SearchObjects.DobavljaciSearchObject, DobavljaciInsertRequest, DobavljaciUpdateRequest>
    {
        Task<Model.Dobavljaci> ChangeStatus(int id, bool status);
    }
}
