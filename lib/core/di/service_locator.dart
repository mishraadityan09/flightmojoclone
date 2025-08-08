import 'package:flightmojo/features/search/presentation/provider/search_provider.dart';
import 'package:get_it/get_it.dart';

import '../network/dio_client.dart';
import '../../features/search/data/datasources/search_remote_resources.dart';


final sl = GetIt.instance;

void setup() {
  // Register core DioClient singleton
  sl.registerLazySingleton<DioClient>(() => DioClient.instance);

  // Register SearchRemoteDataSource
  sl.registerLazySingleton<SearchRemoteDataSource>(
      () => SearchRemoteDataSourceImpl(dioClient: sl()));

  // Register SearchProvider - as factory to get a fresh instance if needed
  sl.registerFactory<SearchProvider>(() => SearchProvider(remoteDataSource: sl()));
}
