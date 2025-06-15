using eventsApp.Model;
using Microsoft.ML;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eventsApp.Services
{
    public interface IRecommenderSystemService
    {
        Task<List<DogadjajiListResponse>> Recommend(int userId);
        Task<ITransformer> CreateModel();
    }
}
