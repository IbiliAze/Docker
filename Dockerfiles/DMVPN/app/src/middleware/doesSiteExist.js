const Site = require('../models/site');

const doesSiteExist = async (request, response, next) => {
    try {
        const siteId = request.body['siteId'];
        const site = await Site.findById(siteId);
        if (!site) {
            console.error(`Site not found, ID: ${siteId}`);
            return response.status(404).send({
                error: 'Site not found',
                id: request.body['siteId'],
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

module.exports = doesSiteExist; 