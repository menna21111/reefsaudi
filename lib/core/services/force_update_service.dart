// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:package_info_plus/package_info_plus.dart';
// import 'package:collectorapp/core/services/service_locator.dart';
// import 'package:collectorapp/core/services/token_service/token_storage.dart';
// import 'package:store_redirect/store_redirect.dart';
// import 'package:firebase_remote_config/firebase_remote_config.dart';
// import 'package:firebase_core/firebase_core.dart';

// class ForceUpdateService {
//   static final ForceUpdateService _instance = ForceUpdateService._internal();
//   factory ForceUpdateService() => _instance;
//   ForceUpdateService._internal();

//   late FirebaseRemoteConfig _remoteConfig;

//   Future<void> _initializeRemoteConfig() async {
//     try {
//       // Ensure Firebase is initialized before accessing Remote Config
//       if (!Firebase.apps.isNotEmpty) {
//         throw Exception('Firebase not initialized');
//       }

//       _remoteConfig = FirebaseRemoteConfig.instance;

//       await _remoteConfig.setDefaults({
//         'force_update_enabled': true,
//         'min_required_version': '1.0.1',
//         'latest_version': '1.0.3',
//         'update_message_ar': 'يجب تحديث التطبيق فورا من فضلك',
//         'is_force_update': true,
//         'android_package_name': "com.qarib.qarib.qarib",
//         'ios_app_id': '6749022513',
//       });

//       await _remoteConfig.setConfigSettings(RemoteConfigSettings(
//         fetchTimeout: const Duration(seconds: 10),
//         minimumFetchInterval: const Duration(seconds: 10),
//       ));

//       await _remoteConfig.fetchAndActivate();
//     } catch (e) {
//       debugPrint('Error initializing Remote Config: $e');
//     }
//   }

//   Future<ForceUpdateResult> checkForUpdate() async {
//     try {
//       debugPrint('🔄 Starting Force Update check...');

//       await _initializeRemoteConfig();
//       debugPrint('✅ Remote Config initialized');

//       PackageInfo packageInfo = await PackageInfo.fromPlatform();
//       String currentVersion = packageInfo.version;
//       debugPrint('📱 Current app version: $currentVersion');

//       bool forceUpdateEnabled = _remoteConfig.getBool('force_update_enabled');
//       String minRequiredVersion =
//           _remoteConfig.getString('min_required_version');
//       String latestVersion = _remoteConfig.getString('latest_version');
//       String updateMessage = _remoteConfig.getString('update_message_ar');
//       bool isForceUpdate = _remoteConfig.getBool('is_force_update');

//       debugPrint('🎛️ Remote Config values:');
//       debugPrint('   - force_update_enabled: $forceUpdateEnabled');
//       debugPrint('   - min_required_version: $minRequiredVersion');
//       debugPrint('   - latest_version: $latestVersion');
//       debugPrint('   - is_force_update: $isForceUpdate');
//       debugPrint('   - update_message_ar: $updateMessage');

//       bool needsUpdate = _isVersionLower(currentVersion, minRequiredVersion);
//       bool hasNewVersion = _isVersionLower(currentVersion, latestVersion);

//       debugPrint('🔍 Version comparison:');
//       debugPrint('   - needsUpdate (current < min_required): $needsUpdate');
//       debugPrint('   - hasNewVersion (current < latest): $hasNewVersion');

//       final result = ForceUpdateResult(
//         isUpdateRequired: forceUpdateEnabled && (needsUpdate || hasNewVersion),
//         isForceUpdate: forceUpdateEnabled &&
//             isForceUpdate &&
//             (needsUpdate || hasNewVersion),
//         latestVersion: latestVersion,
//         updateMessage: updateMessage.isNotEmpty
//             ? updateMessage
//             : 'يتوفر تحديث جديد للتطبيق',
//         storeUrl: Platform.isIOS
//             ? 'itms-apps://itunes.apple.com/app/id${_remoteConfig.getString('ios_app_id')}'
//             : 'market://details?id=${_remoteConfig.getString('android_package_name')}',
//       );

//       debugPrint('🎯 Final result:');
//       debugPrint('   - isUpdateRequired: ${result.isUpdateRequired}');
//       debugPrint('   - isForceUpdate: ${result.isForceUpdate}');

//       return result;
//     } catch (e) {
//       debugPrint('❌ Error checking for update: $e');
//       return ForceUpdateResult(
//         isUpdateRequired: false,
//         isForceUpdate: false,
//         latestVersion: '',
//         updateMessage: '',
//         storeUrl: '',
//       );
//     }
//   }

//   bool _isVersionLower(String currentVersion, String requiredVersion) {
//     try {
//       // Remove build numbers (e.g., "1.0.2+9" becomes "1.0.2")
//       String cleanCurrent = currentVersion.split('+')[0];
//       String cleanRequired = requiredVersion.split('+')[0];

//       debugPrint('🔍 Comparing versions: $cleanCurrent vs $cleanRequired');

//       List<int> current = cleanCurrent.split('.').map(int.parse).toList();
//       List<int> required = cleanRequired.split('.').map(int.parse).toList();

//       while (current.length < required.length) current.add(0);
//       while (required.length < current.length) required.add(0);

