import 'package:flutter_test/flutter_test.dart';
import 'package:project/Attendance/services/face_registration_controller.dart';

void main() {
  test('instructions should be available and non-empty', () {
    final controller = FaceRegistrationController();

    expect(controller.instructions, isA<List<String>>());
    expect(controller.instructions, isNotEmpty);
    expect(controller.instructions.length, equals(controller.faceSteps.length));
  });
}
