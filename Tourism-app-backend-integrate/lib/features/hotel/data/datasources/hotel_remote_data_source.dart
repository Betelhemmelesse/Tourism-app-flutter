import '../../domain/entities/hotel.dart';
import '../models/hotel_model.dart';
import '../../../../core/api/api_service.dart';

abstract class HotelRemoteDataSource {
  Future<List<HotelModel>> getHotels();
  Future<void> toggleFavoriteHotel(String hotelId);
  Future<List<HotelModel>> getFavoriteHotels();
  Future<void> addHotel(HotelModel hotel);
  Future<void> updateHotel(HotelModel hotel);
  Future<void> deleteHotel(String hotelId);
}

class HotelRemoteDataSourceImpl implements HotelRemoteDataSource {
  final ApiService _apiService;
  List<HotelModel> _mockHotels = [
    HotelModel(
      id: '1',
      name: 'Sheraton Addis',
      location: 'Addis Ababa',
      price: 250.0,
      imageUrl: 'https://dynamic-media-cdn.tripadvisor.com/media/photo-o/25/3d/13/ea/exterior.jpg?w=700&h=-1&s=1',
      rating: 4.5,
      services: ['Free Wifi', 'Swimming Pool', 'Restaurant', 'Parking'],
      isFavorite: false,
      hasWifi: true,
      hasPool: true,
      hasRestaurant: true,
      hasParking: true,
    ),
    HotelModel(
      id: '2',
      name: 'Hyatt Regency',
      location: 'Addis Ababa',
      price: 300.0,
      imageUrl: 'https://assets.hyatt.com/content/dam/hyatt/hyattdam/images/2018/06/28/1013/Hyatt-Regency-Addis-Ababa-P001-Exterior.jpg/Hyatt-Regency-Addis-Ababa-P001-Exterior.16x9.jpg',
      rating: 4.8,
      services: ['Free Wifi', 'Swimming Pool', 'Restaurant', 'Spa', 'Gym'],
      isFavorite: false,
      hasWifi: true,
      hasPool: true,
      hasRestaurant: true,
      hasParking: true,
    ),
    HotelModel(
      id: '3',
      name: 'Skylight Hotel',
      location: 'Addis Ababa',
      price: 200.0,
      imageUrl: 'https://cf.bstatic.com/xdata/images/hotel/max1024x768/385653364.jpg?k=e83eada9f4adb2c371e78bb1f36c2fb2ecd4e32da14b16e8d27724c00d0dcc35&o=&hp=1',
      rating: 4.2,
      services: ['Free Wifi', 'Restaurant', 'Parking'],
      isFavorite: false,
      hasWifi: true,
      hasPool: false,
      hasRestaurant: true,
      hasParking: true,
    ),
  ];

  HotelRemoteDataSourceImpl(this._apiService);

  @override
  Future<List<HotelModel>> getHotels() async {
    try {
    final response = await _apiService.getHotels();
      final apiHotels = response.map((json) => HotelModel.fromJson(json)).toList();
      // Merge API hotels with mock hotels, preserving favorite status
      final existingIds = _mockHotels.map((h) => h.id).toSet();
      _mockHotels.addAll(
        apiHotels.where((h) => !existingIds.contains(h.id))
      );
      return _mockHotels;
    } catch (e) {
      // If API fails, return mock data
      return _mockHotels;
    }
  }

  @override
  Future<void> toggleFavoriteHotel(String hotelId) async {
    await Future.delayed(Duration(milliseconds: 300)); // simulate network delay
    _mockHotels = _mockHotels.map((hotel) {
      if (hotel.id == hotelId) {
        return hotel.copyWith(isFavorite: !hotel.isFavorite);
      }
      return hotel;
    }).toList();
  }

  @override
  Future<List<HotelModel>> getFavoriteHotels() async {
    await Future.delayed(Duration(milliseconds: 300)); // simulate network delay
    return _mockHotels.where((hotel) => hotel.isFavorite).toList();
  }

  @override
  Future<void> addHotel(HotelModel hotel) async {
    try {
    await _apiService.addHotel(hotel.toJson());
    } catch (e) {
      // If API fails, just add to mock data
      print('Failed to add hotel to API: $e');
    }
    _mockHotels.add(hotel);
  }

  @override
  Future<void> updateHotel(HotelModel hotel) async {
    try {
    await _apiService.updateHotel(hotel.id, hotel.toJson());
    } catch (e) {
      print('Failed to update hotel in API: $e');
    }
    final index = _mockHotels.indexWhere((h) => h.id == hotel.id);
    if (index != -1) {
      _mockHotels[index] = hotel;
    }
  }

  @override
  Future<void> deleteHotel(String hotelId) async {
    try {
    await _apiService.deleteHotel(hotelId);
    } catch (e) {
      print('Failed to delete hotel from API: $e');
    }
    _mockHotels.removeWhere((hotel) => hotel.id == hotelId);
  }
}
