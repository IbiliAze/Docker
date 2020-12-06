const express = require('express');
const router = new express.Router();

const Config = require('../models/config');

const doesSiteExist = require('../middleware/doesSiteExist');
const doesConfigExist = require('../middleware/doesConfigExist');


// Routes
// POST /api/config
router.post('/config', doesSiteExist, async (request, response) => {
    const config = new Config(request.body);
    try {
        await config.save();
        console.log(`Config saved succesfully, ID: ${config._id}`);
        response.status(201).send({
            message: `Config saved succesfully, ID: ${config._id}`
        });
    } catch(error) {
        console.error(error);
        response.status(400).send({
            error: error
        });
    };
});


// GET /api/config
router.get('/config', async (request, response) => {
    try {
        const configs = await Config.find({});
        console.log(`Configs fetched successfully`);
        response.status(200).send(configs);
    } catch (error) {
        console.error(error);
        response.status(404).send({
            error: error
        });
    };
});


// GET /api/config by ID
router.get('/config/:id', doesConfigExist, async (request, response) => {
    try {
        const config = await Config.findById(request.params.id);
        console.log(`Config fetched successfully, ID: ${config._id}`);
        response.status(200).send(config);
    } catch (error) {
        console.error(error);
        response.status(500).send({
            error: error
        });
    };
});


// PUT /api/config by ID
router.put('/config/:id', doesConfigExist, async (request, response) => {
    const updates = Object.keys(request.body);
    const allowedUpdates = ['encryption', 'hash', 'dhGroup', 'lifetime', "eigrp", "siteId", "credentials"];
    const isValidOperation = updates.every((update) => allowedUpdates.includes(update));
    if (!isValidOperation) {
        console.error(`Invalid update`);
        return response.status(400).send({error: `Invalid update`});
    };
    try {
        const config = await Config.findById(request.params.id);
        updates.forEach((update) => config[update] = request.body[update] );
        await config.save();
        console.log(`Config updated successfully, ID: ${request.params.id}`);
        response.status(200).send({message: `Config updated successfully, ID: ${request.params.id}`});
    } catch (error) {
        console.error(error);
        response.status(500).send({
            error: error
        });
    };
});


// DELETE /api/config by ID
router.delete('/config/:id', doesConfigExist, async (request, response) => {
    try {
        await Config.findOneAndDelete(request.params.id);
        console.log(`Config deleted successfully, ID: ${request.params.id}`);
        response.status(200).send({message: `Config deleted successfully, ID: ${request.params.id}`});
    } catch (error) {
        console.error(error);
        response.status(500).send({
            error: error
        });
    };
});



module.exports = router;