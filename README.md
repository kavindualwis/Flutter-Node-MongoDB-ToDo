# Flutter Nodejs MongoDB Backend Development Guide

This guide will help you create a simple backend application using Node.js, Express, and MongoDB. The application will allow for user registration and login, as well as the management of to-do items.

## Prerequisites

Before you begin, ensure that you have the following installed on your computer:

- **Node.js**: A JavaScript runtime for building server-side applications.
- **MongoDB**: A NoSQL database for storing application data.
- **Postman**: A tool for testing your API endpoints.

---

## Step 1: Set Up Your Project

1. **Create a New Project Folder**: Start by creating a folder for your project.
2. **Initialize the Project**: Use a terminal or command prompt to initialize your project with a package manager, which sets up the basic project structure.
   ```bash
   mkdir backend-app
   cd backend-app
   npm init -y
   ```

---

## Step 2: Connect to the Database

1. **Set Up MongoDB Connection**:
   - Create a configuration file (e.g., `db.js`) that establishes a connection to your MongoDB database.
   ```javascript
   const mongoose = require('mongoose');

   const connectDB = async () => {
       try {
           await mongoose.connect('mongodb://localhost:27017/todoapp', {
               useNewUrlParser: true,
               useUnifiedTopology: true,
           });
           console.log('MongoDB Connected');
       } catch (err) {
           console.error(err.message);
           process.exit(1);
       }
   };

   module.exports = connectDB;
   ```

---

## Step 3: Define Your Data Models

1. **User Model**:
   - Create a schema that defines how user data will be structured, including fields for email and password.
   ```javascript
   const mongoose = require('mongoose');

   const UserSchema = new mongoose.Schema({
       email: {
           type: String,
           required: true,
           unique: true,
       },
       password: {
           type: String,
           required: true,
       },
   });

   module.exports = mongoose.model('User', UserSchema);
   ```

2. **To-Do Model**:
   - Create another schema for to-do items, linking each item to a user.
   ```javascript
   const mongoose = require('mongoose');

   const TodoSchema = new mongoose.Schema({
       user: {
           type: mongoose.Schema.Types.ObjectId,
           ref: 'User',
           required: true,
       },
       title: {
           type: String,
           required: true,
       },
       completed: {
           type: Boolean,
           default: false,
       },
   });

   module.exports = mongoose.model('Todo', TodoSchema);
   ```

---

## Step 4: Implement Service Logic

1. **User Services**:
   - Develop functions for user-related tasks such as registering a new user, checking if a user exists, and generating authentication tokens.

2. **To-Do Services**:
   - Create functions for managing to-do items, including creating new items, retrieving existing ones, and deleting them.

---

## Step 5: Set Up Controllers

1. **User Controller**:
   - Handle incoming requests related to user actions, such as registration and login.

2. **To-Do Controller**:
   - Handle requests to create, retrieve, and delete to-do items.

---

## Step 6: Build the Main Application

1. **Set Up the Express Server**:
   - Create a main application file that initializes the Express server and defines the routes for your API.
   ```javascript
   const express = require('express');
   const connectDB = require('./db');

   const app = express();

   // Connect to the database
   connectDB();

   // Middleware
   app.use(express.json());

   // Define routes
   app.use('/api/users', require('./routes/userRoutes'));
   app.use('/api/todos', require('./routes/todoRoutes'));

   const PORT = process.env.PORT || 5000;
   app.listen(PORT, () => console.log(`Server running on port ${PORT}`));
   ```

2. **Define API Endpoints**:
   - Specify the endpoints that users will interact with, linking them to the appropriate controller functions.

---

## Step 7: Test Your Application

1. **Run the Server**:
   - Start your application server to listen for incoming requests.
   ```bash
   node server.js
   ```

2. **Use Postman**:
   - Test the various API endpoints to ensure that user registration, login, and to-do management work as intended. Check for correct responses and error handling.

---

## Conclusion

You have now built a simple backend application using Node.js, Express, and MongoDB. This guide provides a foundational understanding of backend development. You can continue to enhance your application by adding more features, improving security, and integrating frontend technologies.

**Happy coding!**
