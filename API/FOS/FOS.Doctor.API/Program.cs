using FOS.App.ExtensionMethods;
using System.Text.Json.Serialization;
using NLog;
using NLog.Web;
using Microsoft.Extensions.Options;
using QuestPDF.Infrastructure;

var logger = LogManager.Setup().LoadConfigurationFromAppSettings().GetCurrentClassLogger();

var builder = WebApplication.CreateBuilder(args);

builder.Services.AddControllers().AddJsonOptions(opt => opt.JsonSerializerOptions.ReferenceHandler = ReferenceHandler.IgnoreCycles);
builder.Services.AddEndpointsApiExplorer();
//Services responsible for Versioning swageer
builder.Services.LoadSwaggerVersioningServices("v1", "Doctor's API", 1, 0);
builder.Configuration.LoadConfiguration();
builder.Services.LocalizationConfigure();
//Services responsible for using db connection
builder.LoadDBServices();
//Services responsible for loading dependency injection
builder.Services.LoadDoctorServices();
//Services responsible for Mapping from DB models to DTOs and vice versa
builder.Services.AddAutoMapper(AppDomain.CurrentDomain.GetAssemblies());
//Services responsible for allow calling API from any Platform
builder.Services.LoadCorsServices();
//Services responsible for authentication and authorization 
builder.LoadJwtServices();
//Services responsible for logging
builder.Logging.ClearProviders();
builder.Host.UseNLog();
QuestPDF.Settings.License = LicenseType.Community;
var app = builder.Build();

//if (app.Environment.IsDevelopment())
//{
app.UseSwagger();
app.UseSwaggerUI();
//}

app.UseRequestLocalization(app.Services.GetService<IOptions<RequestLocalizationOptions>>().Value);

app.UseCors();
app.UseStaticFiles();
app.UseHttpsRedirection();
app.UseAuthentication();
app.UseAuthorization();
app.MapControllers();

app.Run();