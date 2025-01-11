const UserModel = require('../models/user_model');
const userModel = require('../models/user_model');
const jwt = require('jsonwebtoken');

class UserService {
  //register user
  static async registerUser(email, password) {
    try {
      const createUser = new userModel({ email, password });
      return await createUser.save();
    } catch (error) {
      throw error;
    }
  }
  
  //check user email in database
  static async checkUser(email) {
    try {
      return await UserModel.findOne({  email });
    } catch (error) {
      throw error;
    }
  }

  //generate token
  static async generateToken(tokenData, secretKey, expiresIn) {
    return jwt.sign(tokenData, secretKey, { expiresIn: expiresIn });
  }
}
module.exports = UserService;
