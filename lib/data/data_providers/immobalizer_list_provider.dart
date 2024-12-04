import 'package:cordon_track_app/data/models/immobalizer_list_model.dart';
import 'package:cordon_track_app/data/repositories/immobalizer_list_api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final immobalizerListProvider = FutureProvider.autoDispose<ImmobalizerListModel?>((ref) async {
  return ImmobalizerListRepository(ref).fetchImmobalizerListData();
});
