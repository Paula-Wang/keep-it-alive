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
import 'package:serverpod/serverpod.dart' as _is;

abstract class Flame implements _is.TableRow<int?>, _is.ProtocolSerialization {
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
      isAlive: _is.BoolJsonExtension.fromJson(jsonSerialization['isAlive']),
    );
  }

  static final t = FlameTable();

  static const db = FlameRepository._();

  @override
  int? id;

  String currentHolder;

  bool isAlive;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [Flame]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
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

  static FlameInclude include() {
    return FlameInclude._();
  }

  static FlameIncludeList includeList({
    _is.WhereExpressionBuilder<FlameTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<FlameTable>? orderBy,
    _is.OrderByListBuilder<FlameTable>? orderByList,
    FlameInclude? include,
  }) {
    return FlameIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Flame.t),
      orderByList: orderByList?.call(Flame.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
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
  @_is.useResult
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

class FlameUpdateTable extends _is.UpdateTable<FlameTable> {
  FlameUpdateTable(super.table);

  _is.ColumnValue<String, String> currentHolder(String value) =>
      _is.ColumnValue(
        table.currentHolder,
        value,
      );

  _is.ColumnValue<bool, bool> isAlive(bool value) => _is.ColumnValue(
    table.isAlive,
    value,
  );
}

class FlameTable extends _is.Table<int?> {
  FlameTable({super.tableRelation}) : super(tableName: 'flame') {
    updateTable = FlameUpdateTable(this);
    currentHolder = _is.ColumnString(
      'currentHolder',
      this,
    );
    isAlive = _is.ColumnBool(
      'isAlive',
      this,
    );
  }

  late final FlameUpdateTable updateTable;

  late final _is.ColumnString currentHolder;

  late final _is.ColumnBool isAlive;

  @override
  List<_is.Column> get columns => [
    id,
    currentHolder,
    isAlive,
  ];
}

class FlameInclude extends _is.IncludeObject {
  FlameInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => Flame.t;
}

class FlameIncludeList extends _is.IncludeList {
  FlameIncludeList._({
    _is.WhereExpressionBuilder<FlameTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(Flame.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => Flame.t;
}

class FlameRepository {
  const FlameRepository._();

  /// Returns a list of [Flame]s matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order of the items use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// The maximum number of items can be set by [limit]. If no limit is set,
  /// all items matching the query will be returned.
  ///
  /// [offset] defines how many items to skip, after which [limit] (or all)
  /// items are read from the database.
  ///
  /// ```dart
  /// var persons = await Persons.db.find(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.firstName,
  ///   limit: 100,
  /// );
  /// ```
  Future<List<Flame>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<FlameTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<FlameTable>? orderBy,
    _is.OrderByListBuilder<FlameTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<Flame>(
      where: where?.call(Flame.t),
      orderBy: orderBy?.call(Flame.t),
      orderByList: orderByList?.call(Flame.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [Flame] matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// [offset] defines how many items to skip, after which the next one will be picked.
  ///
  /// ```dart
  /// var youngestPerson = await Persons.db.findFirstRow(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.age,
  /// );
  /// ```
  Future<Flame?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<FlameTable>? where,
    int? offset,
    _is.OrderByBuilder<FlameTable>? orderBy,
    _is.OrderByListBuilder<FlameTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<Flame>(
      where: where?.call(Flame.t),
      orderBy: orderBy?.call(Flame.t),
      orderByList: orderByList?.call(Flame.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [Flame] by its [id] or null if no such row exists.
  Future<Flame?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<Flame>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [Flame]s in the list and returns the inserted rows.
  ///
  /// The returned [Flame]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  ///
  /// If [noReturn] is set to `true`, the inserted rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Flame>> insert(
    _is.DatabaseSession session,
    List<Flame> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<Flame>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [Flame] and returns the inserted row.
  ///
  /// The returned [Flame] will have its `id` field set.
  Future<Flame> insertRow(
    _is.DatabaseSession session,
    Flame row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<Flame>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [Flame]s in the list and returns the resulting rows.
  ///
  /// If a row conflicts on the given [conflictColumns], the existing row is
  /// updated with the new values. Otherwise, a new row is inserted.
  ///
  /// If [updateColumns] is provided, only those columns will be updated on
  /// conflict. If null, all non-conflict, non-id columns are updated.
  ///
  /// If [updateWhere] is provided, the update only applies to rows matching the
  /// given expression. Conflicting rows that don't match are skipped and not
  /// returned, so the resulting list may be shorter than [rows].
  ///
  /// The returned [Flame]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Flame>> upsert(
    _is.DatabaseSession session,
    List<Flame> rows, {
    required _is.ColumnSelections<FlameTable> conflictColumns,
    _is.ColumnSelections<FlameTable>? updateColumns,
    _is.WhereExpressionBuilder<FlameTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<Flame>(
      rows,
      conflictColumns: conflictColumns(Flame.t),
      updateColumns: updateColumns?.call(Flame.t),
      updateWhere: updateWhere?.call(Flame.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [Flame] and returns the resulting row.
  ///
  /// If the row conflicts on the given [conflictColumns], the existing row is
  /// updated. Otherwise, a new row is inserted.
  ///
  /// If [updateColumns] is provided, only those columns will be updated on
  /// conflict. If null, all non-conflict, non-id columns are updated.
  ///
  /// If [updateWhere] is provided, the update only applies when the existing
  /// row matches the expression. Returns `null` if no row was affected — for
  /// example when [updateWhere] does not match the conflicting row.
  ///
  /// The returned [Flame] will have its `id` field set.
  Future<Flame?> upsertRow(
    _is.DatabaseSession session,
    Flame row, {
    required _is.ColumnSelections<FlameTable> conflictColumns,
    _is.ColumnSelections<FlameTable>? updateColumns,
    _is.WhereExpressionBuilder<FlameTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<Flame>(
      row,
      conflictColumns: conflictColumns(Flame.t),
      updateColumns: updateColumns?.call(Flame.t),
      updateWhere: updateWhere?.call(Flame.t),
      transaction: transaction,
    );
  }

  /// Updates all [Flame]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Flame>> update(
    _is.DatabaseSession session,
    List<Flame> rows, {
    _is.ColumnSelections<FlameTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<Flame>(
      rows,
      columns: columns?.call(Flame.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [Flame]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<Flame> updateRow(
    _is.DatabaseSession session,
    Flame row, {
    _is.ColumnSelections<FlameTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<Flame>(
      row,
      columns: columns?.call(Flame.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Flame] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<Flame?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<FlameUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<Flame>(
      id,
      columnValues: columnValues(Flame.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [Flame]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Flame>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<FlameUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<FlameTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<FlameTable>? orderBy,
    _is.OrderByListBuilder<FlameTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<Flame>(
      columnValues: columnValues(Flame.t.updateTable),
      where: where(Flame.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Flame.t),
      orderByList: orderByList?.call(Flame.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [Flame]s in the list and returns the deleted rows.
  ///
  /// To specify the order of the returned rows use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  ///
  /// If [noReturn] is set to `true`, the deleted rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Flame>> delete(
    _is.DatabaseSession session,
    List<Flame> rows, {
    _is.OrderByBuilder<FlameTable>? orderBy,
    _is.OrderByListBuilder<FlameTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<Flame>(
      rows,
      orderBy: orderBy?.call(Flame.t),
      orderByList: orderByList?.call(Flame.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [Flame].
  Future<Flame> deleteRow(
    _is.DatabaseSession session,
    Flame row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<Flame>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  ///
  /// To specify the order of the returned rows use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// If [noReturn] is set to `true`, the deleted rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Flame>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<FlameTable> where,
    _is.OrderByBuilder<FlameTable>? orderBy,
    _is.OrderByListBuilder<FlameTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<Flame>(
      where: where(Flame.t),
      orderBy: orderBy?.call(Flame.t),
      orderByList: orderByList?.call(Flame.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<FlameTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<Flame>(
      where: where?.call(Flame.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [Flame] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<FlameTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<Flame>(
      where: where(Flame.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
