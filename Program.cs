using Microsoft.EntityFrameworkCore;
using WeWakeAPI.Data;
using WeWakeAPI.Middlewares;
using System.Net;
using WeWakeAPI.DBServices;
using System.Net;
using WeWakeAPI.Utils;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.

builder.Services.AddControllers();
// Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();
builder.Services.AddHttpContextAccessor();
builder.Services.AddScoped<UserService>();
builder.Services.AddScoped<GroupService>();
builder.Services.AddScoped<AlarmService>();


builder.Services.AddDbContext<ApplicationDbContext>(
    options => options.UseSqlServer(builder.Configuration.GetConnectionString("Database")));
Console.WriteLine(builder.Configuration.GetConnectionString("Database"));



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
app.MapGet("/ping", () => "pong");

app.UseJWTMiddleware();
String internalIp = IpAddr.GetIp();
console.log(internalIp);
// app.Urls.Add($"http://{internalIp}:5022");
// app.Urls.Add("http://localhost:5022");
app.Urls.Add("http://0.0.0.0:5022");
app.Run();


