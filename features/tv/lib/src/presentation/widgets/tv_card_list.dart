import 'dart:async';

import 'package:common/common.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tv_domain/tv_domain.dart';

import '../routes/tv_routes.dart';

class TvCard extends StatelessWidget {
  final Tv tv;
  final String? sourceScreen;

  const TvCard(this.tv, {super.key, this.sourceScreen});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: InkWell(
        onTap: () {
          if (sourceScreen != null &&
              locator.isRegistered<AnalyticsTracker>()) {
            unawaited(
              locator<AnalyticsTracker>().logEvent(
                'search_result_opened',
                params: {
                  'feature': 'tv',
                  'content_type': 'tv',
                  'content_id': tv.id,
                  'source_screen': sourceScreen,
                },
              ),
            );
          }
          context.pushNamed(
            TvRouteNames.detail,
            pathParameters: {AppRouteParams.id: '${tv.id}'},
          );
        },
        child: Stack(
          alignment: Alignment.bottomLeft,
          children: [
            Card(
              child: Container(
                margin: const EdgeInsets.only(
                  left: 16 + 80 + 16,
                  bottom: 8,
                  right: 8,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tv.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: kHeading6,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      tv.overview,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 16, bottom: 16),
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(8)),
                child: CachedNetworkImage(
                  imageUrl: '$BASE_IMAGE_URL${tv.posterPath}',
                  width: 80,
                  placeholder: (context, url) =>
                      const Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
