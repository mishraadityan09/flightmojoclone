import 'package:dio/dio.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/dio_client.dart';

abstract class SearchRemoteDataSource {
  // Fetch city data based on user-entered cityId (query)
  Future<Response> getCityData(String cityId);

  // Fetch popular routes for initial or empty-query display
  Future<Response> getPopularRoutes();
}

class SearchRemoteDataSourceImpl implements SearchRemoteDataSource {
  final DioClient dioClient;

  SearchRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<Response> getCityData(String cityId) {
    return dioClient.get(
      ApiConstants.getCityEndpoint, // relative endpoint '/getcity/'
      queryParameters: {
        ApiConstants.authCodeKey: ApiConstants.authCode,
        ApiConstants.idKey: cityId,
      },
    );
  }

  @override
  Future<Response> getPopularRoutes() {
    return dioClient.get(
      ApiConstants.getCityEndpoint, // Use the actual endpoint for popular routes here
      queryParameters: {
        ApiConstants.authCodeKey: ApiConstants.authCode,
        ApiConstants.idKey:''
      },
    );
  }
}
