const ToDoServices = require('../services/todo_services');

// This is the controller class that will be used to interact with the services
exports.createToDo = async (req, res,next) => {
    try {
        const {userId, desc} = req.body;
        let newToDo = await ToDoServices.createToDo(userId, desc);
        res.json({status: true, success: newToDo});
    } catch (error) {
        next(error);
    }
}

// This is the controller class that will be used to interact with the services
exports.getTodoList = async (req, res,next) => {
    try {
        const {userId} = req.body;
        let newToDo = await ToDoServices.getTodoData(userId);
        res.json({status: true, success: newToDo});
    } catch (error) {
        next(error);
    }
}

// This is the controller class that will be used to interact with the services
exports.deleteToDo = async (req, res,next) => {
    try {
        const {id} = req.body;
        let deleted = await ToDoServices.deleteToDo(id);
        res.json({status: true, success: deleted});
    } catch (error) {
        next(error);
    }
}

