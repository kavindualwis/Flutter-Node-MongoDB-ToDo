const express = require('express');
const body_parser = require('body-parser');
const user_routes = require('./routes/user_routes');
const todo_routes = require('./routes/todo_routes');
 
const app = express();

app.use(body_parser.json());

app.use('/', user_routes);
app.use('/', todo_routes);

module.exports = app;
