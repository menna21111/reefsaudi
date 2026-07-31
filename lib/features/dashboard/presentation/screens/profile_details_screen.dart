import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/network/account_user_type.dart';
import '../../../../core/network/api_constant.dart';
import '../../../../core/network/dio_helper.dart';
import '../../../../core/permissions/permission_cubit.dart';
import '../../../../core/utils/app_color_scheme.dart';
import '../../../../core/utils/app_string.dart';
import '../../../../core/utils/app_theme_context.dart';
import '../../../auth/data/models/profile_model.dart';

class ProfileDetailsScreen extends StatefulWidget {
  const ProfileDetailsScreen({super.key});

  static Future<void> open(BuildContext context) {
    return Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const ProfileDetailsScreen()));
  }

  @override
  State<ProfileDetailsScreen> createState() => _ProfileDetailsScreenState();
}

class _ProfileDetailsScreenState extends State<ProfileDetailsScreen> {
  String? _accessToken;

  @override
  void initState() {
    super.initState();
    _loadToken();
  }

  Future<void> _loadToken() async {
    final token = await DioHelper.getAccessToken();
    if (!mounted) return;
    setState(() => _accessToken = token);
  }

  String? _profileImageUrl(ProfileModel? profile) {
    return ApiConstants.resolveProfilePictureUrl(
      profile?.profilePicture,
      token: _accessToken,
    );
  }

  String _valueOrDash(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppString.notAvailable.tr();
    }
    return value.trim();
  }

  String _genderLabel(int? gender) {
    return switch (gender) {
      0 => AppString.genderMale.tr(),
      1 => AppString.genderFemale.tr(),
      _ => AppString.notAvailable.tr(),
    };
  }

  String _accountTypeLabel(ProfileModel? profile) {
    if (profile == null) return AppString.notAvailable.tr();
    return switch (profile.userType) {
      AccountUserType.normalUser => AppString.userTypeNormal.tr(),
      AccountUserType.admin => AppString.userTypeAdmin.tr(),
      AccountUserType.contractor => AppString.userTypeContractor.tr(),
      AccountUserType.consultant => AppString.userTypeConsultant.tr(),
      _ => profile.isContractorAccount
          ? AppString.userTypeContractor.tr()
          : AppString.employee.tr(),
    };
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Scaffold(
      backgroundColor: colors.kBgColor,
      appBar: AppBar(
        backgroundColor: colors.kBgColor,
        elevation: 0,
        centerTitle: true,
        title: Text(
          AppString.profileDetails.tr(),
          style: TextStyle(
            color: colors.kPrimaryColor,
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            fontFamily: 'Almarai',
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: colors.kPrimaryColor,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: BlocBuilder<PermissionCubit, ProfileModel?>(
        builder: (context, profile) {
          final roles = profile?.roles ?? const <String>[];
          final imageUrl = _profileImageUrl(profile);
          final name = profile?.displayName ?? AppString.notAvailable.tr();

          return ListView(
            padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 24.h),
            children: [
              Center(
                child: _DetailsAvatar(
                  colors: colors,
                  imageUrl: imageUrl,
                  name: name,
                ),
              ),
              SizedBox(height: 12.h),
              Text(
                name,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: colors.kFontColor,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Almarai',
                ),
              ),
              SizedBox(height: 20.h),
              Container(
                padding: EdgeInsets.fromLTRB(14.w, 14.h, 14.w, 6.h),
                decoration: BoxDecoration(
                  color: colors.kInputColor,
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(
                    color: colors.kBorderColor.withValues(alpha: 0.35),
                  ),
                ),
                child: Column(
                  children: [
                    _ProfileDetailField(
                      colors: colors,
                      label: AppString.name.tr(),
                      value: _valueOrDash(profile?.displayName),
                    ),
                    _ProfileDetailField(
                      colors: colors,
                      label: AppString.firstName.tr(),
                      value: _valueOrDash(profile?.firstName),
                    ),
                    _ProfileDetailField(
                      colors: colors,
                      label: AppString.lastName.tr(),
                      value: _valueOrDash(profile?.lastName),
                    ),
                    _ProfileDetailField(
                      colors: colors,
                      label: AppString.username.tr(),
                      value: _valueOrDash(profile?.userName),
                    ),
                    _ProfileDetailField(
                      colors: colors,
                      label: AppString.email.tr(),
                      value: _valueOrDash(profile?.email),
                    ),
                    _ProfileDetailField(
                      colors: colors,
                      label: AppString.phoneNumber.tr(),
                      value: _valueOrDash(profile?.phone),
                    ),
                    _ProfileDetailField(
                      colors: colors,
                      label: AppString.gender.tr(),
                      value: _genderLabel(profile?.gender),
                    ),
                    _ProfileDetailField(
                      colors: colors,
                      label: AppString.department.tr(),
                      value: _valueOrDash(profile?.department),
                    ),
                    _ProfileDetailField(
                      colors: colors,
                      label: AppString.designation.tr(),
                      value: _valueOrDash(profile?.designation),
                    ),
                    _ProfileDetailField(
                      colors: colors,
                      label: AppString.supervisor.tr(),
                      value: _valueOrDash(
                        profile?.supervisor ?? profile?.supervisorId,
                      ),
                    ),
                    _ProfileDetailField(
                      colors: colors,
                      label: AppString.accountType.tr(),
                      value: _accountTypeLabel(profile),
                    ),
                    if (roles.isNotEmpty)
                      _ProfileDetailField(
                        colors: colors,
                        label: AppString.role.tr(),
                        value: roles.join(', '),
                      ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _DetailsAvatar extends StatelessWidget {
  const _DetailsAvatar({
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
    return CircleAvatar(
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
    );
  }
}

class _ProfileDetailField extends StatelessWidget {
  const _ProfileDetailField({
    required this.colors,
    required this.label,
    required this.value,
  });

  final AppColorScheme colors;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            label,
            textAlign: FormLayout.alignOf(context),
            textDirection: FormLayout.directionOf(context),
            style: TextStyle(color: colors.kGrayColor, fontSize: 11.sp),
          ),
          SizedBox(height: 4.h),
          Text(
            value,
            textAlign: FormLayout.alignOf(context),
            textDirection: FormLayout.directionOf(context),
            style: TextStyle(
              color: colors.kFontColor,
              fontSize: 13.sp,
              fontWeight: FontWeight.w600,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
