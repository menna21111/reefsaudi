import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/blocs/theme_bloc.dart';
import '../../../../core/funcation.dart';
import '../../../../core/network/api_constant.dart';
import '../../../../core/network/dio_helper.dart';
import '../../../../core/permissions/permission_cubit.dart';
import '../../../../core/services/service_locator.dart';
import '../../../../core/services/token_service/token_storage.dart';
import '../../../../core/utils/app_color.dart';
import '../../../../core/utils/app_color_scheme.dart';
import '../../../../core/utils/app_string.dart';
import '../../../../core/utils/app_theme.dart';
import '../../../../core/utils/app_theme_context.dart';
import '../../../auth/data/models/profile_model.dart';
import '../../../auth/data/repositories/auth_repository_impl.dart';
import '../../../auth/presination/screans/login_screan.dart';
import 'profile_details_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isRefreshing = false;
  String? _accessToken;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadProfile());
  }

  Future<void> _loadProfile() async {
    final cubit = context.read<PermissionCubit>();
    if (cubit.state == null) {
      await cubit.loadCached();
    }
    final token = await DioHelper.getAccessToken();
    if (!mounted) return;
    setState(() {
      _accessToken = token;
      _isRefreshing = true;
    });
    await sl<AuthRepositoryImpl>().refreshProfile();
    if (mounted) setState(() => _isRefreshing = false);
  }

  String? _profileImageUrl(ProfileModel? profile) {
    return ApiConstants.resolveProfilePictureUrl(
      profile?.profilePicture,
      token: _accessToken,
    );
  }

  static const _privacyUrl = 'https://reefpmo.com/privacy';
  static const _supportUrl = 'https://reefpmo.com/support';

  Future<void> _openExternalUrl(String url) async {
    final uri = Uri.parse(url);
    final launched = await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    );
    if (!mounted || launched) return;
    AppFunctions.showsToast(
      AppString.unKnownError.tr(),
      AppColor.kRedColor,
      context,
    );
  }

  Future<void> _confirmLogout() async {
    final colors = context.appColorsRead;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: colors.kInputColor,
        title: Text(
          AppString.logOut.tr(),
          style: TextStyle(color: colors.kFontColor),
        ),
        content: Text(
          AppString.areYouSureLogOut.tr(),
          style: TextStyle(color: colors.kGrayColor),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(AppString.cancel.tr()),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: FilledButton.styleFrom(backgroundColor: colors.kRedColor),
            child: Text(AppString.logOut.tr()),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    await sl<TokenStorage>().clearToken();
    await context.read<PermissionCubit>().clear();
    if (!mounted) return;
    AppFunctions.navigateToAndFinish(context, const LoginScrean());
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = context.locale.languageCode == 'ar';

    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, themeState) {
        final colors = AppTheme.of(themeState.isDark);

        return Theme(
          data: Theme.of(context).copyWith(
            scaffoldBackgroundColor: colors.kBgColor,
            dividerColor: colors.kBorderColor.withValues(alpha: 0.25),
            switchTheme: SwitchThemeData(
              thumbColor: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.selected)) {
                  return colors.kWhiteColor;
                }
                return colors.kGrayColor;
              }),
              trackColor: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.selected)) {
                  return colors.kPrimaryColor.withValues(alpha: 0.55);
                }
                return colors.kBorderColor.withValues(alpha: 0.35);
              }),
            ),
            listTileTheme: ListTileThemeData(
              iconColor: colors.kPrimaryColor,
              textColor: colors.kFontColor,
            ),
          ),
          child: Scaffold(
            backgroundColor: colors.kBgColor,
            appBar: AppBar(
              backgroundColor: colors.kInputColor,
              surfaceTintColor: Colors.transparent,
              elevation: 0,
              centerTitle: true,
              iconTheme: IconThemeData(color: colors.kPrimaryColor),
              title: Text(
                AppString.personalProfile.tr(),
                style: TextStyle(
                  color: colors.kFontColor,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              actions: [
                if (_isRefreshing)
                  Padding(
                    padding: EdgeInsetsDirectional.only(end: 16.w),
                    child: Center(
                      child: SizedBox(
                        width: 20.w,
                        height: 20.w,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: colors.kPrimaryColor,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            body: BlocBuilder<PermissionCubit, ProfileModel?>(
              builder: (context, profile) {
                final imageUrl = _profileImageUrl(profile);
                final roles = profile?.roles ?? const [];
                final primaryRole = roles.isNotEmpty ? roles.first : null;

                return RefreshIndicator(
                  color: colors.kPrimaryColor,
                  backgroundColor: colors.kInputColor,
                  onRefresh: _loadProfile,
                  child: ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: EdgeInsets.all(16.w),
                    children: [
                      _ProfileHeaderCard(
                        colors: colors,
                        profile: profile,
                        imageUrl: imageUrl,
                        primaryRole: primaryRole,
                        onTap: () => ProfileDetailsScreen.open(context),
                      ),
                      SizedBox(height: 20.h),
                      _SectionTitle(
                        colors: colors,
                        title: AppString.general.tr(),
                      ),
                      SizedBox(height: 10.h),
                      _SettingsGroup(
                        colors: colors,
                        items: [
                          _SettingItem(
                            icon: Icons.person_outline_rounded,
                            title: AppString.profileDetails.tr(),
                            onTap: () => ProfileDetailsScreen.open(context),
                          ),
                          _SettingItem(
                            icon: Icons.language_rounded,
                            title: AppString.language.tr(),
                            trailing: Text(
                              isArabic
                                  ? AppString.arabicLanguage.tr()
                                  : AppString.englishLanguage.tr(),
                              style: TextStyle(
                                color: colors.kPrimaryColor,
                                fontSize: 14.sp,
                              ),
                            ),
                            onTap: () {
                              context.setLocale(
                                isArabic
                                    ? const Locale('en')
                                    : const Locale('ar'),
                              );
                            },
                          ),
                          _SettingItem(
                            icon: Icons.dark_mode_outlined,
                            title: AppString.darkMode.tr(),
                            onTap: () {},
                            trailing: Switch.adaptive(
                              value: themeState.isDark,
                              onChanged: (isDark) {
                                context.read<ThemeBloc>().add(
                                  isDark ? DarkThemeEvent() : LightThemeEvent(),
                                );
                              },
                            ),
                          ),
                          // TODO: enable when ready
                          // _SettingItem(
                          //   icon: Icons.notifications_outlined,
                          //   title: AppString.notifications.tr(),
                          //   trailing:
                          //       profile != null &&
                          //           profile.unreadNotifications > 0
                          //       ? _Badge(
                          //           colors: colors,
                          //           label: '${profile.unreadNotifications}',
                          //         )
                          //       : null,
                          //   onTap: () {},
                          // ),
                          // _SettingItem(
                          //   icon: Icons.security_outlined,
                          //   title: AppString.security.tr(),
                          //   onTap: () {},
                          // ),
                          // _SettingItem(
                          //   icon: Icons.lock_outline_rounded,
                          //   title: AppString.changePassword.tr(),
                          //   onTap: () {},
                          // ),
                          _SettingItem(
                            icon: Icons.folder_outlined,
                            title: AppString.documents.tr(),
                            onTap: () {},
                          ),
                        ],
                      ),
                      SizedBox(height: 20.h),
                      _SectionTitle(
                        colors: colors,
                        title: AppString.legalSection.tr(),
                      ),
                      SizedBox(height: 10.h),
                      _SettingsGroup(
                        colors: colors,
                        items: [
                          _SettingItem(
                            icon: Icons.privacy_tip_outlined,
                            title: AppString.privacyPolicy.tr(),
                            onTap: () => _openExternalUrl(_privacyUrl),
                          ),
                          // TODO: enable when ready
                          // _SettingItem(
                          //   icon: Icons.description_outlined,
                          //   title: AppString.termsOfUse.tr(),
                          //   onTap: () {},
                          // ),
                          // _SettingItem(
                          //   icon: Icons.verified_user_outlined,
                          //   title: AppString.warrantySupport.tr(),
                          //   onTap: () {},
                          // ),
                        ],
                      ),
                      SizedBox(height: 20.h),
                      _SectionTitle(
                        colors: colors,
                        title: AppString.helpAndSupport.tr(),
                      ),
                      SizedBox(height: 10.h),
                      _SettingsGroup(
                        colors: colors,
                        items: [
                          _SettingItem(
                            icon: Icons.support_agent_outlined,
                            title: AppString.contactSupport.tr(),
                            onTap: () => _openExternalUrl(_supportUrl),
                          ),
                        ],
                      ),
                      SizedBox(height: 20.h),
                      _SectionTitle(
                        colors: colors,
                        title: AppString.aboutApp.tr(),
                      ),
                      SizedBox(height: 10.h),
                      _SettingsGroup(
                        colors: colors,
                        items: [
                          _SettingItem(
                            icon: Icons.apps_rounded,
                            title: AppString.saudiReef.tr(),
                            trailing: Text(
                              '${AppString.appVersion.tr()} 1.0.0',
                              style: TextStyle(
                                color: colors.kGrayColor,
                                fontSize: 13.sp,
                              ),
                            ),
                            onTap: () {},
                          ),
                        ],
                      ),
                      SizedBox(height: 20.h),
                      _SettingsGroup(
                        colors: colors,
                        items: [
                          _SettingItem(
                            icon: Icons.logout_rounded,
                            title: AppString.signOut.tr(),
                            iconColor: colors.kRedColor,
                            textColor: colors.kRedColor,
                            onTap: _confirmLogout,
                          ),
                        ],
                      ),
                      SizedBox(height: 24.h),
                    ],
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}

class _ProfileHeaderCard extends StatelessWidget {
  const _ProfileHeaderCard({
    required this.colors,
    required this.profile,
    required this.imageUrl,
    required this.primaryRole,
    required this.onTap,
  });

  final AppColorScheme colors;
  final ProfileModel? profile;
  final String? imageUrl;
  final String? primaryRole;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final name = profile?.displayName ?? AppString.notAvailable.tr();
    final email = profile?.email ?? '';

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16.r),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 24.h, horizontal: 16.w),
        decoration: BoxDecoration(
          color: colors.kInputColor,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: colors.kBorderColor.withValues(alpha: 0.35),
          ),
        ),
        child: Column(
          children: [
            _Avatar(colors: colors, imageUrl: imageUrl, name: name),
            SizedBox(height: 14.h),
            Text(
              name,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: colors.kFontColor,
              ),
            ),
            if (email.isNotEmpty) ...[
              SizedBox(height: 6.h),
              Text(
                email,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14.sp, color: colors.kGrayColor),
              ),
            ],
            if (primaryRole != null) ...[
              SizedBox(height: 10.h),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: colors.kPrimaryColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Text(
                  primaryRole!,
                  style: TextStyle(
                    color: colors.kPrimaryColor,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
            SizedBox(height: 10.h),
            Text(
              AppString.profileDetails.tr(),
              style: TextStyle(
                color: colors.kPrimaryColor,
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({
    required this.colors,
    required this.imageUrl,
    required this.name,
  });

  final AppColorScheme colors;
  final String? imageUrl;
  final String name;

  String get _initials {
    final parts = name
        .trim()
        .split(RegExp(r'\s+'))
        .where((p) => p.isNotEmpty)
        .toList();
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return '${parts[0][0]}${parts.last[0]}'.toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: colors.kPrimaryColor.withValues(alpha: 0.35),
          width: 2,
        ),
      ),
      child: CircleAvatar(
        radius: 44.r,
        backgroundColor: colors.kPrimaryColor.withValues(alpha: 0.12),
        backgroundImage: imageUrl != null
            ? CachedNetworkImageProvider(imageUrl!)
            : null,
        child: imageUrl == null
            ? Text(
                _initials,
                style: TextStyle(
                  color: colors.kPrimaryColor,
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                ),
              )
            : null,
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.colors, required this.title});

  final AppColorScheme colors;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional.centerStart,
      child: Text(
        title,
        style: TextStyle(
          color: colors.kFontColor,
          fontSize: 16.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _SettingItem {
  const _SettingItem({
    required this.icon,
    required this.title,
    required this.onTap,
    this.trailing,
    this.iconColor,
    this.textColor,
  });

  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final Widget? trailing;
  final Color? iconColor;
  final Color? textColor;
}

class _SettingsGroup extends StatelessWidget {
  const _SettingsGroup({required this.colors, required this.items});

  final AppColorScheme colors;
  final List<_SettingItem> items;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: colors.kInputColor,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: colors.kBorderColor.withValues(alpha: 0.35)),
      ),
      child: Column(
        children: [
          for (var i = 0; i < items.length; i++) ...[
            ListTile(
              onTap: items[i].onTap,
              leading: Icon(
                items[i].icon,
                color: items[i].iconColor ?? colors.kPrimaryColor,
              ),
              title: Text(
                items[i].title,
                style: TextStyle(
                  color: items[i].textColor ?? colors.kFontColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 15.sp,
                ),
              ),
              trailing: items[i].trailing,
            ),
            if (i < items.length - 1)
              Divider(
                height: 1,
                indent: 16.w,
                endIndent: 16.w,
                color: colors.kBorderColor.withValues(alpha: 0.25),
              ),
          ],
        ],
      ),
    );
  }
}

// TODO: restore with notifications when ready
// class _Badge extends StatelessWidget {
//   const _Badge({required this.colors, required this.label});
//
//   final AppColorScheme colors;
//   final String label;
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
//       decoration: BoxDecoration(
//         color: colors.kRedColor.withValues(alpha: 0.12),
//         borderRadius: BorderRadius.circular(20.r),
//       ),
//       child: Text(
//         label,
//         style: TextStyle(
//           color: colors.kRedColor,
//           fontSize: 12.sp,
//           fontWeight: FontWeight.bold,
//         ),
//       ),
//     );
//   }
// }
