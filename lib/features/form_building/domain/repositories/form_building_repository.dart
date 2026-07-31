import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../models/form_building_item.dart';
import '../models/form_building_module.dart';

abstract class FormBuildingRepository {
  Future<Either<Failure, FormBuildingListResult>> getItems({
    required FormBuildingModule module,
    int skip = 0,
    int take = 100,
  });
}
