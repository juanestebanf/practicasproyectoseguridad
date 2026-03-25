const { Client } = require('pg');
const fs = require('fs');
const path = require('path');

// Capturamos la URL de la base de datos desde los argumentos de la terminal
const connectionString = process.argv[2];

if (!connectionString) {
  console.error('❌ Error: Por favor proporciona la URL externa de la base de datos.');
  console.log('Uso: node init-db.js "TU_URL_EXTERNA_DE_RENDER"');
  process.exit(1);
}

const client = new Client({
  connectionString,
  ssl: {
    rejectUnauthorized: false // Requerido para conexiones externas a Render/Supabase
  }
});

async function run() {
  try {
    const sqlPath = path.join(__dirname, 'init.sql');
    if (!fs.existsSync(sqlPath)) {
      throw new Error(`No se encontró el archivo init.sql en ${sqlPath}`);
    }

    const sql = fs.readFileSync(sqlPath, 'utf8');
    
    console.log('⏳ Conectando a la base de datos de Render...');
    await client.connect();
    
    console.log('🚀 Ejecutando script init.sql...');
    await client.query(sql);
    
    console.log('✅ ¡Tablas creadas y datos iniciales cargados con éxito!');
  } catch (err) {
    console.error('❌ Error ejecutando el script:', err.message);
    if (err.detail) console.error('Detalle:', err.detail);
  } finally {
    await client.end();
  }
}

run();
