import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';

class CityAirport {
  final String city;
  final String code;

  CityAirport({required this.city, required this.code});
}

class SearchPage extends StatefulWidget {
  final String hint;
  const SearchPage({super.key, required this.hint});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();

  final List<CityAirport> suggestions = [
    CityAirport(city: 'Delhi', code: 'DEL'),
    CityAirport(city: 'Mumbai', code: 'BOM'),
    CityAirport(city: 'Bangalore', code: 'BLR'),
    CityAirport(city: 'Chennai', code: 'MAA'),
    CityAirport(city: 'Kolkata', code: 'CCU'),
    CityAirport(city: 'Hyderabad', code: 'HYD'),
    CityAirport(city: 'Goa', code: 'GOI'),
  ];

  List<CityAirport> filteredResults = [];

  @override
  void initState() {
    super.initState();
    filteredResults = suggestions;
  }

  void _onSearchChanged(String query) {
    setState(() {
      filteredResults = suggestions.where((item) {
        final cityLower = item.city.toLowerCase();
        final codeLower = item.code.toLowerCase();
        final queryLower = query.toLowerCase();
        return cityLower.contains(queryLower) || codeLower.contains(queryLower);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Top bar with back icon and search field
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.grey,
                    ),
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
                        prefixIcon: const Icon(
                          Icons.search,
                          color: Colors.grey,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 16),
                      ),
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),

            // List of filtered results
            Expanded(
              child: ListView.builder(
                itemCount: filteredResults.length,
                itemBuilder: (context, index) {
                  final item = filteredResults[index];
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(32, 0, 0, 0),
                    child: ListTile(
                      leading: const Icon(
                        Icons.location_city,
                        color: Colors.grey,
                      ),
                      title: Text(
                        item.city,
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                      subtitle: Text(
                        item.code,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      onTap: () {
                        // Return both city and airport code, as a Map (or you can create your custom object)
                        context.pop({'city': item.city, 'code': item.code});
                      },
                    ),
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
