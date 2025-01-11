const router = require('express').Router();
const todoController = require('../controllers/todo_controller');

// The routes will go here 
router.post('/createToDo', todoController.createToDo);
router.post('/getUserTodoList', todoController.getTodoList);
router.post('/deleteToDo', todoController.deleteToDo);

module.exports = router;