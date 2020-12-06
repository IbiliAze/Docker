const request = require("request");

const weather = (location, api_key, callback) => {
    const url = 'http://api.weatherstack.com';
    const uri = `${url}/current?access_key=${api_key}&query=${location}`;
    const headers = {
        'Content-Type': "application/json",
        Accept: "application/json"
    };
    const temperature = request({uri: uri, headers: headers, json: true}, (error, response) => {
        if (error) {
            callback(error, undefined); //undefined is optional in this case
        } else {
            callback(undefined, response.body.current.temperature); //undefined is a must
        }
    });
    return temperature
};


module.exports = weather