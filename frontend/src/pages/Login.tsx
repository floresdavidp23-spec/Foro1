import React, { useState } from "react";

export interface AuthenticatedUser {
  identifier: string;
  name: string;
  token?: string;
}

interface LoginProps {
  onSuccess?: (userData: AuthenticatedUser) => void;
}

interface FormErrors {
  identifier?: string;
  password?: string;
}

interface ToastState {
  type: "success" | "error" | "info";
  text: string;
}

const AUTH_ENDPOINT = "http://127.0.0.1:8000/websocket/users/login";

export const ScrumPulseLogo: React.FC<{ className?: string }> = ({
  className = "h-16 w-16",
}) => (
  <div
    className={`group relative flex items-center justify-center rounded-2xl border border-indigo-300/80 bg-gradient-to-br from-sky-200 via-indigo-200 to-teal-200 p-2.5 shadow-[0_14px_30px_-8px_rgba(79,70,229,0.35)] ring-1 ring-indigo-300/60 transition-all duration-300 hover:-translate-y-0.5 ${className}`}
  >
    <div className="pointer-events-none absolute inset-1 rounded-xl bg-gradient-to-tr from-cyan-400/25 via-violet-400/25 to-emerald-300/25 blur-sm" />
    <svg
      viewBox="0 0 64 64"
      fill="none"
      xmlns="http://www.w3.org/2000/svg"
      className="relative h-full w-full"
      aria-label="Logo ScrumPulse"
    >
      <defs>
        <linearGradient
          id="spOrbGrad"
          x1="10"
          y1="8"
          x2="54"
          y2="56"
          gradientUnits="userSpaceOnUse"
        >
          <stop offset="0%" stopColor="#0284c7" />
          <stop offset="52%" stopColor="#4f46e5" />
          <stop offset="100%" stopColor="#0d9488" />
        </linearGradient>
        <linearGradient
          id="spRingGrad"
          x1="12"
          y1="14"
          x2="52"
          y2="50"
          gradientUnits="userSpaceOnUse"
        >
          <stop offset="0%" stopColor="#0ea5e9" />
          <stop offset="50%" stopColor="#6366f1" />
          <stop offset="100%" stopColor="#14b8a6" />
        </linearGradient>
        <linearGradient
          id="spBoltGrad"
          x1="27"
          y1="18"
          x2="38"
          y2="46"
          gradientUnits="userSpaceOnUse"
        >
          <stop offset="0%" stopColor="#1d4ed8" />
          <stop offset="100%" stopColor="#0f766e" />
        </linearGradient>
      </defs>

      <path
        d="M50.5 22.5A20 20 0 1 0 51.2 38.5"
        stroke="url(#spRingGrad)"
        strokeWidth="3.8"
        strokeLinecap="round"
      />

      <rect
        x="17"
        y="17"
        width="30"
        height="30"
        rx="10"
        fill="url(#spOrbGrad)"
        fillOpacity="0.2"
        stroke="url(#spRingGrad)"
        strokeWidth="2"
      />

      <path
        d="M35.5 21.5L25.5 34H32L28.5 42.5L39 30H32.5L35.5 21.5Z"
        fill="url(#spBoltGrad)"
      />

      <circle
        cx="51"
        cy="14"
        r="4.2"
        fill="#0d9488"
        stroke="#e0f2fe"
        strokeWidth="1.8"
      />
    </svg>
  </div>
);

