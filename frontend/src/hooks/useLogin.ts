import { useState } from 'react';
import toast from 'react-hot-toast';
import { authService, type LoginPayload } from '../services/auth.service';

export const useLogin = () => {
  const [isLoading, setIsLoading] = useState(false);

  const login = async (credentials: LoginPayload) => {
    setIsLoading(true);
    try {
      const data = await authService.login(credentials);
      localStorage.setItem('access_token', data.access_token);
      toast.success('¡Inicio de sesión exitoso!');
      return data;
    } catch (error: any) {
      const errorMessage =
        error.response?.data?.detail || 'Error al conectar con el servidor';
      toast.error(errorMessage);
      return null;
    } finally {
      setIsLoading(false);
    }
  };

  return { login, isLoading };
};