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
}