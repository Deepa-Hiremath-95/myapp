import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';

class CameraService {
  CameraController? controller;

  Future<void> initialize() async {
    final status = await Permission.camera.request();
    if (!status.isGranted) {
      throw Exception('Camera permission is required to use this feature.');
    }

    final cameras = await availableCameras();
    if (cameras.isEmpty) {
      throw Exception('No camera found on this device.');
    }

    final frontCamera = cameras.firstWhere(
      (camera) => camera.lensDirection == CameraLensDirection.front,
      orElse: () => cameras.first,
    );

    controller = CameraController(
      frontCamera,
      ResolutionPreset.medium,
      enableAudio: false,
      imageFormatGroup: ImageFormatGroup.yuv420,
    );

    await controller!.initialize();
  }

  Future<void> dispose() async {
    await controller?.dispose();
  }

Future<void> startImageStream(
  Function(CameraImage) onImage,
) async {

  if (controller == null) return;

  if (!controller!.value.isInitialized) return;

  if (controller!.value.isStreamingImages) return;

  await controller!.startImageStream(onImage);
}

  Future<void> stopImageStream() async {
    if (controller == null) return;

    if (controller!.value.isStreamingImages) {
      await controller!.stopImageStream();
    }
  }
}
