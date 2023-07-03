using Microsoft.EntityFrameworkCore;
using WeWakeAPI.Data;
using WeWakeAPI.Middlewares;
using WeWakeAPI.DBServices;
using WeWakeAPI.Utils;
using WeWakeAPI.WebSockets;

var builder = WebApplication.CreateBuilder(args);


// Add services to the container.

builder.Services.AddControllers();
// Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();
builder.Services.AddSignalR();

builder.Services.AddHttpContextAccessor();
builder.Services.AddScoped<UserService>();
builder.Services.AddScoped<GroupService>();
builder.Services.AddScoped<AlarmService>();
builder.Services.AddScoped<ChatService>();

string internalIp = IpAddr.GetIp();

builder.Services.AddDbContext<ApplicationDbContext>(
    options => options.UseSqlServer(builder.Configuration.GetConnectionString("Database")));
Console.WriteLine(builder.Configuration.GetConnectionString("Database"));

//builder.Services.AddCors(options =>
//{
//    options.AddPolicy(name: "Origins", policy =>
//    {
//        policy.WithOrigins("http://localhost:52732", $"http://{internalIp}:52732");
//    });
//});

var app = builder.Build();

// Configure the HTTP request pipeline.
// if (app.Environment.IsDevelopment())
// {
app.UseSwagger();
app.UseSwaggerUI();
// }

app.UseHttpsRedirection();
app.UseRouting();

app.UseCors(policy =>
{
    policy.AllowAnyOrigin();
    policy.AllowAnyHeader();
    policy.AllowAnyMethod();
});

app.UseAuthorization();

app.MapControllers();

app.UseWebSockets();
app.UseWebSocketMiddleware("/ws");


app.UseJWTMiddleware();
app.MapGet("/ping", () => "pong");
console.log(internalIp);
app.Urls.Add($"http://{internalIp}:5022");
app.Urls.Add("http://localhost:5022");
//app.Urls.Add("http://0.0.0.0:80");
app.Run();
