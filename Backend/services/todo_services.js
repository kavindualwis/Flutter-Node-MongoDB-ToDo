const ToDoModel = require('../models/to_do');

// This is the service class that will be used to interact with the database
class ToDoServices {
    // This is the service class that will be used to interact with the database
    static async createToDo(userId,desc){
            const newToDo = new ToDoModel({userId,desc});
            return await newToDo.save();
    }

    // This is the service class that will be used to interact with the database
    static async getTodoData(userId){
            const todoData = await ToDoModel.find({userId});
            return todoData;
    }

    // This is the service class that will be used to interact with the database
    static async deleteToDo(id){
            const deleted = await ToDoModel.findOneAndDelete({_id:id});
            return deleted;
    }
    
}

module.exports = ToDoServices;