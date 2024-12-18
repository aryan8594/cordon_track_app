import 'package:cordon_track_app/data/models/immobilizer_list_model.dart';
import 'package:cordon_track_app/data/repositories/immobilizer_list_api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final immobilizerListProvider = FutureProvider.autoDispose<ImmobilizerListModel?>((ref) async {
  return ImmobilizerListRepository(ref).fetchImmobilizerListData();
});
