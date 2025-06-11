import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/hotel.dart';
import '../providers/provider_config.dart';

class AddHotelDialog extends ConsumerStatefulWidget {
  const AddHotelDialog({Key? key}) : super(key: key);

  @override
  ConsumerState<AddHotelDialog> createState() => _AddHotelDialogState();
}

class _AddHotelDialogState extends ConsumerState<AddHotelDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _locationController = TextEditingController();
  final _priceController = TextEditingController();
  final _imageUrlController = TextEditingController();
  bool _hasWifi = false;
  bool _hasPool = false;
  bool _hasRestaurant = false;
  bool _hasParking = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _locationController.dispose();
    _priceController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Hotel'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  hintText: 'Enter hotel name',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _locationController,
                decoration: const InputDecoration(
                  labelText: 'Location',
                  hintText: 'Enter hotel location',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a location';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(
                  labelText: 'Price',
                  hintText: 'Enter price per night',
                  prefixText: '\$',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a price';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _imageUrlController,
                decoration: const InputDecoration(
                  labelText: 'Image URL',
                  hintText: 'Enter image URL',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an image URL';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              const Text('Amenities', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              CheckboxListTile(
                title: const Text('WiFi'),
                value: _hasWifi,
                onChanged: (value) => setState(() => _hasWifi = value!),
              ),
              CheckboxListTile(
                title: const Text('Swimming Pool'),
                value: _hasPool,
                onChanged: (value) => setState(() => _hasPool = value!),
              ),
              CheckboxListTile(
                title: const Text('Restaurant'),
                value: _hasRestaurant,
                onChanged: (value) => setState(() => _hasRestaurant = value!),
              ),
              CheckboxListTile(
                title: const Text('Parking'),
                value: _hasParking,
                onChanged: (value) => setState(() => _hasParking = value!),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _handleSubmit,
          child: _isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Add'),
        ),
      ],
    );
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final hotel = Hotel(
        id: '',  // Will be set by the backend
        name: _nameController.text,
        location: _locationController.text,
        price: double.parse(_priceController.text),
        imageUrl: _imageUrlController.text,
        hasWifi: _hasWifi,
        hasPool: _hasPool,
        hasRestaurant: _hasRestaurant,
        hasParking: _hasParking,
      );

      await ref.read(adminProvider).addHotel(hotel);
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }
}

class EditHotelDialog extends ConsumerStatefulWidget {
  final Hotel hotel;

  const EditHotelDialog({
    Key? key,
    required this.hotel,
  }) : super(key: key);

  @override
  ConsumerState<EditHotelDialog> createState() => _EditHotelDialogState();
}

class _EditHotelDialogState extends ConsumerState<EditHotelDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _locationController;
  late final TextEditingController _priceController;
  late final TextEditingController _imageUrlController;
  late bool _hasWifi;
  late bool _hasPool;
  late bool _hasRestaurant;
  late bool _hasParking;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.hotel.name);
    _locationController = TextEditingController(text: widget.hotel.location);
    _priceController = TextEditingController(text: widget.hotel.price.toString());
    _imageUrlController = TextEditingController(text: widget.hotel.imageUrl);
    _hasWifi = widget.hotel.hasWifi;
    _hasPool = widget.hotel.hasPool;
    _hasRestaurant = widget.hotel.hasRestaurant;
    _hasParking = widget.hotel.hasParking;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _locationController.dispose();
    _priceController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit Hotel'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  hintText: 'Enter hotel name',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _locationController,
                decoration: const InputDecoration(
                  labelText: 'Location',
                  hintText: 'Enter hotel location',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a location';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(
                  labelText: 'Price',
                  hintText: 'Enter price per night',
                  prefixText: '\$',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a price';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _imageUrlController,
                decoration: const InputDecoration(
                  labelText: 'Image URL',
                  hintText: 'Enter image URL',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an image URL';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              const Text('Amenities', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              CheckboxListTile(
                title: const Text('WiFi'),
                value: _hasWifi,
                onChanged: (value) => setState(() => _hasWifi = value!),
              ),
              CheckboxListTile(
                title: const Text('Swimming Pool'),
                value: _hasPool,
                onChanged: (value) => setState(() => _hasPool = value!),
              ),
              CheckboxListTile(
                title: const Text('Restaurant'),
                value: _hasRestaurant,
                onChanged: (value) => setState(() => _hasRestaurant = value!),
              ),
              CheckboxListTile(
                title: const Text('Parking'),
                value: _hasParking,
                onChanged: (value) => setState(() => _hasParking = value!),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _handleSubmit,
          child: _isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Save'),
        ),
      ],
    );
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final updatedHotel = widget.hotel.copyWith(
        name: _nameController.text,
        location: _locationController.text,
        price: double.parse(_priceController.text),
        imageUrl: _imageUrlController.text,
        hasWifi: _hasWifi,
        hasPool: _hasPool,
        hasRestaurant: _hasRestaurant,
        hasParking: _hasParking,
      );

      await ref.read(adminProvider).updateHotel(updatedHotel);
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }
} 