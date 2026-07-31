import 'package:dio/dio.dart';

import '../../../../core/network/dio_helper.dart';
import '../../../../core/network/pmo_endpoints.dart';
import '../../../project/data/models/project_api_models.dart';
import '../models/create_financial_statement_request.dart';
import '../models/dx_title_item_dto.dart';
import '../models/financial_statements_response_model.dart';
import '../../domain/entities/financial_statement_summary.dart';

abstract class FinancialRequirementsRemoteDataSource {
  Future<FinancialStatementsResponseModel> getFinancialStatements({
    required int pageNumber,
    required int pageSize,
  });

  Future<FinancialStatementSummary> getStatementCount();

  Future<FinancialStatementSummary> getStatementSum();

  Future<List<ProjectDxItemDto>> getProjectsDx();

  Future<List<DxTitleItemDto>> getFinancialStatusesDx();

  Future<List<DxTitleItemDto>> getPmStatusesDx();

  Future<void> createFinancialStatement(
    CreateFinancialStatementRequest request,
  );

  Future<void> deleteFinancialStatement(String id);
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
        url: PmoEndpoints.financialStatement,
        query: {'pageNumber': pageNumber, 'pageSize': pageSize},
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

  @override
  Future<FinancialStatementSummary> getStatementCount() async {
    final response = await DioHelper.getData(
      url: PmoEndpoints.financialStatementCount,
    );
    if (response.data is! Map<String, dynamic>) {
      throw const FormatException('Invalid statement-count response');
    }
    return FinancialStatementSummary.fromJson(
      response.data as Map<String, dynamic>,
    );
  }

  @override
  Future<FinancialStatementSummary> getStatementSum() async {
    final response = await DioHelper.getData(
      url: PmoEndpoints.financialStatementSum,
    );
    if (response.data is! Map<String, dynamic>) {
      throw const FormatException('Invalid statement-sum response');
    }
    return FinancialStatementSummary.fromJson(
      response.data as Map<String, dynamic>,
    );
  }

  @override
  Future<List<ProjectDxItemDto>> getProjectsDx() async {
    final response = await DioHelper.getData(url: PmoEndpoints.projectDxList);
    final body = response.data as Map<String, dynamic>;
    return parseProjectDxItems(body['data']);
  }

  @override
  Future<List<DxTitleItemDto>> getFinancialStatusesDx() async {
    final response = await DioHelper.getData(
      url: PmoEndpoints.financialStatusListDx,
    );
    final body = response.data as Map<String, dynamic>;
    return parseDxTitleItems(body['data']);
  }

  @override
  Future<List<DxTitleItemDto>> getPmStatusesDx() async {
    final response = await DioHelper.getData(url: PmoEndpoints.pmStatusListDx);
    final body = response.data as Map<String, dynamic>;
    return parseDxTitleItems(body['data']);
  }

  @override
  Future<void> createFinancialStatement(
    CreateFinancialStatementRequest request,
  ) async {
    await DioHelper.postData(
      url: PmoEndpoints.createFinancialStatement,
      data: request.toFormData(),
    );
  }

  @override
  Future<void> deleteFinancialStatement(String id) async {
    await DioHelper.deleteData(
      url: PmoEndpoints.deleteFinancialStatement,
      data: FormData.fromMap({'key': id}),
    );
  }
}
