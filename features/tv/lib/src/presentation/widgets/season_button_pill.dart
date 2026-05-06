import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tv_domain/tv_domain.dart';

class SeasonButtonPill extends StatelessWidget {
  const SeasonButtonPill({
    super.key,
    required this.isActive,
    required this.season,
    required this.onTap,
  });

  final TvSeason season;
  final bool isActive;
  final ValueChanged<TvSeason> onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => onTap(season),
        borderRadius: BorderRadius.circular(14.r),
        child: Ink(
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
          decoration: BoxDecoration(
            color: isActive
                ? kMikadoYellow.withValues(alpha: 0.2)
                : kPrussianBlue.withValues(alpha: 0.88),
            borderRadius: BorderRadius.circular(14.r),
            border: Border.all(
              color: isActive
                  ? kMikadoYellow
                  : Colors.white.withValues(alpha: 0.12),
              width: 1.2,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                season.name,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
              // SizedBox(height: 2.h),
              // Text(
              //   '${season.episodeCount} episodes',
              //   style: Theme.of(context).textTheme.bodySmall?.copyWith(
              //         color: Colors.white.withValues(alpha: 0.72),
              //         fontSize: 11.sp,
              //       ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
