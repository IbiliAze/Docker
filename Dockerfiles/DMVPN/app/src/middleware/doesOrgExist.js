const Org = require('../models/org');

const doesOrgExist = async (request, response, next) => {
    try {
        const orgId = request.body['orgId'];
        const org = await Org.findById(orgId);
        if (!org) {
            console.error(`Organization not found, ID: ${orgId}`);
            return response.status(404).send({
                error: 'Organization not found',
                id: request.body['orgId']
            });
        };
        next();
    } catch(error) {
        console.error(error);
        response.status(500).send({
            error: error
        });
    };
};

module.exports = doesOrgExist;