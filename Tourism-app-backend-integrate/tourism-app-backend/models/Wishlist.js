const mongoose = require('mongoose');

const wishlistSchema = new mongoose.Schema({
  user: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: true
  },
  destinations: [{
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Destination'
  }],
  hotels: [{
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Hotel'
  }],
  createdAt: {
    type: Date,
    default: Date.now
  }
});

module.exports = mongoose.model('Wishlist', wishlistSchema); 