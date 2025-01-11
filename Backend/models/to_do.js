const db = require('../config/db');
const mongoose = require('mongoose');
const UserModel = require('./user_model');

// Define the schema for the to-do model
const { Schema } = mongoose;

// Define the schema for the to-do model 
const toDoSchema = new Schema({
    userId: {
        type: Schema.Types.ObjectId,
        ref: UserModel.modelName,
        required: true,
    },
    desc:{
        type: String,
        required: true,
    },
    
});

const ToDoModel = db.model('todo', toDoSchema);

module.exports = ToDoModel;