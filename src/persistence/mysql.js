require('dotenv').config();

const waitPort = require('wait-port');
const mysql = require('mysql2');

const {
  DB_HOST,
  DB_USER,
  DB_PASSWORD,
  DB_NAME,
} = process.env;

// Check if required environment variables are present
if (!DB_HOST || !DB_USER || !DB_PASSWORD || !DB_NAME) {
  console.error('Missing required database environment variables');
  process.exit(1);
}

let pool;

// Initialize the database connection and create the required table if not exists
async function init() {
  console.log(`Attempting to connect to MySQL at host: ${DB_HOST}`);
  
  await waitPort({
    host: DB_HOST,
    port: 3306,
    timeout: 10000,
    waitForDns: true,
  });

  pool = mysql.createPool({
    connectionLimit: 5,
    host: DB_HOST,
    user: DB_USER,
    password: DB_PASSWORD,
    database: DB_NAME,
    charset: 'utf8mb4',
  });

  return new Promise((resolve, reject) => {
    const createTableQuery = `
      CREATE TABLE IF NOT EXISTS todo_items (
        id VARCHAR(36) PRIMARY KEY,
        name VARCHAR(255),
        completed BOOLEAN
      ) DEFAULT CHARSET=utf8mb4;
    `;
    
    pool.query(createTableQuery, (err) => {
      if (err) return reject(err);
      console.log(`Connected to MySQL database at host ${DB_HOST}`);
      resolve();
    });
  });
}

// Gracefully close the database connection
async function teardown() {
  return new Promise((resolve, reject) => {
    pool.end((err) => {
      if (err) return reject(err);
      resolve();
    });
  });
}

// Retrieve all todo items
async function getItems() {
  return new Promise((resolve, reject) => {
    pool.query('SELECT * FROM todo_items', (err, rows) => {
      if (err) return reject(err);
      resolve(
        rows.map(item => ({
          ...item,
          completed: item.completed === 1,
        }))
      );
    });
  });
}

// Retrieve a specific todo item by ID
async function getItem(id) {
  return new Promise((resolve, reject) => {
    pool.query('SELECT * FROM todo_items WHERE id = ?', [id], (err, rows) => {
      if (err) return reject(err);
      resolve(
        rows.map(item => ({
          ...item,
          completed: item.completed === 1,
        }))[0]
      );
    });
  });
}

// Add a new todo item
async function storeItem(item) {
  return new Promise((resolve, reject) => {
    const query = 'INSERT INTO todo_items (id, name, completed) VALUES (?, ?, ?)';
    pool.query(query, [item.id, item.name, item.completed ? 1 : 0], (err) => {
      if (err) return reject(err);
      resolve();
    });
  });
}

// Update an existing todo item
async function updateItem(id, item) {
  return new Promise((resolve, reject) => {
    const query = 'UPDATE todo_items SET name = ?, completed = ? WHERE id = ?';
    pool.query(query, [item.name, item.completed ? 1 : 0, id], (err) => {
      if (err) return reject(err);
      resolve();
    });
  });
}

// Remove a todo item by ID
async function removeItem(id) {
  return new Promise((resolve, reject) => {
    pool.query('DELETE FROM todo_items WHERE id = ?', [id], (err) => {
      if (err) return reject(err);
      resolve();
    });
  });
}

// Export the functions
module.exports = {
  init,
  teardown,
  getItems,
  getItem,
  storeItem,
  updateItem,
  removeItem,
};
