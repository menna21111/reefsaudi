import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../models/employee.dart';

abstract class EmployeesRepository {
  Future<Either<Failure, EmployeeListResult>> getEmployees({
    required int skip,
    required int take,
    String? searchText,
  });

  Future<Either<Failure, List<EmployeeOption>>> getDesignations();

  Future<Either<Failure, List<EmployeeOption>>> getDepartments();

  Future<Either<Failure, List<EmployeeOption>>> getRoles();

  Future<Either<Failure, List<EmployeeOption>>> getSupervisors();

  Future<Either<Failure, void>> createEmployee(EmployeeCreateRequest request);

  Future<Either<Failure, void>> updateEmployee(EmployeeUpdateRequest request);

  Future<Either<Failure, void>> resetPassword({
    required String userId,
    required String newPassword,
  });

  Future<Either<Failure, void>> deleteEmployee(String userId);
}
