import 'package:flutter/material.dart';

class FaceRegistrationController extends ChangeNotifier {
  int currentStep = 0;
  int capturedImages = 0;

  final List<Map<String, dynamic>> faceSteps = [
    {
      "title": "Look Straight",
      "icon": Icons.face,
    },
    {
      "title": "Turn Left",
      "icon": Icons.turn_left,
    },
    {
      "title": "Turn Right",
      "icon": Icons.turn_right,
    },
    {
      "title": "Look Up",
      "icon": Icons.keyboard_arrow_up,
    },
    {
      "title": "Look Down",
      "icon": Icons.keyboard_arrow_down,
    },
    {
      "title": "Smile 😊",
      "icon": Icons.sentiment_satisfied_alt,
    },
  ];

  List<bool> completedSteps = List.generate(6, (_) => false);
  bool faceDetected = false;
  bool isCapturing = false;

  int countdown = 3;

  String status = "Looking for Face...";

  double progress = 0;

  void nextStep() {
    if (currentStep < completedSteps.length) {
      completedSteps[currentStep] = true;
    }

    capturedImages++;

    if (currentStep < faceSteps.length - 1) {
      currentStep++;
      progress = (currentStep + 1) / faceSteps.length;
    }

    notifyListeners();
  }

  bool get completed => currentStep >= instructions.length - 1;

  List<String> get instructions =>
      faceSteps.map((step) => step['title'].toString()).toList();
}