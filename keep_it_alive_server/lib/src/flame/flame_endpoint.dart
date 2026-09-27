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
    String newHolder,
  ) async {
    var flame = await Flame.db.findFirstRow(session);

    if (flame == null) {
      throw Exception('No flame exists.');
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
      currentHolder: newHolder,
      isAlive: true,
      expiresAt: DateTime.now().toUtc().add(
        const Duration(seconds: 30),
      ),
    );

    flame = await Flame.db.updateRow(session, flame);

    return flame;
  }

  Future<Flame> startNewFlame(
    Session session,
    String holder,
  ) async {
    var flame = await Flame.db.findFirstRow(session);

    if (flame == null) {
      flame = Flame(
        currentHolder: holder,
        isAlive: true,
        expiresAt: DateTime.now().toUtc().add(
          const Duration(seconds: 30),
        ),
      );

      return await Flame.db.insertRow(session, flame);
    }

    flame = flame.copyWith(
      currentHolder: holder,
      isAlive: true,
      expiresAt: DateTime.now().toUtc().add(
        const Duration(seconds: 30),
      ),
    );

    return await Flame.db.updateRow(session, flame);
  }
}
