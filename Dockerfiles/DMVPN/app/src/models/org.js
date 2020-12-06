const mongoose = require('mongoose');
const validator = require('validator');


const orgSchema = new mongoose.Schema({
    siteName: {
        type: String,
        required: true,
        validate(value) {
            if (value.length < 2) {
                console.error(`Site Name is too short`);
                throw new Error(`Site Name is too short`);
            }
        }
    },
    email: {
        type: String,
        required: true,
        unique: true,
        validate(value){
            if (!validator.isEmail(value)) {
                console.error('Invalid Email');
                throw new Error('Invalid Email');
            };
        }
    },
    orgName: {
        type: String,
        required: true,
        unique: true,
        validate(value) {
            if (value.length < 2) {
                console.log(`Organization Name is too short`);
                throw new Error(`Organization Name is too short`);
            }
        }
    }
});


const Org = mongoose.model('Org', orgSchema);



module.exports = Org;