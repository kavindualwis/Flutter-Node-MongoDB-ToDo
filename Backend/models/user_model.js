const mongoose = require('mongoose');
const bcrypt = require('bcrypt');
const db = require('../config/db');

// Define the schema for the user model 
const { Schema } = mongoose;

const userSchema = new Schema({
    email:{
        type: String,
        lowercase: true,
        required: true,
        unique: true,
    },
    password:{
        type: String,
        required: true,
    },
});

// Password creating/hashing
userSchema.pre('save', async function(next){
    try {
        const salt = await bcrypt.genSalt(10);
        const hashedPassword = await bcrypt.hash(this.password, salt);
        this.password = hashedPassword;
        next();
    } catch (error) {
        next(error);
    }
    
});

// Password validation after register
userSchema.methods.isValidPassword = async function(userPassword){
    try {
        return await bcrypt.compare(userPassword, this.password);
    } catch (error) {
        throw error;
    }
};

const UserModel = db.model('user', userSchema);

module.exports = UserModel;

