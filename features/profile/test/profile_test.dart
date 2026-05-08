import 'package:common/common.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:profile/profile.dart';

void main() {
  test('profile routes available', () {
    expect(ProfilePage.routeName, AppRoutePaths.profile);
    expect(AboutPage.routeName, AppRoutePaths.profileAbout);
  });
}
