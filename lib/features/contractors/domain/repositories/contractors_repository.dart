import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../models/contractor.dart';

abstract class ContractorsRepository {
  Future<Either<Failure, ContractorListResult>> getContractors({
    required int skip,
    required int take,
    String? searchText,
  });

  Future<Either<Failure, void>> createContractor(ContractorWriteRequest request);

  Future<Either<Failure, void>> updateContractor({
    required String id,
    required ContractorWriteRequest request,
  });

  Future<Either<Failure, void>> deleteContractor(String id);
}
