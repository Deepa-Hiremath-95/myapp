import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

class FacePoseService {

  static bool isLookingStraight(Face face) {

    final yaw = face.headEulerAngleY ?? 0;

    return yaw > -10 && yaw < 10;
  }

  static bool isLookingLeft(Face face) {

    final yaw = face.headEulerAngleY ?? 0;

    return yaw < -15;
  }

  static bool isLookingRight(Face face) {

    final yaw = face.headEulerAngleY ?? 0;

    return yaw > 15;
  }

  static bool isLookingUp(Face face) {

    final pitch = face.headEulerAngleX ?? 0;

    return pitch < -10;
  }

  static bool isLookingDown(Face face) {

    final pitch = face.headEulerAngleX ?? 0;

    return pitch > 10;
  }

  static bool isSmiling(Face face) {

    return (face.smilingProbability ?? 0) > 0.7;
  }
  
}