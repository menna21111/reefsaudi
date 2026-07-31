import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../models/role.dart';

abstract class RolesRepository {
  Future<Either<Failure, RoleListResult>> getRoles({
    required int skip,
    required int take,
    String? searchText,
  });

  Future<Either<Failure, void>> createRole(RoleWriteRequest request);

  Future<Either<Failure, RoleDetails>> getRoleDetails(String roleId);

  Future<Either<Failure, void>> updateRole(RoleUpdateRequest request);
}
