using eventsApp;
using eventsApp.Filters;
using eventsApp.Model.SearchObjects;
using eventsApp.Services;
using eventsApp.Services.Database;
using eventsApp.Services.DogadjajiStateMachine;
using Microsoft.AspNetCore.Authentication;
using Microsoft.EntityFrameworkCore;
using Microsoft.OpenApi.Models;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.

builder.Services.AddTransient<IDobavljaciService, DobavljaciServiceImpl>();
builder.Services.AddTransient<IKorisniciService, KorisniciServiceImpl>();
//builder.Services.AddTransient<IService<eventsApp.Model.Kategorije, BaseSearchObject>, BaseService<eventsApp.Model.Kategorije, eventsApp.Services.Database.Kategorije, BaseSearchObject>>();
builder.Services.AddTransient<IDogadjajiService, DogadjajiServiceImpl>();
builder.Services.AddTransient<IKategorijeService, KategorijeServiceImpl>();
builder.Services.AddTransient<IPodkategorijeService, PodkategorijeServiceImpl>();
builder.Services.AddTransient<IGalerijaService, GalerijaServiceImpl>();
builder.Services.AddTransient<IPracenjeService, PracenjeServiceImpl>();
builder.Services.AddTransient<GalerijaServiceImpl>();


builder.Services.AddTransient<BaseState>();
builder.Services.AddTransient<ActiveEventState>();
builder.Services.AddTransient<CancelledEventState>();
builder.Services.AddTransient<InitialEventState>();
builder.Services.AddTransient<OnHoldEventState>();
builder.Services.AddTransient<VerifiedEventState>();
builder.Services.AddTransient<HiddenEventState>();
builder.Services.AddTransient<DraftEventState>();

builder.Services.AddCors(options =>
{
    options.AddPolicy("AllowAnyOrigin", builder =>
    {
        builder.AllowAnyOrigin()
               .AllowAnyMethod()
               .AllowAnyHeader();
    });
});

builder.Services.AddControllers(x => { x.Filters.Add<ErrorFilter>(); });
// Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen( c =>
{
    c.AddSecurityDefinition("basicAuth", new Microsoft.OpenApi.Models.OpenApiSecurityScheme()
    {
        Type = Microsoft.OpenApi.Models.SecuritySchemeType.Http,
        Scheme = "basic"
    });

    c.AddSecurityRequirement(new Microsoft.OpenApi.Models.OpenApiSecurityRequirement()
    {
        {
            new OpenApiSecurityScheme
            {
                Reference = new OpenApiReference{Type = ReferenceType.SecurityScheme, Id = "basicAuth"}
            },
            new string[]{}
    } });

});


var connectionString = builder.Configuration.GetConnectionString("DefaultConnection");
builder.Services.AddDbContext<EventsDbContext>(options => options.UseSqlServer(connectionString));

builder.Services.AddAutoMapper(typeof(IKorisniciService));
builder.Services.AddAuthentication("BasicAuthentication")
    .AddScheme<AuthenticationSchemeOptions, BasicAuthenticationHandler>("BasicAuthentication", null);


var app = builder.Build();

// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseCors("AllowAnyOrigin");

//app.UseHttpsRedirection();
app.UseAuthentication();
app.UseAuthorization();

app.MapControllers();
/*using (var scope = app.Services.CreateScope())
{
    var dataContext = scope.ServiceProvider.GetRequiredService<EventsDbContext>();
    //dataContext.Database.EnsureCreated();
    dataContext.Database.Migrate();
}*/
app.Run();
