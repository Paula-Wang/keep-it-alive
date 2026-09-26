import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';

class FlameEndpoint extends Endpoint {
  Future<String> getCurrentHolder(Session session) async {
    var flame = await Flame.db.findFirstRow(session);

    if (flame == null) {
      flame = Flame(
        currentHolder: 'Pauline',
        isAlive: true,
      );

      flame = await Flame.db.insertRow(session, flame);
    }

    return flame.currentHolder;
  }

  Future<String> passFlame(
    Session session,
    String newHolder,
  ) async {
    var flame = await Flame.db.findFirstRow(session);

    if (flame == null) {
      throw Exception('No flame exists.');
    }

    flame = flame.copyWith(
      currentHolder: newHolder,
    );

    flame = await Flame.db.updateRow(session, flame);

    return flame.currentHolder;
  }
}
