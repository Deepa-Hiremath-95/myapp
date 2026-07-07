class FaceRegistrationResult {
  final bool success;
  final String embedding;
  final int imagesCaptured;

  FaceRegistrationResult({
    required this.success,
    required this.embedding,
    required this.imagesCaptured,
  });
}