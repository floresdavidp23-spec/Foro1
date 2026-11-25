import { Toaster } from 'react-hot-toast';
import { Login } from './pages/Login';

export function App() {
  return (
    <>
      <Toaster position="top-right" />
      <Login />
    </>
  );
}

export default App;