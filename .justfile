refresh-example:
  cd example && flutter pub get && cd ios && rm -rf Podfile.lock Pods && pod install && cd ../..
start-example:
  cd example && flutter pub get && flutter run -t lib/main.dart --debug