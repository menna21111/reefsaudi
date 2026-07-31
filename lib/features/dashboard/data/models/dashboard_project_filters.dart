import 'package:equatable/equatable.dart';

class DashboardProjectFilters extends Equatable {
  const DashboardProjectFilters({
    this.brands = const [],
    this.productionLines = const [],
    this.products = const [],
    this.sizes = const [],
    this.projectStatus = const [],
    this.projectTypes = const [],
  });

  final List<String> brands;
  final List<String> productionLines;
  final List<String> products;
  final List<String> sizes;
  final List<int> projectStatus;
  final List<int> projectTypes;

  bool get hasAny =>
      brands.isNotEmpty ||
      productionLines.isNotEmpty ||
      products.isNotEmpty ||
      sizes.isNotEmpty ||
      projectStatus.isNotEmpty ||
      projectTypes.isNotEmpty;

  int get activeCount =>
      brands.length +
      productionLines.length +
      products.length +
      sizes.length +
      projectStatus.length +
      projectTypes.length;

  DashboardProjectFilters copyWith({
    List<String>? brands,
    List<String>? productionLines,
    List<String>? products,
    List<String>? sizes,
    List<int>? projectStatus,
    List<int>? projectTypes,
  }) {
    return DashboardProjectFilters(
      brands: brands ?? this.brands,
      productionLines: productionLines ?? this.productionLines,
      products: products ?? this.products,
      sizes: sizes ?? this.sizes,
      projectStatus: projectStatus ?? this.projectStatus,
      projectTypes: projectTypes ?? this.projectTypes,
    );
  }

  @override
  List<Object?> get props => [
        brands,
        productionLines,
        products,
        sizes,
        projectStatus,
        projectTypes,
      ];
}
