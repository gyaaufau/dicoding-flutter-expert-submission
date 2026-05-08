import 'dart:io';

const _specialRootCoverageTargets = {
  'features/profile': 'features/profile/test',
};

Future<void> main() async {
  final repoRoot = Directory.current;
  final packages = _findTestPackages(repoRoot);
  var hasFailure = false;

  for (final package in packages) {
    final relativePath = _relativeToRoot(repoRoot, package.path);
    stdout.writeln('--------------------------------------------------------------------------------');
    stdout.writeln(relativePath);

    final success = await _runCoverageForPackage(
      repoRoot: repoRoot,
      package: package,
      relativePath: relativePath,
    );

    stdout.writeln('$relativePath: ${success ? 'SUCCESS' : 'FAILED'}');
    if (!success) {
      hasFailure = true;
      break;
    }
  }

  if (hasFailure) {
    exitCode = 1;
  }
}

List<Directory> _findTestPackages(Directory repoRoot) {
  final packages = <Directory>[];

  for (final entity in repoRoot.listSync(recursive: true, followLinks: false)) {
    if (entity is! File || entity.path.split(Platform.pathSeparator).last != 'pubspec.yaml') {
      continue;
    }

    final packageDir = entity.parent;
    final testDir = Directory('${packageDir.path}${Platform.pathSeparator}test');
    if (!testDir.existsSync()) {
      continue;
    }

    packages.add(packageDir);
  }

  packages.sort((a, b) => a.path.compareTo(b.path));
  return packages;
}

Future<bool> _runCoverageForPackage({
  required Directory repoRoot,
  required Directory package,
  required String relativePath,
}) async {
  final coverageDir = Directory(
    '${package.path}${Platform.pathSeparator}coverage',
  );
  if (coverageDir.existsSync()) {
    coverageDir.deleteSync(recursive: true);
  }

  final rootTarget = _specialRootCoverageTargets[relativePath];
  if (rootTarget != null) {
    final rootCoverageDir = Directory(
      '${repoRoot.path}${Platform.pathSeparator}coverage',
    );
    if (rootCoverageDir.existsSync()) {
      rootCoverageDir.deleteSync(recursive: true);
    }

    final success = await _runProcess(
      executable: 'flutter',
      arguments: ['test', '--coverage', rootTarget],
      workingDirectory: repoRoot.path,
    );
    if (!success) {
      return false;
    }

    final sourceFile = File(
      '${rootCoverageDir.path}${Platform.pathSeparator}lcov.info',
    );
    if (!sourceFile.existsSync()) {
      stderr.writeln('Coverage file not found for $relativePath');
      return false;
    }

    coverageDir.createSync(recursive: true);
    sourceFile.copySync(
      '${coverageDir.path}${Platform.pathSeparator}lcov.info',
    );
    rootCoverageDir.deleteSync(recursive: true);
    return true;
  }

  return _runProcess(
    executable: 'flutter',
    arguments: ['test', '--coverage'],
    workingDirectory: package.path,
  );
}

Future<bool> _runProcess({
  required String executable,
  required List<String> arguments,
  required String workingDirectory,
}) async {
  final process = await Process.start(
    executable,
    arguments,
    workingDirectory: workingDirectory,
    mode: ProcessStartMode.inheritStdio,
  );
  final exitCode = await process.exitCode;
  return exitCode == 0;
}

String _relativeToRoot(Directory repoRoot, String absolutePath) {
  final rootPath = repoRoot.absolute.path;
  final packagePath = Directory(absolutePath).absolute.path;
  if (packagePath == rootPath) {
    return '.';
  }

  final prefix = '$rootPath${Platform.pathSeparator}';
  if (packagePath.startsWith(prefix)) {
    return packagePath.substring(prefix.length);
  }

  return packagePath;
}
