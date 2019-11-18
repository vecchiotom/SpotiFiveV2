const express = require('express')
const app = express()
const port = 80
const mysql = require('mysql');
const routes = require('./router')
const exphbs  = require('express-handlebars');
// .env setup
require('dotenv').config()

// only accept connections from one IP
const ipfilter = require('express-ipfilter').IpFilter
 
// Whitelist the following IPs
const ips = ["127.0.0.1", process.env.WHITELIST_IP]

var con = mysql.createConnection({
    host: process.env.MYSQL_HOST,
    user: process.env.MYSQL_USER,
    password: process.env.MYSQL_PWD,
    database: process.env.MYSQL_DB
});

app.engine('handlebars', exphbs());
app.set('view engine', 'handlebars');
 
// IP Whitelist
//app.use(ipfilter(ips, { mode: 'allow' }))

// database connection
con.connect(function (err) {
    if (err) throw err;
    routes.setUp(app, con)
    app.listen(port, () => console.log(`Example app listening on port ${port}!`))
});