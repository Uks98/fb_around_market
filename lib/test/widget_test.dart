import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Login failure SnackBar is displayed', (WidgetTester tester) async {
    // 테스트를 위한 위젯 트리 구성
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) {
              if (null == null) { // 로그인 실패 시 조건 시뮬레이션
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("로그인 실패"),
                    ),
                  );
                }
                return Container();
              }
              return Container();
            },
          ),
        ),
      ),
    );

    // SnackBar가 표시되었는지 확인
    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.text("로그인 실패"), findsOneWidget);
  });
}
