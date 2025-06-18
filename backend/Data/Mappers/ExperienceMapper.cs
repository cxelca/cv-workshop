using backend.Data.Models;
using backend.DTOs;

namespace backend.Data.Mappers;

public static class ExperienceMapper
{
    public static ExperienceDto ToDto(this Experience experience) =>
    new(
        Id: experience.Id,
        UserId: experience.UserId,
        Title: experience.Title,
        Role: experience.Role,
        Type: experience.Type,
        StartDate: experience.StartDate,
        EndDate: experience.EndDate,
        Description: experience.Description,
        ImageUrl: experience.ImageUrl,
        Company: experience.Company
    );
}