import 'dart:async';

import 'package:flutter/material.dart';

import '../client.dart';

class GreetingsScreen extends StatefulWidget {
  const GreetingsScreen({super.key});

  @override
  State<GreetingsScreen> createState() => _GreetingsScreenState();
}

class _GreetingsScreenState extends State<GreetingsScreen> {
  String _currentHolder = 'Loading...';
  bool _isAlive = true;
  DateTime? _expiresAt;
  Timer? _timer;
  int _secondsRemaining = 0;

  final _newHolderController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _loadCurrentHolder().then((_) {
      _updateCountdown();

      _timer = Timer.periodic(
        const Duration(seconds: 1),
        (_) {
          _updateCountdown();
        },
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _newHolderController.dispose();
    super.dispose();
  }

  Future<void> _loadCurrentHolder() async {
    final flame = await client.flame.getFlame();

    setState(() {
      _currentHolder = flame.currentHolder;
      _isAlive = flame.isAlive;
      _expiresAt = flame.expiresAt;
    });
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
            const SizedBox(height: 40),
            const SizedBox(height: 40),
            SizedBox(
              width: 300,
              child: TextField(
                controller: _newHolderController,
                decoration: const InputDecoration(
                  labelText: 'Who should receive the flame?',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: !_isAlive
                  ? null
                  : () async {
                      final name = _newHolderController.text.trim();

                      if (name.isEmpty) {
                        return;
                      }

                      final flame = await client.flame.passFlame(name);

                      setState(() {
                        _currentHolder = flame.currentHolder;
                        _isAlive = flame.isAlive;
                        _expiresAt = flame.expiresAt;
                        _newHolderController.clear();
                      });

                      _updateCountdown();
                    },
              child: const Text('PASS THE FLAME'),
            ),
            if (!_isAlive) ...[
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  final flame = await client.flame.startNewFlame('Pauline');

                  setState(() {
                    _currentHolder = flame.currentHolder;
                    _isAlive = flame.isAlive;
                    _expiresAt = flame.expiresAt;
                    _newHolderController.clear();
                  });

                  _updateCountdown();
                },
                child: const Text('START NEW FLAME'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
