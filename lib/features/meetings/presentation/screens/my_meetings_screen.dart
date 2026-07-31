import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../../../../core/services/service_locator.dart';
import '../../../../core/utils/app_string.dart';
import '../../../../core/utils/app_theme_context.dart';
import '../../../../core/utils/enums.dart';
import '../../data/models/meeting_models.dart';
import '../cubit/meetings_cubit.dart';
import '../widgets/meetings_calendar_data_source.dart';
import 'meeting_form_screen.dart';

class MyMeetingsScreen extends StatelessWidget {
  const MyMeetingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<MeetingsCubit>(),
      child: const _MyMeetingsView(),
    );
  }
}

class _MyMeetingsView extends StatefulWidget {
  const _MyMeetingsView();

  @override
  State<_MyMeetingsView> createState() => _MyMeetingsViewState();
}

class _MyMeetingsViewState extends State<_MyMeetingsView> {
  final CalendarController _calendarController = CalendarController();
  DateTime _displayDate = DateTime.now();
  DateTime? _pendingStart;
  bool _ignoreNextViewChanged = false;

  @override
  void initState() {
    super.initState();
    _calendarController.view = CalendarView.week;
    _calendarController.displayDate = _displayDate;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadForCurrentView();
    });
  }

  @override
  void dispose() {
    _calendarController.dispose();
    super.dispose();
  }

  (DateTime, DateTime) _rangeFor(DateTime date, MeetingsCalendarViewMode mode) {
    final day = DateTime(date.year, date.month, date.day);
    switch (mode) {
      case MeetingsCalendarViewMode.day:
      case MeetingsCalendarViewMode.timelineDay:
        return (day, day.add(const Duration(days: 1)));
      case MeetingsCalendarViewMode.week:
        final monday = day.subtract(Duration(days: day.weekday - 1));
        return (monday, monday.add(const Duration(days: 7)));
    }
  }

  void _loadForCurrentView() {
    final cubit = context.read<MeetingsCubit>();
    final (start, end) = _rangeFor(_displayDate, cubit.state.viewMode);
    cubit.loadForVisibleRange(
      rangeStart: start,
      rangeEnd: end,
      visibleDate: _displayDate,
    );
  }

  void _setView(MeetingsCalendarViewMode mode, {DateTime? jumpTo}) {
    final view = switch (mode) {
      MeetingsCalendarViewMode.day => CalendarView.day,
      MeetingsCalendarViewMode.week => CalendarView.week,
      MeetingsCalendarViewMode.timelineDay => CalendarView.timelineDay,
    };

    _ignoreNextViewChanged = true;
    context.read<MeetingsCubit>().changeViewMode(mode);
    if (jumpTo != null) {
      _displayDate = jumpTo;
      context.read<MeetingsCubit>().setVisibleDate(jumpTo);
    }
    _calendarController.view = view;
    _calendarController.displayDate = _displayDate;
    setState(() {});
    _loadForCurrentView();
  }

  void _shiftVisibleDate(int days) {
    _ignoreNextViewChanged = true;
    setState(() {
      _displayDate = _displayDate.add(Duration(days: days));
      _calendarController.displayDate = _displayDate;
    });
    context.read<MeetingsCubit>().setVisibleDate(_displayDate);
    _loadForCurrentView();
  }

  String _headerLabel(MeetingsCalendarViewMode mode) {
    final locale = context.locale.toString();
    switch (mode) {
      case MeetingsCalendarViewMode.day:
      case MeetingsCalendarViewMode.timelineDay:
        return DateFormat('d MMMM yyyy', locale).format(_displayDate);
      case MeetingsCalendarViewMode.week:
        final (start, endExclusive) = _rangeFor(
          _displayDate,
          MeetingsCalendarViewMode.week,
        );
        final end = endExclusive.subtract(const Duration(days: 1));
        final sameMonth = start.month == end.month && start.year == end.year;
        if (sameMonth) {
          return '${DateFormat('d', locale).format(start)}-'
              '${DateFormat('d MMMM yyyy', locale).format(end)}';
        }
        return '${DateFormat('d MMM', locale).format(start)} - '
            '${DateFormat('d MMM yyyy', locale).format(end)}';
    }
  }

  Future<void> _openCreate({
    required DateTime start,
    required DateTime end,
  }) async {
    setState(() => _pendingStart = null);
    await showMeetingFormSheet(context, start: start, end: end);
  }

  Future<void> _openEdit(MeetingItem summary) async {
    final cubit = context.read<MeetingsCubit>();
    final detail = await cubit.loadMeetingDetail(summary.id);
    if (!mounted) return;
    final meeting = detail ?? summary;
    await MeetingFormScreen.openEdit(context, meeting: meeting);
  }

  Future<void> _onCalendarTap(CalendarTapDetails details) async {
    // Pressing a day header in week view → jump to that day (no swipe scroll).
    if (details.targetElement == CalendarElement.viewHeader &&
        details.date != null) {
      _setView(MeetingsCalendarViewMode.day, jumpTo: details.date);
      return;
    }

    if (details.targetElement == CalendarElement.appointment &&
        details.appointments != null &&
        details.appointments!.isNotEmpty) {
      final appointment = details.appointments!.first;
      if (appointment is MeetingAppointment) {
        await _openEdit(appointment.meeting);
      }
      return;
    }

    if (details.targetElement != CalendarElement.calendarCell) return;
    final tapped = details.date;
    if (tapped == null) return;

    // First tap = start, second tap = end (any duration).
    if (_pendingStart == null) {
      setState(() => _pendingStart = tapped);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppString.selectMeetingEnd.tr())),
      );
      return;
    }

    final start =
        tapped.isBefore(_pendingStart!) ? tapped : _pendingStart!;
    final end = tapped.isBefore(_pendingStart!)
        ? _pendingStart!
        : tapped;
    final safeEnd =
        end.isAfter(start) ? end : start.add(const Duration(minutes: 30));
    await _openCreate(start: start, end: safeEnd);
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
        iconTheme: IconThemeData(color: colors.kFontColor),
        title: Text(
          AppString.myMeetings.tr(),
          style: TextStyle(
            color: colors.kPrimaryColor,
            fontSize: 18.sp,
            fontWeight: FontWeight.w700,
            fontFamily: 'Almarai',
          ),
        ),
        actions: [
          IconButton(
            tooltip: AppString.createMeeting.tr(),
            onPressed: () {
              final now = DateTime.now();
              final start = DateTime(
                now.year,
                now.month,
                now.day,
                now.hour.clamp(8, 17),
                now.minute >= 30 ? 30 : 0,
              );
              _openCreate(
                start: start,
                end: start.add(const Duration(minutes: 30)),
              );
            },
            icon: Icon(Icons.add_circle_outline, color: colors.kPrimaryColor),
          ),
        ],
      ),
      body: BlocBuilder<MeetingsCubit, MeetingsState>(
        builder: (context, state) {
          return Column(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(12.w, 4.h, 12.w, 8.h),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: _ViewChip(
                            label: AppString.calendarTimelineDay.tr(),
                            selected: state.viewMode ==
                                MeetingsCalendarViewMode.timelineDay,
                            onTap: () => _setView(
                              MeetingsCalendarViewMode.timelineDay,
                            ),
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: _ViewChip(
                            label: AppString.calendarWeek.tr(),
                            selected: state.viewMode ==
                                MeetingsCalendarViewMode.week,
                            onTap: () =>
                                _setView(MeetingsCalendarViewMode.week),
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: _ViewChip(
                            label: AppString.calendarDay.tr(),
                            selected:
                                state.viewMode == MeetingsCalendarViewMode.day,
                            onTap: () =>
                                _setView(MeetingsCalendarViewMode.day),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: () => _shiftVisibleDate(
                            state.viewMode == MeetingsCalendarViewMode.week
                                ? -7
                                : -1,
                          ),
                          icon: Icon(
                            Icons.chevron_right,
                            color: colors.kPrimaryColor,
                          ),
                        ),
                        Flexible(
                          child: Text(
                            _headerLabel(state.viewMode),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: colors.kFontColor,
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'Almarai',
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () => _shiftVisibleDate(
                            state.viewMode == MeetingsCalendarViewMode.week
                                ? 7
                                : 1,
                          ),
                          icon: Icon(
                            Icons.chevron_left,
                            color: colors.kPrimaryColor,
                          ),
                        ),
                      ],
                    ),
                    if (_pendingStart != null)
                      Padding(
                        padding: EdgeInsets.only(top: 4.h),
                        child: Text(
                          AppString.selectMeetingEnd.tr(),
                          style: TextStyle(
                            color: colors.kPrimaryColor,
                            fontFamily: 'Almarai',
                            fontSize: 12.sp,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              if (state.status == RequestStatus.error)
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Text(
                    state.error.tr(),
                    style: TextStyle(
                      color: colors.kRedColor,
                      fontFamily: 'Almarai',
                      fontSize: 12.sp,
                    ),
                  ),
                ),
              Expanded(
                child: Stack(
                  children: [
                    SfCalendar(
                      controller: _calendarController,
                      dataSource: MeetingsCalendarDataSource(state.meetings),
                      view: switch (state.viewMode) {
                        MeetingsCalendarViewMode.day => CalendarView.day,
                        MeetingsCalendarViewMode.week => CalendarView.week,
                        MeetingsCalendarViewMode.timelineDay =>
                          CalendarView.timelineDay,
                      },
                      firstDayOfWeek: 1,
                      allowViewNavigation: false,
                      timeSlotViewSettings: const TimeSlotViewSettings(
                        startHour: 8,
                        endHour: 18,
                        timeInterval: Duration(minutes: 30),
                        timeIntervalHeight: 56,
                        timeFormat: 'h:mm a',
                      ),
                      headerHeight: 0,
                      viewHeaderHeight: 56,
                      todayHighlightColor: colors.kPrimaryColor,
                      cellBorderColor:
                          colors.kBorderColor.withValues(alpha: 0.25),
                      backgroundColor: colors.kBgColor,
                      appointmentTextStyle: TextStyle(
                        color: colors.kWhiteColor,
                        fontSize: 11.sp,
                        fontFamily: 'Almarai',
                        fontWeight: FontWeight.w600,
                      ),
                      viewHeaderStyle: ViewHeaderStyle(
                        backgroundColor: colors.kInputColor,
                        dayTextStyle: TextStyle(
                          color: colors.kFontColor,
                          fontSize: 12.sp,
                          fontFamily: 'Almarai',
                          fontWeight: FontWeight.w700,
                        ),
                        dateTextStyle: TextStyle(
                          color: colors.kPrimaryColor,
                          fontSize: 14.sp,
                          fontFamily: 'Almarai',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      onTap: _onCalendarTap,
                      onViewChanged: (details) {
                        if (_ignoreNextViewChanged) {
                          _ignoreNextViewChanged = false;
                          return;
                        }
                        if (details.visibleDates.isEmpty) return;
                        final mid = details
                            .visibleDates[details.visibleDates.length ~/ 2];
                        if (DateUtils.isSameDay(mid, _displayDate)) return;
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          if (!mounted) return;
                          setState(() => _displayDate = mid);
                          _loadForCurrentView();
                        });
                      },
                    ),
                    if (state.isLoading)
                      Positioned(
                        top: 8,
                        left: 0,
                        right: 0,
                        child: Center(
                          child: SizedBox(
                            width: 22.w,
                            height: 22.w,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: colors.kPrimaryColor,
                            ),
                          ),
                        ),
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

class _ViewChip extends StatelessWidget {
  const _ViewChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20.r),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 10.h),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected
              ? colors.kPrimaryColor.withValues(alpha: 0.12)
              : colors.kInputColor,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: selected
                ? colors.kPrimaryColor
                : colors.kBorderColor.withValues(alpha: 0.35),
          ),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: selected ? colors.kPrimaryColor : colors.kFontColor,
            fontSize: 11.sp,
            fontWeight: FontWeight.w700,
            fontFamily: 'Almarai',
          ),
        ),
      ),
    );
  }
}
