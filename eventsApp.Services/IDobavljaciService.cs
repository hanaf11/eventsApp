using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eventsApp.Services
{
    public interface IDobavljaciService
    {
        IList<Dobavljaci> Get();
        Dobavljaci GetById(int id);
    }
}
