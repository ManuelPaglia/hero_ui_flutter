import 'package:flutter/material.dart';
import 'package:hero_ui_flutter/hero_ui_flutter.dart';

import 'buttons_showcase_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({
    required this.onToggleTheme,
    super.key,
  });

  final VoidCallback onToggleTheme;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Hero UI Flutter'),
        actions: [
          IconButton(
            onPressed: onToggleTheme,
            icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
            tooltip: isDark ? 'Light mode' : 'Dark mode',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Componenti',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 32),
            HUFButton(
              label: 'Bottoni',
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => ButtonsShowcasePage(
                      onToggleTheme: onToggleTheme,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
