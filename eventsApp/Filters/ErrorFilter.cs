using eventsApp.Model;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Filters;
using System.Net;

namespace eventsApp.Filters
{
    public class ErrorFilter:ExceptionFilterAttribute
    {
        public override void OnException(ExceptionContext context)
        {
            if(context.Exception is UserException)
            {
                context.ModelState.AddModelError("userError", context.Exception.Message);
                context.HttpContext.Response.StatusCode = (int)HttpStatusCode.BadRequest;
            }
            else
            {
                //TBD: sakriti trace
                // context.ModelState.AddModelError("ERROR", "Server side error");
                context.ModelState.AddModelError("ERROR", context.Exception.Message);
                context.ModelState.AddModelError("ERROR", context.Exception.StackTrace);
                context.HttpContext.Response.StatusCode = (int)HttpStatusCode.InternalServerError;
            }
            
            var list = context.ModelState.Where(x => x.Value.Errors.Count > 0)
                .ToDictionary(x => x.Key, y => y.Value.Errors.Select(z => z.ErrorMessage));

            context.Result = new JsonResult(new { errors = list });
        }
    }
}
