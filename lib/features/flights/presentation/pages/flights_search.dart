import 'package:flightmojo/core/common/datepicker_bottomsheet.dart';
// import 'package:flightmojo/core/common/generic_loading_screen.dart';
import 'package:flightmojo/core/common/loading_overlay.dart';
import 'package:flightmojo/features/home/presentaion/widgets/passengers_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../../core/router/app_routes.dart';

class FlightResult {
  final String flightNumber;
  final String airline;
  final String departureTime;
  final String arrivalTime;

  FlightResult({
    required this.flightNumber,
    required this.airline,
    required this.departureTime,
    required this.arrivalTime,
  });
}

class FlightSearchWidget extends StatefulWidget {
  final void Function(Map<String, dynamic> searchParams)? onSearchComplete;
  final Map<String, dynamic>? initialData;
  final bool isBottomSheetMode;
  const FlightSearchWidget({
    super.key,
    this.onSearchComplete,
    this.initialData,
    this.isBottomSheetMode = false,
  });

  @override
  State<FlightSearchWidget> createState() => _FlightSearchWidgetState();
}

class _FlightSearchWidgetState extends State<FlightSearchWidget> {
  // Flight-specific state variables

  String _fromCityName = 'Delhi';
  String _fromCityCode = 'DEL';
  String _fromAirportName = 'Indira Gandhi International Airport';
  String _toAirportName = 'Chhatrapati Shivaji Maharaj International Airport';

  String _toCityName = 'Mumbai';
  String _toCityCode = 'BOM';
  late String _departureDate;
  late String _returnDate;

  int _passengers = 1;
  String _travelClass = 'Economy';

  bool _isRoundTrip = false;

  @override
  void initState() {
    super.initState();

    if (widget.initialData != null) {
      print("initialData${widget.initialData}");
      final data = widget.initialData!;
      _fromCityName = data['from'] ?? _fromCityName;
      _toCityName = data['to'] ?? _toCityName;
      _departureDate = data['departureDate'] ?? _formatDate(DateTime.now());
      _returnDate =
          data['returnDate'] ??
          _formatDate(DateTime.now().add(const Duration(days: 1)));

      var passengersValue = data['passengers'];

      if (passengersValue is String) {
        // Try to extract the number at the start of the string
        final match = RegExp(r'\d+').firstMatch(passengersValue);
        _passengers = match != null ? int.parse(match.group(0)!) : 1;
      } else if (passengersValue is int) {
        _passengers = passengersValue;
      } else {
        _passengers = 1;
      }

      _travelClass = data['travelClass'] ?? 'Economy';
      _isRoundTrip = data['isRoundTrip'] ?? false;
    } else {
      _departureDate = _formatDate(DateTime.now());
      _returnDate = _formatDate(DateTime.now().add(const Duration(days: 1)));
    }
  }

  String _formatDate(DateTime date) {
    final formatter = DateFormat('dd MMM yy'); // 02 Aug 25
    return formatter.format(date);
  }

  // Helper methods

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
      (screenWidth * 0.035).clamp(15.0, 18.0); // 3.5% width, clamp 16-18

