using eventsApp.Model.SearchObjects;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eventsApp.Services
{
    public interface IUlogaService:IService<Model.Uloge, Model.Uloge, UlogaSearchObject>
    {
    }
}
