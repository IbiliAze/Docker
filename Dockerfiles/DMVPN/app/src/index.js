require('./db/mongoose');

const express = require('express');
const morgan = require('morgan');

const config = require('./routers/config');
const org = require('./routers/org');
const site = require('./routers/site');
const notFound  = require('./middleware/notFound');

const app = new express();

const port = process.env.PORT || 5000;


// Middlewares
app.use(express.json());
app.use(morgan('dev'));


// Routes
app.use('/api', org);
app.use('/api', site);
app.use('/api', config);


// Error Handlers
app.use(notFound);


// Listen
app.listen(port, () => {
    console.log(`Listening on port ${port}`);
});