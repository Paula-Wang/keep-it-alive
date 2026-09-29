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

abstract class Transfer
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  Transfer._({
    this.id,
    required this.fromPlayerId,
    required this.toPlayerId,
    required this.transferredAt,
  });

  factory Transfer({
    int? id,
    required int fromPlayerId,
    required int toPlayerId,
    required DateTime transferredAt,
  }) = _TransferImpl;

  factory Transfer.fromJson(Map<String, dynamic> jsonSerialization) {
    return Transfer(
      id: jsonSerialization['id'] as int?,
      fromPlayerId: jsonSerialization['fromPlayerId'] as int,
      toPlayerId: jsonSerialization['toPlayerId'] as int,
      transferredAt: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['transferredAt'],
      ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int fromPlayerId;

  int toPlayerId;

  DateTime transferredAt;

  /// Returns a shallow copy of this [Transfer]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  Transfer copyWith({
    int? id,
    int? fromPlayerId,
    int? toPlayerId,
    DateTime? transferredAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Transfer',
      if (id != null) 'id': id,
      'fromPlayerId': fromPlayerId,
      'toPlayerId': toPlayerId,
      'transferredAt': transferredAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Transfer',
      if (id != null) 'id': id,
      'fromPlayerId': fromPlayerId,
      'toPlayerId': toPlayerId,
      'transferredAt': transferredAt.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _TransferImpl extends Transfer {
  _TransferImpl({
    int? id,
    required int fromPlayerId,
    required int toPlayerId,
    required DateTime transferredAt,
  }) : super._(
         id: id,
         fromPlayerId: fromPlayerId,
         toPlayerId: toPlayerId,
         transferredAt: transferredAt,
       );

  /// Returns a shallow copy of this [Transfer]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  Transfer copyWith({
    Object? id = _Undefined,
    int? fromPlayerId,
    int? toPlayerId,
    DateTime? transferredAt,
  }) {
    return Transfer(
      id: id is int? ? id : this.id,
      fromPlayerId: fromPlayerId ?? this.fromPlayerId,
      toPlayerId: toPlayerId ?? this.toPlayerId,
      transferredAt: transferredAt ?? this.transferredAt,
    );
  }
}
