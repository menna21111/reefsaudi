import '../../../../core/network/dio_helper.dart';
import '../../../../core/network/pmo_endpoints.dart';
import '../models/meeting_models.dart';

abstract class MeetingsRemoteDataSource {
  Future<MeetingsListResponse> getMeetings({
    required DateTime rangeStart,
    required DateTime rangeEnd,
    int skip = 0,
    int take = 20,
  });

  Future<MeetingItem> getMeetingById(String id);

  Future<List<MeetingAccountOption>> getAccounts({
    int skip = 0,
    int take = 200,
  });

  Future<MeetingItem> createMeeting(MeetingWriteRequest request);

  Future<MeetingItem> updateMeeting(MeetingWriteRequest request);
}

class MeetingsRemoteDataSourceImpl implements MeetingsRemoteDataSource {
  MeetingItem _parseMeeting(dynamic body, MeetingWriteRequest? fallback) {
    if (body is Map<String, dynamic>) {
      final nested = body['data'];
      if (nested is Map<String, dynamic>) {
        return MeetingItem.fromJson(nested);
      }
      if (body.containsKey('id') || body.containsKey('title')) {
        return MeetingItem.fromJson(body);
      }
    }

    if (fallback == null) {
      throw const FormatException('Unexpected meeting response');
    }

    return MeetingItem(
      id: fallback.id ?? '',
      title: fallback.title,
      startDate: fallback.startDate,
      endDate: fallback.endDate,
      description: fallback.description,
      location: fallback.location,
      employeesIds: fallback.employeesIds,
      topics: fallback.topics,
      isPublished: fallback.isPublished,
    );
  }

  @override
  Future<MeetingsListResponse> getMeetings({
    required DateTime rangeStart,
    required DateTime rangeEnd,
    int skip = 0,
    int take = 20,
  }) async {
    final response = await DioHelper.getData(
      url: PmoEndpoints.meetings,
      query: {
        'skip': skip,
        'take': take,
        'filter': MeetingsFilterBuilder.forRange(rangeStart, rangeEnd),
      },
    );

    final body = response.data;
    if (body is! Map<String, dynamic>) {
      throw const FormatException('Unexpected meetings response');
    }
    return MeetingsListResponse.fromJson(body);
  }

  @override
  Future<MeetingItem> getMeetingById(String id) async {
    final response = await DioHelper.getData(
      url: PmoEndpoints.meetingById(id),
    );
    return _parseMeeting(response.data, null);
  }

  @override
  Future<List<MeetingAccountOption>> getAccounts({
    int skip = 0,
    int take = 200,
  }) async {
    final response = await DioHelper.getData(
      url: PmoEndpoints.accountListDx,
      query: {
        'skip': skip,
        'take': take,
        '_': DateTime.now().millisecondsSinceEpoch,
      },
    );
    final body = response.data;
    if (body is Map<String, dynamic>) {
      return parseMeetingAccounts(body['data']);
    }
    return parseMeetingAccounts(body);
  }

  @override
  Future<MeetingItem> createMeeting(MeetingWriteRequest request) async {
    final response = await DioHelper.postData(
      url: PmoEndpoints.meetings,
      data: request.toJson(),
    );
    return _parseMeeting(response.data, request);
  }

  @override
  Future<MeetingItem> updateMeeting(MeetingWriteRequest request) async {
    final response = await DioHelper.putData(
      url: PmoEndpoints.meetings,
      data: request.toJson(),
      legacyAuthQuery: false,
    );
    return _parseMeeting(response.data, request);
  }
}
