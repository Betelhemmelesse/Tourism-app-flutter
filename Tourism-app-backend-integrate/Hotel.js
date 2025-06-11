const mongoose = require('mongoose');

const hotelSchema = new mongoose.Schema({
  name: {
    type: String,
    required: true,
  },
  location: {
    type: String,
    required: true,
  },
  price: {
    type: Number,
    required: true,
  },
  imageUrl: {
    type: String,
    required: true,
  },
  hasWifi: {
    type: Boolean,
    default: false,
  },
  hasPool: {
    type: Boolean,
    default: false,
  },
  hasRestaurant: {
    type: Boolean,
    default: false,
  },
  hasParking: {
    type: Boolean,
    default: false,
  }
}, {
  timestamps: true
});

module.exports = mongoose.model('Hotel', hotelSchema); 