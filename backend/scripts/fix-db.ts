import { Client } from 'pg';
import * as dotenv from 'dotenv';
import * as path from 'path';

// Cargar .env
dotenv.config({ path: path.join(__dirname, '../.env') });

async function fixDatabase() {
  const client = new Client({
    host: process.env.DB_HOST,
    port: parseInt(process.env.DB_PORT || '5432'),
    user: process.env.DB_USERNAME,
    password: process.env.DB_PASSWORD,
    database: process.env.DB_DATABASE,
    ssl: process.env.DB_SSL === 'true' ? { rejectUnauthorized: false } : false,
  });

  try {
    console.log('🔗 Conectando a la base de datos de Render...');
    await client.connect();
    
    console.log('🛠️ Ejecutando ALTER TYPE...');
    // Intentar añadir el valor al enum
    // Usamos un bloque DO para manejar si ya existe (opcional pero más seguro)
    await client.query(`
      DO $$
      BEGIN
        IF NOT EXISTS (SELECT 1 FROM pg_type t JOIN pg_enum e ON t.oid = e.enumtypid WHERE t.typname = 'users_rol_enum' AND e.enumlabel = 'superadmin') THEN
          ALTER TYPE users_rol_enum ADD VALUE 'superadmin';
        END IF;
      END
      $$;
    `);
    
    console.log('✅ Base de datos actualizada correctamente.');
    console.log('🚀 Ahora reinicia tu servidor NestJS para que cree el usuario master@gmail.com automáticamente.');
    
  } catch (err) {
    console.error('❌ Error actualizando la base de datos:', err.message);
    console.log('\n💡 Tip: Si recibes un error de "type users_rol_enum does not exist", verifica el nombre del tipo en tu base de datos.');
  } finally {
    await client.end();
  }
}

fixDatabase();
