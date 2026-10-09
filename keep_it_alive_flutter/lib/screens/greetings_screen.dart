import 'dart:async';

import 'package:flutter/material.dart';

import 'package:keep_it_alive_client/keep_it_alive_client.dart';

import '../client.dart';

class GreetingsScreen extends StatefulWidget {
  const GreetingsScreen({super.key});

  @override
  State<GreetingsScreen> createState() => _GreetingsScreenState();
}

class _GreetingsScreenState extends State<GreetingsScreen> {
  String _currentHolder = 'Loading...';
  int? _currentHolderId;
  bool _isAlive = true;
  DateTime? _expiresAt;
  int? _roundNumber;
  Timer? _timer;
  int _secondsRemaining = 0;
  List<Player> _players = [];
  Player? _currentPlayer;
  Player? _playerToEnterAs;
  Player? _selectedPlayer;
  List<Transfer> _transfers = [];

  @override
  void initState() {
    super.initState();

    _loadPlayers();

    _loadCurrentHolder().then((_) async {
      await _loadTransfers();

      _updateCountdown();

      _timer = Timer.periodic(
        const Duration(seconds: 1),
        (_) async {
          _updateCountdown();
          await _loadCurrentHolder();
        },
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _loadPlayers() async {
    final players = await client.player.getPlayers();

    setState(() {
      _players = players;
    });
  }

  Future<void> _loadTransfers() async {
    final transfers = await client.transfer.getTransfers();

    setState(() {
      _transfers = transfers
          .where((transfer) => transfer.roundNumber == _roundNumber)
          .toList();
    });
  }

  String _playerName(int playerId) {
    for (final player in _players) {
      if (player.id == playerId) {
        return player.name;
      }
    }

    return 'Unknown';
  }

  Future<void> _loadCurrentHolder() async {
    final flame = await client.flame.getFlame();

    final holderChanged =
        _currentHolder != 'Loading...' && _currentHolder != flame.currentHolder;

    final roundChanged =
        _roundNumber != null && _roundNumber != flame.roundNumber;

    setState(() {
      _currentHolder = flame.currentHolder;
      _currentHolderId = flame.currentHolderId;
      _isAlive = flame.isAlive;
      _expiresAt = flame.expiresAt;
      _roundNumber = flame.roundNumber;
    });

    if (holderChanged || roundChanged) {
      await _loadTransfers();
    }
  }

  void _updateCountdown() {
    final expiresAt = _expiresAt;

    if (expiresAt == null || !_isAlive) {
      setState(() {
        _secondsRemaining = 0;
      });
      return;
    }

    final difference = expiresAt.difference(DateTime.now().toUtc());

    final remainingMilliseconds = difference.inMilliseconds;

    setState(() {
      _secondsRemaining = remainingMilliseconds > 0
          ? (remainingMilliseconds / 1000).ceil()
          : 0;
    });

    if (remainingMilliseconds <= 0) {
      _loadCurrentHolder();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_currentPlayer == null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                '🔥',
                style: TextStyle(fontSize: 80),
              ),
              const SizedBox(height: 16),
              const Text(
                'KEEP IT ALIVE',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Choose your player to enter the game',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 32),

              SizedBox(
                width: 300,
                child: DropdownButtonFormField<Player>(
                  value: _playerToEnterAs,
                  decoration: const InputDecoration(
                    labelText: 'Choose your player',
                    border: OutlineInputBorder(),
                  ),
                  items: _players.map((player) {
                    return DropdownMenuItem<Player>(
                      value: player,
                      child: Text(player.name),
                    );
                  }).toList(),
                  onChanged: (player) {
                    setState(() {
                      _playerToEnterAs = player;
                    });
                  },
                ),
              ),

              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: _playerToEnterAs == null
                    ? null
                    : () {
                        setState(() {
                          _currentPlayer = _playerToEnterAs;
                        });
                      },
                child: const Text('ENTER GAME'),
              ),
            ],
          ),
        ),
      );
    }
    return SingleChildScrollView(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                '🔥',
                style: TextStyle(fontSize: 80),
              ),
              const SizedBox(height: 16),
              const Text(
                'KEEP IT ALIVE',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 40),
              const Text(
                'Current holder',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 8),
              Text(
                _currentHolder,
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                _isAlive
                    ? '$_secondsRemaining seconds remaining'
                    : 'The flame has died 💀',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 24),

              SizedBox(
                width: 300,
                child: DropdownButtonFormField<Player>(
                  value: _selectedPlayer?.id == _currentHolderId
                      ? null
                      : _selectedPlayer,
                  decoration: const InputDecoration(
                    labelText: 'Who should receive the flame?',
                    border: OutlineInputBorder(),
                  ),
                  items: _players.map((player) {
                    return DropdownMenuItem<Player>(
                      value: player,
                      child: Text(player.name),
                    );
                  }).toList(),
                  onChanged: _isAlive
                      ? (player) {
                          setState(() {
                            _selectedPlayer = player;
                          });
                        }
                      : null,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed:
                    !_isAlive ||
                        _selectedPlayer == null ||
                        _currentPlayer?.id != _currentHolderId
                    ? null
                    : () async {
                        final player = _selectedPlayer!;

                        if (player.id == null) {
                          return;
                        }

                        final currentPlayer = _currentPlayer;

                        if (currentPlayer == null || currentPlayer.id == null) {
                          return;
                        }

                        try {
                          final flame = await client.flame.passFlame(
                            currentPlayer.id!,
                            player.id!,
                          );

                          setState(() {
                            _currentHolder = flame.currentHolder;
                            _currentHolderId = flame.currentHolderId;
                            _isAlive = flame.isAlive;
                            _expiresAt = flame.expiresAt;
                            _roundNumber = flame.roundNumber;
                            _selectedPlayer = null;
                          });

                          _updateCountdown();
                          await _loadTransfers();
                        } catch (error) {
                          if (!mounted) return;

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'You cannot pass the flame because you are not the current holder.',
                              ),
                            ),
                          );
                        }
                      },
                child: const Text('PASS THE FLAME'),
              ),
              const SizedBox(height: 32),

              if (_transfers.isNotEmpty) ...[
                const Text(
                  'FLAME JOURNEY 🔥',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),

                ..._transfers.reversed.take(5).map((transfer) {
                  final fromName = _playerName(transfer.fromPlayerId);
                  final toName = _playerName(transfer.toPlayerId);
                  final time = transfer.transferredAt.toLocal();

                  final formattedTime =
                      '${time.hour.toString().padLeft(2, '0')}:'
                      '${time.minute.toString().padLeft(2, '0')}:'
                      '${time.second.toString().padLeft(2, '0')}';

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Text(
                      '$fromName → $toName  •  $formattedTime',
                      style: const TextStyle(fontSize: 16),
                    ),
                  );
                }),
              ],
              if (!_isAlive) ...[
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    final currentPlayer = _currentPlayer;

                    if (currentPlayer == null || currentPlayer.id == null) {
                      return;
                    }

                    final flame = await client.flame.startNewFlame(
                      currentPlayer.id!,
                    );

                    setState(() {
                      _currentHolder = flame.currentHolder;
                      _currentHolderId = flame.currentHolderId;
                      _isAlive = flame.isAlive;
                      _expiresAt = flame.expiresAt;
                      _roundNumber = flame.roundNumber;
                      _selectedPlayer = null;
                    });

                    _updateCountdown();
                    await _loadTransfers();
                  },
                  child: const Text('START NEW FLAME'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
