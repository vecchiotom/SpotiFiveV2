const express = require('express')
const app = express()
const port = 80
const mysql = require('mysql');
const routes = require('./router')

// .env setup
require('dotenv').config()

var con = mysql.createConnection({
    host: process.env.MYSQL_HOST,
    user: process.env.MYSQL_USER,
    password: process.env.MYSQL_PWD,
    database: process.env.MYSQL_DB
});

// database connection
con.connect(function (err) {
    routes.setUp(app, con)
    app.listen(port, () => console.log(`Example app listening on port ${port}!`))
});