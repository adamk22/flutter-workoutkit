import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_workoutkit/flutter_workoutkit.dart';

void main() {
  test('Workoutkit is an alias of WorkoutKit', () {
    expect(Workoutkit, WorkoutKit);
    // Static members resolve through both names.
    expect(identical(Workoutkit.validate, WorkoutKit.validate), isTrue);
  });
}
