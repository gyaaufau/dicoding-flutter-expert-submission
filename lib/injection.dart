import 'package:core/core.dart';
import 'package:movie/movie.dart';
import 'package:movie_domain/movie_domain.dart';
import 'package:tv/tv.dart';
import 'package:tv_domain/tv_domain.dart';

class AppInjection {
  static Future<void> init() async {
    await registerCoreDependencies();
    registerMovieDomainDependencies(locator);
    registerTvDomainDependencies(locator);
    registerMovieFeatureDependencies(locator);
    registerTvFeatureDependencies(locator);
  }

  static void reset() => locator.reset();
}
