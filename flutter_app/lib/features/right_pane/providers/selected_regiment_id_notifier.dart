import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mongo_dart/mongo_dart.dart';

final selectedRegimentIdProvider = NotifierProvider(
  SelectedRegimentIdNotifier.new,
);

class SelectedRegimentIdNotifier extends Notifier<ObjectId?> {
  @override
  ObjectId? build() => null;

  void update(ObjectId? id) => state = id;

  ObjectId? updateToggle(ObjectId? id) {
    state = (id == state) ? null : id;
    return state;
  }
}
