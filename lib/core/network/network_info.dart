import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

abstract class NetworkInfo {
  Future<bool> get isConnected;
}

class NetworkInfoImpl implements NetworkInfo {
  final InternetConnectionChecker _connectionChecker =
      GetIt.instance<InternetConnectionChecker>();

  @override
  Future<bool> get isConnected => _connectionChecker.hasConnection;
}
