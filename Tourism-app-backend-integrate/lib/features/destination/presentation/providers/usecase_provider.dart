import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tourism_app/features/destination/domain/usecases/toggle_favorite_usecase.dart';
import 'package:tourism_app/features/destination/presentation/providers/destination_repository_provider.dart';

import '../../domain/usecases/get_destinations_usecase.dart';

final getDestinationsUseCaseProvider = Provider<GetDestinationsUsecase>((ref) {
  final repository = ref.watch(destinationRepositoryProvider);
  return GetDestinationsUsecase(repository);
});

final toggleFavoriteUseCaseProvider = Provider<ToggleFavoriteUsecase>((ref) {
  final repository = ref.watch(destinationRepositoryProvider);
  return ToggleFavoriteUsecase(repository);
});
