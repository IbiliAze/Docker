const Config = require('../models/config');

const doesConfigExist = async (request, response, next) => {
    try {
        const configId = request.params.id;
        const config = await Config.findById(configId);
        if (!config) {
            console.error(`Config not found, ID: ${configId}`);
            return response.status(404).send({
                error: 'Config not found',
                id: request.params.id
            });
        };
        next();
    } catch (error) {
        console.error(error);
        response.status(500).send({
            error: error
        });
    };
};

module.exports = doesConfigExist; 