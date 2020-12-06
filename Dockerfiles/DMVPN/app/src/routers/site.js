const express = require('express');
const router = new express.Router();

const Site = require('../models/site');

const doesSiteExist = require('../middleware/doesSiteExist');
const doesOrgExist = require('../middleware/doesOrgExist');


// Routes
// POST /api/site
router.post('/site', doesOrgExist, async (request, response) => {
    const site = new Site(request.body);
    try {
        await site.save();
        console.log(`Site saved succesfully, ID: ${site._id}`);
        response.status(201).send({
            message: `Site saved succesfully, ID: ${site._id}`
        });
    } catch(error) {
        console.error(error);
        response.status(400).send({
            error: error
        });
    };
});


// GET /api/site
router.get('/site', async (request, response) => {
    try {
        const sites = await Site.find({});
        console.log(`Sites fetched successfully`);
        response.status(200).send(sites);
    } catch (error) {
        console.error(error);
        response.status(404).send({
            error: error
        });
    };
});


// GET /api/site by ID
router.get('/site/:id', doesSiteExist, async (request, response) => {
    try {
        const site = await Site.findById(request.params.id);
        console.log(`Site fetched successfully, ID: ${site._id}`);
        response.status(200).send(site);
    } catch (error) {
        console.error(error);
        response.status(500).send({
            error: error
        });
    };
});


// PUT /api/site by ID
router.put('/site/:id', doesSiteExist, async (request, response) => {
    const updates = Object.keys(request.body);
    const allowedUpdates = ['siteName'];
    const isValidOperation = updates.every((update) => allowedUpdates.includes(update));
    if (!isValidOperation) {
        console.error(`Invalid update`);
        return response.status(400).send({error: `Invalid update`});
    };
    try {
        const site = await Site.findById(request.params.id);
        updates.forEach((update) => site[update] = request.body[update] );
        await site.save();
        console.log(`Site updated successfully, ID: ${request.params.id}`);
        response.status(200).send({message: `Site updated successfully, ID: ${request.params.id}`});
    } catch (error) {
        console.error(error);
        response.status(500).send({
            error: error
        });
    };
});


// DELETE /api/site by ID
router.delete('/site/:id', doesSiteExist, async (request, response) => {
    try {
        await Site.findOneAndDelete(request.params.id);
        console.log(`Site deleted successfully, ID: ${request.params.id}`);
        response.status(200).send({message: `Site deleted successfully, ID: ${request.params.id}`});
    } catch (error) {
        console.error(error);
        response.status(500).send({
            error: error
        });
    };
});



module.exports = router;