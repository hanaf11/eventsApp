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
    public interface ISavingService
    {
        Task<bool> IsSaved(SavingObject search);
        Task<bool> Save(SavingObject insert);
        Task<bool> Delete(SavingObject request);
    }
}

