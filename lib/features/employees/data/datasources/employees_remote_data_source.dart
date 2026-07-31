import 'package:dio/dio.dart';

import '../../../../core/network/dio_helper.dart';
import '../../../../core/network/dx_list_query.dart';
import '../../../../core/network/pmo_endpoints.dart';
import '../../domain/models/employee.dart';

abstract class EmployeesRemoteDataSource {
  Future<EmployeeListResult> getEmployees({
    required int skip,
    required int take,
    String? searchText,
  });

  Future<List<EmployeeOption>> getDesignations();

  Future<List<EmployeeOption>> getDepartments();

  Future<List<EmployeeOption>> getRoles();

  Future<List<EmployeeOption>> getSupervisors();

  Future<void> createEmployee(EmployeeCreateRequest request);

  Future<void> updateEmployee(EmployeeUpdateRequest request);

  Future<void> resetPassword({
    required String userId,
    required String newPassword,
  });

  Future<void> deleteEmployee(String userId);
}

class EmployeesRemoteDataSourceImpl implements EmployeesRemoteDataSource {
  Future<Map<String, dynamic>> _readMapResponse(dynamic body) async {
    if (body is! Map<String, dynamic>) {
      throw const FormatException('Unexpected API response');
    }
    return body;
  }

  @override
  Future<EmployeeListResult> getEmployees({
    required int skip,
    required int take,
    String? searchText,
  }) async {
    final trimmedSearch = searchText?.trim();
    final response = await DioHelper.getData(
      url: PmoEndpoints.accountListDetailsDx,
      query: {
        'isOnlyTeam': false,
        'isOnlySupplier': false,
        'skip': skip,
        'take': take,
        'requireTotalCount': true,
        if (trimmedSearch != null && trimmedSearch.isNotEmpty)
          'filter': DxListQuery.buildContainsFilter(
            fields: const ['email', 'firstName', 'lastName'],
            value: trimmedSearch,
          ),
      },
    );
    final body = await _readMapResponse(response.data);
    final rawItems = body['data'];
    final items = rawItems is List
        ? rawItems
              .whereType<Map<String, dynamic>>()
              .map(EmployeeDto.fromJson)
              .where((item) => item.id.isNotEmpty)
              .toList()
        : <Employee>[];

    return EmployeeListResult(
      items: items,
      totalCount: _toInt(body['totalCount'], fallback: items.length),
    );
  }

  @override
  Future<List<EmployeeOption>> getDesignations() =>
      _fetchTitleOptions(url: PmoEndpoints.designationListDx);

  @override
  Future<List<EmployeeOption>> getDepartments() =>
      _fetchTitleOptions(url: PmoEndpoints.departmentListDx);

  @override
  Future<List<EmployeeOption>> getRoles() async {
    final response = await DioHelper.getData(
      url: PmoEndpoints.roleListDx,
      query: {'skip': 0, 'take': 100, 'requireTotalCount': true},
    );
    final body = await _readMapResponse(response.data);
    final rawItems = body['data'];
    if (rawItems is! List) return const [];

    return rawItems
        .whereType<Map<String, dynamic>>()
        .map(
          (json) => EmployeeOption(
            id: json['id']?.toString() ?? '',
            title: json['name']?.toString() ?? '',
          ),
        )
        .where((item) => item.id.isNotEmpty && item.title.isNotEmpty)
        .toList();
  }

  @override
  Future<List<EmployeeOption>> getSupervisors() async {
    final result = await getEmployees(skip: 0, take: 100);
    return result.items
        .map(
          (employee) => EmployeeOption(
            id: employee.id,
            title: employee.fullName.isNotEmpty
                ? employee.fullName
                : employee.email,
          ),
        )
        .where((item) => item.id.isNotEmpty)
        .toList();
  }

