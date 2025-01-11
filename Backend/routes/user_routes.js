const router = require('express').Router();
const userController = require('../controllers/user_controller');

router.post('/registration', userController.register);
router.post('/login', userController.login);

module.exports = router;