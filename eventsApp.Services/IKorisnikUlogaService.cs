using eventsApp.Model.SearchObjects;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eventsApp.Services
{
    public interface IKorisnikUlogaService : ICRUDService<Model.KorisniciUloge, Model.KorisniciUloge, BaseSearchObject, Model.KorisniciUloge, Model.KorisniciUloge>
    {
    }
}
