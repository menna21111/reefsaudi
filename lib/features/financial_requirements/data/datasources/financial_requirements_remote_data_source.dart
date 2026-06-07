import 'package:dio/dio.dart';

import '../../../../core/network/api_constant.dart';
import '../../../../core/network/dio_helper.dart';
import '../models/financial_statements_response_model.dart';

abstract class FinancialRequirementsRemoteDataSource {
  Future<FinancialStatementsResponseModel> getFinancialStatements({
    required int pageNumber,
    required int pageSize,
  });
}

class FinancialRequirementsRemoteDataSourceImpl
    implements FinancialRequirementsRemoteDataSource {
  @override
  Future<FinancialStatementsResponseModel> getFinancialStatements({
    required int pageNumber,
    required int pageSize,
  }) async {
    try {
      final response = await DioHelper.getData(
        url: ApiConstants.financialStatementUrl,
        query: {
          'pageNumber': pageNumber,
          'pageSize': pageSize,
        },
      );

      if (response.data is! Map<String, dynamic>) {
        throw const FormatException('Invalid financial statements response');
      }

      return FinancialStatementsResponseModel.fromJson(
        response.data as Map<String, dynamic>,
      );
    } on DioException {
      rethrow;
    }
  }
}
