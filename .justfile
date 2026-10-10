# Analyze, format-check and run every test suite.
check: analyze test test-ios

analyze:
  dart format --output=none --set-exit-if-changed lib test example/lib
  flutter analyze --fatal-infos

# Dart unit, model, channel and widget tests (plugin + example).
test:
  flutter test
  cd example && flutter test

# Swift unit tests against the shared JSON fixtures (needs Xcode).
test-ios:
  tool/ios_test.sh

# Integration tests on a booted simulator or connected device.
test-integration:
  cd example && flutter test integration_test

refresh-example:
  cd example && flutter clean && flutter pub get

start-example:
  cd example && flutter pub get && flutter run -t lib/main.dart --debug
