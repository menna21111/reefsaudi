import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/app_string.dart';
import '../../../../core/utils/app_theme_context.dart';
import '../bloc/dashboard_bloc.dart';
import '../bloc/dashboard_event.dart';
import '../bloc/dashboard_state.dart';

class DashboardSearchBar extends StatefulWidget {
  const DashboardSearchBar({super.key});

  @override
  State<DashboardSearchBar> createState() => _DashboardSearchBarState();
}

class _DashboardSearchBarState extends State<DashboardSearchBar> {
  final TextEditingController _controller = TextEditingController();
  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _dispatchSearch(String value) {
    context.read<DashboardBloc>().add(SearchProjects(value));
  }

  void _onChanged(String value) {
    setState(() {});
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 450), () {
      if (!mounted) return;
      _dispatchSearch(value);
    });
  }

  void _clear() {
    _controller.clear();
    _debounce?.cancel();
    _dispatchSearch('');
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return BlocListener<DashboardBloc, DashboardState>(
      listenWhen: (prev, curr) =>
          prev is DashboardStatsLoaded &&
          curr is DashboardStatsLoaded &&
          prev.query != curr.query,
      listener: (context, state) {
        if (state is! DashboardStatsLoaded) return;
        final query = state.query ?? '';
        if (_controller.text != query) {
          _controller.text = query;
          _controller.selection = TextSelection.collapsed(offset: query.length);
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: colors.kInputColor,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: colors.kBorderColor.withValues(alpha: 0.35),
          ),
        ),
        child: TextField(
          controller: _controller,
          style: TextStyle(
            color: colors.kFontColor,
            fontSize: 14.sp,
          ),
          textInputAction: TextInputAction.search,
          onChanged: _onChanged,
          onSubmitted: (value) {
            _debounce?.cancel();
            _dispatchSearch(value);
          },
          decoration: InputDecoration(
            hintText: AppString.searchProjects.tr(),
            hintStyle: TextStyle(
              color: colors.kGrayColor,
              fontSize: 14.sp,
            ),
            prefixIcon: Icon(
              Icons.search_rounded,
              color: colors.kGrayColor,
              size: 22.sp,
            ),
            suffixIcon: _controller.text.isNotEmpty
                ? IconButton(
                    onPressed: _clear,
                    icon: Icon(
                      Icons.close_rounded,
                      color: colors.kGrayColor,
                      size: 20.sp,
                    ),
                  )
                : null,
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(vertical: 12.h),
          ),
        ),
      ),
    );
  }
}
