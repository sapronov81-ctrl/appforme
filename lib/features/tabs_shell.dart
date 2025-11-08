import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TabsShell extends StatefulWidget {
  final Widget child;
  const TabsShell({super.key, required this.child});

  @override
  State<TabsShell> createState() => _TabsShellState();
}

class _TabsShellState extends State<TabsShell> {
  int _index = 0;
  final _tabs = [
    '/tabs/audit',
    '/tabs/attestation',
    '/tabs/learning',
    '/tabs/drinks',
    '/tabs/trends',
    '/tabs/library',
    '/tabs/settings',
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) context.go(_tabs[_index]);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) {
          setState(() => _index = i);
          context.go(_tabs[i]);
        },
        destinations: const [
          NavigationDestination(icon: Icon(Icons.checklist), label: 'Аудит'),
          NavigationDestination(icon: Icon(Icons.badge_outlined), label: 'Аттестация'),
          NavigationDestination(icon: Icon(Icons.school_outlined), label: 'Обучение'),
          NavigationDestination(icon: Icon(Icons.local_cafe_outlined), label: 'Напитки'),
          NavigationDestination(icon: Icon(Icons.public), label: 'Тренды'),
          NavigationDestination(icon: Icon(Icons.folder_open), label: 'Материалы'),
          NavigationDestination(icon: Icon(Icons.settings), label: 'Настройки'),
        ],
      ),
    );
  }
}
