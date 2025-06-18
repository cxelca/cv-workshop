using backend.Data.Models;

namespace backend.Services;

public interface ICvService
{
    // Users
    Task<IEnumerable<User>> GetAllUsersAsync();

    // TODO: Oppgave 1: ny metode for å hente User basert på id
    Task<User> GetUserByIdAsync(Guid id);

    // TODO: Oppgave 4: ny metode - GetUsersWithDesiredSkills

    // Experiences
    Task<IEnumerable<Experience>> GetAllExperiencesAsync();
    Task<Experience?> GetExperienceByIdAsync(Guid id);
    Task<IEnumerable<Experience>> GetExperiencesByTypeAsync(string type);
}
 