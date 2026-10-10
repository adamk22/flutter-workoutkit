import 'package:collection/collection.dart';

const _deepEquality = DeepCollectionEquality();

/// Value equality based on `toJson()`: two objects are equal when they have
/// the same runtime type and serialize to the same JSON.
mixin JsonValueEquality {
  /// The JSON representation used for equality and hashing.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other.runtimeType == runtimeType &&
          other is JsonValueEquality &&
          _deepEquality.equals(toJson(), other.toJson()));

  @override
  int get hashCode => Object.hash(runtimeType, _deepEquality.hash(toJson()));
}
