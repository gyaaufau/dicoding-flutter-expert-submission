import 'package:dependencies/dependencies.dart';

class PagedResponseDto<T> extends Equatable {
  const PagedResponseDto({
    required this.page,
    required this.results,
    required this.totalPages,
    required this.totalResults,
  });

  factory PagedResponseDto.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic> json) itemFromJson, {
    bool Function(T item)? where,
  }) {
    final items = (json['results'] as List)
        .map((item) => itemFromJson(item as Map<String, dynamic>))
        .where((item) => where?.call(item) ?? true)
        .toList();

    return PagedResponseDto<T>(
      page: json['page'],
      results: items,
      totalPages: json['total_pages'],
      totalResults: json['total_results'],
    );
  }

  final int page;
  final List<T> results;
  final int totalPages;
  final int totalResults;

  Map<String, dynamic> toPagedJson(
    Map<String, dynamic> Function(T item) itemToJson,
  ) => {
    'page': page,
    'results': List<dynamic>.from(results.map(itemToJson)),
    'total_pages': totalPages,
    'total_results': totalResults,
  };

  @override
  List<Object?> get props => [page, results, totalPages, totalResults];
}
