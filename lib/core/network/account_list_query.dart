/// Builds DevExtreme account list query params (same shape as web).
abstract final class AccountListQuery {
  static Map<String, dynamic> dx({
    int skip = 0,
    int take = 100,
    int? userType,
  }) {
    return {
      'skip': skip,
      'take': take,
      if (userType != null) 'filter': '["userType","=",$userType]',
      '_': DateTime.now().millisecondsSinceEpoch,
    };
  }
}