  @override
  Future<void> createEmployee(EmployeeCreateRequest request) async {
    final map = <String, dynamic>{
      'firstName': request.firstName,
      'lastName': request.lastName,
      'email': request.email,
      'password': request.password,
      'gender': request.gender,
      'phone': request.phone,
      'designationId': request.designationId,
      'departmentId': request.departmentId,
      'supervisorId': request.supervisorId,
      'roles': request.roles.join(','),
    };

    final picturePath = request.profilePicturePath;
    if (picturePath != null && picturePath.isNotEmpty) {
      map['profilePicture'] = await MultipartFile.fromFile(
        picturePath,
        filename: picturePath.split('/').last,
      );
    }

    await DioHelper.postData(
      url: PmoEndpoints.accountAddUser,
      data: FormData.fromMap(map),
    );
  }

  @override
  Future<void> updateEmployee(EmployeeUpdateRequest request) async {
    final map = <String, dynamic>{
      'userId': request.userId,
      'roles': request.roles.join(','),
      'firstName': request.firstName,
      'lastName': request.lastName,
      'gender': request.gender,
      'phone': request.phone,
      'designationId': request.designationId,
      'departmentId': request.departmentId,
      'supervisorId': request.supervisorId,
    };

    final picturePath = request.profilePicturePath;
    if (picturePath != null && picturePath.isNotEmpty) {
      map['profilePicture'] = await MultipartFile.fromFile(
        picturePath,
        filename: picturePath.split('/').last,
      );
    }

    await DioHelper.postData(
      url: PmoEndpoints.accountUpdateUser,
      data: FormData.fromMap(map),
    );
  }

  @override
  Future<void> resetPassword({
    required String userId,
    required String newPassword,
  }) async {
    await DioHelper.postData(
      url: PmoEndpoints.accountResetPassword,
      data: {
        'userId': userId,
        'newPassword': newPassword,
        'rePassword': newPassword,
      },
    );
  }

  @override
  Future<void> deleteEmployee(String userId) async {
    await DioHelper.deleteData(
      url: PmoEndpoints.accountDeleteDx,
      data: FormData.fromMap({'key': userId}),
    );
  }

  Future<List<EmployeeOption>> _fetchTitleOptions({required String url}) async {
    final response = await DioHelper.getData(
      url: url,
      query: {
        'skip': 0,
        'take': 100,
        '_': DateTime.now().millisecondsSinceEpoch,
      },
    );
    final body = await _readMapResponse(response.data);
    final rawItems = body['data'];
    if (rawItems is! List) return const [];

    return rawItems
        .whereType<Map<String, dynamic>>()
        .map(
          (json) => EmployeeOption(
            id: json['id']?.toString() ?? '',
            title: json['title']?.toString() ?? '',
          ),
        )
        .where((item) => item.id.isNotEmpty && item.title.isNotEmpty)
        .toList();
  }

  int _toInt(dynamic value, {required int fallback}) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ?? fallback;
  }
}

class EmployeeDto extends Employee {
  const EmployeeDto({
    required super.id,
    required super.email,
    required super.firstName,
    required super.lastName,
    required super.fullName,
    required super.gender,
    required super.phone,
    required super.designation,
    required super.department,
    required super.supervisorId,
    required super.profilePicture,
    required super.readyTasksCount,
    required super.inProgressTasksCount,
  });

  factory EmployeeDto.fromJson(Map<String, dynamic> json) {
    final firstName = json['firstName']?.toString() ?? '';
    final lastName = json['lastName']?.toString() ?? '';
    final fullName = json['fullName']?.toString().trim();

    return EmployeeDto(
      id: json['id']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      firstName: firstName,
      lastName: lastName,
      fullName: (fullName != null && fullName.isNotEmpty)
          ? fullName
          : '$firstName $lastName'.trim(),
      gender: _toInt(json['gender']),
      phone: json['phone']?.toString() ?? '',
      designation: json['designation']?.toString() ?? '',
      department: json['department']?.toString() ?? '',
      supervisorId: json['supervisorId']?.toString(),
      profilePicture: json['profilePicture']?.toString(),
      readyTasksCount: _toInt(json['readyTasksCount']),
      inProgressTasksCount: _toInt(json['inprogressTasksCount']),
    );
  }

  static int _toInt(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }
}
