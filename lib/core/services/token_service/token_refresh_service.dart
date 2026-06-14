import 'dart:developer';

import 'package:dio/dio.dart';

import '../../../features/auth/data/models/login_response_model.dart';
import '../../network/api_constant.dart';
import '../../network/pmo_endpoints.dart';
import '../pmo_device_service.dart';
import 'token_storage.dart';

class TokenRefreshService {
  TokenRefreshService({
    required TokenStorage tokenStorage,
    required PmoDeviceService deviceService,
  })  : _tokenStorage = tokenStorage,
        _deviceService = deviceService;

  final TokenStorage _tokenStorage;
  final PmoDeviceService _deviceService;

  Dio? _refreshDio;
  Future<bool>? _refreshFuture;

  Future<void> persistLoginResponse(LoginResponseModel response) async {
    await _tokenStorage.storeToken(response.accessToken);
    final refreshToken = response.refreshToken;
    if (refreshToken != null && refreshToken.isNotEmpty) {
      await _tokenStorage.storeRefreshToken(refreshToken);
    }
    final expiresIn = response.expiresIn;
    if (expiresIn != null && expiresIn.isNotEmpty) {
      await _tokenStorage.storeTokenExpiresAt(expiresIn);
    }
  }

  Future<bool> shouldRefreshProactively() async {
    final expiresAt = await _tokenStorage.getTokenExpiresAt();
    if (expiresAt == null) return false;
    return expiresAt.isBefore(DateTime.now().add(const Duration(minutes: 2)));
  }

  Future<bool> refreshAccessToken() {
    final inFlight = _refreshFuture;
    if (inFlight != null) {
      return inFlight;
    }

    final future = _refreshAccessToken();
    _refreshFuture = future;
    return future.whenComplete(() {
      if (identical(_refreshFuture, future)) {
        _refreshFuture = null;
      }
    });
  }

  Future<bool> _refreshAccessToken() async {
    final refreshToken = await _tokenStorage.getRefreshToken();
    if (refreshToken == null || refreshToken.isEmpty) {
      log('TokenRefreshService - No refresh token available');
      return false;
    }

    try {
      final deviceId = await _deviceService.getDeviceId();
      final firebaseToken = await _deviceService.getFirebaseToken();

      final dio = _refreshDio ??= Dio(
        BaseOptions(
          baseUrl: ApiConstants.reefBaseUrl,
          receiveDataWhenStatusError: true,
          headers: const {'Content-Type': 'application/json'},
        ),
      );

      final response = await dio.post<Map<String, dynamic>>(
        PmoEndpoints.refreshToken,
        data: {
          'refreshToken': refreshToken,
          'deviceId': deviceId,
          'firbaseTokin': firebaseToken,
        },
      );

      final data = response.data;
      if (data == null) {
        log('TokenRefreshService - Empty refresh response');
        return false;
      }

      await persistLoginResponse(LoginResponseModel.fromJson(data));
      log('TokenRefreshService - Access token refreshed');
      return true;
    } catch (e, stackTrace) {
      log('TokenRefreshService - Refresh failed: $e', stackTrace: stackTrace);
      return false;
    }
  }
}
