class AttendanceModel {
  final int? id;
  final int employeeId;
  final String attendanceDate;
  final String? checkInTime;
  final String? checkOutTime;
  final String status;
  final double confidence;
  final String createdAt;

  AttendanceModel({
    this.id,
    required this.employeeId,
    required this.attendanceDate,
    this.checkInTime,
    this.checkOutTime,
    required this.status,
    required this.confidence,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'employeeId': employeeId,
      'attendanceDate': attendanceDate,
      'checkInTime': checkInTime,
      'checkOutTime': checkOutTime,
      'status': status,
      'confidence': confidence,
      'createdAt': createdAt,
    };
  }

  factory AttendanceModel.fromMap(Map<String, dynamic> map) {
    return AttendanceModel(
      id: map['id'],
      employeeId: map['employeeId'],
      attendanceDate: map['attendanceDate'],
      checkInTime: map['checkInTime'],
      checkOutTime: map['checkOutTime'],
      status: map['status'],
      confidence: (map['confidence'] as num).toDouble(),
      createdAt: map['createdAt'],
    );
  }
  
}