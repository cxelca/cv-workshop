import { NavLink } from "react-router-dom";
import classes from "./main-header.module.css";
import MainHeaderBackground from "./main-header-background";

export default function MainHeader() {
  return (
    <>
      <MainHeaderBackground />
      <header className={classes.header}>
        <h1 className={classes.title}>Espen Askeladd sin CV</h1>
        <div className={classes.nav}>
          <NavLink
            to="/"
            className={({ isActive }) =>
              isActive ? "cx-tab cx-tab--active" : "cx-tab"
            }
            end
          >
            Om meg
          </NavLink>

          {/*TODO Oppgave 1.2: Legg til Erfaringer i `MainHeader.tsx` som en ny tab */}

        <NavLink
            to="/experiences"
            className={({ isActive }) =>
              isActive ? "cx-tab cx-tab--active" : "cx-tab"
            }
            end
          >
            Erfaringer
          </NavLink>

        </div>
      </header>
    </>
  );
}
