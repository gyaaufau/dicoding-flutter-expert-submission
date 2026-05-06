import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:movie/movie.dart';

void main() {
  Widget makeTestableWidget(Widget child) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      builder: (context, _) => MaterialApp(home: Scaffold(body: child)),
    );
  }

  testWidgets('banner should show empty state when items are empty', (
    tester,
  ) async {
    // arrange
    const widget = CarousellBannerWidget(items: []);

    // act
    await tester.pumpWidget(makeTestableWidget(widget));

    // assert
    expect(find.text('No banner data'), findsOneWidget);
  });

  testWidgets('banner should show item content and handle actions', (
    tester,
  ) async {
    // arrange
    var cardTapped = false;
    var buttonTapped = false;

    final widget = CarousellBannerWidget(
      height: 320,
      items: [
        CarousellBannerItem(
          title: 'Spider-Man',
          imagePath: 'https://example.com/poster.jpg',
          overview: 'hero story',
          rating: 7.2,
          genreLabels: const ['Action', 'Adventure'],
          durationText: '120 min',
          onTap: () => cardTapped = true,
          onWatchNow: () => buttonTapped = true,
        ),
        const CarousellBannerItem(
          title: 'Batman',
          imagePath: '/poster.jpg',
          overview: 'dark knight',
          rating: 8.0,
        ),
      ],
    );

    // act
    await tester.pumpWidget(makeTestableWidget(widget));
    await tester.tap(find.text('Watch Now'));
    await tester.pump();
    await tester.tap(find.byType(InkWell).first);
    await tester.pump();

    // assert
    expect(find.text('Spider-Man'), findsOneWidget);
    expect(find.text('hero story'), findsOneWidget);
    expect(find.text('Action'), findsOneWidget);
    expect(find.text('Adventure'), findsOneWidget);
    expect(find.text('120 min'), findsOneWidget);
    expect(find.text('7.2'), findsOneWidget);
    expect(cardTapped, true);
    expect(buttonTapped, true);
    expect(find.byType(PageView), findsOneWidget);
    expect(find.byType(AnimatedContainer), findsNWidgets(2));
  });
}
