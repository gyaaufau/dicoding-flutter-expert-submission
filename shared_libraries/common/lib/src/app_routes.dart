class AppRoutePaths {
  const AppRoutePaths._();

  static const root = '/';
  static const movies = '/movies';
  static const moviesPopular = '/movies/popular';
  static const moviesTopRated = '/movies/top-rated';
  static const moviesSearch = '/movies/search';
  static const moviesDetailPattern = '/movies/:id';
  static const tv = '/tv';
  static const tvPopular = '/tv/popular';
  static const tvTopRated = '/tv/top-rated';
  static const tvSearch = '/tv/search';
  static const tvDetailPattern = '/tv/:id';
  static const watchlist = '/watchlist';
  static const profile = '/profile';
  static const profileAbout = '/profile/about';
}

class AppRouteNames {
  const AppRouteNames._();

  static const moviesHome = 'movies-home';
  static const moviesPopular = 'movies-popular';
  static const moviesTopRated = 'movies-top-rated';
  static const moviesSearch = 'movies-search';
  static const moviesDetail = 'movies-detail';
  static const tvHome = 'tv-home';
  static const tvPopular = 'tv-popular';
  static const tvTopRated = 'tv-top-rated';
  static const tvSearch = 'tv-search';
  static const tvDetail = 'tv-detail';
  static const watchlist = 'watchlist';
  static const profile = 'profile';
  static const profileAbout = 'profile-about';
}

class AppRouteParams {
  const AppRouteParams._();

  static const id = 'id';
}

class AppRouteHelpers {
  const AppRouteHelpers._();

  static String movieDetail(int id) => '${AppRoutePaths.movies}/$id';

  static String tvDetail(int id) => '${AppRoutePaths.tv}/$id';
}
