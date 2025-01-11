const UserModel = require('../models/user_model');
const UserService = require('../services/user_services');

// Register a new user
exports.register = async (req,res,next) => {
  try {
    const { email, password } = req.body;
    const successRes = await UserService.registerUser(email, password);
    res.json({
      status: true, 
      success: "User created successfully"});
  } catch (error) {
    throw error
  }
};

// Login a user
exports.login = async (req,res,next) => {
  try {
    const { email, password } = req.body;
    // Check if user exists
    const checkUser = await UserService.checkUser(email);
    if (!checkUser) {
      throw new Error('User not found');
    }

    // Check if password is valid
    const isValidPassword = await checkUser.isValidPassword(password);
    if (!isValidPassword) {
      throw new Error('Invalid password');
    }

    let tokenData = {_id: checkUser._id, email: checkUser.email};

    const token = await UserService.generateToken(tokenData, "secretKey", '1h');
    
    res.status(200).json({status: true, token: token, message: 'User logged in successfully'});
    
  } catch (error) {
    throw error
  }
}