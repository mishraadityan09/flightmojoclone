import 'dart:async';

import 'package:flightmojo/features/search/presentation/provider/search_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_theme.dart';

import '../../data/models/city_airport_model.dart';

class SearchPage extends StatefulWidget {
  final String hint;
  const SearchPage({super.key, required this.hint});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    // Cancel any existing timer to debounce calls
    if (_debounce?.isActive ?? false) _debounce?.cancel();

    _debounce = Timer(const Duration(milliseconds: 500), () {
      final provider = context.read<SearchProvider>();

      if (query.length >= 2) {
        provider.searchCity(query);
      } else {
        provider.fetchPopularRoutes(); // Clear when input < 2 chars
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Search input bar with back button
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.grey),
                    onPressed: () => context.pop(),
                  ),
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      autofocus: true,
                      onChanged: _onSearchChanged,
                      decoration: InputDecoration(
                        hintText: widget.hint,
                        hintStyle: const TextStyle(color: Colors.grey),
                        prefixIcon: const Icon(Icons.search, color: Colors.grey),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                      ),
                      style: GoogleFonts.poppins(fontSize: 14),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),

            // Results List
            Expanded(
              child: Consumer<SearchProvider>(
                builder: (context, provider, child) {
                  if (provider.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (provider.errorMessage != null) {
                    return Center(child: Text(provider.errorMessage!));
                  }

                  final List<CityAirportModel> results = provider.results;

                  if (results.isEmpty) {
                    return const Center(child: Text('No locations found'));
                  }

                  return ListView.builder(
                    itemCount: results.length,
                    itemBuilder: (context, index) {
                      final item = results[index];
                      return Padding(
                        padding: const EdgeInsets.fromLTRB(32, 0, 0, 0),
                        child: ListTile(
                          leading: const Icon(Icons.location_city, color: Colors.grey),
                          title: Text(item.cityName,
                              style: GoogleFonts.poppins(
                                  fontSize: 16, color: Colors.grey)),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(item.cityCode,
                                  style: GoogleFonts.poppins(
                                      fontSize: 14, color: Colors.grey.shade600)),
                              Text(item.airportName,
                                  style: GoogleFonts.poppins(
                                      fontSize: 12, color: Colors.grey.shade500)),
                            ],
                          ),
                          onTap: () {
                            context.pop({
                              'city': item.cityName,
                              'code': item.cityCode,
                              'airportName': item.airportName,
                            });
                          },
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
