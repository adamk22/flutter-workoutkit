#
# Run `pod lib lint flutter_workoutkit.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'flutter_workoutkit'
  s.version          = '1.0.0'
  s.summary          = "Create, preview and schedule Apple Watch workouts with Apple's WorkoutKit."
  s.description      = <<-DESC
A Flutter plugin that uses Apple's WorkoutKit to create, preview, validate,
export and schedule custom workouts for the Workout app on Apple Watch.
                       DESC
  s.homepage         = 'https://github.com/adamk22/flutter-workoutkit'
  s.license          = { :type => 'Apache-2.0', :file => '../LICENSE' }
  s.author           = { 'Adam Kramer' => 'a@adamkramer.dev' }
  s.source           = { :http => 'https://github.com/adamk22/flutter-workoutkit' }
  s.source_files     = 'flutter_workoutkit/Sources/flutter_workoutkit/**/*.swift'
  s.dependency 'Flutter'
  s.platform         = :ios, '17.0'
  s.frameworks       = 'WorkoutKit', 'HealthKit', 'SwiftUI'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = {
    'DEFINES_MODULE' => 'YES',
    'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386',
    # Swift 6 readiness: complete data-race checking in Swift 5 mode.
    'SWIFT_STRICT_CONCURRENCY' => 'complete',
  }
  s.swift_version = '5.9'

  s.resource_bundles = { 'flutter_workoutkit_privacy' => ['flutter_workoutkit/Sources/flutter_workoutkit/PrivacyInfo.xcprivacy'] }
end
