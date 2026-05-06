import 'package:movie/movie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget makeTestableWidget(Widget body) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      builder: (context, child) => MaterialApp(
        home: Scaffold(body: body),
      ),
    );
  }

  testWidgets('render genre label', (tester) async {
    await tester.pumpWidget(
      makeTestableWidget(
        const GenreChip(label: 'Action'),
      ),
    );

    expect(find.text('Action'), findsOneWidget);
  });
}
