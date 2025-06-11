const express = require('express');
const router = express.Router();
const Hotel = require('../models/hotel');
const { protect, authorize } = require('../middleware/auth');

// Get all hotels
router.get('/', async (req, res) => {
  try {
    const hotels = await Hotel.find();
    res.json(hotels);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
});

// Get single hotel
router.get('/:id', async (req, res) => {
  try {
    const hotel = await Hotel.findById(req.params.id);
    if (!hotel) {
      return res.status(404).json({ message: 'Hotel not found' });
    }
    res.json(hotel);
  } catch (error) {
    res.status(500).json({ message: 'Server error' });
  }
});

// Create hotel (Admin only)
router.post('/', protect, authorize('admin'), async (req, res) => {
  const hotel = new Hotel({
    name: req.body.name,
    location: req.body.location,
    price: req.body.price,
    imageUrl: req.body.imageUrl,
    hasWifi: req.body.hasWifi,
    hasPool: req.body.hasPool,
    hasRestaurant: req.body.hasRestaurant,
    hasParking: req.body.hasParking,
  });

  try {
    const newHotel = await hotel.save();
    res.status(201).json(newHotel);
  } catch (error) {
    res.status(400).json({ message: error.message });
  }
});

// Update hotel (Admin only)
router.put('/:id', protect, authorize('admin'), async (req, res) => {
  try {
    const hotel = await Hotel.findById(req.params.id);
    if (!hotel) {
      return res.status(404).json({ message: 'Hotel not found' });
    }

    hotel.name = req.body.name;
    hotel.location = req.body.location;
    hotel.price = req.body.price;
    hotel.imageUrl = req.body.imageUrl;
    hotel.hasWifi = req.body.hasWifi;
    hotel.hasPool = req.body.hasPool;
    hotel.hasRestaurant = req.body.hasRestaurant;
    hotel.hasParking = req.body.hasParking;

    const updatedHotel = await hotel.save();
    res.json(updatedHotel);
  } catch (error) {
    res.status(400).json({ message: error.message });
  }
});

// Delete hotel (Admin only)
router.delete('/:id', protect, authorize('admin'), async (req, res) => {
  try {
    const hotel = await Hotel.findById(req.params.id);
    if (!hotel) {
      return res.status(404).json({ message: 'Hotel not found' });
    }

    await hotel.deleteOne();
    res.json({ message: 'Hotel deleted' });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
});

// Search hotels
router.get('/search/:query', async (req, res) => {
  try {
    const { query } = req.params;
    const hotels = await Hotel.find({
      $or: [
        { name: { $regex: query, $options: 'i' } },
        { location: { $regex: query, $options: 'i' } }
      ]
    });
    res.json(hotels);
  } catch (error) {
    res.status(500).json({ message: 'Server error' });
  }
});

module.exports = router; 