import axios from 'axios';

const API_URL = 'http://localhost:8000/websocket/users';

export interface LoginPayload {
  userName: string;
  userPassword: string;
}

export interface TokenResponse {
  access_token: string;
  token_type: string;
}

export const authService = {
  async login(credentials: LoginPayload): Promise<TokenResponse> {
    const response = await axios.post<TokenResponse>(`${API_URL}/login`, credentials);
    return response.data;
  },
};