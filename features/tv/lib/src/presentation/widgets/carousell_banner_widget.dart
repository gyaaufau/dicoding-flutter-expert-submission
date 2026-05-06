import 'package:common/common.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'genre_chip.dart';

class CarousellBannerItem {
  const CarousellBannerItem({
    required this.title,
    required this.imagePath,
    this.overview,
    this.rating,
    this.genreLabels = const [],
    this.isTvShows = false,
    this.seasonCount,
    this.durationText,
    this.onTap,
    this.onWatchNow,
    this.buttonText = 'Watch Now',
  });

  final String title;
  final String imagePath;
  final String? overview;
  final double? rating;
  final List<String> genreLabels;
  final bool isTvShows;
  final int? seasonCount;
  final String? durationText;
  final VoidCallback? onTap;
  final VoidCallback? onWatchNow;
  final String buttonText;
}

class CarousellBannerWidget extends StatefulWidget {
  const CarousellBannerWidget({super.key, required this.items, this.height});

  final List<CarousellBannerItem> items;
  final double? height;

  @override
  State<CarousellBannerWidget> createState() => _CarousellBannerWidgetState();
}

class _CarousellBannerWidgetState extends State<CarousellBannerWidget> {
  late final PageController _pageController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 1);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.items.isEmpty) {
      return _EmptyBanner(height: widget.height);
    }

    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: widget.height ?? 220.h,
          child: PageView.builder(
            controller: _pageController,
            itemCount: widget.items.length,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            itemBuilder: (context, index) {
              final item = widget.items[index];
              return _BannerCard(
                item: item,
                compact: (widget.height ?? 420.h) <= 260.h,
              );
            },
          ),
        ),
        if (widget.items.length > 1) ...[
          SizedBox(height: 12.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              widget.items.length,
              (index) => AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                margin: EdgeInsets.symmetric(horizontal: 4.w),
                width: index == _currentIndex ? 18.w : 8.w,
                height: 8.w,
                decoration: BoxDecoration(
                  color: index == _currentIndex
                      ? kMikadoYellow
                      : Colors.white.withValues(alpha: 0.25),
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class _BannerCard extends StatelessWidget {
  const _BannerCard({required this.item, required this.compact});

  final CarousellBannerItem item;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: item.onTap,
        child: Stack(
          fit: StackFit.expand,
          children: [
            CachedNetworkImage(
              imageUrl: _resolveImageUrl(item.imagePath),
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                color: kOxfordBlue,
                child: const Center(child: CircularProgressIndicator()),
              ),
              errorWidget: (context, url, error) => Container(
                color: kOxfordBlue,
                child: const Center(
                  child: Icon(
                    Icons.broken_image_outlined,
                    color: Colors.white70,
                    size: 36,
                  ),
                ),
              ),
            ),
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.12),
                    Colors.black.withValues(alpha: 0.30),
                    Colors.black.withValues(alpha: 0.78),
                    kRichBlack,
                  ],
                  stops: const [0.0, 0.35, 0.72, 1.0],
                ),
              ),
            ),
            SafeArea(
              bottom: false,
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  20.w,
                  compact ? 16.h : 20.h,
                  20.w,
                  compact ? 20.h : 28.h,
                ),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final isVeryCompact =
                        compact && constraints.maxHeight <= 250.h;
                    final showOverview =
                        (item.overview ?? '').trim().isNotEmpty &&
                        !isVeryCompact;

                    return Align(
                      alignment: Alignment.bottomLeft,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Wrap(
                            spacing: 8.w,
                            runSpacing: isVeryCompact ? 6.h : 8.h,
                            children: [
                              if (item.rating != null)
                                _MetaBadge(
                                  compact: compact,
                                  icon: Icons.star_rounded,
                                  label: item.rating!.toStringAsFixed(1),
                                  highlighted: true,
                                ),
                              if (item.isTvShows && item.seasonCount != null)
                                _MetaBadge(
                                  compact: compact,
                                  icon: Icons.layers_rounded,
                                  label:
                                      '${item.seasonCount} ${item.seasonCount == 1 ? 'Season' : 'Seasons'}',
                                ),
                              if (!item.isTvShows &&
                                  (item.durationText ?? '').trim().isNotEmpty)
                                _MetaBadge(
                                  compact: compact,
                                  icon: Icons.schedule_rounded,
                                  label: item.durationText!.trim(),
                                ),
                            ],
                          ),
                          if (item.genreLabels.isNotEmpty) ...[
                            SizedBox(
                              height: isVeryCompact
                                  ? 6.h
                                  : compact
                                  ? 8.h
                                  : 10.h,
                            ),
                            Wrap(
                              spacing: 8.w,
                              runSpacing: isVeryCompact ? 6.h : 8.h,
                              children: item.genreLabels
                                  .map(
                                    (genre) => GenreChip(
                                      label: genre,
                                      compact: compact,
                                    ),
                                  )
                                  .toList(),
                            ),
                          ],
                          SizedBox(
                            height: isVeryCompact
                                ? 8.h
                                : compact
                                ? 10.h
                                : 12.h,
                          ),
                          ConstrainedBox(
                            constraints: BoxConstraints(
                              maxWidth: compact ? 220.w : 250.w,
                            ),
                            child: Text(
                              item.title,
                              maxLines: isVeryCompact ? 1 : 2,
                              overflow: TextOverflow.ellipsis,
                              style: kHeading5.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          if (showOverview) ...[
                            SizedBox(height: compact ? 8.h : 10.h),
                            ConstrainedBox(
                              constraints: BoxConstraints(
                                maxWidth: compact ? 240.w : 300.w,
                              ),
                              child: Text(
                                item.overview!,
                                maxLines: compact ? 2 : 3,
                                overflow: TextOverflow.ellipsis,
                                style: kBodyText.copyWith(
                                  color: Colors.white.withValues(alpha: 0.86),
                                  height: 1.5,
                                ),
                              ),
                            ),
                          ],
                          SizedBox(height: compact ? 12.h : 16.h),
                          FilledButton(
                            onPressed: item.onWatchNow ?? item.onTap,
                            style: FilledButton.styleFrom(
                              backgroundColor: kMikadoYellow,
                              foregroundColor: Colors.black,
                              padding: EdgeInsets.symmetric(
                                horizontal: compact ? 14.w : 18.w,
                                vertical: compact ? 12.h : 14.h,
                              ),
                            ),
                            child: Text(item.buttonText),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MetaBadge extends StatelessWidget {
  const _MetaBadge({
    required this.compact,
    required this.icon,
    required this.label,
    this.highlighted = false,
  });

  final bool compact;
  final IconData icon;
  final String label;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    final backgroundColor = highlighted
        ? kMikadoYellow.withValues(alpha: 0.18)
        : Colors.white.withValues(alpha: 0.10);
    final foregroundColor = highlighted ? kMikadoYellow : Colors.white;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 10.w : 12.w,
        vertical: compact ? 6.h : 8.h,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: foregroundColor.withValues(alpha: 0.18)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: compact ? 14.sp : 16.sp, color: foregroundColor),
          SizedBox(width: 6.w),
          Text(
            label,
            style: kBodyText.copyWith(
              color: foregroundColor,
              fontWeight: FontWeight.w600,
              fontSize: compact ? 11.sp : 12.sp,
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyBanner extends StatelessWidget {
  const _EmptyBanner({this.height});

  final double? height;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: height ?? 220.h,
      decoration: BoxDecoration(
        color: kOxfordBlue,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Center(
        child: Text(
          'No banner data',
          style: kBodyText.copyWith(color: Colors.white70),
        ),
      ),
    );
  }
}

String _resolveImageUrl(String imagePath) {
  if (imagePath.startsWith('http://') || imagePath.startsWith('https://')) {
    return imagePath;
  }

  return '$BASE_IMAGE_URL$imagePath';
}
