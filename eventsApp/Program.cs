using eventsApp.Model.SearchObjects;
using eventsApp.Services;
using eventsApp.Services.Database;
using Microsoft.EntityFrameworkCore;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.

builder.Services.AddTransient<IDobavljaciService, DobavljaciServiceImpl>();
builder.Services.AddTransient<IKorisniciService, KorisniciServiceImpl>();
builder.Services.AddTransient<IDobavljaciService, DobavljaciServiceImpl>();
builder.Services.AddTransient<IService<eventsApp.Model.Kategorije, BaseSearchObject>, BaseService<eventsApp.Model.Kategorije, eventsApp.Services.Database.Kategorije, BaseSearchObject>>();
builder.Services.AddTransient<IDogadjajiService, DogadjajiServiceImpl>();

builder.Services.AddControllers();
// Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

var connectionString = builder.Configuration.GetConnectionString("DefaultConnection");
builder.Services.AddDbContext<EventsDbContext>(options => options.UseSqlServer(connectionString));

builder.Services.AddAutoMapper(typeof(IKorisniciService));


var app = builder.Build();

// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseHttpsRedirection();

app.UseAuthorization();

app.MapControllers();

app.Run();
