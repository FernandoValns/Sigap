import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:sigap/screens/login_page.dart';
import 'package:sigap/screens/main_layout.dart';

void main() {
  testWidgets('login menampilkan akses SIGAP dan membuka dashboard', (
    tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: LoginPage()));

    expect(find.text('Selamat datang di SIGAP'), findsOneWidget);
    expect(find.text('Masuk ke SIGAP'), findsOneWidget);

    await tester.tap(find.text('Masuk ke SIGAP'));
    await tester.pumpAndSettle();

    expect(find.byType(MainLayout), findsOneWidget);
    expect(find.text('Ringkasan laporan'), findsOneWidget);
  });
}
