using backend.Data;
using backend.Data.Mappers;
using backend.Data.Models;
using Microsoft.EntityFrameworkCore;

namespace backend.Services;

public class CvService(AppDbContext context) : ICvService
{
    public async Task<IEnumerable<User>> GetAllUsersAsync()
    {
        return await context.Users.OrderBy(u => u.Name).ToListAsync();
    }

    // TODO: Oppgave 1
    public async Task<User> GetUserByIdAsync(Guid id)
    {
        return await context.Users.FindAsync(id);

    }

    public async Task<IEnumerable<Experience>> GetAllExperiencesAsync()
    {
        return  context.Experiences;
    } 

    public async Task<Experience?> GetExperienceByIdAsync(Guid id)
    {

        return await context.Experiences.FindAsync(id);

    }

    public async Task<IEnumerable<Experience>> GetExperiencesByTypeAsync(string type)
    {
        // TODO: Oppgave 3

        return [];
    }

    // TODO: Oppgave 4 ny metode (husk å legge den til i interfacet)
}
