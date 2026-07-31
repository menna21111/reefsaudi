import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../../core/network/api_constant.dart';
import '../../../../core/network/dio_helper.dart';
import '../../../../core/utils/app_theme_context.dart';

class ProjectImageCard extends StatefulWidget {
  const ProjectImageCard({
    super.key,
    required this.imageUrls,
  });

  final List<String> imageUrls;

  @override
  State<ProjectImageCard> createState() => _ProjectImageCardState();
}

class _ProjectImageCardState extends State<ProjectImageCard> {
  static const _autoPlayInterval = Duration(seconds: 4);

  late final PageController _pageController;
  Timer? _autoPlayTimer;
  int _currentPage = 0;
  String? _accessToken;
  bool _tokenLoaded = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _loadAccessToken();
    _startAutoPlay();
  }

  Future<void> _loadAccessToken() async {
    final token = await DioHelper.getAccessToken();
    final normalized = ApiConstants.normalizeJweAccessToken(token);
    if (normalized != null) {
      log('Project image JWE parts: ${ApiConstants.jweTokenPartCount(normalized)}');
      log('Project image JWE starts with eyJ: ${ApiConstants.jweTokenStartsWithHeader(normalized)}');
      log('Project image JWE header: ${normalized.split('.').first}');
    }
    if (!mounted) return;
    setState(() {
      _accessToken = normalized;
      _tokenLoaded = true;
    });
  }

  @override
  void didUpdateWidget(covariant ProjectImageCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.imageUrls.length != widget.imageUrls.length) {
      _currentPage = 0;
      if (_pageController.hasClients) {
        _pageController.jumpToPage(0);
      }
      _restartAutoPlay();
    }
  }

  @override
  void dispose() {
    _autoPlayTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _startAutoPlay() {
    _autoPlayTimer?.cancel();
    if (widget.imageUrls.length <= 1) return;

    _autoPlayTimer = Timer.periodic(_autoPlayInterval, (_) {
      if (!mounted || !_pageController.hasClients) return;

      final nextPage = (_currentPage + 1) % widget.imageUrls.length;
      _pageController.animateToPage(
        nextPage,
        duration: const Duration(milliseconds: 450),
        curve: Curves.easeInOut,
      );
    });
  }

  void _restartAutoPlay() {
    _autoPlayTimer?.cancel();
    _startAutoPlay();
  }

  void _onPageChanged(int index) {
    setState(() => _currentPage = index);
    _restartAutoPlay();
  }

  List<String> _resolvedUrls() {
    return widget.imageUrls
        .map(
          (imageUrl) => ApiConstants.resolveProjectImageUrl(
            imageUrl,
            token: _accessToken,
          ),
        )
        .whereType<String>()
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    if (!_tokenLoaded) {
      return _loadingBox(colors);
    }

    final resolvedUrls = _resolvedUrls();
    if (resolvedUrls.isEmpty) {
      return const SizedBox.shrink();
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(16.r),
      child: SizedBox(
        height: 180.h,
        width: double.infinity,
        child: Stack(
          fit: StackFit.expand,
          children: [
            PageView.builder(
              controller: _pageController,
              onPageChanged: _onPageChanged,
              itemCount: resolvedUrls.length,
              itemBuilder: (context, index) {
                final fullUrl = resolvedUrls[index];
                final imagePath = widget.imageUrls[index];

                return GestureDetector(
                  onTap: () {
                    final token = _accessToken ?? '';
                    log('Project image tap');
                    log('imageUrl from API: $imagePath');
                    log('JWE parts: ${ApiConstants.jweTokenPartCount(token)}');
                    log('Starts with eyJ header: ${ApiConstants.jweTokenStartsWithHeader(token)}');
                    log('JWE header segment: ${token.split('.').first}');
                    log('Full media URL: $fullUrl');
                    debugPrint('Full media URL: $fullUrl');
                  },
                  child: Image.network(
                    fullUrl,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, progress) {
                      if (progress == null) return child;
                      return ColoredBox(
                        color: colors.kInputColor,
                        child: Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: colors.kPrimaryColor,
                            value: progress.expectedTotalBytes != null
                                ? progress.cumulativeBytesLoaded /
                                    progress.expectedTotalBytes!
                                : null,
                          ),
                        ),
                      );
                    },
                    errorBuilder: (_, __, ___) => ColoredBox(
                      color: colors.kInputColor,
                      child: Icon(
                        Icons.broken_image_outlined,
                        color: colors.kGrayColor,
                        size: 36.sp,
                      ),
                    ),
                  ),
                );
              },
            ),
            if (resolvedUrls.length > 1) ...[
              Positioned(
                bottom: 12.h,
                left: 0,
                right: 0,
                child: Center(
                  child: SmoothPageIndicator(
                    controller: _pageController,
                    count: resolvedUrls.length,
                    effect: WormEffect(
                      dotHeight: 6.h,
                      dotWidth: 6.w,
                      spacing: 6.w,
                      activeDotColor: colors.kPrimaryColor,
                      dotColor: colors.kWhiteColor.withValues(alpha: 0.55),
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _loadingBox(dynamic colors) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16.r),
      child: SizedBox(
        height: 180.h,
        width: double.infinity,
        child: ColoredBox(
          color: colors.kInputColor,
          child: Center(
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: colors.kPrimaryColor,
            ),
          ),
        ),
      ),
    );
  }
}
