import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';

class TransferEndpoint extends Endpoint {
  Future<List<Transfer>> getTransfers(Session session) async {
    return await Transfer.db.find(session);
  }
}