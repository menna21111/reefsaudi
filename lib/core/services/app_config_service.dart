// import 'package:firebase_remote_config/firebase_remote_config.dart';
// import 'package:flutter/foundation.dart';
// import 'package:collectorapp/core/network/api_constant.dart';

// class AppConfigService {
//   static final AppConfigService _instance = AppConfigService._internal();
//   factory AppConfigService() => _instance;
//   AppConfigService._internal();

//   final FirebaseRemoteConfig _remoteConfig = FirebaseRemoteConfig.instance;

//   Future<void> initialize() async {
//     try {
//       // Set default values
//       await _remoteConfig.setDefaults({
//         'use_dev_server': false, // Default to Production for safety
//       });

//       // Fetch and activate
//       // During development, we might want to fetch frequently.
//       // For production, the default cache expiration is usually 12 hours.
//       // But for this "testing period", they might want shorter cache.
//       await _remoteConfig.setConfigSettings(RemoteConfigSettings(
//         fetchTimeout: const Duration(minutes: 1),
//         minimumFetchInterval:
//             kDebugMode ? const Duration(seconds: 0) : const Duration(hours: 1),
//       ));

//       await _remoteConfig.fetchAndActivate();

//       // Read the value
//       final bool useDevServer = _remoteConfig.getBool('use_dev_server');

//       debugPrint("🔧 Remote Config: use_dev_server = $useDevServer");

//       // Update ApiConstants
//       ApiConstants.useDevServer = useDevServer;
//       debugPrint("🌐 Active Base URL: ${ApiConstants.baseUrl}");
//       debugPrint(
//           "🚀 Environment: ${useDevServer ? 'Development' : 'Production'}");
//     } catch (e) {
//       debugPrint("❌ Failed to initialize Remote Config: $e");
//       // Fallback is already handled by defaults in ApiConstants (usually you set a default there too)
//     }
//   }
// }
