import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'features/tabs_shell.dart';
import 'features/audit/audit_page.dart';
import 'features/attestation/attestation_flow.dart';
import 'features/learning/learning_page.dart';
import 'features/drinks/drinks_page.dart';
import 'features/trends/trends_page.dart';
import 'features/library/library_page.dart';
import 'features/settings/settings_page.dart';

final router = GoRouter(
  initialLocation: '/tabs',
  routes: [
    ShellRoute(
      builder: (context, state, child) => TabsShell(child: child),
      routes: [
        GoRoute(path: '/tabs/audit', builder: (ctx, st) => const AuditPage()),
        GoRoute(path: '/tabs/attestation', builder: (ctx, st) => const AttestationFlow()),
        GoRoute(path: '/tabs/learning', builder: (ctx, st) => const LearningPage()),
        GoRoute(path: '/tabs/drinks', builder: (ctx, st) => const DrinksPage()),
        GoRoute(path: '/tabs/trends', builder: (ctx, st) => const TrendsPage()),
        GoRoute(path: '/tabs/library', builder: (ctx, st) => const LibraryPage()),
        GoRoute(path: '/tabs/settings', builder: (ctx, st) => const SettingsPage()),
      ],
    ),
  ],
);
