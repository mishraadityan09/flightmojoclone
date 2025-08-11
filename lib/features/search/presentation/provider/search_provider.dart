import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';

import '../../../search/data/datasources/search_remote_resources.dart';
import '../../../search/data/models/city_airport_model.dart';

class SearchProvider extends ChangeNotifier {
  final SearchRemoteDataSource remoteDataSource;

  SearchProvider({required this.remoteDataSource}) {
    fetchPopularRoutes(); // Fetch popular routes initially
  }

  List<CityAirportModel> _results = [];
  List<CityAirportModel> get results => _results;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<void> fetchPopularRoutes() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await remoteDataSource.getPopularRoutes();
      final List<dynamic> data = response.data;

      _results = data.map((json) => CityAirportModel.fromJson(json)).toList();
    } catch (e) {
      _errorMessage = 'Failed to load popular routes';
      _results = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> searchCity(String query) async {
    if (query.isEmpty) {
      await fetchPopularRoutes();
      return;
    }

    if (query.length < 2) {
      _results = [];
      notifyListeners();
      return;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final Response response = await remoteDataSource.getCityData(query);
      final List<dynamic> data = response.data;

      _results = data.map((json) => CityAirportModel.fromJson(json)).toList();
    } catch (e) {
      _errorMessage = 'Failed to fetch city data';
      _results = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearResults() {
    _results = [];
    _errorMessage = null;
    _isLoading = false;
    notifyListeners();
  }
}
