import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_workoutkit/flutter_workoutkit.dart';

import '../support/samples.dart';
import 'test_helpers.dart';

void main() {
  test('allSamples lists every exported sample', () {
    final declared = <String>{};
    for (final file in Directory('lib/src/samples').listSync()) {
      if (file is! File || !file.path.endsWith('.dart')) continue;
      final source = file.readAsStringSync();
      declared.addAll(RegExp(r'^final \w+ (sample\w+)', multiLine: true)
          .allMatches(source)
          .map((m) => m.group(1)!));
    }
    expect(allSamples.keys.toSet(), declared);
  });

  test('samples.json golden matches every sample (Swift tests read it too)',
      () {
    expectJsonGolden(
      {for (final e in allSamples.entries) e.key: e.value.toJson()},
      'samples.json',
    );
  });

  test('every sample round-trips through fromJson', () {
    allSamples.forEach((name, sample) {
      final json = normalize(sample.toJson());
      expect(normalize(Workout.fromJson(json).toJson()), json, reason: name);
    });
  });
}
