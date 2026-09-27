import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';

class PlayerEndpoint extends Endpoint {
  Future<Player> createPlayer(
    Session session,
    String name,
  ) async {
    final player = Player(
      name: name,
    );

    return await Player.db.insertRow(session, player);
  }

  Future<List<Player>> getPlayers(Session session) async {
    return await Player.db.find(session);
  }
}
