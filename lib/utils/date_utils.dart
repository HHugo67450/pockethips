double? dateTimeToMjd(DateTime dateTime) {
  final mjdEpoch = DateTime.utc(1858, 11, 17);
  return dateTime.difference(mjdEpoch).inMilliseconds / 86400000.0;
}

double? yearToMjd(double year) {
  final dateTime = DateTime.utc(year.toInt());
  return dateTimeToMjd(dateTime);
}

DateTime? mjdToDateTime(double mjd) {
  if (mjd == 0) {
    return null;
  }
  final mjdEpoch = DateTime.utc(1858, 11, 17);
  return mjdEpoch.add(Duration(milliseconds: (mjd * 86400000).round()));
}

String formatMjdRange(double tMin, double tMax) {
  final dateMin = mjdToDateTime(tMin);
  final dateMax = mjdToDateTime(tMax);

  if (dateMin == null && dateMax == null) {
    return 'Not available';
  }

  if (dateMin == null) {
    return 'Up to ${dateMax!.year}';
  }

  if (dateMax == null) {
    return 'From ${dateMin.year}';
  }

  final yearMin = dateMin.year;
  final yearMax = dateMax.year;

  if (yearMin == yearMax) {
    final monthMin = dateMin.month;
    final monthMax = dateMax.month;
    if (monthMin == monthMax) {
      return '${monthMin.toString().padLeft(2, '0')}/$yearMin';
    } else {
      return '${monthMin.toString().padLeft(2, '0')} - ${monthMax.toString().padLeft(2, '0')}/$yearMin';
    }
  } else {
    return '$yearMin - $yearMax';
  }
}