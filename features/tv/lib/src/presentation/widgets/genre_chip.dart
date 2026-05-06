import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GenreChip extends StatelessWidget {
  const GenreChip({super.key, required this.label, this.compact = false});

  final String label;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 10.w : 12.w,
        vertical: compact ? 5.h : 6.h,
      ),
      decoration: BoxDecoration(
        color: kPrussianBlue.withValues(alpha: 0.82),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.white.withValues(alpha: 0.14)),
      ),
      child: Text(
        label,
        style: kBodyText.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w500,
          fontSize: compact ? 11.sp : 12.sp,
        ),
      ),
    );
  }
}
