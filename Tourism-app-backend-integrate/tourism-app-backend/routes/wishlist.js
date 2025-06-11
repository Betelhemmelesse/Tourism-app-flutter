const express = require('express');
const router = express.Router();
const Wishlist = require('../models/Wishlist');
const { protect } = require('../middleware/auth');

// Get user's wishlist
router.get('/', protect, async (req, res) => {
  try {
    let wishlist = await Wishlist.findOne({ user: req.user._id })
      .populate('destinations')
      .populate('hotels');
    
    if (!wishlist) {
      wishlist = await Wishlist.create({ user: req.user._id });
    }
    
    res.json(wishlist);
  } catch (error) {
    res.status(500).json({ message: 'Server error' });
  }
});

// Add destination to wishlist
router.post('/destinations/:id', protect, async (req, res) => {
  try {
    let wishlist = await Wishlist.findOne({ user: req.user._id });
    
    if (!wishlist) {
      wishlist = await Wishlist.create({
        user: req.user._id,
        destinations: [req.params.id]
      });
    } else if (!wishlist.destinations.includes(req.params.id)) {
      wishlist.destinations.push(req.params.id);
      await wishlist.save();
    }
    
    wishlist = await wishlist.populate('destinations');
    res.json(wishlist);
  } catch (error) {
    res.status(500).json({ message: 'Server error' });
  }
});

// Remove destination from wishlist
router.delete('/destinations/:id', protect, async (req, res) => {
  try {
    const wishlist = await Wishlist.findOne({ user: req.user._id });
    
    if (!wishlist) {
      return res.status(404).json({ message: 'Wishlist not found' });
    }
    
    wishlist.destinations = wishlist.destinations.filter(
      dest => dest.toString() !== req.params.id
    );
    
    await wishlist.save();
    await wishlist.populate('destinations');
    res.json(wishlist);
  } catch (error) {
    res.status(500).json({ message: 'Server error' });
  }
});

// Add hotel to wishlist
router.post('/hotels/:id', protect, async (req, res) => {
  try {
    let wishlist = await Wishlist.findOne({ user: req.user._id });
    
    if (!wishlist) {
      wishlist = await Wishlist.create({
        user: req.user._id,
        hotels: [req.params.id]
      });
    } else if (!wishlist.hotels.includes(req.params.id)) {
      wishlist.hotels.push(req.params.id);
      await wishlist.save();
    }
    
    wishlist = await wishlist.populate('hotels');
    res.json(wishlist);
  } catch (error) {
    res.status(500).json({ message: 'Server error' });
  }
});

// Remove hotel from wishlist
router.delete('/hotels/:id', protect, async (req, res) => {
  try {
    const wishlist = await Wishlist.findOne({ user: req.user._id });
    
    if (!wishlist) {
      return res.status(404).json({ message: 'Wishlist not found' });
    }
    
    wishlist.hotels = wishlist.hotels.filter(
      hotel => hotel.toString() !== req.params.id
    );
    
    await wishlist.save();
    await wishlist.populate('hotels');
    res.json(wishlist);
  } catch (error) {
    res.status(500).json({ message: 'Server error' });
  }
});

module.exports = router; 