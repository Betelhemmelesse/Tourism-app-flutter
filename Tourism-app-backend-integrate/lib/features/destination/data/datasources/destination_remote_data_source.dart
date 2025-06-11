import '../models/destination_model.dart';

abstract class DestinationRemoteDataSource {
  Future<List<DestinationModel>> getDestinations();
  Future<void> toggleFavorite(String destinationId);
  Future<List<DestinationModel>> getFavoriteDestinations();
}

class DestinationRemoteDataSourceImpl implements DestinationRemoteDataSource {
  List<DestinationModel> _mockData = [
    DestinationModel(
      id: '1',
      title:
          "Discover Ethiopia's breathtaking landscapes.from falls to desert to mountains",
      imageUrl:
          'https://i.pinimg.com/474x/d8/dc/96/d8dc96e414e3cc4f696e04608878cddd.jpg',
    ),
    DestinationModel(
      id: '2',
      title:
          "Discover Ethiopia's Ancient Architecture:Axum And Lalibela's Timeless wonders.",
      imageUrl:
          'https://encrypted-tbn1.gstatic.com/images?q=tbn:ANd9GcTRq1UbQJ0GhkPGwY-Z4YzA1H8Qkd_1u1tW0wCDfSFLt1ATj4fn',
    ),
    DestinationModel(
      id: '3',
      title:
          "Ancient Traditions, Vibrant Festivals And  Warm Hospitality. Experience All In Ethiopia",
      imageUrl:
          'https://i.pinimg.com/136x136/11/08/d1/1108d184e6494d67f71dd96aaf59a072.jpg',
    ),
    DestinationModel(
      id: '4',
      title:
          "Ethiopia's festivals A journey into ancient religious traditions and vibrant culture.",
      imageUrl: 'https://pbs.twimg.com/media/DoM2Qj8UUAA0RKj.jpg',
    ),
  ];

  @override
  Future<List<DestinationModel>> getDestinations() async {
    await Future.delayed(Duration(seconds: 1));
    return _mockData;
  }

  @override
  Future<void> toggleFavorite(String destinationId) async {
    await Future.delayed(Duration(milliseconds: 300)); // simulate delay
    _mockData =
        _mockData.map((destination) {
          if (destination.id == destinationId) {
            return destination.copyWith(isFavorite: !destination.isFavorite);
          }
          return destination;
        }).toList();
  }

  @override
  Future<List<DestinationModel>> getFavoriteDestinations() async {
    await Future.delayed(Duration(milliseconds: 500)); // simulate delay
    return _mockData.where((destination) => destination.isFavorite).toList();
  }
}
