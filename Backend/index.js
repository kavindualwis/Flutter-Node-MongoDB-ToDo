const app = require('./app');
const db = require('./config/db');
const userModel = require('./models/user_model');

const port = 3000;

app.get('/', (req, res) => {
    res.send('Data');
});

app.listen(port, () => {
    console.log(`Server running on port http://localhost:${port}`);
});
