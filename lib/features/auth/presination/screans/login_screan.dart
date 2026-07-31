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
import '../../../../core/utils/enums.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/utils/validators.dart';
import '../cubit/auth_cubit.dart';
import '../widgets/login_header_widget.dart';
import '../widgets/login_text_field_widget.dart';

class LoginScrean extends StatelessWidget {
  const LoginScrean({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<AuthCubit>(),
      child: const _LoginView(),
    );
  }
}

class _LoginView extends StatefulWidget {
  const _LoginView();

  @override
  State<_LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<_LoginView>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

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
    setState(() => _obscurePassword = !_obscurePassword);
  }

  void _onLogin() {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    context.read<AuthCubit>().login(
          email: _emailController.text,
          password: _passwordController.text,
        );
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(Theme.of(context).brightness == Brightness.dark);
    final isTablet = context.isTablet;
    final horizontalPad = isTablet ? 40.w : 24.w;

    return BlocListener<AuthCubit, AuthState>(
      listenWhen: (previous, current) =>
          previous.loginStatus != current.loginStatus,
      listener: (context, state) {
        if (state.loginStatus == RequestStatus.error) {
          AppFunctions.showsToast(
            state.loginError,
            AppColor.kRedColor,
            context,
          );
        } else if (state.loginStatus == RequestStatus.success) {
          AppFunctions.navigateToAndFinish(context, BottomNavigation());
        }
      },
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          backgroundColor: theme.kBgColor,
          body: SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: constraints.maxHeight),
                    child: IntrinsicHeight(
                      child: Column(
                        children: [
                          LoginHeaderWidget(
                            trailing: BlocBuilder<ThemeBloc, ThemeState>(
                              builder: (context, themeState) {
                                return IconButton(
                                  onPressed: () {
                                    if (themeState.isDark) {
                                      context
                                          .read<ThemeBloc>()
                                          .add(LightThemeEvent());
                                    } else {
                                      context
                                          .read<ThemeBloc>()
                                          .add(DarkThemeEvent());
                                    }
                                  },
                                  icon: Icon(
                                    themeState.isDark
                                        ? Icons.light_mode_outlined
                                        : Icons.dark_mode_outlined,
                                    color: theme.kPrimaryColor,
                                    size: isTablet ? 28.sp : 24.sp,
                                  ),
                                  tooltip: themeState.isDark
                                      ? 'المظهر الفاتح'
                                      : 'المظهر الداكن',
                                );
                              },
                            ),
                          ),
                          if (isTablet) const Spacer(flex: 1),
                          FadeTransition(
                            opacity: _fadeAnimation,
                            child: SlideTransition(
                              position: _slideAnimation,
                              child: AdaptiveContent(
                                maxWidth: kFormMaxWidth,
                                padding:
                                    EdgeInsets.symmetric(horizontal: horizontalPad),
                                child: _buildLoginCard(context),
                              ),
                            ),
                          ),
                          if (isTablet) const Spacer(flex: 2),
                          SizedBox(height: isTablet ? 48.h : 32.h),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoginCard(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final secondaryText =
        theme.textTheme.bodyMedium?.color ?? AppColor.kGrayTextColor;
    final isTablet = context.isTablet;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: isTablet ? 28.w : 16.w,
        vertical: isTablet ? 32.h : 24.h,
      ),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(
          color: theme.dividerColor.withValues(alpha: 0.5),
          width: 1,
        ),
        boxShadow: isTablet
            ? [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
              ]
            : null,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            Center(
              child: RobotoText(
                text: AppString.loginTitle.tr(),
                fontSize: isTablet ? 22.sp : 18.sp,
                fontWeight: FontWeight.w700,
                color: colorScheme.onSurface,
              ),
            ),
            SizedBox(height: isTablet ? 28.h : 24.h),
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
            SizedBox(height: isTablet ? 32.h : 28.h),
            _buildLoginButton(context),
            SizedBox(height: 24.h),
          ],
        ),
      ),
    );
  }

  Widget _buildLoginButton(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      buildWhen: (previous, current) =>
          previous.loginStatus != current.loginStatus,
      builder: (context, state) {
        final isLoading = state.isLoginLoading;
        final isTablet = context.isTablet;

        return GestureDetector(
          onTap: isLoading ? null : _onLogin,
          child: Container(
            width: double.infinity,
            height: isTablet ? 56.h : 52.h,
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
              child: isLoading
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
                      fontSize: isTablet ? 16.sp : 14.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
            ),
          ),
        );
      },
    );
  }
}