  double get bodyTextFontSize =>
      (screenWidth * 0.03).clamp(12.0, 16.0); // 4% width, clamp 12-16

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
        _buildTripTypeSelector(),
        const SizedBox(height: 16),
        Card(
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const SizedBox(height: 16),
                _buildLocationFields(),
                const SizedBox(height: 24),
                _buildDateFields(),
                const SizedBox(height: 24),
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
      height: 52,
      margin: const EdgeInsets.symmetric(horizontal: 3),
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
          margin: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(36),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
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
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 300),
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.grey.shade800,
              fontWeight: isSelected ? FontWeight.w400 : FontWeight.normal,
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
              city: _fromCityName,
              code: _fromCityCode,
              airportName: _fromAirportName,
              icon: LucideIcons.planeTakeoff,
              onTap: () => _selectLocation("From"),
            ),

            const SizedBox(height: 24),
            _buildOutlinedField(
              label: "To",
              city: _toCityName,
              code: _toCityCode,
              airportName: _toAirportName,
              icon: LucideIcons.planeLanding,
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
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Transform.rotate(
            angle:
                3.1416 /
                2, // 90 degrees in radians; use -3.1416/2 for the other direction
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
    String? city,
    String? code,
    String? airportName,
    String? value,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    final bool showCityCode =
        city != null && code != null && airportName != null;

    return InkWell(
      onTap: onTap,
      child: InputDecorator(
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.black, size: iconSize),
          labelText: label,
          labelStyle: TextStyle(color: Colors.black),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey),
          ),
          contentPadding: const EdgeInsets.symmetric(
            vertical: 14,
            horizontal: 12,
          ),
        ),
        child: showCityCode
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // City and Code on one line with some spacing
                  RichText(
                    text: TextSpan(
                      style: GoogleFonts.poppins(
                        fontSize: bodyTextFontSize,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                      children: [
                        TextSpan(text: city),
                        const WidgetSpan(child: SizedBox(width: 8)),
                        TextSpan(
                          text: code,
                          style: GoogleFonts.poppins(
                            fontSize: bodyTextFontSize - 2,
                            fontWeight: FontWeight.w400,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Airport name on a separate line, ellipsis if too long
                  Text(
                    airportName,
                    style: GoogleFonts.poppins(
                      fontSize: bodyTextFontSize - 4,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey.shade600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              )
            : Text(
                value ?? '',
                style: GoogleFonts.poppins(
                  fontSize: bodyTextFontSize,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
      ),
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
                Icon(
                  icon,
                  color: Theme.of(context).primaryColor,
                  size: iconSize,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    value,
                    style: GoogleFonts.poppins(
                      fontSize: bodyTextFontSize,
                      fontWeight: FontWeight.w500,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 40), // Space for exchange icon
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
    return _buildOutlinedField(
      label: label,
      value: value,
      icon: LucideIcons.calendarRange,
      onTap: () => _selectDate(label),
    );
  }

  Widget _buildAddReturnDateField() {
    return GestureDetector(
      onTap: () => _toggleTripType(true),
      child: AbsorbPointer(
        // Prevent editing but keep tap working on GestureDetector
        child: TextField(
          readOnly: true,
          decoration: InputDecoration(
            labelText: 'Return',
            labelStyle: TextStyle(
              color: Colors.black,

              fontWeight: FontWeight.w500,
            ),
            hintText: ' + Add Return Date',
            hintStyle: GoogleFonts.poppins(
              fontSize: (smallFontSize - 2 < 11) ? 11 : smallFontSize - 2,
              fontWeight: FontWeight.w400,
              color: Colors.grey,
            ),

            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey),
            ),
            floatingLabelBehavior: FloatingLabelBehavior.always,
            contentPadding: const EdgeInsets.symmetric(
              vertical: 10,
              horizontal: 12,
            ),
          ),
          style: GoogleFonts.poppins(
            fontSize: bodyTextFontSize,
            fontWeight: FontWeight.w500,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }

  Widget _buildPassengerField() {
    // Build passenger count text e.g., "3 Adults"
    final passengerText =
        '$_passengers Passenger${_passengers > 1 ? 's' : ''}'; // You can customize this text

    return GestureDetector(
      onTap: _showPassengersBottomSheet,
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: 'Passengers',
          labelStyle: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w500,
          ),
          prefixIcon: Icon(
            _passengers > 1 ? LucideIcons.users : LucideIcons.user,
            color: Colors.black,
            size: iconSize,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Theme.of(context).primaryColor),
          ),
          contentPadding: const EdgeInsets.symmetric(
            vertical: 12,
            horizontal: 12,
          ),
          floatingLabelBehavior: FloatingLabelBehavior.auto,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              passengerText,
              style: GoogleFonts.poppins(
                fontSize: bodyTextFontSize,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              _travelClass, // Display selected class here
              style: GoogleFonts.poppins(
                fontSize: bodyTextFontSize - 4,
                fontWeight: FontWeight.w400,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _searchFlights,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
        ),
        child: Text(
          'Search',
          style: GoogleFonts.poppins(
            fontSize: buttonLabelFontSize,
            fontWeight: FontWeight.w400,
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
        fontSize: secondaryLabelFontSize,
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

  // Event handlers
  Future<void> _selectLocation(String fieldType) async {
    final result = await context.push(
      AppRoutes.flightSearch,
      extra: {'hint': fieldType},
    );

    if (result != null && result is Map<String, dynamic>) {
      setState(() {
        final city = result['city'] as String? ?? '';
        final code = result['code'] as String? ?? '';
        final airportName = result['airportName'] as String? ?? '';

        if (fieldType == 'From') {
          _fromCityName = city;
          _fromCityCode = code;
          _fromAirportName = airportName; // Add this variable in your state
        } else if (fieldType == 'To') {
          _toCityName = city;
          _toCityCode = code;
          _toAirportName = airportName; // Add this variable in your state
        }
      });
    }
  }

  void _selectDate(String dateType) {
    final initialDate = dateType == 'Departure'
        ? _parseDate(_departureDate) ?? DateTime.now()
        : _parseDate(_returnDate) ??
              DateTime.now().add(const Duration(days: 1));

    showDatePickerBottomSheet(
      context,
      initialDepartureDate: dateType == 'Departure'
          ? initialDate
          : _parseDate(_departureDate) ?? DateTime.now(),
      initialReturnDate: dateType == 'Return'
          ? initialDate
          : (_isRoundTrip ? _parseDate(_returnDate) : null),
      prices: const {},
      isAddingReturnDate: dateType == 'Return',
      onDatesSelected: (departureDate, returnDate) {
        setState(() {
          // Update departure date always
          _departureDate = _formatDate(departureDate);

          if (returnDate != null) {
            // Return date selected, ensure return >= departure
            if (!returnDate.isBefore(departureDate)) {
              _returnDate = _formatDate(returnDate);
              _isRoundTrip = true; // keep round trip true
            } else {
              // If return date is before departure, fix it by setting return to departure + 1 day
              _returnDate = _formatDate(
                departureDate.add(const Duration(days: 1)),
              );
              _isRoundTrip = true;
            }
          } else {
            // Return date not selected (i.e., one-way trip)
            _isRoundTrip = false;
            _returnDate = _formatDate(
              departureDate.add(const Duration(days: 1)),
            ); // Optional, keep return date valid for later usage
          }

          // Additionally, if departure date is after current return date, fix return date
          final currentReturnDate = _parseDate(_returnDate);
          if (currentReturnDate != null &&
              currentReturnDate.isBefore(departureDate)) {
            _returnDate = _formatDate(
              departureDate.add(const Duration(days: 1)),
            );
            _isRoundTrip = true;
          }
        });
      },
    );
  }

  Future<void> _showPassengersBottomSheet() async {
    final result = await showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      showDragHandle: true,
      useRootNavigator: true,
      isScrollControlled: true,
      builder: (context) => const PassengersBottomSheet(),
    );

    if (result != null) {
      setState(() {
        // Extract values from the received Map
        final int adults = result['adultCount'] ?? 1; // default 1
        final int children = result['childCount'] ?? 0;
        final int infants = result['infantCount'] ?? 0;
        final String travelClass = result['travelClass'] ?? 'Economy';

        // Update your state variables as needed
        // For example, if you have _passengers as total adults+children+infants:
        _passengers = adults + children + infants;

        // Store or use them separately if desired:
        // _adultCount = adults;
        // _childCount = children;
        // _infantCount = infants;
        _travelClass = travelClass;

        // (Make sure these variables are declared in your State class)
      });
    }
  }

  void _toggleTripType(bool isRoundTrip) {
    setState(() {
      _isRoundTrip = isRoundTrip;
      // if (isRoundTrip) {
      //   final departureDateTime = _parseDate(_departureDate);
      //   final returnDateTime = _parseDate(_returnDate);
      //   if (departureDateTime != null &&
      //       (returnDateTime == null ||
      //           returnDateTime.isBefore(departureDateTime) ||
      //           returnDateTime.isAtSameMomentAs(departureDateTime))) {
      //     _returnDate = _formatDate(
      //       departureDateTime.add(const Duration(days: 1)),
      //     );
      //   }
      // }
    });
  }

  void _exchangeLocations() {
    setState(() {
      debugPrint('clicked');

      // Swap city names
      final tempCity = _fromCityName;
      _fromCityName = _toCityName;
      _toCityName = tempCity;

      // Swap airport codes
      final tempCode = _fromCityCode;
      _fromCityCode = _toCityCode;
      _toCityCode = tempCode;

      // Swap airport names
      final tempAirportName = _fromAirportName;
      _fromAirportName = _toAirportName;
      _toAirportName = tempAirportName;
    });
  }

  void _searchFlights({String? destinationOverride}) {
    final searchParams = {
      'from': _fromCityName,
      'to': destinationOverride ?? _toCityName,
      'departureDate': _departureDate,
      'returnDate': _isRoundTrip ? _returnDate : null,
      'passengers': _passengers,
      'travelClass': _travelClass,
      'isRoundTrip': _isRoundTrip,
    };

    if (widget.onSearchComplete != null) {
      widget.onSearchComplete!(searchParams);
      if (widget.isBottomSheetMode) Navigator.pop(context);
      return;
    }

    LoadingOverlay.show<void>(
      context: context,
      infoToShow: searchParams,
      operation: () async {
        await Future.delayed(const Duration(seconds: 3));
      },
      onSuccess: (context, _) {
        context.push(
          AppRoutes.flightResults,
          extra: {'searchParams': searchParams},
        );
      },

      // onSuccess: (context, _) {
      //   context.push(
      //    AppRoutes.flightResultsReturn
      //   );
      // },
      onError: (context, error) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Unexpected error: $error')));
      },
    );
  }

  // Public method to handle external search with destination override
  void searchWithDestination(String destination) {
    _searchFlights(destinationOverride: destination);
  }
}