//       for (int i = 0; i < current.length; i++) {
//         if (current[i] < required[i]) return true;
//         if (current[i] > required[i]) return false;
//       }
//       return false;
//     } catch (e) {
//       debugPrint('❌ Error comparing versions: $e');
//       return false;
//     }
//   }

//   Future<void> checkForceUpdate({required BuildContext context}) async {
//     final updateResult = await checkForUpdate();

//     if (updateResult.isUpdateRequired && context.mounted) {
//       await _showForceUpdateDialog(context, updateResult);
//     }
//   }

//   Future<void> _showForceUpdateDialog(
//     BuildContext context,
//     ForceUpdateResult updateResult,
//   ) async {
//     return showDialog<void>(
//       context: context,
//       barrierDismissible: !updateResult.isForceUpdate,
//       builder: (BuildContext context) {
//         return WillPopScope(
//           onWillPop: () async => !updateResult.isForceUpdate,
//           child: AlertDialog(
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(16),
//             ),
//             title: Row(
//               children: [
//                 Icon(
//                   Icons.system_update,
//                   color: Theme.of(context).primaryColor,
//                   size: 24,
//                 ),
//                 const SizedBox(width: 8),
//                 Expanded(
//                   child: Text(
//                     updateResult.isForceUpdate ? "تحديث إجباري" : "تحديث متاح",
//                     style: TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                       color: Theme.of(context).primaryColor,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             content: Column(
//               mainAxisSize: MainAxisSize.min,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   updateResult.updateMessage,
//                   style: TextStyle(
//                     fontSize: 14,
//                     color: Colors.grey[700],
//                   ),
//                   textAlign: TextAlign.center,
//                 ),
//                 const SizedBox(height: 16),
//                 if (updateResult.latestVersion.isNotEmpty)
//                   Container(
//                     padding: const EdgeInsets.all(12),
//                     decoration: BoxDecoration(
//                       color: Theme.of(context).primaryColor.withOpacity(0.1),
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         const Text(
//                           "الإصدار الجديد:",
//                           style: TextStyle(
//                             fontSize: 12,
//                             fontWeight: FontWeight.w600,
//                           ),
//                         ),
//                         Text(
//                           updateResult.latestVersion,
//                           style: TextStyle(
//                             fontSize: 12,
//                             fontWeight: FontWeight.bold,
//                             color: Theme.of(context).primaryColor,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 if (updateResult.isForceUpdate) ...[
//                   const SizedBox(height: 12),
//                   Container(
//                     padding: const EdgeInsets.all(8),
//                     decoration: BoxDecoration(
//                       color: Colors.red.withOpacity(0.1),
//                       borderRadius: BorderRadius.circular(6),
//                       border: Border.all(color: Colors.red.withOpacity(0.3)),
//                     ),
//                     child: Row(
//                       children: [
//                         const Icon(
//                           Icons.warning,
//                           color: Colors.red,
//                           size: 16,
//                         ),
//                         const SizedBox(width: 8),
//                         Expanded(
//                           child: Text(
//                             "هذا التحديث إجباري ولا يمكن تجاهله",
//                             style: TextStyle(
//                               fontSize: 11,
//                               color: Colors.red[700],
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ],
//             ),
//             actions: [
//               if (!updateResult.isForceUpdate)
//                 TextButton(
//                   onPressed: () async {
//                     Navigator.of(context).pop();
//                     await sl<TokenStorage>().clearToken();
//                     sl<TokenStorage>().storeUserId(0);
//                   },
//                   child: Text(
//                     "لاحقاً",
//                     style: TextStyle(
//                       fontSize: 14,
//                       color: Colors.grey[600],
//                     ),
//                   ),
//                 ),
//               ElevatedButton(
//                 onPressed: () async {
//                   await openStore();
//                   await sl<TokenStorage>().clearToken();
//                   sl<TokenStorage>().storeUserId(0);
//                 },
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Theme.of(context).primaryColor,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   padding:
//                       const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
//                 ),
//                 child: const Text(
//                   "تحديث الآن",
//                   style: TextStyle(
//                     fontSize: 14,
//                     color: Colors.white,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   Future<void> openStore() async {
//     try {
//       String androidPackageName =
//           _remoteConfig.getString('android_package_name');
//       String iosAppId = _remoteConfig.getString('ios_app_id');

//       await StoreRedirect.redirect(
//         androidAppId: androidPackageName.isNotEmpty
//             ? androidPackageName
//             : 'com.yourcompany.qarib',
//         iOSAppId: iosAppId.isNotEmpty ? iosAppId : '1234567890',
//       );
//     } catch (e) {
//       debugPrint('Error opening store: $e');
//     }
//   }
// }

// class ForceUpdateResult {
//   final bool isUpdateRequired;
//   final bool isForceUpdate;
//   final String latestVersion;
//   final String updateMessage;
//   final String storeUrl;
//   final bool shouldForceLogout; // Add this line

//   ForceUpdateResult({
//     required this.isUpdateRequired,
//     required this.isForceUpdate,
//     required this.latestVersion,
//     required this.updateMessage,
//     required this.storeUrl,
//     this.shouldForceLogout = false, // Add this line with default value
//   });
// }
