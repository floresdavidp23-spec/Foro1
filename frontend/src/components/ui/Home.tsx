import React, { useState } from "react";

export interface ActiveUser {
  identifier: string;
  name: string;
  role?: string;
  token?: string;
}

interface HomeProps {
  user?: ActiveUser | null;
  onLogout?: () => void;
}

type SectionKey = "inicio" | "usuarios" | "tareas" | "iniciativas";

interface NavSection {
  key: SectionKey;
  label: string;
  subtitle: string;
  badge?: string;
}

const SECTIONS: NavSection[] = [
  {
    key: "inicio",
    label: "Inicio",
    subtitle: "Vista general del espacio de trabajo y estado del sprint",
  },
  {
    key: "usuarios",
    label: "Usuarios",
    subtitle: "Gestión de cuentas, roles y accesos del equipo",
    badge: "3",
  },
  {
    key: "tareas",
    label: "Tareas",
    subtitle: "Seguimiento de actividades y avance diario del sprint",
    badge: "3",
  },
  {
    key: "iniciativas",
    label: "Iniciativas",
    subtitle: "Objetivos estratégicos y épicas de planificación Scrum",
    badge: "2",
  },
];

const MOCK_USERS = [
  {
    name: "Hector Calero",
    username: "CALHECTOR",
    email: "hcalero@scrumpulse.io",
    role: "Admin / Authenticate",
    status: "Activo",
  },
  {
    name: "Edwing Isaid Gutierrez Espinoza",
    username: "egutierrez",
    email: "edwing_gutierrez@udem.edu.ni",
    role: "Developer (Rol 2)",
    status: "Activo",
  },
  {
    name: "Kevin Moises Velasquez Rivera",
    username: "kvelasquez",
    email: "kevin@correo.com",
    role: "Scrum Member",
    status: "Activo",
  },
];

const MOCK_TASKS = [
  {
    id: "SCR-101",
    title: "Validar inicio de sesión con usuario o correo",
    assignee: "CALHECTOR",
    priority: "Alta",
    status: "En progreso",
  },
  {
    id: "SCR-102",
    title: "Diseñar pantalla Home con Navbar y Sidebar responsive",
    assignee: "kvelasquez",
    priority: "Alta",
    status: "Completado",
  },
  {
    id: "SCR-103",
    title: "Conectar autenticación contra servicio WebSocket/Auth",
    assignee: "egutierrez",
    priority: "Media",
    status: "Pendiente",
  },
];

const MOCK_INITIATIVES = [
  {
    code: "INI-01",
    title: "Portal de Planificación Ágil ScrumPulse",
    progress: 75,
    owner: "Equipo Scrum SI09B",
    summary:
      "Centralizar autenticación, gestión de usuarios y tablero de ejecución en una interfaz oscura y ágil.",
  },
  {
    code: "INI-02",
    title: "Sincronización en Tiempo Real de Tareas",
    progress: 45,
    owner: "Módulo WebSocket",
    summary:
      "Reflejar cambios de estado de tareas y sesiones activas sin recargar la aplicación.",
  },
];

