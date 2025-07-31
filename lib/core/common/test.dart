import 'package:flightmojo/core/common/datepicker_bottomsheet.dart';
import 'package:flightmojo/feature/home/presentaion/widgets/passengers_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/app_routes.dart';

class FlightSearchWidget extends StatefulWidget {
  const FlightSearchWidget({super.key});

  @override
  State<FlightSearchWidget> createState() => _FlightSearchWidgetState();
}

class _FlightSearchWidgetState extends State<FlightSearchWidget> {
  // Flight-specific state variables
  String _fromCity = 'Delhi';
  String _toCity = 'Mumbai';
  String _departureDate = _formatDate(DateTime.now());
  String _returnDate = _formatDate(DateTime.now().add(const Duration(days: 1)));
  final int _passengers = 1;
  bool _isRoundTrip = false;

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

  // Responsive font size getters based on MediaQuery width
  double get screenWidth => MediaQuery.of(context).size.width;

  double get headingFontSize =>
      (screenWidth * 0.055).clamp(20.0, 24.0); // 5.5% width, clamp 20-24

  double get buttonLabelFontSize =>
      (screenWidth * 0.045).clamp(16.0, 18.0); // 4.5% width, clamp 16-18

  double get bodyTextFontSize =>
      (screenWidth * 0.04).clamp(14.0, 16.0); // 4% width, clamp 14-16

  double get secondaryLabelFontSize =>
      (screenWidth * 0.030).clamp(12.0, 14.0); // 3.2% width, clamp 12-14

  double get secondaryFontSize =>
      (screenWidth * 0.032).clamp(12.0, 14.0); // 3.2% width, clamp 12-14

  double get smallFontSize =>
      (screenWidth * 0.025).clamp(10.0, 12.0); // ~2.5% width, clamp 10-12

  double get iconSize => 20.0; // Fixed icon size for consistency

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
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
        ),
      ],
    );
  }

  Widget _buildTripTypeSelector() {
    return Container(
      height: 48,
      margin: const EdgeInsets.symmetric(horizontal: 0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(36),
        border: Border.all(color: Colors.grey.shade300),
        color: Colors.grey.shade100,
      ),
      child: Stack(
        children: [_buildSlidingIndicator(), _buildTripTypeButtons()],
      ),
    );
  }

  Widget _buildSlidingIndicator() {
    return AnimatedAlign(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      alignment: _isRoundTrip ? Alignment.centerRight : Alignment.centerLeft,
      child: FractionallySizedBox(
        widthFactor: 0.5,
        heightFactor: 1,
        child: Container(
          margin: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(36),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 3,
                offset: const Offset(0, 1),
              ),
            ],
          ),
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
        onTap: () => setState(() => _isRoundTrip = isRoundTrip),
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 300),
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.grey.shade600,
              fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
              fontSize: buttonLabelFontSize,
            ),
            child: Text(text),
          ),
        ),
      ),
    );
  }

  Widget _buildLocationFields() {
    return Stack(
      children: [
        Column(
          children: [
            _buildOutlinedField(
              label: "From",
              value: _fromCity,
              icon: Icons.flight_takeoff,
              onTap: () => _selectLocation("From"),
            ),
            const SizedBox(height: 24),
            _buildOutlinedField(
              label: "To",
              value: _toCity,
              icon: Icons.flight_land,
              onTap: () => _selectLocation("To"),
            ),
          ],
        ),
        Positioned(right: 12, top: 6, bottom: 0, child: _buildExchangeIcon()),
      ],
    );
  }

  Widget _buildExchangeIcon() {
    return Center(
      child: GestureDetector(
        onTap: _exchangeLocations,
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.grey, width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Transform.rotate(
            angle: 3.1416 / 2, // 90 degrees in radians
            child: Icon(
              Icons.sync_alt,
              color: Theme.of(context).primaryColor,
              size: iconSize,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOutlinedField({
    required String label,
    required String value,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return TextField(
      readOnly: true,
      onTap: onTap,
      controller: TextEditingController(text: value),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.grey),
        labelStyle: TextStyle(color: Colors.grey),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey), // always grey
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey), // always grey
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey), // always grey
        ),
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        isDense: true,
      ),
      style: GoogleFonts.poppins(
        fontSize: bodyTextFontSize,
        fontWeight: FontWeight.w500,
        color: Colors.grey,
      ),
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
    return _buildOutlinedField(
      label: label,
      value: value,
      icon: Icons.calendar_today,
      onTap: () => _selectDate(label),
    );
  }

  Widget _buildAddReturnDateField() {
    return GestureDetector(
      onTap: () => _toggleTripType(true),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 1),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Return',
              style: GoogleFonts.poppins(
                fontSize: bodyTextFontSize * 0.85,
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                Icon(
                  Icons.add,
                  color: Colors.grey,
                  size: 14,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    'Add Return Date',
                    style: GoogleFonts.poppins(
                      fontSize: bodyTextFontSize * 0.85,
                      fontWeight: FontWeight.w300,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              'Save more with round trip',
              style: GoogleFonts.poppins(
                fontSize: bodyTextFontSize * 0.75,
                fontWeight: FontWeight.w300,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPassengerField() {
    return _buildOutlinedField(
      label: 'Passengers',
      value: '$_passengers Adult${_passengers > 1 ? 's' : ''}',
      icon: Icons.person,
      onTap: _showPassengersBottomSheet,
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
            fontSize: buttonLabelFontSize,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  // Your existing helper widgets and event handlers remain untouched

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
      initialDepartureDate:
          dateType == 'Departure' ? initialDate : _parseDate(_departureDate) ?? DateTime.now(),
      initialReturnDate:
          dateType == 'Return' ? initialDate : (_isRoundTrip ? _parseDate(_returnDate) : null),
      prices: const {},
      isAddingReturnDate: dateType == 'Return',
      onDatesSelected: (departureDate, returnDate) {
        setState(() {
          _departureDate = _formatDate(departureDate);

          if (returnDate != null) {
            _returnDate = _formatDate(returnDate);
            _isRoundTrip = true;
          } else if (dateType == 'Departure' && _isRoundTrip) {
            final currentReturnDate = _parseDate(_returnDate);
            if (currentReturnDate != null && currentReturnDate.isBefore(departureDate)) {
              _returnDate = _formatDate(
                departureDate.add(const Duration(days: 1)),
              );
            }
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

  void _toggleTripType(bool isRoundTrip) {
    setState(() {
      _isRoundTrip = isRoundTrip;
      if (isRoundTrip) {
        final departureDateTime = _parseDate(_departureDate);
        final returnDateTime = _parseDate(_returnDate);
        if (departureDateTime != null &&
            (returnDateTime == null ||
                returnDateTime.isBefore(departureDateTime) ||
                returnDateTime.isAtSameMomentAs(departureDateTime))) {
          _returnDate = _formatDate(
            departureDateTime.add(const Duration(days: 1)),
          );
        }
      }
    });
  }

  void _exchangeLocations() {
    setState(() {
      debugPrint('clicked');
      final temp = _fromCity;
      _fromCity = _toCity;
      _toCity = temp;
    });
  }

  void _searchFlights({String? destinationOverride}) {
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

    context.push(AppRoutes.flightResults, extra: searchData);
  }

  // Optionally public method to handle external search with destination override
  void searchWithDestination(String destination) {
    _searchFlights(destinationOverride: destination);
  }
}
