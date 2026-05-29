import 'package:dartz/dartz.dart';

import '../error/failures.dart';
import '../network/response.dart';

abstract class UseCase2<T, Params> {
  Future<Either<Failure, T>> call(Params params);
}

abstract class UseCase<T, Params> {
  Future<Result<T>> call(Params params);
}

class NoParams {
  const NoParams();
}
