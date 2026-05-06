import 'package:flutter_test/flutter_test.dart';

import 'package:profile/profile.dart';

void main() {
  test('profile routes available', () {
    expect(ProfilePage.routeName, '/profile');
    expect(AboutPage.routeName, '/about');
  });
}
