import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../data/models/meeting_models.dart';

abstract class MeetingsRepository {
  Future<Either<Failure, MeetingsListResponse>> getMeetings({
    required DateTime rangeStart,
    required DateTime rangeEnd,
    int skip = 0,
    int take = 20,
  });

  Future<Either<Failure, MeetingItem>> getMeetingById(String id);

  Future<Either<Failure, List<MeetingAccountOption>>> getAccounts({
    int skip = 0,
    int take = 200,
  });

  Future<Either<Failure, MeetingItem>> createMeeting(
    MeetingWriteRequest request,
  );

  Future<Either<Failure, MeetingItem>> updateMeeting(
    MeetingWriteRequest request,
  );
}
