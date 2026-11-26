import React, { useState } from "react";
import Login, { type AuthenticatedUser } from "./pages/Login";
import Home from "./components/ui/Home";

export const App: React.FC = () => {
  const [user, setUser] = useState<AuthenticatedUser | null>(() => {
    const saved = localStorage.getItem("activeUser");
    if (!saved) return null;
    try {
      return JSON.parse(saved) as AuthenticatedUser;
    } catch {
      return null;
    }
  });

  const handleLoginSuccess = (userData: AuthenticatedUser) => {
    setUser(userData);
  };

  if (!user) {
    return <Login onSuccess={handleLoginSuccess} />;
  }

  return (
    <Home
      user={user}
      onLogout={() => {
        localStorage.removeItem("activeUser");
        localStorage.removeItem("scrumpulse_token");
        setUser(null);
      }}
    />
  );
};

export default App;