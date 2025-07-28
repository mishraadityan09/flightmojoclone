import 'package:flightmojo/core/common/datepicker_bottomsheet.dart';
import 'package:flightmojo/core/theme/app_theme.dart';
import 'package:flightmojo/feature/home/presentaion/widgets/passengers_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/app_routes.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // State variables
  String _fromCity = 'Delhi';
  String _toCity = 'Mumbai';
  String _departureDate = _formatDate(DateTime.now());
  String _returnDate = _formatDate(DateTime.now().add(const Duration(days: 1)));
  int _passengers = 1;
  bool _isRoundTrip = false;

  // Constants
  static const List<Map<String, String>> _destinations = [
    {'name': 'Mumbai', 'price': '₹4,500'},
    {'name': 'Bangalore', 'price': '₹5,200'},
    {'name': 'Chennai', 'price': '₹4,800'},
    {'name': 'Kolkata', 'price': '₹3,900'},
  ];

  static const Map<DateTime, double> _samplePrices = {
    // You might want to make this dynamic
  };

  // Helper methods
  static String _formatDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year}";
  }

  DateTime? _parseDate(String dateString) {
    try {
      final parts = dateString.split('/');
      if (parts.length == 3) {
        return DateTime(
          int.parse(parts[2]), // year
          int.parse(parts[1]), // month
          int.parse(parts[0]), // day
        );
      }
    } catch (e) {
      debugPrint('Error parsing date: $e');
    }
    return null;
  }

  // Event handlers
  Future<void> _selectLocation(String fieldType) async {
    final result = await context.push(
      AppRoutes.flightSearch,
      extra: {'hint': fieldType},
    );

    if (result != null && result is String) {
      setState(() {
        if (fieldType == 'From') {
          _fromCity = result;
        } else if (fieldType == 'To') {
          _toCity = result;
        }
      });
    }
  }

  void _selectDate(String dateType) {
    final initialDate = dateType == 'Departure' 
        ? _parseDate(_departureDate) ?? DateTime.now()
        : _parseDate(_returnDate) ?? DateTime.now().add(const Duration(days: 1));

    showDatePickerBottomSheet(
      context,
      initialDepartureDate: dateType == 'Departure' ? initialDate : _parseDate(_departureDate) ?? DateTime.now(),
      initialReturnDate: dateType == 'Return' ? initialDate : null,
      prices: const {
        // Add your sample prices here
      },
      isAddingReturnDate: dateType == 'Return',
      onDatesSelected: (departureDate, returnDate) {
        setState(() {
          if (dateType == 'Departure') {
            _departureDate = _formatDate(departureDate);
          } else if (returnDate != null) {
            _returnDate = _formatDate(returnDate);
          }
        });
      },
    );
  }

  void _showPassengersBottomSheet() {
    showModalBottomSheet(
      showDragHandle: true,
      useRootNavigator: true,
      isScrollControlled: true,
      context: context,
      builder: (context) => const PassengersBottomSheet(),
    );
  }

  void _searchFlights({String? destinationOverride}) {
    // Create comprehensive search data
    final searchData = {
      'searchParams': {
        'from': _fromCity,
        'to': destinationOverride ?? _toCity,
        'departureDate': _departureDate,
        'returnDate': _isRoundTrip ? _returnDate : null,
        'passengers': _passengers,
        'isRoundTrip': _isRoundTrip,
        'searchTimestamp': DateTime.now().toIso8601String(),
      },
    };

    // Navigate to results page
    context.push(
      AppRoutes.flightResults,
      extra: searchData,
    );
  }

  void _toggleTripType(bool isRoundTrip) {
    setState(() {
      _isRoundTrip = isRoundTrip;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeroSection(),
            _buildPopularDestinationsSection(),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: Text(
        'FlightsMojo',
        style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold),
      ),
      backgroundColor: Theme.of(context).primaryColor,
      foregroundColor: Colors.white,
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications_outlined),
          onPressed: () {}, // Add notification logic
        ),
      ],
    );
  }

  Widget _buildHeroSection() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Theme.of(context).primaryColor,
            Theme.of(context).primaryColor.withValues(alpha: 0.8),
          ],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeroText(),
            const SizedBox(height: 24),
            _buildSearchCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroText() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Find Your Perfect Flight',
          style: GoogleFonts.poppins(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Book flights at the best prices',
          style: GoogleFonts.poppins(
            fontSize: 16,
            color: Colors.white.withValues(alpha: 0.9),
          ),
        ),
      ],
    );
  }

  Widget _buildSearchCard() {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildFlightsBadge(),
            const SizedBox(height: 16),
            _buildTripTypeSelector(),
            const SizedBox(height: 16),
            _buildLocationFields(),
            const SizedBox(height: 16),
            _buildDateFields(),
            const SizedBox(height: 16),
            _buildPassengerField(),
            const SizedBox(height: 20),
            _buildSearchButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildFlightsBadge() {
    return Row(
      children: [
        Container(
          decoration: AppTheme.gradientContainerDecoration,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: Text(
            'Flights',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTripTypeSelector() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade300),
        color: Colors.grey.shade100,
      ),
      child: Stack(
        children: [
          _buildSlidingIndicator(),
          _buildTripTypeButtons(),
        ],
      ),
    );
  }

  Widget _buildSlidingIndicator() {
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOutCubic,
      left: _isRoundTrip ? null : 2,
      right: _isRoundTrip ? 2 : null,
      top: 2,
      bottom: 2,
      width: (MediaQuery.of(context).size.width - 36) / 2.5,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 3,
              offset: const Offset(0, 1),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTripTypeButtons() {
    return Row(
      children: [
        _buildTripTypeButton('One Way', false),
        _buildTripTypeButton('Round Trip', true),
      ],
    );
  }

  Widget _buildTripTypeButton(String text, bool isRoundTrip) {
    final isSelected = _isRoundTrip == isRoundTrip;
    
    return Expanded(
      child: GestureDetector(
        onTap: () => _toggleTripType(isRoundTrip),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Center(
            child: AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 300),
              style: TextStyle(
                color: isSelected ? Colors.black : Colors.grey.shade600,
                fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
                fontSize: 16,
              ),
              child: Text(text),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLocationFields() {
    return Row(
      children: [
        Expanded(
          child: _buildLocationField('From', _fromCity, Icons.flight_takeoff),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildLocationField('To', _toCity, Icons.flight_land),
        ),
      ],
    );
  }

  Widget _buildLocationField(String label, String value, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildFieldLabel(label),
        const SizedBox(height: 4),
        GestureDetector(
          onTap: () => _selectLocation(label),
          child: _buildFieldContainer(
            child: Row(
              children: [
                Icon(icon, color: Theme.of(context).primaryColor, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    value,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDateFields() {
    return Row(
      children: [
        Expanded(child: _buildDateField('Departure', _departureDate)),
        const SizedBox(width: 16),
        Expanded(
          child: _isRoundTrip 
              ? _buildDateField('Return', _returnDate)
              : _buildAddReturnDateField(),
        ),
      ],
    );
  }

  Widget _buildDateField(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildFieldLabel(label),
        const SizedBox(height: 4),
        GestureDetector(
          onTap: () => _selectDate(label),
          child: _buildFieldContainer(
            child: Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  color: Theme.of(context).primaryColor,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    value,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAddReturnDateField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildFieldLabel('Return'),
        const SizedBox(height: 4),
        GestureDetector(
          onTap: () => _toggleTripType(true),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 9),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.add,
                      color: Theme.of(context).primaryColor,
                      size: 10,
                    ),
                    Text(
                      'Add Return Date',
                      style: GoogleFonts.poppins(
                        fontSize: 10,
                        fontWeight: FontWeight.w300,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  'Save more with round trip',
                  style: GoogleFonts.poppins(
                    fontSize: 10,
                    fontWeight: FontWeight.w300,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPassengerField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildFieldLabel('Passengers'),
        const SizedBox(height: 4),
        GestureDetector(
          onTap: _showPassengersBottomSheet,
          child: _buildFieldContainer(
            child: Row(
              children: [
                Icon(
                  Icons.person,
                  color: Theme.of(context).primaryColor,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '$_passengers Adult${_passengers > 1 ? 's' : ''}',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSearchButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _searchFlights,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          'Search Flights',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildPopularDestinationsSection() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Popular Destinations',
            style: GoogleFonts.poppins(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.2,
            ),
            itemCount: _destinations.length,
            itemBuilder: (context, index) => _buildDestinationCard(_destinations[index]),
          ),
        ],
      ),
    );
  }

  Widget _buildDestinationCard(Map<String, String> destination) {
    return GestureDetector(
      onTap: () => _searchFlights(destinationOverride: destination['name']),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Theme.of(context).primaryColor.withValues(alpha: 0.8),
                Theme.of(context).primaryColor,
              ],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Icon(Icons.location_city, color: Colors.white, size: 32),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      destination['name']!,
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'from ${destination['price']!}',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.white.withValues(alpha: 0.9),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper widgets
  Widget _buildFieldLabel(String label) {
    return Text(
      label,
      style: GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: Colors.grey[600],
      ),
    );
  }

  Widget _buildFieldContainer({required Widget child}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: child,
    );
  }
}