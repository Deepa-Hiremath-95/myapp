import 'package:path/path.dart';
import 'package:project/models/attendance_model.dart';
import 'package:project/models/employee_face_model.dart';
import 'package:sqflite/sqflite.dart';
// import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import '../models/employee_model.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();

  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('employee.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();

    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
      onOpen: (db) async {
        // Ensure tables exist in case the database was created earlier without them.
        await db.execute('''
          CREATE TABLE IF NOT EXISTS employees (

            id INTEGER PRIMARY KEY AUTOINCREMENT,
            empId TEXT NOT NULL,
            name TEXT NOT NULL,
            department TEXT NOT NULL,
            phone TEXT NOT NULL,

            basicSalary TEXT NOT NULL,
            allowances TEXT NOT NULL,
            deductions TEXT NOT NULL,

            email TEXT,
            joiningDate TEXT,
            skills TEXT,
            status TEXT,
            experience TEXT,
            photo TEXT
          )
        ''');

        await db.execute('''
          CREATE TABLE IF NOT EXISTS user_master(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            username TEXT NOT NULL UNIQUE,
            password TEXT NOT NULL
          )
        ''');

        //employee_faces
        await db.execute('''
          CREATE TABLE IF NOT EXISTS employee_faces(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            employeeId INTEGER UNIQUE,
            embedding TEXT,
            totalImages INTEGER,
            createdAt TEXT
          )
        ''');
              Future<int> insertEmployeeFace(EmployeeFace face) async {
  final db = await database;

  return await db.insert(
    'employee_faces',
    face.toMap(),
  );
}
Future<EmployeeFace?> getEmployeeFace(int employeeId) async {
  final db = await database;

  final result = await db.query(
    'employee_faces',
    where: 'employeeId = ?',
    whereArgs: [employeeId],
  );

  if (result.isNotEmpty) {
    return EmployeeFace.fromMap(result.first);
  }

  return null;
}
Future<int> updateEmployeeFace(EmployeeFace face) async {
  final db = await database;

  return await db.update(
    'employee_faces',
    face.toMap(),
    where: 'employeeId = ?',
    whereArgs: [face.employeeId],
  );
}
Future<int> deleteEmployeeFace(int employeeId) async {
  final db = await database;

  return await db.delete(
    'employee_faces',
    where: 'employeeId = ?',
    whereArgs: [employeeId],
  );
}
Future<bool> isFaceRegistered(
    int employeeId) async {

  final db = await database;

  final result = await db.query(
    "employee_faces",
    where: "employeeId=?",
    whereArgs: [employeeId],
  );

  return result.isNotEmpty;
}

//attendance table
        await db.execute('''
          CREATE TABLE IF NOT EXISTS attendance(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            employeeId INTEGER NOT NULL,
            attendanceDate TEXT NOT NULL,
            checkInTime TEXT,
            checkOutTime TEXT,
            status TEXT,
            confidence REAL,
            createdAt TEXT
          )
        ''');

Future<int> insertAttendance(AttendanceModel attendance) async {
  final db = await database;
  return await db.insert(
    'attendance',
    attendance.toMap(),
  );
  
}
Future<AttendanceModel?> getTodayAttendance(
  int employeeId,
  String date,
) async {
  final db = await database;

  final result = await db.query(
    'attendance',
    where: 'employeeId = ? AND attendanceDate = ?',
    whereArgs: [employeeId, date],
  );

  if (result.isNotEmpty) {
    return AttendanceModel.fromMap(result.first);
  }

  return null;
}
Future<int> updateCheckout(
  int attendanceId,
  String checkoutTime,
) async {
  final db = await database;

  return await db.update(
    'attendance',
    {
      'checkOutTime': checkoutTime,
    },
    where: 'id = ?',
    whereArgs: [attendanceId],
  );
}
        // Ensure default admin user exists
        final existing = await db.query(
          'user_master',
          where: 'username = ?',
          whereArgs: ['ad'],
        );

        if (existing.isEmpty) {
          await db.insert('user_master', {'username': 'ad', 'password': 'ad'});
        }
      },
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
    CREATE TABLE employees (

      id INTEGER PRIMARY KEY AUTOINCREMENT,
      empId TEXT NOT NULL,
      name TEXT NOT NULL,
      department TEXT NOT NULL,
      phone TEXT NOT NULL,

      basicSalary TEXT NOT NULL,
      allowances TEXT NOT NULL,
      deductions TEXT NOT NULL,

      email TEXT,
      joiningDate TEXT,
      skills TEXT,
      status TEXT,
      experience TEXT,
      photo TEXT
    )
  ''');
    await db.execute('''
      CREATE TABLE user_master(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT NOT NULL UNIQUE,
        password TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS employee_faces(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        employeeId INTEGER UNIQUE,
        embedding TEXT,
        totalImages INTEGER,
        createdAt TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS attendance(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        employeeId INTEGER NOT NULL,
        attendanceDate TEXT NOT NULL,
        checkInTime TEXT,
        checkOutTime TEXT,
        status TEXT,
        confidence REAL,
        createdAt TEXT
      )
    ''');

    await db.insert('user_master', {'username': 'ad', 'password': 'ad'});
  }

  Future<bool> login(String username, String password) async {
    final db = await instance.database;

    final result = await db.query(
      'user_master',
      where: 'username = ? AND password = ?',
      whereArgs: [username, password],
    );

    return result.isNotEmpty;
  }

  // Insert Employee
  Future<int> insertEmployee(Employee employee) async {
    final db = await database;

    return await db.insert('employees', employee.toMap());
  }

  // Get All Employees
  Future<List<Employee>> getEmployees() async {
    final db = await instance.database;

    final result = await db.query('employees', orderBy: 'id DESC');

    return result.map((e) => Employee.fromMap(e)).toList();
  }

  // Get Employees with Pagination (for better performance with large datasets)
  Future<List<Employee>> getEmployeesPaginated({
    int pageNumber = 1,
    int pageSize = 20,
  }) async {
    final db = await instance.database;
    final offset = (pageNumber - 1) * pageSize;

    final result = await db.query(
      'employees',
      orderBy: 'id DESC',
      limit: pageSize,
      offset: offset,
    );

    return result.map((e) => Employee.fromMap(e)).toList();
  }

  // Get Employee By ID
  Future<Employee?> getEmployeeById(int id) async {
    final db = await instance.database;

    final result = await db.query(
      'employees',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (result.isNotEmpty) {
      return Employee.fromMap(result.first);
    }

    return null;
  }

  Future<int> getEmployeeCount() async {
    final db = await instance.database;

    final result = await db.rawQuery('SELECT COUNT(*) as count FROM employees');

    return Sqflite.firstIntValue(result) ?? 0;
  }

  // Update Employee
  Future<int> updateEmployee(Employee employee) async {
    final db = await instance.database;

    int result = await db.update(
      'employees',
      employee.toMap(),
      where: 'id = ?',
      whereArgs: [employee.id],
    );

    print("Rows Updated = $result");

    return result;
  }

  // Delete Employee
  Future<int> deleteEmployee(int id) async {
    final db = await instance.database;

    return await db.delete('employees', where: 'id = ?', whereArgs: [id]);
  }

  // Close Database
  Future close() async {
    final db = await instance.database;

    db.close();
  }
}
