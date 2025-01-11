const mongoose = require('mongoose');


/*

// Don't forget to replace the connection string with your own connection string

*/
// Connect to MongoDB using mongoose 
const connection = mongoose.createConnection('Replace your connection string here....!').on('open', ()=> {
    console.log('Connected to MongoDB');
}).on('error', () => {
    console.log('Error connecting to MongoDB');
});

module.exports = connection;