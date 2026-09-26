import 'package:flutter/material.dart';

import '../client.dart';

class GreetingsScreen extends StatefulWidget {
  const GreetingsScreen({super.key});

  @override
  State<GreetingsScreen> createState() => _GreetingsScreenState();
}

class _GreetingsScreenState extends State<GreetingsScreen> {
  String _currentHolder = 'Loading...';
  final _newHolderController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadCurrentHolder();
  }

  @override
  void dispose() {
    _newHolderController.dispose();
    super.dispose();
  }

  Future<void> _loadCurrentHolder() async {
    final holder = await client.flame.getCurrentHolder();

    setState(() {
      _currentHolder = holder;
    });
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
              onPressed: () async {
                final name = _newHolderController.text.trim();

                if (name.isEmpty) {
                  return;
                }

                final newHolder = await client.flame.passFlame(name);

                setState(() {
                  _currentHolder = newHolder;
                  _newHolderController.clear();
                });
              },
              child: const Text('PASS THE FLAME'),
            ),
          ],
        ),
      ),
    );
  }
}
