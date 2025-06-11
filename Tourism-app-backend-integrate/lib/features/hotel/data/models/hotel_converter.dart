import 'package:tourism_app/features/admin/domain/models/hotel.dart' as admin;
import 'package:tourism_app/features/hotel/data/models/hotel_model.dart';

class HotelConverter {
  static HotelModel fromAdminModel(admin.Hotel hotel) {
    return HotelModel(
      id: hotel.id,
      name: hotel.name,
      location: hotel.location,
      price: hotel.price,
      imageUrl: hotel.imageUrl,
      rating: 4.0, // Default rating for new hotels
      services: [
        if (hotel.hasWifi) 'Free Wifi',
        if (hotel.hasPool) 'Swimming Pool',
        if (hotel.hasRestaurant) 'Restaurant',
        if (hotel.hasParking) 'Parking',
      ],
      isFavorite: false,
      hasWifi: hotel.hasWifi,
      hasPool: hotel.hasPool,
      hasRestaurant: hotel.hasRestaurant,
      hasParking: hotel.hasParking,
    );
  }

  static admin.Hotel toAdminModel(HotelModel hotel) {
    return admin.Hotel(
      id: hotel.id,
      name: hotel.name,
      location: hotel.location,
      price: hotel.price,
      imageUrl: hotel.imageUrl,
      hasWifi: hotel.hasWifi,
      hasPool: hotel.hasPool,
      hasRestaurant: hotel.hasRestaurant,
      hasParking: hotel.hasParking,
    );
  }
} 