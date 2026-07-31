import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/enums.dart';
import '../../data/models/meeting_models.dart';
import '../../domain/repositories/meetings_repository.dart';

part 'meetings_state.dart';

class MeetingsCubit extends Cubit<MeetingsState> {
  MeetingsCubit({required this.repository})
      : super(MeetingsState(visibleDate: DateTime.now()));

  final MeetingsRepository repository;

  Future<void> loadForVisibleRange({
    required DateTime rangeStart,
    required DateTime rangeEnd,
    DateTime? visibleDate,
  }) async {
    emit(
      state.copyWith(
        status: RequestStatus.loading,
        visibleDate: visibleDate ?? state.visibleDate,
        clearError: true,
      ),
    );

    final result = await repository.getMeetings(
      rangeStart: rangeStart,
      rangeEnd: rangeEnd,
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: RequestStatus.error,
          error: failure.errMessage,
        ),
      ),
      (response) => emit(
        state.copyWith(
          status: RequestStatus.success,
          meetings: response.data,
          clearError: true,
        ),
      ),
    );
  }

  void changeViewMode(MeetingsCalendarViewMode mode) {
    if (state.viewMode == mode) return;
    emit(state.copyWith(viewMode: mode));
  }

  void setVisibleDate(DateTime date) {
    emit(state.copyWith(visibleDate: date));
  }

  Future<MeetingItem?> loadMeetingDetail(String id) async {
    emit(
      state.copyWith(
        detailStatus: RequestStatus.loading,
        clearDetailError: true,
        clearSelectedMeeting: true,
      ),
    );

    final result = await repository.getMeetingById(id);
    return result.fold(
      (failure) {
        emit(
          state.copyWith(
            detailStatus: RequestStatus.error,
            detailError: failure.errMessage,
          ),
        );
        return null;
      },
      (meeting) {
        emit(
          state.copyWith(
            detailStatus: RequestStatus.success,
            selectedMeeting: meeting,
            clearDetailError: true,
          ),
        );
        return meeting;
      },
    );
  }

  Future<List<MeetingAccountOption>> fetchAccounts({
    bool forceRefresh = false,
  }) async {
    if (!forceRefresh && state.accounts.isNotEmpty) {
      return state.accounts;
    }

    emit(state.copyWith(accountsStatus: RequestStatus.loading));
    final result = await repository.getAccounts();
    return result.fold(
      (failure) {
        emit(
          state.copyWith(
            accountsStatus: RequestStatus.error,
            accountsError: failure.errMessage,
          ),
        );
        return state.accounts;
      },
      (accounts) {
        emit(
          state.copyWith(
            accountsStatus: RequestStatus.success,
            accounts: accounts,
            clearAccountsError: true,
          ),
        );
        return accounts;
      },
    );
  }

  Future<bool> saveMeeting(MeetingWriteRequest request) async {
    emit(
      state.copyWith(
        saveStatus: RequestStatus.loading,
        clearSaveError: true,
      ),
    );

    final isEdit = request.id != null && request.id!.isNotEmpty;
    final result = isEdit
        ? await repository.updateMeeting(request)
        : await repository.createMeeting(request);

    return result.fold(
      (failure) {
        emit(
          state.copyWith(
            saveStatus: RequestStatus.error,
            saveError: failure.errMessage,
          ),
        );
        return false;
      },
      (meeting) {
        emit(
          state.copyWith(
            saveStatus: RequestStatus.success,
            selectedMeeting: meeting,
            clearSaveError: true,
          ),
        );
        return true;
      },
    );
  }

  Future<void> reloadCurrentRange() async {
    final date = state.visibleDate ?? DateTime.now();
    final day = DateTime(date.year, date.month, date.day);
    late final DateTime start;
    late final DateTime end;
    switch (state.viewMode) {
      case MeetingsCalendarViewMode.day:
      case MeetingsCalendarViewMode.timelineDay:
        start = day;
        end = day.add(const Duration(days: 1));
      case MeetingsCalendarViewMode.week:
        start = day.subtract(Duration(days: day.weekday - 1));
        end = start.add(const Duration(days: 7));
    }
    await loadForVisibleRange(
      rangeStart: start,
      rangeEnd: end,
      visibleDate: date,
    );
  }
}
