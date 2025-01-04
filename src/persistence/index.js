require('dotenv').config();
if (process.env.DB_HOST) module.exports = require('./mysql');
