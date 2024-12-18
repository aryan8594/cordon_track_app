import 'package:cordon_track_app/data/models/immobilizer_create_model.dart';
import 'package:cordon_track_app/data/repositories/immobilizer_create_api.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

final immobilizerCreateRepoProvider = Provider<ImmobilizerCreateRepository>((ref) {
  return ImmobilizerCreateRepository(ref);
});

// Fetch immobilizer creation data with parameters
final immobilizerCreateProvider = FutureProvider.family<ImmobilizerCreateModel?, Map<String, String>>((ref, params) async {
  final repository = ref.read(immobilizerCreateRepoProvider);

  final vehicleArray = params['vehicleArray']!;
  final event = params['event']!;

  return await repository.fetchImmobilizerCreate(vehicleArray, event);
});
