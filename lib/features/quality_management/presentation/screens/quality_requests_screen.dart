import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/services/service_locator.dart';
import '../../../../core/utils/app_string.dart';
import '../../../../core/utils/app_color_scheme.dart';
import '../../../../core/utils/app_theme_context.dart';
import '../../../../core/utils/enums.dart';
import '../../data/models/project_request_item_models.dart';
import '../../data/datasources/quality_remote_data_source.dart';
import '../constants/request_type_config.dart';
import '../cubit/quality_management_cubit.dart';
import '../widgets/quality_filter_header.dart';
import '../widgets/quality_list_filters_bar.dart';
import '../widgets/quality_request_card.dart';
import 'create_quality_request_screen.dart';
import 'quality_approval_task_detail_screen.dart';
import 'quality_request_detail_screen.dart';

class QualityRequestsScreen extends StatefulWidget {
  const QualityRequestsScreen._({
    required this.titleKey,
    required this.kind,
    this.showAppBar = true,
  });

  final String titleKey;
  final ProjectRequestListKind kind;
  final bool showAppBar;

  factory QualityRequestsScreen.myRequests({bool showAppBar = true}) {
    return QualityRequestsScreen._(
      titleKey: AppString.myRequests,
      kind: ProjectRequestListKind.myRequests,
      showAppBar: showAppBar,
    );
  }

  factory QualityRequestsScreen.approvalTasks({bool showAppBar = true}) {
    return QualityRequestsScreen._(
      titleKey: AppString.approvalTasks,
      kind: ProjectRequestListKind.approvalTasks,
      showAppBar: showAppBar,
    );
  }

  factory QualityRequestsScreen.archive({bool showAppBar = true}) {
    return QualityRequestsScreen._(
      titleKey: AppString.requestsArchive,
      kind: ProjectRequestListKind.archive,
      showAppBar: showAppBar,
    );
  }

  @override
  State<QualityRequestsScreen> createState() => _QualityRequestsScreenState();
}

