const express = require('express');
const router = express.Router();
const Feedback = require('../models/Feedback');
const { protect, authorize } = require('../middleware/auth');

// Get all feedback (Admin only)
router.get('/', protect, authorize('admin'), async (req, res) => {
  try {
    const feedback = await Feedback.find().populate('user', 'name email');
    res.json(feedback);
  } catch (error) {
    res.status(500).json({ message: 'Server error' });
  }
});

// Get user's feedback
router.get('/me', protect, async (req, res) => {
  try {
    const feedback = await Feedback.find({ user: req.user._id });
    res.json(feedback);
  } catch (error) {
    res.status(500).json({ message: 'Server error' });
  }
});

// Create feedback
router.post('/', protect, async (req, res) => {
  try {
    const feedback = new Feedback({
      user: req.user._id,
      content: req.body.content,
      rating: req.body.rating
    });
    
    await feedback.save();
    res.status(201).json(feedback);
  } catch (error) {
    res.status(500).json({ message: 'Server error' });
  }
});

// Update feedback
router.put('/:id', protect, async (req, res) => {
  try {
    let feedback = await Feedback.findById(req.params.id);
    
    if (!feedback) {
      return res.status(404).json({ message: 'Feedback not found' });
    }
    
    // Make sure user owns feedback
    if (feedback.user.toString() !== req.user._id.toString()) {
      return res.status(401).json({ message: 'Not authorized' });
    }
    
    feedback = await Feedback.findByIdAndUpdate(
      req.params.id,
      { content: req.body.content, rating: req.body.rating },
      { new: true, runValidators: true }
    );
    
    res.json(feedback);
  } catch (error) {
    res.status(500).json({ message: 'Server error' });
  }
});

// Delete feedback
router.delete('/:id', protect, async (req, res) => {
  try {
    const feedback = await Feedback.findById(req.params.id);
    
    if (!feedback) {
      return res.status(404).json({ message: 'Feedback not found' });
    }
    
    // Make sure user owns feedback or is admin
    if (feedback.user.toString() !== req.user._id.toString() && req.user.role !== 'admin') {
      return res.status(401).json({ message: 'Not authorized' });
    }
    
    await feedback.remove();
    res.json({ message: 'Feedback removed' });
  } catch (error) {
    res.status(500).json({ message: 'Server error' });
  }
});

module.exports = router; 