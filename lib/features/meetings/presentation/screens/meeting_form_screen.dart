import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/app_color_scheme.dart';
import '../../../../core/utils/app_string.dart';
import '../../../../core/utils/app_theme_context.dart';
import '../../../../core/utils/enums.dart';
import '../../../../core/widgets/lazy_styled_popup_dropdown.dart';
import '../../../../core/widgets/multi_select_popup_dropdown.dart';
import '../../../../core/widgets/styled_popup_dropdown.dart';
import '../../data/models/meeting_models.dart';
import '../cubit/meetings_cubit.dart';

/// Create meeting as bottom sheet.
Future<void> showMeetingFormSheet(
  BuildContext context, {
  required DateTime start,
  required DateTime end,
}) {
  final cubit = context.read<MeetingsCubit>();
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => BlocProvider.value(
      value: cubit,
      child: _MeetingFormSheetShell(
        initialStart: start,
        initialEnd: end,
      ),
    ),
  );
}

/// Edit meeting as a full page.
class MeetingFormScreen extends StatelessWidget {
  const MeetingFormScreen({
    super.key,
    required this.meeting,
  });

  final MeetingItem meeting;

  static Future<bool?> openEdit(
    BuildContext context, {
    required MeetingItem meeting,
  }) {
    final cubit = context.read<MeetingsCubit>();
    return Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: cubit,
          child: MeetingFormScreen(meeting: meeting),
        ),
      ),
    );
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
          AppString.editMeeting.tr(),
          style: TextStyle(
            color: colors.kPrimaryColor,
            fontSize: 18.sp,
            fontWeight: FontWeight.w700,
            fontFamily: 'Almarai',
          ),
        ),
      ),
      body: SafeArea(
        child: MeetingFormBody(
          initialStart: meeting.startDate,
          initialEnd: meeting.endDate,
          meeting: meeting,
          embeddedInSheet: false,
        ),
      ),
    );
  }
}

class _MeetingFormSheetShell extends StatelessWidget {
  const _MeetingFormSheetShell({
    required this.initialStart,
    required this.initialEnd,
  });

  final DateTime initialStart;
  final DateTime initialEnd;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;

    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.sizeOf(context).height * 0.9,
        ),
        decoration: BoxDecoration(
          color: colors.kBgColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
        ),
        child: MeetingFormBody(
          initialStart: initialStart,
          initialEnd: initialEnd,
          embeddedInSheet: true,
        ),
      ),
    );
  }
}

class MeetingFormBody extends StatefulWidget {
  const MeetingFormBody({
    super.key,
    required this.initialStart,
    required this.initialEnd,
    required this.embeddedInSheet,
    this.meeting,
  });

  final DateTime initialStart;
  final DateTime initialEnd;
  final MeetingItem? meeting;
  final bool embeddedInSheet;

  @override
  State<MeetingFormBody> createState() => _MeetingFormBodyState();
}

