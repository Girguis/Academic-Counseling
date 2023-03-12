using AutoMapper;
using FOS.DB.Models;
using FOS.Doctors.API.Models;

namespace FOS.Doctors.API.Mappers
{
    public static class DoctorMapper
    {
        public static Doctor ToDBDoctorModel(this DoctorAddModel supervisorModel,bool isNew)
        {
            var config = new MapperConfiguration(c =>
                            c.CreateMap<DoctorAddModel, Doctor>());
            var mapper = config.CreateMapper();
            var supervisor = mapper.Map<Doctor>(supervisorModel);
            if(isNew)
            {
                supervisor.CreatedOn = DateTime.UtcNow.AddHours(2);
                supervisor.Guid = Guid.NewGuid().ToString();
                supervisor.IsActive = true;
            }
            return supervisor;
        }
        public static Doctor DoctorUpdater(this Doctor toBeUpdated, DoctorUpdateModel fromModel)
        {
            toBeUpdated.Email = fromModel.Email;
            toBeUpdated.Name = fromModel.Name;
            toBeUpdated.ProgramId= fromModel.ProgramId;
            toBeUpdated.Type = fromModel.Type;
            return toBeUpdated;
        }
    }
}
