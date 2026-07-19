import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mess_manager/core/l10n/app_localizations.dart';
import 'package:mess_manager/ui/screens/onboarding/onboarding_screen.dart';

/// Renders the onboarding screen directly rather than booting the full app
/// through the splash screen, which depends on a real Drift/sqlite3 query —
/// that combination doesn't resolve reliably under flutter_test's fake-async
/// zone on this machine. On-device verification (see MESS_MANAGER_PLAN.md)
/// covers the full app boot + database flow instead.
void main() {
  testWidgets('Onboarding shows the language picker with English selected by default', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          localizationsDelegates: [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          home: OnboardingScreen(),
        ),
      ),
    );
    await tester.pump();

    expect(find.text('MessBook'), findsOneWidget);
    expect(find.text('English'), findsOneWidget);
    expect(find.text('বাংলা'), findsOneWidget);
  });
}
