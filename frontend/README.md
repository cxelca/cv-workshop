# Sett opp frontend

1. Lag en kopi av **.env.example**-filen, og gi den navnet `.env`
1. Fyll inn følgende verdier\_
   1. **BACKEND_API_URL:** = http://localhost:5007 (Sjekk at dette er samme som Backenden din kjører på)
   2. **BACKEND_API_KEY:** = <api-nøkkelen du genererte i backenden>
1. Kjør `npm install`
1. Kjør `npm run dev`

# Vise og filtrere erfaringer
Vi bruker Computas sitt egne designsystem for styling av diverse komponenter. Les mer om det her: https://designsystem.computas.com/

## Oppgave 1 - Routing: Legg til "Erfaringer" som en route

Vi skal nå lage en ny side som viser alle erfaringene du har i databasen din. Vi må kunne navigere til denne siden, noe vi gjør med å lage en ny route ved siden av "Om meg" som linker til den nye siden vår. 

1. Legg til en ny route i `App.tsx` for Erfaringer med `path="/experiences"` og en komponent `Experiences`. Denne tasken vil ikke gi noen synlige endringer, men dersom du skriver inn url'en `http://localhost:5173/experiences`, så ser du at urlen er gyldig. Før dette steget, ville den samme url'en lede til en 404-side.

<details>
<summary>Vis løsning</summary>

Vi bruker Route-komponenten fra react-router-dom for å definere hvilke komponenter som vises på ulike URL-er. Alt pakkes inn i en BrowserRouter, som gjør at React kan håndtere navigasjon uten å laste siden på nytt.

path="/" viser forsiden. path="\*" fanger opp alle ukjente ruter – nyttig for å vise en 404-side.

```tsx
// TODO Oppgave 1.2: Legg til en ny route i App.tsx for Erfaringer
<Route path="/experiences" element={<Experiences />} />
```

</details>

2. Legg til Erfaringer i `MainHeader.tsx` som en ny tab, slik at vi når siden uten å endre url'en. 

<details>
<summary>Vis løsning</summary>
Her bruker vi `NavLink`-komponenten fra react-router-dom for å lage en lenke til Erfaringer. NavLink fungerer som en Link-komponent, men legger til en aktive state når gjeldende URL samsvarer med lenken. Dette kan man bruke til å style lenken til siden som er aktiv. Den får stylingen `cx-tab cx-tab--active` når den er aktiv, og `cx-tab` når den ikke er aktiv. Disse styling-klassene kommer fra designsystemt til Computas. 

```tsx
// TODO Oppgave 1: Legg til Erfaringer som en tab
<NavLink
  to="/experiences"
  className={({ isActive }) => (isActive ? "cx-tab cx-tab--active" : "cx-tab")}
>
  Erfaring
</NavLink>
```

</details>

## Oppgave 2 - Intro til tanstack query: Hente alle erfaringene fra backend

TanStack Query er et React-bibliotek som gjør det enkelt å hente og holde ekstern data oppdatert. Det løser problemer som manuell håndtering av API-kall, lasting, feil og caching, og gir en mer effektiv og ryddig måte å jobbe med data på i frontend.

Mer info om tanstack query: https://tanstack.com/query

Nå brukes hooken fra `useExperiences.ts` for å hente alle erfaringene i `Experiences.tsx`. Tanstack hånterer også mange innebyde states, som loading mens data hentes og error hvis det går feil. Vi skal håndtere disse i vår frontend.

1. Hent `isLoading` fra `useExperiences` hooken og vis en loading-melding når siden loader. Passende styling finnes i experiences.module.css, for eksempel `styles.loading`.

2. Gjør det samme med error. Hvis `error` er true, vis en error-melding. Passende styling finnes i experiences.module.css, for eksempel `styles.error`.

<details>
<summary>Vis løsning</summary>

```tsx
// TODO Oppgave 1.1 of 1.2: Håndter loading og error av erfaringer
const { data: experiences, isLoading, error } = useExperiences();

if (isLoading) {
  return <div className={styles.loading}>Loading experiences...</div>;
}

if (error) {
  return (
    <div className={styles.error}>
      Failed to load experiences. Please try again later.
    </div>
  );
}
```

</details>

## Oppgave 3 - Vis alle erfaringene i erfaring siden

1. Vis alle erfaringene i `Experiences.tsx` ved å mappe gjennom experiences, og rendre en p-tag med experience.title for hver erfaring.

<details>
<summary>Vis løsning for 3.1</summary>
I denne oppgaven bruker vi `map()` for å loope gjennom experiences og rendre et `p`-tag med `experience.title` for hver erfaring.

