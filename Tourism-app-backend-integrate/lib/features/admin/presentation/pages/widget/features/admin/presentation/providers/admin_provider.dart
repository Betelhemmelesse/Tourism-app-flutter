import 'package:flutter/foundation.dart';
import '../../domain/models/destination.dart';
import '../../domain/models/hotel.dart';
import '../../domain/repositories/admin_repository.dart';

class AdminProvider extends ChangeNotifier {
  final AdminRepository _repository;
  
  List<Destination> _destinations = [];
  List<Hotel> _hotels = [];
  bool _isLoading = false;
  String? _error;

  AdminProvider(this._repository) {
    // Load data on initialization
    loadInitialData();
  }

  // Getters
  List<Destination> get destinations => _destinations;
  List<Hotel> get hotels => _hotels;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Initial data loading
  Future<void> loadInitialData() async {
    await Future.wait([
      loadDestinations(),
      loadHotels(),
    ]);
  }

  // Load Data
  Future<void> loadDestinations() async {
    _setLoading(true);
    try {
      _destinations = await _repository.getDestinations();
      _error = null;
    } catch (e) {
      _error = 'Failed to load destinations: ${e.toString()}';
      _destinations = []; // Clear destinations on error
    } finally {
      _setLoading(false);
      notifyListeners();
    }
  }

  Future<void> loadHotels() async {
    _setLoading(true);
    try {
      _hotels = await _repository.getHotels();
      _error = null;
    } catch (e) {
      _error = 'Failed to load hotels: ${e.toString()}';
      _hotels = []; // Clear hotels on error
    } finally {
      _setLoading(false);
      notifyListeners();
    }
  }

  // Destinations CRUD
  Future<void> addDestination(Destination destination) async {
    _setLoading(true);
    try {
      final newDestination = await _repository.addDestination(destination);
      _destinations = [..._destinations, newDestination];
      _error = null;
    } catch (e) {
      _error = e.toString();
      rethrow; // Rethrow to handle in UI
    } finally {
      _setLoading(false);
      notifyListeners();
    }
  }

  Future<void> updateDestination(Destination destination) async {
    _setLoading(true);
    try {
      final updatedDestination = await _repository.updateDestination(destination);
      _destinations = _destinations.map((d) => 
        d.id == destination.id ? updatedDestination : d
      ).toList();
      _error = null;
    } catch (e) {
      _error = e.toString();
      rethrow; // Rethrow to handle in UI
    } finally {
      _setLoading(false);
      notifyListeners();
    }
  }

  Future<void> deleteDestination(String id) async {
    _setLoading(true);
    try {
      await _repository.deleteDestination(id);
      _destinations = _destinations.where((d) => d.id != id).toList();
      _error = null;
    } catch (e) {
      _error = e.toString();
      rethrow; // Rethrow to handle in UI
    } finally {
      _setLoading(false);
      notifyListeners();
    }
  }

  // Hotels CRUD
  Future<void> addHotel(Hotel hotel) async {
    _setLoading(true);
    try {
      final newHotel = await _repository.addHotel(hotel);
      _hotels = [..._hotels, newHotel];
      _error = null;
    } catch (e) {
      _error = e.toString();
      rethrow; // Rethrow to handle in UI
    } finally {
      _setLoading(false);
      notifyListeners();
    }
  }

  Future<void> updateHotel(Hotel hotel) async {
    _setLoading(true);
    try {
      final updatedHotel = await _repository.updateHotel(hotel);
      _hotels = _hotels.map((h) => 
        h.id == hotel.id ? updatedHotel : h
      ).toList();
      _error = null;
    } catch (e) {
      _error = e.toString();
      rethrow; // Rethrow to handle in UI
    } finally {
      _setLoading(false);
      notifyListeners();
    }
  }

  Future<void> deleteHotel(String id) async {
    _setLoading(true);
    try {
      await _repository.deleteHotel(id);
      _hotels = _hotels.where((h) => h.id != id).toList();
      _error = null;
    } catch (e) {
      _error = e.toString();
      rethrow; // Rethrow to handle in UI
    } finally {
      _setLoading(false);
      notifyListeners();
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
} 