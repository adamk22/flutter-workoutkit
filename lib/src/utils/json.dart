/// Internal helpers for decoding JSON-like maps coming from Dart code,
/// `jsonDecode` or the platform channel (which yields `Map<Object?, Object?>`).
library;

/// Casts a decoded JSON object to `Map<String, dynamic>`.
Map<String, dynamic> asJsonMap(Object? value) =>
    Map<String, dynamic>.from(value as Map);

/// Casts a decoded JSON array of objects to a typed list of maps.
List<Map<String, dynamic>> asJsonList(Object? value) =>
    (value as List).map(asJsonMap).toList();

/// Reads a JSON number (int or double) as a double.
double asDouble(Object? value) => (value as num).toDouble();

/// Reads an optional JSON number as a double.
double? asDoubleOrNull(Object? value) =>
    value == null ? null : (value as num).toDouble();

/// Reads a JSON number of seconds as a [Duration].
Duration asSecondsDuration(Object? value) =>
    Duration(milliseconds: ((value as num) * 1000).round());

/// Serializes a [Duration] as whole seconds when possible, fractional otherwise.
num durationToSeconds(Duration duration) => duration.inMilliseconds % 1000 == 0
    ? duration.inSeconds
    : duration.inMilliseconds / 1000;

/// Adds [value] to [json] under [key] unless it is null.
void putIfNotNull(Map<String, dynamic> json, String key, Object? value) {
  if (value != null) json[key] = value;
}
