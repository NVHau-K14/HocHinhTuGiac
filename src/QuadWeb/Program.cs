using QuadWeb.Middleware;
using QuadWeb.Models;
using QuadWeb.Repositories;
using QuadWeb.Services;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.
builder.Services.AddControllersWithViews();

// Configure Neo4j settings and services
builder.Services.Configure<Neo4jSettings>(builder.Configuration.GetSection("Neo4j"));
builder.Services.AddSingleton<INeo4jDriverService, Neo4jDriverService>();

// Repositories & Services
builder.Services.AddScoped<IShapeRepository, ShapeRepository>();
builder.Services.AddScoped<IShapeService, ShapeService>();
builder.Services.AddScoped<ILearnerRepository, LearnerRepository>();
builder.Services.AddScoped<ILearnerService, LearnerService>();

var app = builder.Build();

// Global Neo4j error handling middleware
app.UseMiddleware<Neo4jExceptionMiddleware>();

// Configure the HTTP request pipeline.
if (!app.Environment.IsDevelopment())
{
    app.UseExceptionHandler("/Home/Error");
    app.UseHsts();
}

app.UseHttpsRedirection();
app.UseStaticFiles();
app.UseRouting();

// Learner cookie identification middleware
app.UseMiddleware<LearnerMiddleware>();

app.UseAuthorization();

app.MapControllerRoute(
    name: "default",
    pattern: "{controller=Home}/{action=Index}/{id?}");

app.Run();