export const Home: React.FC<HomeProps> = ({ user, onLogout }) => {
  const [activeSection, setActiveSection] = useState<SectionKey>("inicio");
  const [sidebarOpen, setSidebarOpen] = useState(false);

  const currentUser: ActiveUser = user ?? {
    identifier: "CALHECTOR",
    name: "Hector Calero",
    role: "Usuario activo",
  };

  const currentSectionMeta =
    SECTIONS.find((s) => s.key === activeSection) ?? SECTIONS[0];

  const handleSelectSection = (key: SectionKey) => {
    setActiveSection(key);
    setSidebarOpen(false);
  };

  return (
    <div className="min-h-screen bg-slate-950 text-slate-100">
      {sidebarOpen && (
        <div
          onClick={() => setSidebarOpen(false)}
          className="fixed inset-0 z-30 bg-black/60 lg:hidden"
          aria-hidden="true"
        />
      )}

      <header className="sticky top-0 z-40 flex h-16 items-center justify-between border-b border-slate-800 bg-slate-900 px-4 sm:px-6">
        <div className="flex items-center gap-3">
          <button
            type="button"
            onClick={() => setSidebarOpen((prev) => !prev)}
            aria-label="Abrir o cerrar menú lateral"
            className="inline-flex h-10 w-10 items-center justify-center rounded-xl border border-slate-800 bg-slate-950 text-slate-300 lg:hidden"
          >
            ☰
          </button>

          <div>
            <div className="flex items-center gap-2">
              <span className="text-base font-bold text-white sm:text-lg">
                ScrumPulse
              </span>
              <span className="rounded-full border border-cyan-500/30 bg-cyan-950 px-2 py-0.5 text-[11px] font-medium text-cyan-300">
                Home
              </span>
            </div>
            <p className="hidden text-[11px] text-slate-400 md:block">
              Cada sprint en movimiento, cada equipo en sintonía.
            </p>
          </div>
        </div>

        <div className="flex items-center gap-3 sm:gap-4">
          <div className="hidden items-center gap-2 rounded-xl border border-slate-800 bg-slate-950 px-3 py-1.5 text-xs md:flex">
            <span className="text-slate-500">Ubicación:</span>
            <span className="font-semibold text-cyan-400">
              Home / {currentSectionMeta.label}
            </span>
          </div>

          <div className="text-right">
            <p className="max-w-[140px] truncate text-xs font-semibold text-white sm:max-w-[200px] sm:text-sm">
              {currentUser.name}
            </p>
            <p className="truncate text-[11px] text-slate-400">
              @{currentUser.identifier}
            </p>
          </div>

          {onLogout && (
            <button
              type="button"
              onClick={onLogout}
              className="rounded-xl border border-slate-700 bg-slate-800 px-3 py-2 text-xs font-medium text-slate-200 hover:border-rose-500/50 hover:bg-rose-950/50 hover:text-rose-200"
            >
              Salir
            </button>
          )}
        </div>
      </header>

      <div className="mx-auto flex max-w-[1440px]">
        <aside
          className={`fixed top-16 bottom-0 left-0 z-30 w-64 shrink-0 border-r border-slate-800 bg-slate-900 p-4 transition-transform duration-200 lg:static lg:top-0 lg:block lg:h-[calc(100vh-4rem)] lg:translate-x-0 ${
            sidebarOpen ? "translate-x-0" : "-translate-x-full"
          }`}
        >
          <div className="mb-3 px-2 text-[11px] font-semibold uppercase tracking-wider text-slate-500">
            Navegación principal
          </div>

          <nav aria-label="Secciones de Home" className="space-y-1.5">
            {SECTIONS.map((section) => {
              const isActive = section.key === activeSection;
              return (
                <button
                  key={section.key}
                  type="button"
                  onClick={() => handleSelectSection(section.key)}
                  className={`flex w-full items-center justify-between rounded-xl px-3.5 py-2.5 text-left text-sm font-medium transition ${
                    isActive
                      ? "bg-cyan-500/20 text-white ring-1 ring-cyan-400/40"
                      : "text-slate-400 hover:bg-slate-800 hover:text-slate-100"
                  }`}
                >
                  <span>{section.label}</span>
                  {section.badge && (
                    <span className="rounded-full bg-slate-800 px-2 py-0.5 text-[11px] font-semibold text-cyan-300">
                      {section.badge}
                    </span>
                  )}
                </button>
              );
            })}
          </nav>

          <div className="mt-8 rounded-2xl border border-slate-800 bg-slate-950 p-3.5">
            <p className="text-xs font-semibold text-cyan-300">
              Estado de sesión
            </p>
            <p className="mt-1 text-xs text-slate-400">
              Conectado como{" "}
              <span className="font-medium text-slate-200">
                {currentUser.identifier}
              </span>
            </p>
          </div>
        </aside>

        <main className="min-w-0 flex-1 p-4 sm:p-6 lg:p-8">
          <div className="mb-6 rounded-2xl border border-slate-800 bg-slate-900 p-4 sm:p-5">
            <div className="flex flex-wrap items-center justify-between gap-2">
              <div className="flex items-center gap-2 text-xs font-medium text-slate-400">
                <span>Home</span>
                <span>/</span>
                <span className="rounded-md bg-cyan-500/15 px-2 py-0.5 font-semibold text-cyan-300">
                  {currentSectionMeta.label}
                </span>
              </div>
              <span className="text-xs text-slate-500">
                Estás ubicado en:{" "}
                <strong className="text-slate-300">
                  {currentSectionMeta.label}
                </strong>
              </span>
            </div>

            <h1 className="mt-2.5 text-xl font-bold text-white sm:text-2xl">
              {currentSectionMeta.label}
            </h1>
            <p className="mt-1 text-xs text-slate-400 sm:text-sm">
              {currentSectionMeta.subtitle}
            </p>
          </div>

          {activeSection === "inicio" && (
            <div className="grid grid-cols-1 gap-4 sm:grid-cols-3">
              <div className="rounded-2xl border border-slate-800 bg-slate-900 p-5">
                <p className="text-xs text-slate-400">Usuarios registrados</p>
                <p className="mt-2 text-2xl font-bold text-white">3</p>
              </div>
              <div className="rounded-2xl border border-slate-800 bg-slate-900 p-5">
                <p className="text-xs text-slate-400">Tareas del sprint</p>
                <p className="mt-2 text-2xl font-bold text-white">3</p>
              </div>
              <div className="rounded-2xl border border-slate-800 bg-slate-900 p-5">
                <p className="text-xs text-slate-400">Iniciativas activas</p>
                <p className="mt-2 text-2xl font-bold text-white">2</p>
              </div>
            </div>
          )}

          {activeSection === "usuarios" && (
            <div className="overflow-x-auto rounded-2xl border border-slate-800 bg-slate-900">
              <table className="w-full text-left text-sm">
                <thead className="border-b border-slate-800 bg-slate-950 text-xs uppercase text-slate-400">
                  <tr>
                    <th className="px-5 py-3">Nombre</th>
                    <th className="px-5 py-3">Usuario</th>
                    <th className="px-5 py-3">Correo</th>
                    <th className="px-5 py-3">Rol</th>
                    <th className="px-5 py-3">Estado</th>
                  </tr>
                </thead>
                <tbody className="divide-y divide-slate-800">
                  {MOCK_USERS.map((u) => (
                    <tr key={u.username}>
                      <td className="px-5 py-3.5 font-medium text-white">
                        {u.name}
                      </td>
                      <td className="px-5 py-3.5 text-cyan-300">
                        {u.username}
                      </td>
                      <td className="px-5 py-3.5 text-slate-300">{u.email}</td>
                      <td className="px-5 py-3.5 text-slate-300">{u.role}</td>
                      <td className="px-5 py-3.5 text-emerald-300">
                        {u.status}
                      </td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>
          )}

          {activeSection === "tareas" && (
            <div className="grid grid-cols-1 gap-4 md:grid-cols-3">
              {MOCK_TASKS.map((task) => (
                <div
                  key={task.id}
                  className="rounded-2xl border border-slate-800 bg-slate-900 p-5"
                >
                  <div className="flex items-center justify-between text-xs">
                    <span className="font-semibold text-indigo-300">
                      {task.id}
                    </span>
                    <span className="text-slate-400">
                      Prioridad: {task.priority}
                    </span>
                  </div>
                  <h2 className="mt-3 text-sm font-semibold text-white">
                    {task.title}
                  </h2>
                  <div className="mt-4 flex items-center justify-between border-t border-slate-800 pt-3 text-xs">
                    <span className="text-slate-400">@{task.assignee}</span>
                    <span className="font-medium text-cyan-300">
                      {task.status}
                    </span>
                  </div>
                </div>
              ))}
            </div>
          )}

          {activeSection === "iniciativas" && (
            <div className="grid grid-cols-1 gap-4 lg:grid-cols-2">
              {MOCK_INITIATIVES.map((ini) => (
                <div
                  key={ini.code}
                  className="rounded-2xl border border-slate-800 bg-slate-900 p-5"
                >
                  <div className="flex items-center justify-between text-xs">
                    <span className="font-semibold text-fuchsia-300">
                      {ini.code}
                    </span>
                    <span className="text-slate-400">{ini.owner}</span>
                  </div>
                  <h2 className="mt-3 text-base font-bold text-white">
                    {ini.title}
                  </h2>
                  <p className="mt-1.5 text-xs text-slate-400 sm:text-sm">
                    {ini.summary}
                  </p>
                  <p className="mt-4 text-xs font-semibold text-cyan-300">
                    Progreso: {ini.progress}%
                  </p>
                </div>
              ))}
            </div>
          )}
        </main>
      </div>
    </div>
  );
};

export default Home;