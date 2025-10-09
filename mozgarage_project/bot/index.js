import express from 'express';
const app = express();
app.use(express.json());
app.get('/', (req,res)=>res.send('🤖 MoscoBot active for MozGarage!'));
app.listen(5050, ()=>console.log('MoscoBot listening on 5050'));
