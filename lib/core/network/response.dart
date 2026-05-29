class Result<T> {
  final T? data;
  final String? errorMessage;
  final int? errorCode;

  bool get isSuccess => errorCode == 0;

  Result.success(this.data)
      : errorMessage = '',
        errorCode = 0;

  Result.error(this.errorMessage, {this.data, this.errorCode = 1});

  factory Result.fromJson(Map<String, dynamic> json, T Function(Map<String, dynamic>) fromJsonT) {
    return json['errorCode'] == 0
        ? Result.success(fromJsonT(json['data']))
        : Result.error(
      json['errorMessage'] ?? 'An error occurred',
      data: null,
      errorCode: json['errorCode'] ?? 0,
    );
  }
}