class _QualityRequestsScreenState extends State<QualityRequestsScreen> {
  late final QualityManagementCubit _cubit;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    final defaultFilter = QualityListFilterConfig.defaultValueFor(widget.kind);
    _cubit = sl<QualityManagementCubit>()
      ..initRequests(widget.kind)
      ..loadRequests(kind: widget.kind, approvalStatus: defaultFilter);
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    _cubit.close();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final position = _scrollController.position;
    if (position.pixels >= position.maxScrollExtent - 200) {
      _cubit.loadMoreRequests();
    }
  }

  Future<void> _openCreateRequest() async {
    final created = await Navigator.push<ProjectRequestItem?>(
      context,
      CreateQualityRequestScreen.route(),
    );

    if (!mounted || created == null) return;

    if (widget.kind == ProjectRequestListKind.myRequests) {
      await _cubit.refreshRequests();
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return BlocProvider.value(
      value: _cubit,
      child: Scaffold(
        backgroundColor: colors.kBgColor,
        appBar: widget.showAppBar
            ? AppBar(
                backgroundColor: colors.kBgColor,
                elevation: 0,
                centerTitle: true,
                iconTheme: IconThemeData(color: colors.kFontColor),
                title: Text(
                  widget.titleKey.tr(),
                  style: TextStyle(
                    color: colors.kFontColor,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Almarai',
                  ),
                ),
              )
            : null,
        body: SafeArea(
          top: !widget.showAppBar,
          child: BlocBuilder<QualityManagementCubit, QualityManagementState>(
            builder: (context, state) {
              if (state.requestsKind == null) {
                return const SizedBox.shrink();
              }

              return RefreshIndicator(
                color: colors.kPrimaryColor,
                onRefresh: state.requestsFilterLoading
                    ? () async {}
                    : _cubit.refreshRequests,
                child: ListView.builder(
                  controller: _scrollController,
                  physics: const AlwaysScrollableScrollPhysics(
                    parent: BouncingScrollPhysics(),
                  ),
                  padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 24.h),
                  itemCount: _listItemCount(state),
                  itemBuilder: (context, index) =>
                      _buildListItem(context, state, index, colors),
                ),
              );
            },
          ),
        ),
        floatingActionButton: widget.kind == ProjectRequestListKind.myRequests
            ? FloatingActionButton.extended(
                heroTag: 'quality_my_requests_fab',
                onPressed: _openCreateRequest,
                backgroundColor: colors.kPrimaryColor,
                icon: const Icon(Icons.add_rounded, color: Colors.white),
                label: Text(
                  AppString.createRequest.tr(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontFamily: 'Almarai',
                    fontWeight: FontWeight.w600,
                  ),
                ),
              )
            : null,
      ),
    );
  }

  int _headerCount() => widget.showAppBar ? 1 : 2;

  int _listItemCount(QualityManagementState state) {
    final header = _headerCount();

    if (state.requestsFilterLoading) return header + 1;

    if (state.requestsStatus == RequestStatus.error) return header + 1;

    if (state.requestsItems.isEmpty) return header + 2;

    return header +
        1 +
        state.requestsItems.length +
        (state.requestsLoadingMore ? 1 : 0);
  }

  Widget _buildListItem(
    BuildContext context,
    QualityManagementState state,
    int index,
    AppColorScheme colors,
  ) {
    var current = index;

    if (!widget.showAppBar) {
      if (current == 0) {
        return Padding(
          padding: EdgeInsets.only(bottom: 16.h, top: 8.h),
          child: Text(
            widget.titleKey.tr(),
            textAlign: TextAlign.right,
            style: TextStyle(
              color: colors.kFontColor,
              fontSize: 22.sp,
              fontWeight: FontWeight.w800,
              fontFamily: 'Almarai',
            ),
          ),
        );
      }
      current -= 1;
    }

    if (current == 0) {
      final counts = state.requestsStatusCounts;
      final kind = widget.kind;
      final statusCounts = counts == null
          ? null
          : {
              for (final option in QualityListFilterConfig.optionsFor(kind))
                option.value: QualityListFilterConfig.countForStatus(
                      kind: kind,
                      statusValue: option.value,
                      counts: counts,
                    ) ??
                    0,
            };

      return Padding(
        padding: EdgeInsets.only(bottom: 12.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            QualityListFiltersBar(
              filter: state.requestsListFilter,
              enabled: !state.requestsFilterLoading,
              onRequestTypeChanged: _cubit.changeRequestTypeFilter,
              onDateRangeChanged: (from, to) => _cubit.changeDateRangeFilter(
                fromDate: from,
                toDate: to,
              ),
              onClear: _cubit.clearListFilters,
            ),
            SizedBox(height: 12.h),
            QualityFilterHeader(
              options: QualityListFilterConfig.optionsFor(widget.kind),
              selectedStatus: state.requestsApprovalStatus,
              statusCounts: statusCounts,
              onChanged: state.requestsFilterLoading
                  ? (_) {}
                  : _cubit.changeRequestsFilter,
            ),
          ],
        ),
      );
    }

    if (state.requestsFilterLoading) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 48.h),
        child: Center(
          child: CircularProgressIndicator(color: colors.kPrimaryColor),
        ),
      );
    }

    if (state.requestsStatus == RequestStatus.error) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 32.h),
        child: Column(
          children: [
            Text(
              state.requestsError.tr(),
              textAlign: TextAlign.center,
              style: TextStyle(
                color: colors.kFontColor,
                fontSize: 14.sp,
                fontFamily: 'Almarai',
              ),
            ),
            SizedBox(height: 16.h),
            FilledButton(
              onPressed: () => _cubit.loadRequests(
                kind: widget.kind,
                approvalStatus: state.requestsApprovalStatus,
              ),
              child: Text(AppString.retry.tr()),
            ),
          ],
        ),
      );
    }

    if (current == 1) {
      return Padding(
        padding: EdgeInsets.only(bottom: 14.h),
        child: Align(
          alignment: AlignmentDirectional.centerEnd,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: colors.kPrimaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Text(
              '${AppString.totalRecords.tr()}: ${state.requestsTotalCount}',
              style: TextStyle(
                color: colors.kPrimaryColor,
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                fontFamily: 'Almarai',
              ),
            ),
          ),
        ),
      );
    }

    if (state.requestsItems.isEmpty) {
      return Padding(
        padding: EdgeInsets.only(top: 48.h),
        child: Column(
          children: [
            Icon(
              Icons.inbox_outlined,
              size: 56.sp,
              color: colors.kGrayColor.withValues(alpha: 0.5),
            ),
            SizedBox(height: 12.h),
            Text(
              AppString.noData.tr(),
              style: TextStyle(
                color: colors.kGrayColor,
                fontSize: 14.sp,
                fontFamily: 'Almarai',
              ),
            ),
          ],
        ),
      );
    }

    final itemIndex = current - 2;
    if (itemIndex >= state.requestsItems.length) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 16.h),
        child: Center(
          child: CircularProgressIndicator(
            color: colors.kPrimaryColor,
            strokeWidth: 2,
          ),
        ),
      );
    }

    return QualityRequestCard(
      item: state.requestsItems[itemIndex],
      onTap: () {
        final id = state.requestsItems[itemIndex].id;
        Navigator.push(
          context,
          widget.kind == ProjectRequestListKind.approvalTasks
              ? QualityApprovalTaskDetailScreen.route(id)
              : QualityRequestDetailScreen.route(id),
        );
      },
    );
  }
}
