import 'dart:io';

final _defaultExcludePatterns = <RegExp>[
  RegExp(r'\.g\.dart$'),
  RegExp(r'\.freezed\.dart$'),
  RegExp(r'/generated_plugin_registrant\.dart$'),
  RegExp(r'/main\.dart$'),
];

void main(List<String> args) {
  final minCoverage = _readMinCoverage(args);
  final outputFile = File('coverage/lcov.info');
  final inputs = Directory.current
      .listSync(recursive: true)
      .whereType<File>()
      .where((file) => file.path.endsWith('coverage/lcov.info'))
      .where((file) => file.absolute.path != outputFile.absolute.path)
      .toList()
    ..sort((a, b) => a.path.compareTo(b.path));

  final keptRecords = <String>[];
  var totalFound = 0;
  var totalHit = 0;

  for (final file in inputs) {
    final content = file.readAsStringSync();
    if (content.trim().isEmpty) {
      continue;
    }

    for (final record in content.split('end_of_record')) {
      final trimmed = record.trim();
      if (trimmed.isEmpty) {
        continue;
      }

      final sourceLine = trimmed
          .split('\n')
          .firstWhere((line) => line.startsWith('SF:'), orElse: () => '');
      if (sourceLine.isEmpty) {
        continue;
      }

      final sourcePath = sourceLine.substring(3);
      if (_defaultExcludePatterns
          .any((pattern) => pattern.hasMatch(sourcePath))) {
        continue;
      }

      keptRecords.add('$trimmed\nend_of_record\n');

      for (final line in trimmed.split('\n')) {
        if (line.startsWith('LF:')) {
          totalFound += int.parse(line.substring(3));
        } else if (line.startsWith('LH:')) {
          totalHit += int.parse(line.substring(3));
        }
      }
    }
  }

  outputFile.parent.createSync(recursive: true);
  outputFile.writeAsStringSync(keptRecords.join());

  final coverage = totalFound == 0 ? 0.0 : (totalHit / totalFound) * 100;
  stdout.writeln(
    'Merged ${keptRecords.length} records into ${outputFile.path}',
  );
  stdout.writeln(
    'Coverage: $totalHit/$totalFound (${coverage.toStringAsFixed(2)}%)',
  );

  if (minCoverage != null && coverage < minCoverage) {
    stderr.writeln(
      'Coverage ${coverage.toStringAsFixed(2)}% below minimum ${minCoverage.toStringAsFixed(2)}%',
    );
    exitCode = 1;
  }
}

double? _readMinCoverage(List<String> args) {
  for (final arg in args) {
    if (arg.startsWith('--min=')) {
      return double.parse(arg.substring('--min='.length));
    }
  }
  return null;
}
