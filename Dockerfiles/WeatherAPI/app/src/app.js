const express = require('express');
const path = require('path');
const hbs = require('hbs');
const weather = require('./utils/callback');
const morgan = require('morgan');

const server = express();

const port = 5000;
const static_path = path.join(__dirname, './public');



// View engine
server.set('view engine', 'hbs');



// Middleware
server.use(morgan('dev'));
server.use(express.static(static_path));



// Routes
server.get('/', (request, response) => {
    response.render('index', {
        title: 'Weather APP',
        name: 'User'
    });
});

server.get('/about', (request, response) => {
    response.render('about', {
        title: 'About page',
        name: 'User'
    });
});

server.get('/help', (request, response) => {
    response.render('help', {
        title: 'this is helpful',
        name: 'User'
    });
});

server.get('/weather', (request, response) => {
    if (!request.query.token || !request.query.city) {
        console.log('No token or city provided');
        response.statusCode = 400
        return response.send({
            error: 'No token or city provided'
        });
    }
    const { token, city } = request.query;
    weather(city, token, (err, res) => {
        if (err){
            console.log(err);
        } else {
            response.send({
                temperature: res,
                city: city
            });
        }
    });
});



// 404
server.get('*', (request, response) => {
    response.statusCode = 404
    response.send('Not Found')
});



// Listen
server.listen(port, () => {
    console.log(`Listening on port ${port}`)
});
