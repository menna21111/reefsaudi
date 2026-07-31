part of 'meetings_cubit.dart';

enum MeetingsCalendarViewMode { day, week, timelineDay }

class MeetingsState extends Equatable {
  const MeetingsState({
    this.status = RequestStatus.initial,
    this.saveStatus = RequestStatus.initial,
    this.detailStatus = RequestStatus.initial,
    this.accountsStatus = RequestStatus.initial,
    this.meetings = const [],
    this.accounts = const [],
    this.selectedMeeting,
    this.visibleDate,
    this.viewMode = MeetingsCalendarViewMode.week,
    this.error = '',
    this.saveError = '',
    this.detailError = '',
    this.accountsError = '',
  });

  final RequestStatus status;
  final RequestStatus saveStatus;
  final RequestStatus detailStatus;
  final RequestStatus accountsStatus;
  final List<MeetingItem> meetings;
  final List<MeetingAccountOption> accounts;
  final MeetingItem? selectedMeeting;
  final DateTime? visibleDate;
  final MeetingsCalendarViewMode viewMode;
  final String error;
  final String saveError;
  final String detailError;
  final String accountsError;

  bool get isLoading =>
      status == RequestStatus.loading || status == RequestStatus.initial;

  MeetingsState copyWith({
    RequestStatus? status,
    RequestStatus? saveStatus,
    RequestStatus? detailStatus,
    RequestStatus? accountsStatus,
    List<MeetingItem>? meetings,
    List<MeetingAccountOption>? accounts,
    MeetingItem? selectedMeeting,
    DateTime? visibleDate,
    MeetingsCalendarViewMode? viewMode,
    String? error,
    String? saveError,
    String? detailError,
    String? accountsError,
    bool clearError = false,
    bool clearSaveError = false,
    bool clearDetailError = false,
    bool clearAccountsError = false,
    bool clearSelectedMeeting = false,
  }) {
    return MeetingsState(
      status: status ?? this.status,
      saveStatus: saveStatus ?? this.saveStatus,
      detailStatus: detailStatus ?? this.detailStatus,
      accountsStatus: accountsStatus ?? this.accountsStatus,
      meetings: meetings ?? this.meetings,
      accounts: accounts ?? this.accounts,
      selectedMeeting: clearSelectedMeeting
          ? null
          : selectedMeeting ?? this.selectedMeeting,
      visibleDate: visibleDate ?? this.visibleDate,
      viewMode: viewMode ?? this.viewMode,
      error: clearError ? '' : error ?? this.error,
      saveError: clearSaveError ? '' : saveError ?? this.saveError,
      detailError: clearDetailError ? '' : detailError ?? this.detailError,
      accountsError:
          clearAccountsError ? '' : accountsError ?? this.accountsError,
    );
  }

  @override
  List<Object?> get props => [
        status,
        saveStatus,
        detailStatus,
        accountsStatus,
        meetings,
        accounts,
        selectedMeeting,
        visibleDate,
        viewMode,
        error,
        saveError,
        detailError,
        accountsError,
      ];
}
