import express, { Request, Response } from 'express';

const app = express();
const port = 9090;

// Middleware para JSON
app.use(express.json());

// Rota principal
app.get('/', (req: Request, res: Response) => {
  res.send('Hello World!');
});

// Iniciar servidor
app.listen(port, () => {
  console.log(`Servidor rodando em http://localhost:${port}`);
});
