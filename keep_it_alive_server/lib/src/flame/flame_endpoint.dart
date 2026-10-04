import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';

class FlameEndpoint extends Endpoint {
  Future<String> getCurrentHolder(Session session) async {
    var flame = await Flame.db.findFirstRow(session);

    if (flame == null) {
      flame = Flame(
        currentHolder: 'Pauline',
        isAlive: true,
        expiresAt: DateTime.now().toUtc().add(
          const Duration(seconds: 30),
        ),
      );

      flame = await Flame.db.insertRow(session, flame);
    }

    return flame.currentHolder;
  }

  Future<Flame> getFlame(Session session) async {
    var flame = await Flame.db.findFirstRow(session);

    if (flame == null) {
      throw Exception('No flame exists.');
    }

    if (flame.roundNumber == null) {
      flame = flame.copyWith(
        roundNumber: 1,
      );

      flame = await Flame.db.updateRow(session, flame);
    }

    if (flame.expiresAt == null && flame.isAlive) {
      flame = flame.copyWith(
        expiresAt: DateTime.now().toUtc().add(
          const Duration(seconds: 30),
        ),
      );

      flame = await Flame.db.updateRow(session, flame);
    }

    final expiresAt = flame.expiresAt;

    if (expiresAt != null &&
        flame.isAlive &&
        DateTime.now().toUtc().isAfter(expiresAt)) {
      flame = flame.copyWith(
        isAlive: false,
      );

      flame = await Flame.db.updateRow(session, flame);
    }

    return flame;
  }

  Future<Flame> passFlame(
    Session session,
    int newHolderId,
  ) async {
    final newHolder = await Player.db.findById(
      session,
      newHolderId,
    );

    if (newHolder == null) {
      throw Exception('Player does not exist.');
    }
    var flame = await Flame.db.findFirstRow(session);

    if (flame == null) {
      throw Exception('No flame exists.');
    }

    final previousHolderId = flame.currentHolderId;

    if (previousHolderId == null) {
      throw Exception('Current holder is not linked to a player.');
    }

    final expiresAt = flame.expiresAt;
    final now = DateTime.now().toUtc();

    if (!flame.isAlive || (expiresAt != null && now.isAfter(expiresAt))) {
      if (flame.isAlive) {
        flame = flame.copyWith(
          isAlive: false,
        );

        await Flame.db.updateRow(session, flame);
      }

      throw Exception('The flame has died.');
    }

    flame = flame.copyWith(
      currentHolder: newHolder.name,
      currentHolderId: newHolder.id,
      isAlive: true,
      expiresAt: DateTime.now().toUtc().add(
        const Duration(seconds: 30),
      ),
    );

    flame = await Flame.db.updateRow(session, flame);

    await Transfer.db.insertRow(
      session,
      Transfer(
        fromPlayerId: previousHolderId,
        toPlayerId: newHolder.id!,
        transferredAt: DateTime.now().toUtc(),
        roundNumber: flame.roundNumber,
      ),
    );

    return flame;
  }

  Future<Flame> startNewFlame(
    Session session,
    int holderId,
  ) async {
    final holder = await Player.db.findById(
      session,
      holderId,
    );

    if (holder == null) {
      throw Exception('Player does not exist.');
    }

    var flame = await Flame.db.findFirstRow(session);

    if (flame == null) {
      flame = Flame(
        currentHolder: holder.name,
        currentHolderId: holder.id,
        isAlive: true,
        roundNumber: 1,
        expiresAt: DateTime.now().toUtc().add(
          const Duration(seconds: 30),
        ),
      );

      return await Flame.db.insertRow(session, flame);
    }

    flame = flame.copyWith(
      currentHolder: holder.name,
      currentHolderId: holder.id,
      isAlive: true,
      expiresAt: DateTime.now().toUtc().add(
        const Duration(seconds: 30),
      ),
      roundNumber: (flame.roundNumber ?? 0) + 1,
    );

    return await Flame.db.updateRow(session, flame);
  }
}
