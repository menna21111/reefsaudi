import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/repositories/meetings_repository.dart';
import '../datasources/meetings_remote_data_source.dart';
import '../models/meeting_models.dart';

class MeetingsRepositoryImpl implements MeetingsRepository {
  MeetingsRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  final MeetingsRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  Future<Either<Failure, T>> _guard<T>(Future<T> Function() action) async {
    if (!await networkInfo.isConnected) {
      return Left(NetworkFailure('no_internet_error'));
    }
    try {
      return Right(await action());
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, MeetingsListResponse>> getMeetings({
    required DateTime rangeStart,
    required DateTime rangeEnd,
    int skip = 0,
    int take = 20,
  }) {
    return _guard(
      () => remoteDataSource.getMeetings(
        rangeStart: rangeStart,
        rangeEnd: rangeEnd,
        skip: skip,
        take: take,
      ),
    );
  }

  @override
  Future<Either<Failure, MeetingItem>> getMeetingById(String id) {
    return _guard(() => remoteDataSource.getMeetingById(id));
  }

  @override
  Future<Either<Failure, List<MeetingAccountOption>>> getAccounts({
    int skip = 0,
    int take = 200,
  }) {
    return _guard(
      () => remoteDataSource.getAccounts(skip: skip, take: take),
    );
  }

  @override
  Future<Either<Failure, MeetingItem>> createMeeting(
    MeetingWriteRequest request,
  ) {
    return _guard(() => remoteDataSource.createMeeting(request));
  }

  @override
  Future<Either<Failure, MeetingItem>> updateMeeting(
    MeetingWriteRequest request,
  ) {
    return _guard(() => remoteDataSource.updateMeeting(request));
  }
}