> **Visste du dette?**  
> Vi bruker `map()` i stedet for `forEach()` fordi `map()` returnerer en ny array som vi kan bruke til å rendre JSX-komponenter. `forEach()` utfører en handling for hvert element, men returnerer ingenting.

```tsx
// TODO Oppgave 3.1: Vis alle erfaringene

    {experiences.map((experience) => (
      <p key={experience.id}>{experience.title}</p>
    ))}
```

</details>


2. Nå skal vi bruke en ferdiglaget komponent for å få hver erfaring til å se litt freshere ut. Endre mappingen fra å returnere en p-tag til og heller returnere et `ExperienceCard`.

<details>
<summary>Vis løsning for 3.2</summary>

```tsx
// TODO Oppgave 3.2: Vis alle erfaringene med ExperienceCard

    {experiences.map((experience) => (
      <ExperienceCard key={experience.id} experience={experience} />
    ))}
```

</details>  

## Oppgave 4 - Sorter erfaringene

1. Sorter erfaringene på dato i `Experiences.tsx` ved å bruke `sort` på experiences. Se mer om dette her: https://arc.net/l/quote/ggmncfoh. Dette gjøres før vi mapper gjennom erfaringene.

<details>
<summary>Hint</summary>
startDate kommer som en string fra db, så først må vi konvertere den til et Date-objekt. Dette kan gjøres med `new Date(experience.startDate)`. 

Date-metoden `getTime()` returnerer antall millisekunder siden 1. Jan 1970. Dette er en vanlig måte å sammenligne datoer på. Les mer om det her: https://www.w3schools.com/jsref/jsref_gettime.asp
</details>

<details>
<summary>Vis løsning</summary>

```tsx
// TODO Oppgave 4.1: Sorter erfaringene
    {experiences
      .sort(
        (a, b) =>
          new Date(b.startDate).getTime() - new Date(a.startDate).getTime()
      )
      .map((experience) => (
        <ExperienceCard key={experience.id} experience={experience} />
      ))}
```
Våre erfaringer kommer ferdig sortert, men gjerne prøv å bytte rekkefølgen på sorteringen ved å endre rekkefølgen på `a` og `b`.

</details>

## Oppgave 5 - Filtrer erfaringer etter type

Vi skal nå legge til filtrering av erfaringer etter type. Dette kan gjøres via å lagre en state med valgte type. Vi skal derfor bruke `useState`.

1. Som dere kanskje ser, så funker ikke filtrering akkurat nå. Det er fordi staten `selectedExperience` aldri blir oppdatert. cxSelect-komponenten har en `handleSelectChange` funksjon som console.loger valgte type. Oppdater funksjonen `handleSelectChange` så staten endres når man velger type i selecten.
2. Endre mappingen av erfaringen slik at den bruker filteredExperiences() istedenfor experiences. NB: husk å fjerne kommenteringen av filteredExperiences()
<details>
<summary>Vis løsning</summary>

```tsx
// TODO Oppgave 5.1: Filtrer experiences etter type
setSelectedExperience(selectedFilter);
```
```tsx
 {filteredExperiences()
          .sort(
            (a, b) =>
              new Date(b.startDate).getTime() - new Date(a.startDate).getTime()
          )
          .map((experience) => (
            <ExperienceCard key={experience.id} experience={experience} />
          ))}
```

</details>

## Oppgave 6 - Conditional rendering

Vi skal nå håndtere situasjoner der enkelte erfaringer mangler noen felt. For eksempel trenger ikke alle erfaringer å være knyttet til en bedrift, slik det kan være ved blant annet hobbyprosjekter.

1. Denne oppgaven løses i `ExperienceCard.tsx`. Sjekk om erfaringen har en `company` property. Hvis ikke, så vis "Selvstendig arbeid" istedenfor.

<details>
<summary>Vis løsning</summary>
Det finnes flere måter å løse dette på:
Det første eksempelet bruker nullish coalescing (??), som viser verdien til venstre hvis den finnes, ellers verdien til høyre.

Det andre eksempelet bruker ternary-operatoren for å sjekke om verdien finnes, og velge mellom to alternativer: betingelse ? verdiHvisTrue : verdiHvisFalse

```tsx
// TODO Oppgave 6.1: Conditional rendering

{
  experience.company ?? "Selvstendig arbeid";
}

{
  experience.company ? experience.company : "Selvstendig arbeid";
}
```

</details>

## Ekstraoppgaver

1. Lag en modal som viser en erfaring i detalj når man klikker på en erfaring.
2. Lag et utkast av om meg siden.
