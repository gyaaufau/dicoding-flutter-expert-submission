import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tv/tv.dart';

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

  testWidgets('banner should show tv content and handle actions', (
    tester,
  ) async {
    // arrange
    var cardTapped = false;
    var buttonTapped = false;

    final widget = CarousellBannerWidget(
      height: 320,
      items: [
        CarousellBannerItem(
          title: 'Breaking Bad',
          imagePath: 'https://example.com/poster.jpg',
          overview: 'crime story',
          rating: 9.1,
          genreLabels: const ['Drama'],
          seasonCount: 5,
          isTvShows: true,
          onTap: () => cardTapped = true,
          onWatchNow: () => buttonTapped = true,
        ),
        const CarousellBannerItem(
          title: 'Dark',
          imagePath: '/poster.jpg',
          overview: 'mystery story',
          rating: 8.0,
          isTvShows: true,
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
    expect(find.text('Breaking Bad'), findsOneWidget);
    expect(find.text('crime story'), findsOneWidget);
    expect(find.text('Drama'), findsOneWidget);
    expect(find.text('5 Seasons'), findsOneWidget);
    expect(find.text('9.1'), findsOneWidget);
    expect(cardTapped, true);
    expect(buttonTapped, true);
    expect(find.byType(PageView), findsOneWidget);
    expect(find.byType(AnimatedContainer), findsNWidgets(2));
  });
}
