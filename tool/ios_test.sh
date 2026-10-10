#!/usr/bin/env bash
# Runs the Swift unit tests (example/ios/RunnerTests) on the first available
# iPhone simulator. Usage: tool/ios_test.sh [simulator name]
set -euo pipefail
cd "$(dirname "$0")/../example"

SIMULATOR="${1:-$(xcrun simctl list devices available | grep -oE 'iPhone [^(]+' | head -1 | sed 's/ *$//')}"
echo "Using simulator: $SIMULATOR"

flutter pub get
flutter build ios --simulator --debug --config-only
cd ios
set -o pipefail
xcodebuild test \
  -workspace Runner.xcworkspace \
  -scheme Runner \
  -destination "platform=iOS Simulator,name=$SIMULATOR" \
  -only-testing:RunnerTests \
  -parallel-testing-enabled NO \
  | if command -v xcbeautify >/dev/null; then xcbeautify; else cat; fi
