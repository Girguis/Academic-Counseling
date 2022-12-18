using FOS.App.ExtensionMethods;
using System.Text.Json.Serialization;

var builder = WebApplication.CreateBuilder(args);

builder.Services.AddControllers().AddJsonOptions(opt => opt.JsonSerializerOptions.ReferenceHandler = ReferenceHandler.IgnoreCycles);
builder.Services.AddEndpointsApiExplorer();
//Services responsible for Versioning swageer
builder.Services.LoadSwaggerVersioningServices("v1", "Student API", 1, 0);
//Services responsible for using db connection
builder.LoadDBServices();
//Services responsible for loading dependency injection
builder.Services.LoadStudentServices();
//Services responsible for Mapping from DB models to DTOs and vice versa
builder.Services.AddAutoMapper(AppDomain.CurrentDomain.GetAssemblies());
//Services responsible for allow calling API from any Platform
builder.Services.LoadCorsServices();
//Services responsible for authentication and authorization 
builder.LoadJwtServices();

var app = builder.Build();

//if (app.Environment.IsDevelopment())
//{
app.UseSwagger();
app.UseSwaggerUI();
//}
app.UseCors();
app.UseHttpsRedirection();
app.UseAuthentication();
app.UseAuthorization();
app.MapControllers();

app.Run();