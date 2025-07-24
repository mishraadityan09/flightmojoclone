import 'package:flightmojo/core/theme/app_theme.dart';
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
  // State variables to hold selected values
  String _fromCity = 'Delhi';
  String _toCity = 'Mumbai';
  String _departureDate = 'Today';
  String _returnDate = 'Tomorrow';
  int _passengers = 1;
  bool _isRoundTrip = false;

  // Move destinations to class level to avoid recreating in build
  final List<Map<String, String>> destinations = [
    {'name': 'Mumbai', 'price': '₹4,500', 'image': 'mumbai'},
    {'name': 'Bangalore', 'price': '₹5,200', 'image': 'bangalore'},
    {'name': 'Chennai', 'price': '₹4,800', 'image': 'chennai'},
    {'name': 'Kolkata', 'price': '₹3,900', 'image': 'kolkata'},
  ];

  // Method to handle location selection
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'FlightsMojo',
          style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
           
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero Section
            Container(
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
                        color: Colors.white.withValues(alpha:0.9),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Search Form
                    Card(
                      elevation: 8,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            // From and To fields
                            Row(
                              children: [
                                Container(
                                  decoration:
                                      AppTheme.gradientContainerDecoration,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
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
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                GestureDetector(
                                  onTap: () => setState(() {
                                    _isRoundTrip=false;
                                  }),
                                  child: Container(
                                    decoration: !_isRoundTrip
                                        ? AppTheme.gradientContainerDecoration
                                        : BoxDecoration(
                                            color: Colors
                                                .white, // or Theme.of(context).cardColor
                                            borderRadius: BorderRadius.circular(
                                              12,
                                              
                                            ),
                                            border: Border.all(color: Colors.grey,width: 1)
                                          ),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    child: Text(
                                      'One Way',
                                      style: GoogleFonts.poppins(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color:  !_isRoundTrip
                                            ? Colors.white
                                            : Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 12),
                                GestureDetector(
                                   onTap: () => setState(() {
                                    _isRoundTrip=true;
                                  }),
                                  child: Container(
                                    decoration: _isRoundTrip
                                        ? AppTheme.gradientContainerDecoration
                                        : BoxDecoration(
                                            color: Colors
                                                .white, // or Theme.of(context).cardColor
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                              border: Border.all(color: Colors.grey,width: 1)
                                          ),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    child: Text(
                                      'Round Trip',
                                      style: GoogleFonts.poppins(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: _isRoundTrip
                                            ? Colors.white
                                            : Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                  child: _buildLocationField(
                                    context,
                                    'From',
                                    _fromCity,
                                    Icons.flight_takeoff,
                                    () => _selectLocation('From'),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: _buildLocationField(
                                    context,
                                    'To',
                                    _toCity,
                                    Icons.flight_land,
                                    () => _selectLocation('To'),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),

                            // Date fields
                            Row(
                              children: [
                                Expanded(
                                  child: _buildDateField(
                                    context,
                                    'Departure',
                                    _departureDate,
                                  ),
                                ),
                                if (_isRoundTrip) const SizedBox(width: 16),
                                if (_isRoundTrip)
                                  Expanded(
                                    child: _buildDateField(
                                      context,
                                      'Return',
                                      _returnDate,
                                    ),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 16),

                            // Passenger field
                            _buildPassengerField(context),
                            const SizedBox(height: 20),

                            // Search button
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {
                                  // Navigate to search results with current state
                                  context.push(
                                    AppRoutes.flightResults,
                                    extra: {
                                      'searchParams': {
                                        'from': _fromCity,
                                        'to': _toCity,
                                        'date': _departureDate,
                                        'passengers': _passengers,
                                      },
                                    },
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                  ),
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
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Popular Destinations Section
            Padding(
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

                  // Grid of popular destinations
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 1.2,
                        ),
                    itemCount: destinations.length,
                    itemBuilder: (context, index) {
                      return _buildDestinationCard(
                        context,
                        destinations[index],
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationField(
    BuildContext context,
    String label,
    String value,
    IconData icon,
    VoidCallback onTap,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 4),
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(8),
            ),
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

  Widget _buildDateField(BuildContext context, String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 4),
        GestureDetector(
          onTap: () async {
            // Handle date selection
            final DateTime? picked = await showDatePicker(
  context: context,
  initialDate: DateTime.now(),
  firstDate: DateTime.now(),
  lastDate: DateTime.now().add(const Duration(days: 365)),
  builder: (context, child) {
    return Theme(
      data: Theme.of(context).copyWith(
        colorScheme: ColorScheme.light(
          primary: Theme.of(context).primaryColor, // header background
          onPrimary: Colors.white, // header text color
          onSurface: Colors.black, // body text color
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: Theme.of(context).primaryColor, // button text
          ),
        ),
      ),
      child: child!,
    );
  },
);

            if (picked != null) {
              setState(() {
                if (label == 'Departure') {
                  _departureDate =
                      "${picked.day}/${picked.month}/${picked.year}";
                } else {
                  _returnDate = "${picked.day}/${picked.month}/${picked.year}";
                }
              });
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(8),
            ),
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

  Widget _buildPassengerField(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Passengers',
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 4),
        GestureDetector(
          onTap: () {
            // Handle passenger selection
            _showPassengerDialog(context);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(8),
            ),
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

  void _showPassengerDialog(BuildContext context) {
    int tempPassengers = _passengers;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text(
                'Select Passengers',
                style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Adults', style: GoogleFonts.poppins()),
                      Row(
                        children: [
                          IconButton(
                            onPressed: tempPassengers > 1
                                ? () {
                                    setDialogState(() {
                                      tempPassengers--;
                                    });
                                    // Navigator.pop(context);
                                  }
                                : null,
                            icon: const Icon(Icons.remove,color: Colors.grey,),
                          ),
                          Text('$tempPassengers', style: GoogleFonts.poppins()),
                          IconButton(
                            onPressed: tempPassengers < 9
                                ? () {
                                    setDialogState(() {
                                      tempPassengers++;
                                    });
                                    // Navigator.pop(context);
                                  }
                                : null,
                            icon: const Icon(Icons.add,color: Colors.grey,),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    setState(() {
                      _passengers = tempPassengers;
                    });
                  },
                  child: Text('Done', style: GoogleFonts.poppins()),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildDestinationCard(
    BuildContext context,
    Map<String, String> destination,
  ) {
    return GestureDetector(
      onTap: () {
        // Navigate to search results for this destination
        context.push(
          AppRoutes.flightResults,
          extra: {
            'searchParams': {
              'from': _fromCity,
              'to': destination['name'],
              'date': _departureDate,
              'passengers': _passengers,
            },
          },
        );
      },
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
                Theme.of(context).primaryColor.withValues(alpha:0.8),
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
                        color: Colors.white.withValues(alpha:0.9),
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
}
