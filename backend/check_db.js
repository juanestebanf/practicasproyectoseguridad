const { Client } = require('pg');
require('dotenv').config();

const client = new Client({
  host: process.env.DB_HOST,
  port: process.env.DB_PORT,
  user: process.env.DB_USERNAME,
  password: process.env.DB_PASSWORD,
  database: process.env.DB_DATABASE,
  ssl: { rejectUnauthorized: false }
});

async function check() {
  await client.connect();
  try {
    const res = await client.query("SELECT column_name FROM information_schema.columns WHERE table_name='alerts' AND column_name='reporte_texto';");
    if (res.rows.length === 0) {
      console.log('Column NOT found. Adding it...');
      await client.query("ALTER TABLE alerts ADD COLUMN reporte_texto TEXT;");
      console.log('Column added.');
    } else {
      console.log('Column ALREADY exists.');
    }
  } catch (e) {
    console.error('Error:', e);
  } finally {
    await client.end();
  }
}

check();
