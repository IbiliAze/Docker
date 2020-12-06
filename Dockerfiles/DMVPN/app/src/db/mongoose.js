const mongoose = require('mongoose');

const databaseName = 'DMVPN';
const connectionURL = `mongodb://10.0.0.3:27017/${databaseName}`;

mongoose.connect(connectionURL, {
    useNewUrlParser: true,
    useCreateIndex: true,
    useFindAndModify: false,
    useUnifiedTopology: true,
}, (error, client) => {
    if (error) {
        return console.error(`Connection error`);
    } 
    console.log(`Connection successful`);
});

