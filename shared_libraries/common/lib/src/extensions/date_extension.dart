const _indonesianMonthNames = <int, String>{
  1: 'januari',
  2: 'februari',
  3: 'maret',
  4: 'april',
  5: 'mei',
  6: 'juni',
  7: 'juli',
  8: 'agustus',
  9: 'september',
  10: 'oktober',
  11: 'november',
  12: 'desember',
};

extension IndonesianDateFormatting on String {
  String toIndonesianDate() {
    if (trim().isEmpty) return this;

    final date = DateTime.tryParse(this);
    if (date == null) return this;

    final monthName = _indonesianMonthNames[date.month];
    if (monthName == null) return this;

    return '${date.day} $monthName ${date.year}';
  }
}
