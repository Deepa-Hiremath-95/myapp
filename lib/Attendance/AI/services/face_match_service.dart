import 'dart:math';

class FaceMatchService {

  double calculateDistance(
    List<double> embedding1,
    List<double> embedding2,
  ) {

    double sum = 0;

    for (int i = 0; i < embedding1.length; i++) {

      sum += pow(
        embedding1[i] - embedding2[i],
        2,
      );

    }

    return sqrt(sum);

  }

  bool isMatch(
    List<double> embedding1,
    List<double> embedding2,
  ) {

    final distance =
        calculateDistance(
          embedding1,
          embedding2,
        );

    print("Distance : $distance");

    return distance < 1.0;

  }

}
