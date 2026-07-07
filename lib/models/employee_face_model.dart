class EmployeeFace {
  final int? id;
  final int employeeId;

  final String embedding;

  final int totalImages;

  final String createdAt;

  EmployeeFace({
    this.id,
    required this.employeeId,
    required this.embedding,
    required this.totalImages,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "employeeId": employeeId,
      "embedding": embedding,
      "totalImages": totalImages,
      "createdAt": createdAt,
    };
  }

  factory EmployeeFace.fromMap(Map<String, dynamic> map) {
    return EmployeeFace(
      id: map["id"],
      employeeId: map["employeeId"],
      embedding: map["embedding"],
      totalImages: map["totalImages"],
      createdAt: map["createdAt"],
    );
  }
}