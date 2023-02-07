using AutoMapper;
using FOS.DB.Models;
using FOS.Doctor.API.Models;

namespace FOS.Doctor.API.Mappers
{
    public static class SupervisorMapper
    {
        public static Supervisor ToDBSupervisorModel(this SupervisorModel supervisorModel,bool isNew)
        {
            var config = new MapperConfiguration(c =>
                            c.CreateMap<SupervisorModel, Supervisor>());
            var mapper = config.CreateMapper();
            var supervisor = mapper.Map<Supervisor>(supervisorModel);
            if(isNew)
            {
                supervisor.CreatedOn = DateTime.UtcNow.AddHours(2);
                supervisor.Guid = Guid.NewGuid().ToString();
                supervisor.IsActive = true;
            }
            return supervisor;
        }
        public static Supervisor SupervisorUpdater(this Supervisor toBeUpdated, SupervisorModel fromModel)
        {
            toBeUpdated.Email = fromModel.Email;
            toBeUpdated.Name = fromModel.Name;
            toBeUpdated.Password = fromModel.Password;
            toBeUpdated.ProgramId= fromModel.ProgramId;
            return toBeUpdated;
        }
    }
}
