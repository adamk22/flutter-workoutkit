import 'dart:convert';
import 'dart:io';

/// Loads a JSON fixture from `test/fixtures`.
dynamic loadFixture(String name) =>
    jsonDecode(File('test/fixtures/$name').readAsStringSync());

/// Round-trips [json] through `jsonEncode`/`jsonDecode`, like a real payload.
dynamic normalize(Object? json) => jsonDecode(jsonEncode(json));

/// Removes null values from maps recursively (0.0.11 serialized nulls).
dynamic stripNulls(Object? json) {
  if (json is Map) {
    return {
      for (final e in json.entries)
        if (e.value != null) e.key: stripNulls(e.value),
    };
  }
  if (json is List) return json.map(stripNulls).toList();
  return json;
}

/// Whether golden files should be rewritten instead of compared.
/// Run `UPDATE_GOLDENS=true flutter test` after an intentional change.
bool get updateGoldens => Platform.environment['UPDATE_GOLDENS'] == 'true';

/// Compares [actual] with the JSON fixture [name], or rewrites it when
/// [updateGoldens] is set.
void expectJsonGolden(Object? actual, String name) {
  final file = File('test/fixtures/$name');
  final encoded = '${const JsonEncoder.withIndent('  ').convert(actual)}\n';
  if (updateGoldens || !file.existsSync()) {
    file.writeAsStringSync(encoded);
    return;
  }
  if (file.readAsStringSync() != encoded) {
    throw StateError(
      'test/fixtures/$name is out of date. If the change is intentional, run '
      '`UPDATE_GOLDENS=true flutter test` and update the Swift tests if needed.',
    );
  }
}
