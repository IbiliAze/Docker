const express = require('express');
const router = new express.Router();

const Org = require('../models/org');


// Routes
// POST /api/org/token
router.post('/org/token', async (request, response) => {
    const org = new Org(request.body);
    try {
        await org.save();
        console.log(`Organization saved succesfully, ID: ${org._id}`);
        response.status(201).send({
            message: `Organization saved succesfully, ID: ${org._id}`
        });
    } catch(error) {
        console.error(error);
        response.status(400).send({
            error: error
        });
    };
});


module.exports = router;