import 'package:flutter_test/flutter_test.dart';
import 'package:project/models/employee_model.dart';

void main() {
  test('netSalary falls back to zero for empty or invalid salary values', () {
    final employee = Employee.fromMap({
      'id': 1,
      'empId': 'E001',
      'name': 'Alice',
      'department': 'IT',
      'phone': '123',
      'basicSalary': '',
      'allowances': 'abc',
      'deductions': null,
      'email': null,
      'joiningDate': null,
      'skills': null,
      'status': null,
      'experience': null,
      'photo': null,
    });

    expect(employee.netSalary, 0);
  });
}
