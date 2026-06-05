import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:reefsaudia/core/utils/app_font.dart';

import '../../../../core/blocs/theme_bloc.dart';
import '../../../../core/config/navigation.dart';
import '../../../../core/funcation.dart';
import '../../../../core/services/service_locator.dart';
import '../../../../core/utils/app_color.dart';
import '../../../../core/utils/app_string.dart';
import '../../../../core/utils/app_theme.dart';
import '../../../../core/utils/validators.dart';
import '../../data/repositories/auth_repository_impl.dart';

import '../widgets/login_header_widget.dart';
import '../widgets/login_text_field_widget.dart';

class LoginScrean extends StatefulWidget {
  const LoginScrean({super.key});

  @override
  State<LoginScrean> createState() => _LoginScreanState();
}

class _LoginScreanState extends State<LoginScrean>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.15), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeOutCubic,
          ),
        );

    _animationController.forward();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  Future<void> _onLogin() async {
    if (!(_formKey.currentState?.validate() ?? false) || _isLoading) return;

    setState(() => _isLoading = true);

    final result = await sl<AuthRepositoryImpl>().login(
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );

    if (!mounted) return;
    setState(() => _isLoading = false);

    result.fold(
      (failure) {
        AppFunctions.showsToast(
          failure.errMessage,
          AppColor.kRedColor,
          context,
        );
      },
      (_) => AppFunctions.navigateToAndFinish(context, BottomNavigation()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(Theme.of(context).brightness == Brightness.dark);
  

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: theme.kBgColor,
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              LoginHeaderWidget(
                trailing: BlocBuilder<ThemeBloc, ThemeState>(
                  builder: (context, themeState) {
                    return IconButton(
                      onPressed: () {
                        if (themeState.isDark) {
                          context.read<ThemeBloc>().add(LightThemeEvent());
                        } else {
                          context.read<ThemeBloc>().add(DarkThemeEvent());
                        }
                      },
                      icon: Icon(
                        themeState.isDark
                            ? Icons.light_mode_outlined
                            : Icons.dark_mode_outlined,
                        color: theme.kPrimaryColor,
                      ),
                      tooltip: themeState.isDark
                          ? 'المظهر الفاتح'
                          : 'المظهر الداكن',
                    );
                  },
                ),
              ),
              FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.w),
                    child: _buildLoginCard(context),
                  ),
                ),
              ),
              SizedBox(height: 32.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoginCard(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final secondaryText = theme.textTheme.bodyMedium?.color ??
        AppColor.kGrayTextColor;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(
          color: theme.dividerColor.withValues(alpha: 0.5),
          width: 1,
        ),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            Center(
              child: RobotoText(
                text: AppString.loginTitle.tr(),
                fontSize: 18.sp,
                fontWeight: FontWeight.w700,
                color: colorScheme.onSurface,
              ),
            ),
            SizedBox(height: 24.h),
            LoginTextFieldWidget(
              controller: _emailController,
              label: AppString.emailLabel.tr(),
              hintText: 'example@saudi-reef.sa',
              keyboardType: TextInputType.emailAddress,
              validator: validateEmail,
              prefixIcon: Icons.email_outlined,
            ),
            SizedBox(height: 16.h),
            LoginTextFieldWidget(
              controller: _passwordController,
              label: AppString.passwordLabel.tr(),
              hintText: '••••••••',
              obscureText: _obscurePassword,
              validator: validatePassword,
              prefixIcon: Icons.lock_outline_rounded,
              suffixIcon: IconButton(
                onPressed: _togglePasswordVisibility,
                icon: Icon(
                  _obscurePassword
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: secondaryText,
                  size: 20.sp,
                ),
              ),
            ),
            SizedBox(height: 12.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                RobotoText(
                  text: AppString.forgotYourPassword.tr(),
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                  color: colorScheme.primary,
                ),
              ],
            ),
            SizedBox(height: 28.h),
            _buildLoginButton(context),
            SizedBox(height: 24.h),
          ],
        ),
      ),
    );
  }

  Widget _buildLoginButton(BuildContext context) {
    return GestureDetector(
      onTap: _isLoading ? null : _onLogin,
      child: Container(
        width: double.infinity,
        height: 52.h,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Theme.of(context).colorScheme.primary,
              const Color(0xFF0D9668),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Center(
          child: _isLoading
              ? SizedBox(
                  width: 22.w,
                  height: 22.w,
                  child: const CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : RobotoText(
                  text: AppString.login.tr(),
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
        ),
      ),
    );
  }
}
