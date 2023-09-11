using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using eventsApp.Model;
using eventsApp.Model.SearchObjects;

namespace eventsApp.Services
{
    public interface IKategorijeService : ICRUDService<Model.Kategorije, Model.Kategorije, KategorijeSearchObject, Model.Requests.KategorijeInsertRequest, Model.Requests.KategorijeUpdateRequest>
    {

    }
}

