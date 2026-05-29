import 'dart:convert';

import 'package:dio/dio.dart';

Future<String> fetchAndConvertImageToBase64(String imageUrl) async {
  final dio = Dio();
  final response = await dio.get<List<int>>(
    imageUrl,
    options: Options(responseType: ResponseType.bytes),
  );

  if (response.statusCode == 200 && response.data != null) {
    return base64Encode(response.data!);
  } else {
    throw Exception("Failed to load image");
  }
}

Future<String> fetchAndConvertFileToBase64(String fileUrl) async {
  final dio = Dio();
  final response = await dio.get<List<int>>(
    fileUrl,
    options: Options(responseType: ResponseType.bytes),
  );

  if (response.statusCode == 200 && response.data != null) {
    return base64Encode(response.data!); // Convert file bytes to Base64
  } else {
    throw Exception("Failed to load file");
  }
}