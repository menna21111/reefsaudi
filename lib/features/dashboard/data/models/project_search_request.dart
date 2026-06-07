class ProjectSearchRequest {
  final String? query;
  final List<String> brands;
  final List<String> tags;
  final List<String> productionLines;
  final List<String> products;
  final List<int> projectStatus;
  final List<int> projectTypes;
  final List<String> sizes;
  final bool aggsOnly;
  final bool includeAggs;
  final int page;
  final int size;

  const ProjectSearchRequest({
    this.query,
    this.brands = const [],
    this.tags = const [],
    this.productionLines = const [],
    this.products = const [],
    this.projectStatus = const [],
    this.projectTypes = const [0],
    this.sizes = const [],
    this.aggsOnly = false,
    this.includeAggs = false,
    this.page = 1,
    this.size = 10,
  });

  Map<String, dynamic> toJson() => {
        'query': (query == null || query!.trim().isEmpty) ? null : query!.trim(),
        'brands': brands,
        'tags': tags,
        'productionLines': productionLines,
        'products': products,
        'projectStatus': projectStatus,
        'projectTypes': projectTypes,
        'sizes': sizes,
        'aggsOnly': aggsOnly,
        'includeAggs': includeAggs,
        'page': page,
        'size': size,
      };

  ProjectSearchRequest copyWith({
    String? query,
    List<String>? brands,
    List<String>? tags,
    List<String>? productionLines,
    List<String>? products,
    List<int>? projectStatus,
    List<int>? projectTypes,
    List<String>? sizes,
    bool? aggsOnly,
    bool? includeAggs,
    int? page,
    int? size,
  }) {
    return ProjectSearchRequest(
      query: query ?? this.query,
      brands: brands ?? this.brands,
      tags: tags ?? this.tags,
      productionLines: productionLines ?? this.productionLines,
      products: products ?? this.products,
      projectStatus: projectStatus ?? this.projectStatus,
      projectTypes: projectTypes ?? this.projectTypes,
      sizes: sizes ?? this.sizes,
      aggsOnly: aggsOnly ?? this.aggsOnly,
      includeAggs: includeAggs ?? this.includeAggs,
      page: page ?? this.page,
      size: size ?? this.size,
    );
  }
}
