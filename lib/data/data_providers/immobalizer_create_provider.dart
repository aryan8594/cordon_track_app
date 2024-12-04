import 'package:cordon_track_app/data/models/immobaizer_create_model.dart';
import 'package:cordon_track_app/data/repositories/immobalizer_create_api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final immobalizerCreateRepoProvider = Provider<ImmobalizerCreateRepository>((ref) {
  return ImmobalizerCreateRepository(ref);
});

// Fetch immobilizer creation data with parameters
final immobalizerCreateProvider = FutureProvider.family<ImmobalizerCreateModel?, Map<String, String>>((ref, params) async {
  final repository = ref.read(immobalizerCreateRepoProvider);

  final vehicleArray = params['vehicleArray']!;
  final event = params['event']!;

  return await repository.fetchImmobalizerCreate(vehicleArray, event);
});
