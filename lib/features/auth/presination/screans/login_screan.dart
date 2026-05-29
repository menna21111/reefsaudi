import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:reefsaudia/core/utils/app_font.dart';

import '../../../../core/config/navigation.dart';
import '../../../../core/funcation.dart';
import '../../../../core/utils/app_color.dart';
import '../../../../core/utils/app_string.dart';
import '../../../../core/utils/validators.dart';

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

  void _onLogin() {
    if (_formKey.currentState?.validate() ?? false) {
      // TODO: Integrate with AuthBloc
      AppFunctions.navigateToAndFinish(context, BottomNavigation());
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: AppColor.kBackgroundColor,
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              const LoginHeaderWidget(),

              FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.w),
                    child: _buildLoginCard(),
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

  Widget _buildLoginCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
      decoration: BoxDecoration(
        color: AppColor.kSurfaceColor,
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(
          color: AppColor.kBorderColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            // استخدام المفتاح بدلاً من النص المباشر
            Center(
              child: RobotoText(
                text: AppString.loginTitle.tr(), // 👈 استخدام المفتاح

                fontSize: 18.sp,
                fontWeight: FontWeight.w700,
                color: AppColor.kWhiteColor,
              ),
            ),
            SizedBox(height: 24.h),

            LoginTextFieldWidget(
              controller: _emailController,
              label: AppString.emailLabel.tr(), // 👈 استخدام المفتاح
              hintText: 'example@saudi-reef.sa',
              keyboardType: TextInputType.emailAddress,
              validator: validateEmail,
              prefixIcon: Icons.email_outlined,
            ),
            SizedBox(height: 16.h),

            LoginTextFieldWidget(
              controller: _passwordController,
              label: AppString.passwordLabel.tr(), // 👈 استخدام المفتاح
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
                  color: AppColor.kGrayTextColor,
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
                  color: AppColor.kPrimaryColor,
                ),
              ],
            ),
            SizedBox(height: 28.h),

            _buildLoginButton(),
            SizedBox(height: 24.h),
          ],
        ),
      ),
    );
  }

  Widget _buildLoginButton() {
    return GestureDetector(
      onTap: _onLogin,
      child: Container(
        width: double.infinity,
        height: 52.h,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppColor.kPrimaryColor, Color(0xFF0D9668)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12.r),
          // boxShadow: [
          //   BoxShadow(
          //     color: AppColor.kPrimaryColor.withOpacity(0.35),
          //     blurRadius: 16,
          //     offset: const Offset(0, 6),
          //   ),
          // ],
        ),
        child: Center(
          child: RobotoText(
            text: AppString.login.tr(), // 👈 استخدام المفتاح
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: AppColor.kSurfaceContainer,
          ),
        ),
      ),
    );
  }
}
