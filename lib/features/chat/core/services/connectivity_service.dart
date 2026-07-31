import 'package:internet_connection_checker/internet_connection_checker.dart';

/// Emits connectivity changes for the chat WebSocket layer.
class ConnectivityService {
  ConnectivityService([InternetConnectionChecker? checker])
    : _checker = checker ?? InternetConnectionChecker();

  final InternetConnectionChecker _checker;

  /// Emits `true` when the device has real internet, `false` when offline.
  Stream<bool> get onStatusChange => _checker.onStatusChange.map(
    (status) => status == InternetConnectionStatus.connected,
  );

  /// One-shot check for current internet availability.
  Future<bool> get hasInternet => _checker.hasConnection;
}
