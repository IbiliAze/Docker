const { request, response } = require("express");

const notFound = (request, response, next) => {
    console.error('Resource not found');
    response.status(404).send({
        error: 'Resource not found'
    });
};

module.exports = notFound;