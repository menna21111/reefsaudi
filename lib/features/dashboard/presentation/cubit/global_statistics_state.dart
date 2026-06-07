part of 'global_statistics_cubit.dart';

sealed class GlobalStatisticsState extends Equatable {
  const GlobalStatisticsState();

  @override
  List<Object?> get props => [];
}

class GlobalStatisticsInitial extends GlobalStatisticsState {
  const GlobalStatisticsInitial();
}

class GlobalStatisticsLoading extends GlobalStatisticsState {
  const GlobalStatisticsLoading();
}

class GlobalStatisticsLoaded extends GlobalStatisticsState {
  final GlobalStatisticsBundle bundle;
  final bool isRefreshing;

  const GlobalStatisticsLoaded(
    this.bundle, {
    this.isRefreshing = false,
  });

  GlobalStatisticsLoaded copyWith({
    GlobalStatisticsBundle? bundle,
    bool? isRefreshing,
  }) {
    return GlobalStatisticsLoaded(
      bundle ?? this.bundle,
      isRefreshing: isRefreshing ?? this.isRefreshing,
    );
  }

  @override
  List<Object?> get props => [bundle, isRefreshing];
}

class GlobalStatisticsError extends GlobalStatisticsState {
  final String message;

  const GlobalStatisticsError(this.message);

  @override
  List<Object?> get props => [message];
}
