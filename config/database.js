// config/database.js
require('dotenv').config();
const { Sequelize } = require('sequelize');

const sequelize = new Sequelize(
    process.env.MENAGE_DB_NAME,
    process.env.MENAGE_DB_USER,
    process.env.MENAGE_DB_PASSWORD,
    {
        host: process.env.DB_HOST,
        dialect: 'mysql',
        logging: false, 
    }
);

module.exports = sequelize;
