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
    const background = Color(0xFFF2F2F0);
    const surface = Color(0xFFFFFFFF);
    const text = Color(0xFF171717);
    const muted = Color(0xFF6B6B68);
    const border = Color(0xFFD8D8D4);
    const accent = Color(0xFFFF4D2E);
    const accentSoft = Color(0xFFFFE4DE);
    const darkSurface = Color(0xFF20201F);

    // =========================================================
    // ENTRY SCREEN
    // =========================================================
    if (_currentPlayer == null) {
      return Container(
        color: background,
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: Column(
                children: [
                  const Text(
                    '🔥',
                    style: TextStyle(fontSize: 76),
                  ),

                  const SizedBox(height: 14),

                  const Text(
                    'KEEP IT ALIVE',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: text,
                      fontSize: 38,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.5,
                    ),
                  ),

                  const SizedBox(height: 18),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: darkSurface,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'ONE FLAME  •  ONE HOLDER  •  30 SECONDS',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1,
                      ),
                    ),
                  ),

                  const SizedBox(height: 18),

                  const Text(
                    'Pass it before time runs out.\nBreak the chain and it\'s over.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: muted,
                      fontSize: 16,
                      height: 1.5,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  const SizedBox(height: 38),

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(22),
                    decoration: BoxDecoration(
                      color: surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: border),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text(
                          'CHOOSE YOUR PLAYER',
                          style: TextStyle(
                            color: text,
                            fontSize: 13,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1,
                          ),
                        ),

                        const SizedBox(height: 14),

                        DropdownButtonFormField<Player>(
                          value: _playerToEnterAs,
                          dropdownColor: surface,
                          style: const TextStyle(
                            color: text,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Select player',
                            hintStyle: const TextStyle(color: muted),
                            filled: true,
                            fillColor: background,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 17,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(color: border),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                color: accent,
                                width: 2,
                              ),
                            ),
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

                        const SizedBox(height: 14),

                        SizedBox(
                          height: 56,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: accent,
                              foregroundColor: Colors.white,
                              disabledBackgroundColor: const Color(0xFFD9D9D6),
                              disabledForegroundColor: const Color(0xFF999995),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onPressed: _playerToEnterAs == null
                                ? null
                                : () {
                                    setState(() {
                                      _currentPlayer = _playerToEnterAs;
                                    });
                                  },
                            child: const Text(
                              'ENTER GAME  →',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 0.8,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    final bool iHaveTheFlame =
        _isAlive && _currentPlayer?.id == _currentHolderId;

    final int passCount = _transfers.length;
    final bool danger = _isAlive && _secondsRemaining <= 10;
    final bool critical = _isAlive && _secondsRemaining <= 5;

    // =========================================================
    // GAME SCREEN
    // =========================================================
    return Container(
      color: danger ? const Color(0xFFFFF0EC) : background,
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 22,
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: Column(
              children: [
                // PLAYER / ROUND / SCORE
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'YOU: ${_currentPlayer!.name.toUpperCase()}',
                        style: const TextStyle(
                          color: text,
                          fontSize: 13,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ),

                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 7,
                      ),
                      decoration: BoxDecoration(
                        color: darkSurface,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'ROUND ${_roundNumber ?? '-'}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0.7,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 11,
                  ),
                  decoration: BoxDecoration(
                    color: surface,
                    border: Border.all(color: border),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        '🔥',
                        style: TextStyle(fontSize: 18),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '$passCount ${passCount == 1 ? 'PASS' : 'PASSES'} IN THE CHAIN',
                        style: const TextStyle(
                          color: text,
                          fontSize: 13,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0.7,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 18),

                // =================================================
                // MAIN GAME PANEL
                // =================================================
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: danger
                          ? accent
                          : iHaveTheFlame
                          ? accent
                          : border,
                      width: danger || iHaveTheFlame ? 2 : 1,
                    ),
                  ),
                  child: Column(
                    children: [
                      // =================================================
                      // ALIVE
                      // =================================================
                      if (_isAlive) ...[
                        const Text(
                          '🔥',
                          style: TextStyle(fontSize: 44),
                        ),

                        const SizedBox(height: 8),

                        Text(
                          iHaveTheFlame
                              ? 'YOU HAVE THE FLAME'
                              : '${_currentHolder.toUpperCase()} HAS IT',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: iHaveTheFlame ? accent : text,
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1,
                          ),
                        ),

                        const SizedBox(height: 20),

                        // TIMER
                        Text(
                          '$_secondsRemaining',
                          style: TextStyle(
                            color: danger ? accent : text,
                            fontSize: critical ? 100 : 92,
                            height: 0.95,
                            fontWeight: FontWeight.w900,
                          ),
                        ),

                        const SizedBox(height: 6),

                        Text(
                          critical ? 'SECONDS. MOVE!' : 'SECONDS LEFT',
                          style: TextStyle(
                            color: danger ? accent : muted,
                            fontSize: 13,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 2,
                          ),
                        ),

                        const SizedBox(height: 20),

                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: (_secondsRemaining / 30).clamp(0.0, 1.0),
                            minHeight: 10,
                            backgroundColor: const Color(0xFFE7E7E3),
                            valueColor: const AlwaysStoppedAnimation<Color>(
                              accent,
                            ),
                          ),
                        ),

                        const SizedBox(height: 18),

                        Text(
                          iHaveTheFlame
                              ? critical
                                    ? 'PASS IT. NOW.'
                                    : danger
                                    ? 'HURRY — THE CLOCK IS DYING.'
                                    : 'Pick someone. Keep the chain alive.'
                              : danger
                              ? 'Will $_currentHolder make it?'
                              : '$_currentHolder\'s turn — the flame is on their screen.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: danger ? accent : muted,
                            fontSize: danger ? 16 : 15,
                            fontWeight: danger
                                ? FontWeight.w900
                                : FontWeight.w600,
                          ),
                        ),

                        // ===============================================
                        // HOLDER ACTIONS
                        // ===============================================
                        if (iHaveTheFlame) ...[
                          const SizedBox(height: 26),

                          Container(
                            height: 2,
                            color: border,
                          ),

                          const SizedBox(height: 22),

                          const Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'WHO GETS IT NEXT?',
                              style: TextStyle(
                                color: text,
                                fontSize: 13,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 0.8,
                              ),
                            ),
                          ),

                          const SizedBox(height: 10),

                          DropdownButtonFormField<Player>(
                            value: _selectedPlayer?.id == _currentHolderId
                                ? null
                                : _selectedPlayer,
                            dropdownColor: surface,
                            style: const TextStyle(
                              color: text,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                            decoration: InputDecoration(
                              hintText: 'Choose next holder',
                              hintStyle: const TextStyle(color: muted),
                              filled: true,
                              fillColor: background,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 17,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(color: border),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                  color: accent,
                                  width: 2,
                                ),
                              ),
                            ),
                            items: _players
                                .where(
                                  (player) => player.id != _currentHolderId,
                                )
                                .map((player) {
                                  return DropdownMenuItem<Player>(
                                    value: player,
                                    child: Text(player.name),
                                  );
                                })
                                .toList(),
                            onChanged: (player) {
                              setState(() {
                                _selectedPlayer = player;
                              });
                            },
                          ),

                          const SizedBox(height: 12),

                          SizedBox(
                            width: double.infinity,
                            height: 58,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: accent,
                                foregroundColor: Colors.white,
                                disabledBackgroundColor: const Color(
                                  0xFFD9D9D6,
                                ),
                                disabledForegroundColor: const Color(
                                  0xFF999995,
                                ),
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              onPressed: _selectedPlayer == null
                                  ? null
                                  : () async {
                                      final player = _selectedPlayer!;
                                      final currentPlayer = _currentPlayer;

                                      if (player.id == null ||
                                          currentPlayer == null ||
                                          currentPlayer.id == null) {
                                        return;
                                      }

                                      try {
                                        final flame = await client.flame
                                            .passFlame(
                                              currentPlayer.id!,
                                              player.id!,
                                            );

                                        setState(() {
                                          _currentHolder = flame.currentHolder;
                                          _currentHolderId =
                                              flame.currentHolderId;
                                          _isAlive = flame.isAlive;
                                          _expiresAt = flame.expiresAt;
                                          _roundNumber = flame.roundNumber;
                                          _selectedPlayer = null;
                                        });

                                        _updateCountdown();
                                        await _loadTransfers();
                                      } catch (error) {
                                        if (!mounted) return;

                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                              'The flame could not be passed. Try again.',
                                            ),
                                          ),
                                        );
                                      }
                                    },
                              child: Text(
                                danger
                                    ? 'PASS IT NOW  🔥 →'
                                    : 'PASS THE FLAME  🔥 →',
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 0.6,
                                ),
                              ),
                            ),
                          ),
                        ],

                        // ===============================================
                        // WAITING PLAYER
                        // ===============================================
                        if (!iHaveTheFlame) ...[
                          const SizedBox(height: 26),

                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 15,
                            ),
                            decoration: BoxDecoration(
                              color: background,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: border),
                            ),
                            child: Text(
                              danger
                                  ? '●  WATCH THE CLOCK  ●'
                                  : '●  WAITING FOR ${_currentHolder.toUpperCase()}  ●',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: danger ? accent : muted,
                                fontSize: 12,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 1.2,
                              ),
                            ),
                          ),
                        ],
                      ]
                      // =================================================
                      // DEAD
                      // =================================================
                      else ...[
                        const Text(
                          '🔥',
                          style: TextStyle(fontSize: 46),
                        ),

                        const SizedBox(height: 10),

                        const Text(
                          'FLAME OUT.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: text,
                            fontSize: 34,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1.3,
                          ),
                        ),

                        const SizedBox(height: 7),

                        Text(
                          'THE CHAIN BROKE AT $passCount ${passCount == 1 ? 'PASS' : 'PASSES'}',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: accent,
                            fontSize: 13,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1,
                          ),
                        ),

                        const SizedBox(height: 24),

                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color: background,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: border),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  children: [
                                    Text(
                                      '$passCount',
                                      style: const TextStyle(
                                        color: text,
                                        fontSize: 36,
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                    const Text(
                                      'CHAIN SCORE',
                                      style: TextStyle(
                                        color: muted,
                                        fontSize: 10,
                                        fontWeight: FontWeight.w900,
                                        letterSpacing: 1,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              Container(
                                width: 1,
                                height: 48,
                                color: border,
                              ),

                              Expanded(
                                child: Column(
                                  children: [
                                    Text(
                                      _currentHolder.toUpperCase(),
                                      textAlign: TextAlign.center,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        color: text,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    const Text(
                                      'LAST HOLDER',
                                      style: TextStyle(
                                        color: muted,
                                        fontSize: 10,
                                        fontWeight: FontWeight.w900,
                                        letterSpacing: 1,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 22),

                        Text(
                          passCount == 0
                              ? 'You can do better than that.'
                              : 'Think you can beat $passCount?',
                          style: const TextStyle(
                            color: text,
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                          ),
                        ),

                        const SizedBox(height: 14),

                        SizedBox(
                          width: double.infinity,
                          height: 58,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: accent,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onPressed: () async {
                              final currentPlayer = _currentPlayer;

                              if (currentPlayer == null ||
                                  currentPlayer.id == null) {
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
                            child: const Text(
                              'PLAY AGAIN  🔥 →',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 0.7,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),

                // =================================================
                // CHAIN HISTORY
                // =================================================
                if (_transfers.isNotEmpty) ...[
                  const SizedBox(height: 16),

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: border),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Expanded(
                              child: Text(
                                'THE CHAIN',
                                style: TextStyle(
                                  color: text,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 1,
                                ),
                              ),
                            ),
                            Text(
                              '$passCount ${passCount == 1 ? 'PASS' : 'PASSES'}',
                              style: const TextStyle(
                                color: accent,
                                fontSize: 11,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
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

                          return Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 9,
                            ),
                            decoration: const BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: Color(0xFFE8E8E5),
                                ),
                              ),
                            ),
                            child: Row(
                              children: [
                                const Text(
                                  '🔥',
                                  style: TextStyle(fontSize: 15),
                                ),
                                const SizedBox(width: 10),

                                Expanded(
                                  child: Text(
                                    '$fromName  →  $toName',
                                    style: const TextStyle(
                                      color: text,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),

                                Text(
                                  formattedTime,
                                  style: const TextStyle(
                                    color: muted,
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                ],

                const SizedBox(height: 18),

                const Text(
                  'DON\'T BREAK THE CHAIN.',
                  style: TextStyle(
                    color: muted,
                    fontSize: 11,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.4,
                  ),
                ),

                const SizedBox(height: 18),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
