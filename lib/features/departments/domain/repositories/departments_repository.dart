import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../models/department.dart';

abstract class DepartmentsRepository {
  Future<Either<Failure, DepartmentListResult>> getDepartments({
    required int skip,
    required int take,
    String? searchText,
  });

  Future<Either<Failure, void>> createDepartment(DepartmentWriteRequest request);

  Future<Either<Failure, void>> updateDepartment({
    required String id,
    required DepartmentWriteRequest request,
  });

  Future<Either<Failure, void>> deleteDepartment(String id);
}
