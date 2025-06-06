using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace eventsApp.Services.Database
{
    public class TrainedModel
    {
        public int TrainedModelId { get; set; }
        public byte[] ModelData { get; set; } = null!;
        public DateTime Created { get; set; }
    }
}
