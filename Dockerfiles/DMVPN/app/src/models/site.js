const mongoose = require('mongoose');
const validator = require('validator');


const siteSchema = new mongoose.Schema({
    siteName: {
        type: String,
        unique: true,
        required: true,
        validate(value) {
            if (value.length < 2) {
                console.error(`Site Name is too short`);
                throw new Error(`Site Name is too short`);
            }
        }
    },
    orgId: {
        type: String,
        required: true
    }
});


const Site = mongoose.model('Site', siteSchema);



module.exports = Site;