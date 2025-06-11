const express = require('express');
const router = express.Router();
const Destination = require('../models/destination');
const { protect, authorize } = require('../middleware/auth');

// Get all destinations
router.get('/', async (req, res) => {
  try {
    const destinations = await Destination.find();
    res.json(destinations);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
});

// Get single destination
router.get('/:id', async (req, res) => {
  try {
    const destination = await Destination.findById(req.params.id);
    if (!destination) {
      return res.status(404).json({ message: 'Destination not found' });
    }
    res.json(destination);
  } catch (error) {
    res.status(500).json({ message: 'Server error' });
  }
});

// Create destination (Admin only)
router.post('/', protect, authorize('admin'), async (req, res) => {
  const destination = new Destination({
    name: req.body.name,
    description: req.body.description,
    imageUrl: req.body.imageUrl,
  });

  try {
    const newDestination = await destination.save();
    res.status(201).json(newDestination);
  } catch (error) {
    res.status(400).json({ message: error.message });
  }
});

// Update destination (Admin only)
router.put('/:id', protect, authorize('admin'), async (req, res) => {
  try {
    const destination = await Destination.findById(req.params.id);
    if (!destination) {
      return res.status(404).json({ message: 'Destination not found' });
    }

    destination.name = req.body.name;
    destination.description = req.body.description;
    destination.imageUrl = req.body.imageUrl;

    const updatedDestination = await destination.save();
    res.json(updatedDestination);
  } catch (error) {
    res.status(400).json({ message: error.message });
  }
});

// Delete destination (Admin only)
router.delete('/:id', protect, authorize('admin'), async (req, res) => {
  try {
    const destination = await Destination.findById(req.params.id);
    if (!destination) {
      return res.status(404).json({ message: 'Destination not found' });
    }

    await destination.deleteOne();
    res.json({ message: 'Destination deleted' });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
});

// Search destinations
router.get('/search/:query', async (req, res) => {
  try {
    const { query } = req.params;
    const destinations = await Destination.find({
      $or: [
        { name: { $regex: query, $options: 'i' } },
        { location: { $regex: query, $options: 'i' } }
      ]
    });
    res.json(destinations);
  } catch (error) {
    res.status(500).json({ message: 'Server error' });
  }
});

module.exports = router; 