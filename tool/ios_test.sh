#!/usr/bin/env bash
# Runs the Swift unit tests (example/ios/RunnerTests) on a simulator.
# Usage: tool/ios_test.sh [simulator name or UDID]
# Without an argument, the first available iPhone simulator is used.
set -euo pipefail
cd "$(dirname "$0")/../example"

SIMULATOR="${1:-$(xcrun simctl list devices available | grep -oE 'iPhone [^(]+' | head -1 | sed 's/ *$//')}"
if [[ "$SIMULATOR" =~ ^[0-9A-Fa-f-]{36}$ ]]; then
  DESTINATION="platform=iOS Simulator,id=$SIMULATOR"
else
  DESTINATION="platform=iOS Simulator,name=$SIMULATOR"
fi
echo "Using simulator: $SIMULATOR"

flutter pub get
flutter build ios --simulator --debug --config-only
cd ios
set -o pipefail
xcodebuild test \
  -workspace Runner.xcworkspace \
  -scheme Runner \
  -destination "$DESTINATION" \
  -only-testing:RunnerTests \
  -parallel-testing-enabled NO \
  | if command -v xcbeautify >/dev/null; then xcbeautify; else cat; fi
