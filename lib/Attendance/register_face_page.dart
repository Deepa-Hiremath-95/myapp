import 'dart:async';

import 'package:flutter/material.dart';
import 'package:project/Attendance/services/Camera_service.dart';
import 'package:project/Attendance/services/face_detector_service.dart';
import 'package:project/Attendance/services/face_registration_controller.dart';
import 'package:project/models/face_registration_result.dart';
import 'services/face_pose_service.dart';
class RegisterFacePage extends StatefulWidget {
  const RegisterFacePage({super.key});

  @override
  State<RegisterFacePage> createState() => _RegisterFacePageState();
}

class _RegisterFacePageState extends State<RegisterFacePage> {
final FaceRegistrationController controller =
    FaceRegistrationController();
final CameraService _cameraService = CameraService();
final FaceDetectorService _faceDetectorService = FaceDetectorService();
bool isHolding = false;

bool isDetecting = false;
bool faceDetected = false;

bool capturing = false;

int currentStep = 0;


int countdown = 3;

String status = "Looking for Face...";
Timer? holdTimer;
final Rect guideRect = Rect.fromLTWH(
  70,
  150,
  250,
  330,
);
final List<String> instructions = [

  "Look Straight",

  "Turn Left 30°",

  "Turn Right 30°",

  "Look Up",

  "Smile 😊",

];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Register Face"),
        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          children: [

            const SizedBox(height: 30),

            const Icon(
              Icons.face,
              size: 120,
              color: Colors.blue,
            ),

            const SizedBox(height: 30),

            Text(
              "Step ${controller.currentStep + 1} / ${controller.instructions.length}",
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            Text(
              controller.instructions[controller.currentStep],
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 50),

           LinearProgressIndicator(
  value: (controller.currentStep + 1) /
      controller.faceSteps.length,
  minHeight: 12,
  borderRadius: BorderRadius.circular(20),
),
const SizedBox(height: 20),

Wrap(
  spacing: 10,
  children: List.generate(
    controller.faceSteps.length,
    (index) {
      return Icon(
        controller.completedSteps[index]
            ? Icons.check_circle
            : Icons.radio_button_unchecked,
        color: controller.completedSteps[index]
            ? Colors.green
            : Colors.grey,
      );
    },
  ),
),

const Spacer(),

            ElevatedButton(
             onPressed: () {

  if (!controller.completed) {

    setState(() {

      controller.nextStep();

    });

  } else {

    Navigator.pop(
      context,
      FaceRegistrationResult(
        success: true,
        embedding: "temporary_embedding",
        imagesCaptured: 15,
      ),
    );

  }

},

              child: const Text("Next"),
            ),

            const SizedBox(height: 20),

          ],
        ),
      ),
    );
  }
}