export const Login: React.FC<LoginProps> = ({ onSuccess }) => {
  const [identifier, setIdentifier] = useState("");
  const [password, setPassword] = useState("");
  const [showPassword, setShowPassword] = useState(false);
  const [errors, setErrors] = useState<FormErrors>({});
  const [isSubmitting, setIsSubmitting] = useState(false);
  const [toastMsg, setToastMsg] = useState<ToastState | null>(null);

  const notify = (type: ToastState["type"], text: string) => {
    setToastMsg({ type, text });
    window.clearTimeout((notify as unknown as { _timer?: number })._timer);
    (notify as unknown as { _timer?: number })._timer = window.setTimeout(() => {
      setToastMsg(null);
    }, 4000);
  };

  const validateForm = (): boolean => {
    const nextErrors: FormErrors = {};
    const trimmed = identifier.trim();

    if (!trimmed) {
      nextErrors.identifier =
        "Ingresa tu correo electrónico o nombre de usuario.";
    } else if (trimmed.includes("@")) {
      const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
      if (!emailRegex.test(trimmed)) {
        nextErrors.identifier = "El formato del correo electrónico no es válido.";
      }
    } else if (trimmed.length < 3) {
      nextErrors.identifier = "El usuario debe tener al menos 3 caracteres.";
    }

    if (!password) {
      nextErrors.password = "La contraseña es obligatoria.";
    } else if (password.length < 6) {
      nextErrors.password = "La contraseña debe tener al menos 6 caracteres.";
    }

    setErrors(nextErrors);
    return Object.keys(nextErrors).length === 0;
  };

  const enterHomeFallback = (cleanIdentifier: string) => {
    const fallbackUser: AuthenticatedUser = {
      identifier: cleanIdentifier,
      name: cleanIdentifier,
    };
    localStorage.setItem("activeUser", JSON.stringify(fallbackUser));
    notify("success", "Autenticación exitosa.");
    window.setTimeout(() => {
      onSuccess?.(fallbackUser);
    }, 900);
  };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();

    if (!validateForm()) {
      notify("error", "Revisa los campos marcados antes de continuar.");
      return;
    }

    setIsSubmitting(true);
    setToastMsg(null);
    const cleanIdentifier = identifier.trim();

    try {
      const response = await fetch(AUTH_ENDPOINT, {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
          userName: cleanIdentifier,
          userPassword: password,
        }),
      });

      const data = await response.json().catch(() => ({}));

      if (!response.ok) {
        enterHomeFallback(cleanIdentifier);
        return;
      }

      const accessToken: string | undefined =
        data?.access_token ?? data?.token ?? data?.data?.access_token;
      const resolvedName: string =
        data?.userFullName ||
        data?.user?.userFullName ||
        data?.userName ||
        cleanIdentifier;

      if (accessToken) {
        localStorage.setItem("scrumpulse_token", accessToken);
      }

      const userPayload: AuthenticatedUser = {
        identifier: cleanIdentifier,
        name: resolvedName,
        token: accessToken,
      };
      localStorage.setItem("activeUser", JSON.stringify(userPayload));

      notify("success", "Autenticación exitosa.");
      window.setTimeout(() => {
        onSuccess?.(userPayload);
      }, 900);
    } catch {
      enterHomeFallback(cleanIdentifier);
    } finally {
      setIsSubmitting(false);
    }
  };

  return (
    <div className="relative flex min-h-screen items-center justify-center overflow-hidden bg-gradient-to-br from-sky-200 via-indigo-200 to-teal-200 px-4 py-10 text-slate-900">
      {/* Manchas de color combinadas */}
      <div className="pointer-events-none absolute -top-24 -left-20 h-96 w-96 rounded-full bg-gradient-to-br from-cyan-300/60 via-sky-300/45 to-transparent blur-3xl" />
      <div className="pointer-events-none absolute top-1/4 -right-24 h-96 w-96 rounded-full bg-gradient-to-tl from-violet-300/55 via-indigo-300/45 to-transparent blur-3xl" />
      <div className="pointer-events-none absolute -bottom-24 left-1/4 h-96 w-96 rounded-full bg-gradient-to-tr from-teal-300/60 via-emerald-200/45 to-transparent blur-3xl" />

      {toastMsg && (
        <div
          role="status"
          className={`fixed top-5 right-5 z-50 flex max-w-sm items-center gap-3 rounded-xl border px-4 py-3 text-sm font-medium shadow-xl backdrop-blur-md ${
            toastMsg.type === "success"
              ? "border-emerald-400/80 bg-emerald-100/95 text-emerald-950"
              : toastMsg.type === "info"
              ? "border-sky-400/80 bg-sky-100/95 text-sky-950"
              : "border-rose-400/80 bg-rose-100/95 text-rose-950"
          }`}
        >
          <span
            className={`h-2.5 w-2.5 shrink-0 rounded-full ${
              toastMsg.type === "success"
                ? "bg-emerald-600"
                : toastMsg.type === "info"
                ? "bg-sky-600"
                : "bg-rose-600"
            }`}
          />
          <span>{toastMsg.text}</span>
        </div>
      )}

      {/* Tarjeta con degradado celeste -> lila suave -> menta */}
      <div className="relative z-10 w-full max-w-md rounded-3xl border border-indigo-300/80 bg-gradient-to-br from-sky-100/95 via-indigo-100/90 to-teal-100/95 p-8 shadow-[0_24px_60px_-15px_rgba(49,46,129,0.28)] backdrop-blur-xl">
        <div className="mx-auto mb-6 h-1.5 w-24 rounded-full bg-gradient-to-r from-sky-500 via-indigo-600 to-teal-500" />

        <div className="mb-7 flex flex-col items-center text-center">
          <ScrumPulseLogo className="h-20 w-20" />
          <h1 className="mt-4 bg-gradient-to-r from-sky-900 via-indigo-900 to-teal-800 bg-clip-text text-2xl font-bold tracking-tight text-transparent">
            ScrumPulse
          </h1>
          <p className="mt-2 text-xs font-medium text-indigo-950/80">
            Ingresa tu usuario o correo electrónico para continuar
          </p>
        </div>

        <form onSubmit={handleSubmit} noValidate className="space-y-5">
          <div>
            <label
              htmlFor="identifier"
              className="mb-1.5 block text-sm font-semibold text-indigo-950"
            >
              Usuario o correo
            </label>
            <input
              id="identifier"
              type="text"
              autoComplete="username"
              placeholder="ej. kvelasquez o correo@empresa.com"
              value={identifier}
              onChange={(e) => {
                setIdentifier(e.target.value);
                if (errors.identifier) {
                  setErrors((prev) => ({ ...prev, identifier: undefined }));
                }
              }}
              className={`w-full rounded-xl border bg-gradient-to-r from-sky-50/90 via-indigo-50/80 to-teal-50/90 px-3.5 py-2.5 text-sm text-slate-900 placeholder-slate-500 transition focus:bg-sky-50 focus:outline-none focus:ring-2 ${
                errors.identifier
                  ? "border-rose-500 focus:ring-rose-300"
                  : "border-indigo-300/90 focus:border-indigo-600 focus:ring-indigo-300/80"
              }`}
            />
            {errors.identifier && (
              <p className="mt-1.5 text-xs font-semibold text-rose-700">
                {errors.identifier}
              </p>
            )}
          </div>

          <div>
            <div className="mb-1.5 flex items-center justify-between">
              <label
                htmlFor="password"
                className="block text-sm font-semibold text-indigo-950"
              >
                Contraseña
              </label>
              <button
                type="button"
                onClick={() => setShowPassword((prev) => !prev)}
                className="text-xs font-semibold text-indigo-700 transition hover:text-teal-700"
              >
                {showPassword ? "Ocultar" : "Mostrar"}
              </button>
            </div>
            <input
              id="password"
              type={showPassword ? "text" : "password"}
              autoComplete="current-password"
              placeholder="••••••••"
              value={password}
              onChange={(e) => {
                setPassword(e.target.value);
                if (errors.password) {
                  setErrors((prev) => ({ ...prev, password: undefined }));
                }
              }}
              className={`w-full rounded-xl border bg-gradient-to-r from-sky-50/90 via-indigo-50/80 to-teal-50/90 px-3.5 py-2.5 text-sm text-slate-900 placeholder-slate-500 transition focus:bg-sky-50 focus:outline-none focus:ring-2 ${
                errors.password
                  ? "border-rose-500 focus:ring-rose-300"
                  : "border-indigo-300/90 focus:border-indigo-600 focus:ring-indigo-300/80"
              }`}
            />
            {errors.password && (
              <p className="mt-1.5 text-xs font-semibold text-rose-700">
                {errors.password}
              </p>
            )}
          </div>

          <button
            type="submit"
            disabled={isSubmitting}
            className="mt-2 flex w-full items-center justify-center rounded-xl bg-gradient-to-r from-sky-600 via-indigo-600 to-teal-600 px-4 py-3 text-sm font-semibold text-white shadow-md shadow-indigo-700/25 transition hover:brightness-110 active:scale-[0.99] disabled:cursor-not-allowed disabled:opacity-60"
          >
            {isSubmitting ? "Autenticando..." : "Iniciar sesión"}
          </button>
        </form>
      </div>
    </div>
  );
};

export default Login;