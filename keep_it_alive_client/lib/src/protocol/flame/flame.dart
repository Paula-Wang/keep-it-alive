/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _isc;

abstract class Flame
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  Flame._({
    this.id,
    required this.currentHolder,
    required this.isAlive,
  });

  factory Flame({
    int? id,
    required String currentHolder,
    required bool isAlive,
  }) = _FlameImpl;

  factory Flame.fromJson(Map<String, dynamic> jsonSerialization) {
    return Flame(
      id: jsonSerialization['id'] as int?,
      currentHolder: jsonSerialization['currentHolder'] as String,
      isAlive: _isc.BoolJsonExtension.fromJson(jsonSerialization['isAlive']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String currentHolder;

  bool isAlive;

  /// Returns a shallow copy of this [Flame]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  Flame copyWith({
    int? id,
    String? currentHolder,
    bool? isAlive,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Flame',
      if (id != null) 'id': id,
      'currentHolder': currentHolder,
      'isAlive': isAlive,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Flame',
      if (id != null) 'id': id,
      'currentHolder': currentHolder,
      'isAlive': isAlive,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _FlameImpl extends Flame {
  _FlameImpl({
    int? id,
    required String currentHolder,
    required bool isAlive,
  }) : super._(
         id: id,
         currentHolder: currentHolder,
         isAlive: isAlive,
       );

  /// Returns a shallow copy of this [Flame]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  Flame copyWith({
    Object? id = _Undefined,
    String? currentHolder,
    bool? isAlive,
  }) {
    return Flame(
      id: id is int? ? id : this.id,
      currentHolder: currentHolder ?? this.currentHolder,
      isAlive: isAlive ?? this.isAlive,
    );
  }
}
