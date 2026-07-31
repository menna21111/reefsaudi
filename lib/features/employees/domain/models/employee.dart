import 'package:equatable/equatable.dart';

class Employee extends Equatable {
  const Employee({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.fullName,
    required this.gender,
    required this.phone,
    required this.designation,
    required this.department,
    required this.supervisorId,
    required this.profilePicture,
    required this.readyTasksCount,
    required this.inProgressTasksCount,
  });

  final String id;
  final String email;
  final String firstName;
  final String lastName;
  final String fullName;
  final int gender;
  final String phone;
  final String designation;
  final String department;
  final String? supervisorId;
  final String? profilePicture;
  final int readyTasksCount;
  final int inProgressTasksCount;

  @override
  List<Object?> get props => [
    id,
    email,
    firstName,
    lastName,
    fullName,
    gender,
    phone,
    designation,
    department,
    supervisorId,
    profilePicture,
    readyTasksCount,
    inProgressTasksCount,
  ];
}

class EmployeeListResult extends Equatable {
  const EmployeeListResult({required this.items, required this.totalCount});

  final List<Employee> items;
  final int totalCount;

  @override
  List<Object?> get props => [items, totalCount];
}

class EmployeeOption extends Equatable {
  const EmployeeOption({required this.id, required this.title});

  final String id;
  final String title;

  @override
  List<Object?> get props => [id, title];
}

class EmployeeCreateRequest extends Equatable {
  const EmployeeCreateRequest({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
    required this.gender,
    required this.phone,
    required this.designationId,
    required this.departmentId,
    required this.supervisorId,
    required this.roles,
    this.profilePicturePath,
  });

  final String firstName;
  final String lastName;
  final String email;
  final String password;
  final int gender;
  final String phone;
  final String designationId;
  final String departmentId;
  final String supervisorId;
  final List<String> roles;
  final String? profilePicturePath;

  @override
  List<Object?> get props => [
    firstName,
    lastName,
    email,
    password,
    gender,
    phone,
    designationId,
    departmentId,
    supervisorId,
    roles,
    profilePicturePath,
  ];
}

class EmployeeUpdateRequest extends Equatable {
  const EmployeeUpdateRequest({
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.gender,
    required this.phone,
    required this.designationId,
    required this.departmentId,
    required this.supervisorId,
    required this.roles,
    this.profilePicturePath,
  });

  final String userId;
  final String firstName;
  final String lastName;
  final int gender;
  final String phone;
  final String designationId;
  final String departmentId;
  final String supervisorId;
  final List<String> roles;
  final String? profilePicturePath;

  @override
  List<Object?> get props => [
    userId,
    firstName,
    lastName,
    gender,
    phone,
    designationId,
    departmentId,
    supervisorId,
    roles,
    profilePicturePath,
  ];
}