class _MeetingFormBodyState extends State<MeetingFormBody> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _locationController;
  late DateTime _start;
  late DateTime _end;
  late List<MeetingTopic> _topics;
  late Set<String> _selectedEmployeeIds;
  late bool _isPublished;
  Map<String, String> _accountNames = {};

  bool get _isEdit =>
      widget.meeting != null && widget.meeting!.id.trim().isNotEmpty;

  @override
  void initState() {
    super.initState();
    final meeting = widget.meeting;
    _titleController = TextEditingController(text: meeting?.title ?? '');
    _descriptionController =
        TextEditingController(text: meeting?.description ?? '');
    _locationController = TextEditingController(text: meeting?.location ?? '');
    _start = meeting?.startDate ?? widget.initialStart;
    _end = meeting?.endDate ??
        (widget.initialEnd.isAfter(widget.initialStart)
            ? widget.initialEnd
            : widget.initialStart.add(const Duration(minutes: 30)));
    _topics = List<MeetingTopic>.from(meeting?.topics ?? const []);
    _selectedEmployeeIds = {...?meeting?.employeesIds};
    _isPublished = meeting?.isPublished ?? false;

    for (final topic in _topics) {
      if (topic.presenterId != null &&
          topic.presenterId!.isNotEmpty &&
          topic.presenter.isNotEmpty) {
        _accountNames[topic.presenterId!] = topic.presenter;
      }
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _preloadAccounts();
    });
  }

  Future<void> _preloadAccounts() async {
    final accounts = await context.read<MeetingsCubit>().fetchAccounts();
    if (!mounted) return;
    setState(() {
      _accountNames = {
        ..._accountNames,
        for (final account in accounts) account.id: account.fullName,
      };
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<List<MultiSelectOption<String>>> _loadEmployeeOptions() async {
    final accounts = await context.read<MeetingsCubit>().fetchAccounts();
    final options = accounts
        .map(
          (account) => MultiSelectOption<String>(
            value: account.id,
            label: account.fullName,
          ),
        )
        .toList();

    if (mounted) {
      setState(() {
        _accountNames = {
          ..._accountNames,
          for (final account in accounts) account.id: account.fullName,
        };
      });
    }
    return options;
  }

  Future<List<DropdownMenuItem<String>>> _loadPresenterItems() async {
    final colors = context.appColorsRead;
    final accounts = await context.read<MeetingsCubit>().fetchAccounts();
    return accounts
        .map(
          (account) => DropdownMenuItem<String>(
            value: account.id,
            child: Text(
              account.fullName,
              style: TextStyle(
                color: colors.kFontColor,
                fontFamily: 'Almarai',
                fontSize: 14.sp,
              ),
            ),
          ),
        )
        .toList();
  }

  Future<void> _pickDateTime({required bool isStart}) async {
    final colors = context.appColorsRead;
    final initial = isStart ? _start : _end;

    final date = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
      builder: (ctx, child) {
        return Theme(
          data: Theme.of(ctx).copyWith(
            colorScheme: ColorScheme.light(primary: colors.kPrimaryColor),
          ),
          child: child!,
        );
      },
    );
    if (date == null || !mounted) return;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(initial),
    );
    if (time == null || !mounted) return;

    final selected = DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );

    setState(() {
      if (isStart) {
        _start = selected;
        if (!_end.isAfter(_start)) {
          _end = _start.add(const Duration(minutes: 30));
        }
      } else {
        _end = selected.isAfter(_start)
            ? selected
            : _start.add(const Duration(minutes: 30));
      }
    });
  }

  Future<void> _openTopicEditor({
    MeetingTopic? topic,
    int? index,
    String? parentId,
  }) async {
    final titleController = TextEditingController(text: topic?.title ?? '');
    final descriptionController =
        TextEditingController(text: topic?.description ?? '');
    final durationController = TextEditingController(
      text: (topic?.duration ?? 15).toString(),
    );
    String? presenterId = topic?.presenterId;
    String presenterLabel = topic?.presenter ?? '';
    final colors = context.appColorsRead;

    final saved = await showDialog<bool>(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setDialogState) {
            return AlertDialog(
              backgroundColor: colors.kBgColor,
              title: Text(
                topic == null
                    ? AppString.addMeetingTopic.tr()
                    : AppString.editMeeting.tr(),
                style: TextStyle(
                  fontFamily: 'Almarai',
                  color: colors.kPrimaryColor,
                ),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: titleController,
                      decoration: InputDecoration(
                        labelText: AppString.subTopic.tr(),
                      ),
                    ),
                    SizedBox(height: 10.h),
                    TextField(
                      controller: durationController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: AppString.topicDurationMinutes.tr(),
                      ),
                    ),
                    SizedBox(height: 10.h),
                    LazyStyledPopupDropdown(
                      title: AppString.topicPresenter.tr(),
                      valueId: presenterId,
                      valueLabel: presenterLabel,
                      hintText: AppString.selectPlaceholder.tr(),
                      loadItems: _loadPresenterItems,
                      onSelected: (id, label) {
                        setDialogState(() {
                          presenterId = id;
                          presenterLabel = label;
                        });
                      },
                    ),
                    SizedBox(height: 10.h),
                    TextField(
                      controller: descriptionController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        labelText: AppString.description.tr(),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx, false),
                  child: Text(AppString.cancel.tr()),
                ),
                FilledButton(
                  onPressed: () => Navigator.pop(ctx, true),
                  child: Text(AppString.save.tr()),
                ),
              ],
            );
          },
        );
      },
    );

    if (saved != true) return;
    final title = titleController.text.trim();
    if (title.isEmpty) return;

    final next = MeetingTopic(
      id: topic?.id,
      title: title,
      description: descriptionController.text.trim(),
      duration: int.tryParse(durationController.text.trim()) ?? 15,
      sortIndex: topic?.sortIndex ?? (_topics.length + 1),
      parentId: parentId ?? topic?.parentId,
      presenterId: presenterId,
      presenter: presenterLabel,
    );

    setState(() {
      if (presenterId != null && presenterId!.isNotEmpty) {
        _accountNames[presenterId!] = presenterLabel;
      }
      if (index != null) {
        _topics = [..._topics]..[index] = next;
      } else {
        _topics = [..._topics, next];
      }
    });
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final cubit = context.read<MeetingsCubit>();
    final messenger = ScaffoldMessenger.of(context);

    final ok = await cubit.saveMeeting(
      MeetingWriteRequest(
        id: widget.meeting?.id,
        title: _titleController.text,
        description: _descriptionController.text,
        location: _locationController.text,
        startDate: _start,
        endDate: _end,
        employeesIds: _selectedEmployeeIds.toList(),
        topics: _topics,
        isPublished: _isPublished,
      ),
    );

    if (!mounted) return;
    if (ok) {
      Navigator.pop(context, true);
      await cubit.reloadCurrentRange();
      messenger.showSnackBar(
        SnackBar(
          content: Text(
            (_isEdit ? AppString.meetingUpdated : AppString.meetingCreated).tr(),
          ),
        ),
      );
    }
  }

  String _formatDateTime(DateTime value) {
    return DateFormat('d/M/yyyy  h:mm a', context.locale.toString())
        .format(value);
  }

  String _accountLabel(String id) =>
      _accountNames[id] ?? id;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return BlocBuilder<MeetingsCubit, MeetingsState>(
      buildWhen: (p, n) =>
          p.saveStatus != n.saveStatus || p.saveError != n.saveError,
      builder: (context, state) {
        final isLoading = state.saveStatus == RequestStatus.loading;

        return Form(
          key: _formKey,
          child: ListView(
            padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 24.h),
            children: [
              if (widget.embeddedInSheet) ...[
                Center(
                  child: Container(
                    width: 40.w,
                    height: 4.h,
                    decoration: BoxDecoration(
                      color: colors.kBorderColor.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                  ),
                ),
                SizedBox(height: 16.h),
                Text(
                  AppString.createMeeting.tr(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: colors.kPrimaryColor,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Almarai',
                  ),
                ),
                SizedBox(height: 16.h),
              ],
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 3,
                    child: _field(
                      controller: _titleController,
                      label: AppString.meetingTitle.tr(),
                      enabled: !isLoading,
                      requiredField: true,
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    flex: 2,
                    child: StyledPopupDropdown<bool>(
                      title: AppString.meetingStatus.tr(),
                      value: _isPublished,
                      hintText: AppString.selectPlaceholder.tr(),
                      items: [
                        DropdownMenuItem(
                          value: false,
                          child: Text(
                            AppString.meetingDraft.tr(),
                            style: TextStyle(
                              fontFamily: 'Almarai',
                              color: colors.kFontColor,
                            ),
                          ),
                        ),
                        DropdownMenuItem(
                          value: true,
                          child: Text(
                            AppString.published.tr(),
                            style: TextStyle(
                              fontFamily: 'Almarai',
                              color: colors.kFontColor,
                            ),
                          ),
                        ),
                      ],
                      onChanged: isLoading
                          ? (_) {}
                          : (value) {
                              if (value == null) return;
                              setState(() => _isPublished = value);
                            },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12.h),
              Row(
                children: [
                  Expanded(
                    child: _DateTimeTile(
                      label: AppString.startDate.tr(),
                      value: _formatDateTime(_start),
                      onTap: isLoading
                          ? null
                          : () => _pickDateTime(isStart: true),
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: _DateTimeTile(
                      label: AppString.endDate.tr(),
                      value: _formatDateTime(_end),
                      onTap: isLoading
                          ? null
                          : () => _pickDateTime(isStart: false),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12.h),
              _field(
                controller: _locationController,
                label: AppString.location.tr(),
                enabled: !isLoading,
              ),
              SizedBox(height: 12.h),
              _field(
                controller: _descriptionController,
                label: AppString.description.tr(),
                enabled: !isLoading,
                maxLines: 3,
              ),
              SizedBox(height: 14.h),
              MultiSelectPopupDropdown<String>(
                title: AppString.employees.tr(),
                hintText: AppString.selectPlaceholder.tr(),
                selected: _selectedEmployeeIds,
                loadItems: _loadEmployeeOptions,
                onSelectionChanged: (selected) {
                  setState(() => _selectedEmployeeIds = selected);
                },
              ),
              if (_selectedEmployeeIds.isNotEmpty) ...[
                SizedBox(height: 8.h),
                Wrap(
                  spacing: 6.w,
                  runSpacing: 6.h,
                  children: _selectedEmployeeIds.map((id) {
                    return InputChip(
                      label: Text(
                        _accountLabel(id),
                        style: TextStyle(
                          fontFamily: 'Almarai',
                          fontSize: 12.sp,
                          color: colors.kFontColor,
                        ),
                      ),
                      onDeleted: isLoading
                          ? null
                          : () {
                              setState(() {
                                _selectedEmployeeIds = {..._selectedEmployeeIds}
                                  ..remove(id);
                              });
                            },
                      backgroundColor: colors.kInputColor,
                      deleteIconColor: colors.kGrayColor,
                      side: BorderSide(
                        color: colors.kBorderColor.withValues(alpha: 0.35),
                      ),
                    );
                  }).toList(),
                ),
              ],
              SizedBox(height: 18.h),
              _TopicsSection(
                topics: _topics,
                accountNames: _accountNames,
                enabled: !isLoading,
                onAdd: () => _openTopicEditor(),
                onEdit: (index) =>
                    _openTopicEditor(topic: _topics[index], index: index),
                onDelete: (index) {
                  setState(() {
                    _topics = [..._topics]..removeAt(index);
                  });
                },
                onAddChild: (index) => _openTopicEditor(
                  parentId: _topics[index].id ?? _topics[index].title,
                ),
              ),
              if (state.saveError.isNotEmpty) ...[
                SizedBox(height: 10.h),
                Text(
                  state.saveError.tr(),
                  style: TextStyle(
                    color: colors.kRedColor,
                    fontFamily: 'Almarai',
                    fontSize: 12.sp,
                  ),
                ),
              ],
              SizedBox(height: 20.h),
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 48.h,
                      child: FilledButton(
                        onPressed: isLoading ? null : _submit,
                        style: FilledButton.styleFrom(
                          backgroundColor: colors.kPrimaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                        ),
                        child: isLoading
                            ? SizedBox(
                                width: 22.w,
                                height: 22.w,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: colors.kWhiteColor,
                                ),
                              )
                            : Text(
                                AppString.save.tr(),
                                style: TextStyle(
                                  fontFamily: 'Almarai',
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14.sp,
                                ),
                              ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: SizedBox(
                      height: 48.h,
                      child: OutlinedButton(
                        onPressed:
                            isLoading ? null : () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: colors.kPrimaryColor),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                        ),
                        child: Text(
                          AppString.cancel.tr(),
                          style: TextStyle(
                            color: colors.kPrimaryColor,
                            fontFamily: 'Almarai',
                            fontWeight: FontWeight.w700,
                            fontSize: 14.sp,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _field({
    required TextEditingController controller,
    required String label,
    required bool enabled,
    bool requiredField = false,
    int maxLines = 1,
  }) {
    final colors = context.appColors;
    return TextFormField(
      controller: controller,
      enabled: enabled,
      maxLines: maxLines,
      style: TextStyle(
        color: colors.kFontColor,
        fontFamily: 'Almarai',
        fontSize: 14.sp,
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: colors.kGrayColor, fontFamily: 'Almarai'),
        filled: true,
        fillColor: colors.kBgColor,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide(
            color: colors.kBorderColor.withValues(alpha: 0.5),
          ),
        ),
      ),
      validator: requiredField
          ? (value) {
              if (value == null || value.trim().isEmpty) {
                return AppString.fillRequiredFields.tr();
              }
              return null;
            }
          : null,
    );
  }
}

class _TopicsSection extends StatelessWidget {
  const _TopicsSection({
    required this.topics,
    required this.accountNames,
    required this.enabled,
    required this.onAdd,
    required this.onEdit,
    required this.onDelete,
    required this.onAddChild,
  });

  final List<MeetingTopic> topics;
  final Map<String, String> accountNames;
  final bool enabled;
  final VoidCallback onAdd;
  final ValueChanged<int> onEdit;
  final ValueChanged<int> onDelete;
  final ValueChanged<int> onAddChild;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final headerColor = colors.kDarkBlueColor;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          AppString.meetingTopics.tr(),
          style: TextStyle(
            color: colors.kFontColor,
            fontFamily: 'Almarai',
            fontWeight: FontWeight.w700,
            fontSize: 15.sp,
          ),
        ),
        SizedBox(height: 8.h),
        Align(
          alignment: AlignmentDirectional.centerStart,
          child: InkWell(
            onTap: enabled ? onAdd : null,
            borderRadius: BorderRadius.circular(6.r),
            child: Container(
              width: 36.w,
              height: 36.w,
              decoration: BoxDecoration(
                color: headerColor,
                borderRadius: BorderRadius.circular(6.r),
              ),
              child: Icon(Icons.add, color: colors.kWhiteColor, size: 20.sp),
            ),
          ),
        ),
        SizedBox(height: 8.h),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minWidth: MediaQuery.sizeOf(context).width - 32.w,
            ),
            child: Table(
              border: TableBorder.all(
                color: colors.kBorderColor.withValues(alpha: 0.35),
                width: 1,
              ),
              columnWidths: {
                0: FixedColumnWidth(140.w),
                1: FixedColumnWidth(70.w),
                2: FixedColumnWidth(180.w),
                3: FixedColumnWidth(120.w),
              },
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              children: [
                TableRow(
                  decoration: BoxDecoration(color: headerColor),
                  children: [
                    _headerCell(AppString.subTopic.tr(), colors),
                    _headerCell(AppString.topicDuration.tr(), colors),
                    _headerCell(AppString.topicPresenter.tr(), colors),
                    _headerCell('', colors),
                  ],
                ),
                if (topics.isEmpty)
                  TableRow(
                    children: [
                      _bodyCell(AppString.noRecordsFound.tr(), colors),
                      _bodyCell('', colors),
                      _bodyCell('', colors),
                      _bodyCell('', colors),
                    ],
                  )
                else
                  ...topics.asMap().entries.map((entry) {
                    final index = entry.key;
                    final topic = entry.value;
                    final presenter = topic.presenter.isNotEmpty
                        ? topic.presenter
                        : (topic.presenterId != null
                            ? accountNames[topic.presenterId!] ?? ''
                            : '');
                    final stripe = index.isOdd
                        ? colors.kInputColor.withValues(alpha: 0.45)
                        : colors.kBgColor;

                    return TableRow(
                      decoration: BoxDecoration(color: stripe),
                      children: [
                        _bodyCell(topic.title, colors),
                        _bodyCell('${topic.duration}', colors),
                        _bodyCell(presenter, colors),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 4.w,
                            vertical: 4.h,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _actionIcon(
                                icon: Icons.delete_outline,
                                color: colors.kPrimaryColor,
                                onTap: enabled ? () => onDelete(index) : null,
                              ),
                              _actionIcon(
                                icon: Icons.edit_outlined,
                                color: colors.kPrimaryColor,
                                onTap: enabled ? () => onEdit(index) : null,
                              ),
                              _actionIcon(
                                icon: Icons.add,
                                color: colors.kPrimaryColor,
                                onTap:
                                    enabled ? () => onAddChild(index) : null,
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  }),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _headerCell(String text, AppColorScheme colors) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 10.h),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: colors.kWhiteColor,
          fontFamily: 'Almarai',
          fontWeight: FontWeight.w700,
          fontSize: 12.sp,
        ),
      ),
    );
  }

  Widget _bodyCell(String text, AppColorScheme colors) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 10.h),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: colors.kFontColor,
          fontFamily: 'Almarai',
          fontSize: 12.sp,
        ),
      ),
    );
  }

  Widget _actionIcon({
    required IconData icon,
    required Color color,
    required VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Icon(icon, color: color, size: 18.sp),
      ),
    );
  }
}

class _DateTimeTile extends StatelessWidget {
  const _DateTimeTile({
    required this.label,
    required this.value,
    required this.onTap,
  });

  final String label;
  final String value;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8.r),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: colors.kGrayColor, fontFamily: 'Almarai'),
          filled: true,
          fillColor: colors.kBgColor,
          prefixIcon: Icon(
            Icons.calendar_month_outlined,
            color: colors.kGrayColor,
            size: 20.sp,
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r)),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.r),
            borderSide: BorderSide(
              color: colors.kBorderColor.withValues(alpha: 0.5),
            ),
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 12.h),
        ),
        child: Text(
          value,
          style: TextStyle(
            color: colors.kFontColor,
            fontSize: 12.sp,
            fontFamily: 'Almarai',
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
