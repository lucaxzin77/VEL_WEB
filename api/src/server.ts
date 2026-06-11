import app from "./app.ts";
// import { connectDatabaseStatus } from './core/utils/helpers.ts';
import dotenv from "dotenv";

dotenv.config();


// async function main() {
//     const dbConnection = await connectDatabaseStatus();

//     if (!dbConnection.connected) {
//         console.error('Erro ao conectar ao banco de dados:', dbConnection.message);
//         process.exit(1);
//     }

//     // resto da aplicação
// }

// main().catch(err => {
//     console.error(err);
//     process.exit(1);
// });


const PORT = process.env.PORT || 3000;

app.listen(PORT, () => {
  console.log(`Servidor rodando na porta ${PORT}`);
});