part of 'portfolio_overview_cubit.dart';

sealed class PortfolioOverviewState extends Equatable {
  const PortfolioOverviewState();

  @override
  List<Object?> get props => [];
}

class PortfolioOverviewInitial extends PortfolioOverviewState {
  const PortfolioOverviewInitial();
}

class PortfolioOverviewLoading extends PortfolioOverviewState {
  const PortfolioOverviewLoading();
}

class PortfolioOverviewError extends PortfolioOverviewState {
  const PortfolioOverviewError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

class PortfolioOverviewLoaded extends PortfolioOverviewState {
  const PortfolioOverviewLoaded({
    required this.bundle,
    this.isRefreshing = false,
  });

  final PortfolioOverviewBundle bundle;
  final bool isRefreshing;

  PortfolioOverviewLoaded copyWith({
    PortfolioOverviewBundle? bundle,
    bool? isRefreshing,
  }) {
    return PortfolioOverviewLoaded(
      bundle: bundle ?? this.bundle,
      isRefreshing: isRefreshing ?? this.isRefreshing,
    );
  }

  @override
  List<Object?> get props => [bundle, isRefreshing];
}
