const mongoose = require('mongoose');
const validator = require('validator');
const bcrypt = require('bcryptjs');


const configSchema = new mongoose.Schema({
    credentials: {
        sshUsername: {
            type: String,
            required: true
        },
        sshPassword: {
            type: String,
            required: true
        },
        sshPort: {
            type: Number,
            required: false,
            default: 22,
            validate(value) {
                if (value < 21 || value > 35000 ) {
                    console.error('Invalid SSH Port');
                    throw new Error('SSH Port out of range (22-35000)');
                }
            }
        }
    },
    siteId: {
        type: String,
        required: true
    },
    nhrp: {
        hubNbmaIp: {
            type: String,
            required: true,
            validate(value) {
                if (value.length < 15) {
                    console.error('Invalid IP address');
                    throw new Error('Invalid IP address');
                }
            }
        },
        nhrpNetworkId: {
            type: Number,
            required: false,
            default: 50,
            validate(value) {
                if (value <= 0 || value >=101) {
                    console.error('Invalid NHRP Network-ID');
                    throw new Error('NHRP Network-ID out of range (1-100)');
                }
            }
        }
    },
    tunnel: {
        tunnelIp: {
            type: String,
            required: true,
            validate(value) {
                if (value.length < 15) {
                    console.error('Invalid IP address');
                    throw new Error('Invalid IP address');
                }
            }
        },
        tunnelKey: {
            type: String,
            required: true,
            validate(value) {
                if (value.length < 8) {
                    console.error('Invalid Tunnel Key');
                    throw new Error('Tunnel key must have more than 8 characters');
                }
            }
        },
    },
    crypto: {
        isakmpKey: {
            type: String,
            required: true,
            validate(value) {
                if (value.length < 8) {
                    console.error('Invalid Crypto ISAKMP Key');
                    throw new Error('Crypto ISAKMP key must have more than 8 characters');
                }
            }
        },
        transformSet: {
            type: String,
            required: false,
            default: "esp-aes 256 esp-sha-hmac",
            enum: [
                'esp-aes 256 esp-md5-hmac',
                'esp-aes 192 esp-md5-hmac',
                'esp-aes 128 esp-md5-hmac',
                'esp-aes esp-md5-hmac',
                'esp-aes 256 esp-sha-hmac',
                'esp-aes 192 esp-sha-hmac',
                'esp-aes 128 esp-sha-hmac',
                'esp-aes esp-sha-hmac',
                'esp-des esp-md5-hmac',
                'esp-des esp-sha-hmac',
                'esp-3des esp-md5-hmac',
                'esp-3des esp-sha-hmac'
            ]
        },
        encryption: {
            type: String,
            required: false,
            default: "aes 256",
            enum: [
                'aes 256',
                'aes 192',
                'aes 128',
                'aes',
                '3des',
                'des'
            ]
        },
        hash: {
            type: String,
            required: false,
            default: "sha",
            enum: [
                "sha",
                "md5"
            ]
        },
        dhGroup: {
            type: String,
            required: false,
            default: "19",
            enum: [
                '19',
                '17',
                '5',
                '14',
                '20',
                '1',
                '2'
            ]
        },
        psk: {
            type: String,
            required: true,
            validate(value) {
                if (value.length < 8) {
                    console.error('Invalid PSK');
                    throw new Error('PSK must have more than 8 characters');
                }
            }
        },
        lifetime: {
            type: Number,
            default: 70000,
            required: false,
            validate(value) {
                if (value < 60 || value > 86400) {
                    console.error('Invalid lifetime');
                    throw new Error('Lifetime must be between 60 and 86400');
                }
            }
        }
    },
    spokes: {
        type: Array,
        required: true
    },
    eigrp: {
        type: Boolean,
        required: true,
    },
    eigrpAsn:{
        type: Number,
        required: false
    }
});


configSchema.pre('save', async function(next) {
    const config = this;

    if (config.isModified('credentials')) { 
        config['credentials']['sshPassword'] = await bcrypt.hash(config['credentials']['sshPassword'], 8);
    };

    next();
});

const Config = mongoose.model('Config', configSchema);




module.exports = Config;