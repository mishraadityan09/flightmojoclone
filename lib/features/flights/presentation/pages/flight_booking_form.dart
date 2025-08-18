import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'dart:async'; // Added for Timer

class FlightBookingForm extends StatefulWidget {
  const FlightBookingForm({super.key});

  @override
  _FlightBookingFormState createState() => _FlightBookingFormState();
}

class _FlightBookingFormState extends State<FlightBookingForm>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final int _selectedDepartureFlight = 0;
  final int _selectedReturnFlight = 0;
  int selectedDateIndex = 0;
  int selectedFareIndex = 0;

  // Session timer variables
  Timer? _sessionTimer;
  int _sessionTimeRemaining = 900; // 15 minutes in seconds
  bool _isSessionExpired = false;

  // Mock data for flights
  final List<Map<String, dynamic>> departureFlights = [
    {
      'airline': 'Air India Limited',
      'flightNumber': 'AI-2422',
      'departureTime': '1:50 AM',
      'arrivalTime': '4:10 AM',
      'duration': '2h:20m',
      'price': '₹5,371',
      'stops': 'Non-Stop',
      'departureAirport': 'BOM',
      'arrivalAirport': 'DEL',
      'departureDate': '2025-08-23',
      'arrivalDate': '2025-08-23',
      'discount': 'Extra ₹ 250 off on total amount',
      'color': Colors.red[800]!,
    },
    {
      'airline': 'Air India Limited',
      'flightNumber': 'AI-2954',
      'departureTime': '2:35 AM',
      'arrivalTime': '5:00 AM',
      'duration': '2h:25m',
      'price': '₹5,478',
      'stops': 'Non-Stop',
      'departureAirport': 'BOM',
      'arrivalAirport': 'DEL',
      'departureDate': '2025-08-23',
      'arrivalDate': '2025-08-23',
      'discount': 'Extra ₹ 250 off on total amount',
      'color': Colors.red[800]!,
    },
  ];

  final List<Map<String, dynamic>> returnFlights = [
    {
      'airline': 'IndiGo',
      'flightNumber': '6E-5678',
      'departureTime': '18:30',
      'arrivalTime': '20:45',
      'duration': '2h 15m',
      'price': '₹4,200',
      'stops': 'Non-stop',
      'departureAirport': 'DEL',
      'arrivalAirport': 'BOM',
      'color': Colors.blue[800]!,
    },
    {
      'airline': 'Air India',
      'flightNumber': 'AI-1234',
      'departureTime': '21:15',
      'arrivalTime': '23:30',
      'duration': '2h 15m',
      'price': '₹4,900',
      'stops': 'Non-stop',
      'departureAirport': 'DEL',
      'arrivalAirport': 'BOM',
      'color': Colors.red[800]!,
    },
  ];

  final List<Map<String, dynamic>> priceGraphData = [
    {'date': '07 Aug', 'price': '₹ 4,799'},
    {'date': '08 Aug', 'price': '₹ 4,870'},
    {'date': '09 Aug', 'price': '₹ 4,986'},
    {'date': '10 Aug', 'price': '₹ 5,267'},
    {'date': '11 Aug', 'price': '₹ 5,100'},
    {'date': '12 Aug', 'price': '₹ 4,950'},
    {'date': '13 Aug', 'price': '₹ 5,350'},
  ];

  final List<Map<String, dynamic>> fareData = [
    {'airline': 'Indigo', 'price': '₹ 4,799'},
    {'airline': 'Air India', 'price': '₹ 4,870'},
    {'airline': 'SpiceJet', 'price': '₹ 4,986'},
    {'airline': 'Akasha Air', 'price': '₹ 5,267'},
    {'airline': 'Vistara', 'price': '₹ 5,100'},
    {'airline': 'GoAir', 'price': '₹ 4,950'},
    {'airline': 'Alliance', 'price': '₹ 5,350'},
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _startSessionTimer();
  }

  @override
  void dispose() {
    _sessionTimer?.cancel();
    _tabController.dispose();
    super.dispose();
  }

  void _startSessionTimer() {
    _sessionTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_sessionTimeRemaining > 0) {
        setState(() {
          _sessionTimeRemaining--;
        });
      } else {
        setState(() {
          _isSessionExpired = true;
        });
        _sessionTimer?.cancel();
        _showSessionExpiredDialog();
      }
    });
  }

  void _showSessionExpiredDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Session Expired'),
          content: Text(
            'Your session has expired. Please start your search again.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                // Navigator.of(context).pop();
                // Navigator.of(context).pop(); // Go back to search page
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  String _formatTime(int seconds) {
    int hours = seconds ~/ 3600;
    int minutes = (seconds % 3600) ~/ 60;
    int secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  void _extendSession() {
    setState(() {
      _sessionTimeRemaining = 900; // Reset to 15 minutes
      _isSessionExpired = false;
    });
    _startSessionTimer();
  }

  void _showFlightDetails() {
  showModalBottomSheet(
    context: context,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    isScrollControlled: true,
    builder: (BuildContext context) {
      return Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 16,
          right: 16,
          top: 24,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: Colors.grey[350],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              // Departure Flights (if array)
              if (departureFlights.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Departure Flights',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[800],
                      ),
                    ),
                    ...departureFlights.map((flight) => Container(
                      width: double.infinity,
                      margin: EdgeInsets.only(top: 8, bottom: 8),
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.blue[50],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.blue!),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${flight['departureAirport']} → ${flight['arrivalAirport']}',
                          ),
                          Text(
                            '${flight['date'] ?? 'Date'} | ${flight['departureTime']} - ${flight['arrivalTime']}',
                          ),
                          Text(
                            '${flight['stops']} | ${flight['duration']}',
                          ),
                          Text(
                            '${flight['airline']} | ${flight['flightNumber']}',
                          ),
                        ],
                      ),
                    ))
                  ],
                ),
              SizedBox(height: 16),
              // Return Flights (if array)
              if (returnFlights.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Return Flights',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange[800],
                      ),
                    ),
                    ...returnFlights.map((flight) => Container(
                      width: double.infinity,
                      margin: EdgeInsets.only(top: 8, bottom: 8),
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.orange[50],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.orange!),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${flight['departureAirport']} → ${flight['arrivalAirport']}',
                          ),
                          Text(
                            '${flight['date'] ?? 'Date'} | ${flight['departureTime']} - ${flight['arrivalTime']}',
                          ),
                          Text(
                            '${flight['stops']} | ${flight['duration']}',
                          ),
                          Text(
                            '${flight['airline']} | ${flight['flightNumber']}',
                          ),
                        ],
                      ),
                    ))
                  ],
                ),
              SizedBox(height: 24),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('Close'),
                ),
              ),
              SizedBox(height: 12),
            ],
          ),
        ),
      );
    },
  );
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Column(
        children: [
          // Fixed Header (Session Timer + Flight Summary)
          Container(
            padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
            child: Column(
              children: [
                // Session Timer
                Container(
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "Session will expire in ",
                          style: TextStyle(
                            color: const Color.fromARGB(255, 34, 34, 34),
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        TextSpan(
                          text: _formatTime(_sessionTimeRemaining),
                          style: TextStyle(
                            color: _sessionTimeRemaining <= 300
                                ? Colors.red
                                : _sessionTimeRemaining <= 600
                                ? Theme.of(context).colorScheme.primary
                                : const Color.fromARGB(255, 242, 136, 30),
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Flight Summary Header
                Container(
                  color: Colors.grey[800],
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 12,
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.arrow_back, color: Colors.white),
                          onPressed: () {},
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'DEL - BOM - DEL • 1 Traveler',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                '15 Aug - 22 Aug • Economy',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Scrollable Middle Content
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Combined Flight Card (Departure + Return)
                  Stack(
                    children: [
                      Container(
                        margin: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 24,
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[800],
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.3),
                                blurRadius: 8,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          padding: EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Departure Flight Section
                              Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: [
                                          Colors.red[600]!,
                                          Colors.orange[600]!,
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Icon(
                                      Icons.flight_takeoff,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  ),
                                  SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Departure',
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.white70,
                                          ),
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          '${departureFlights.isNotEmpty ? departureFlights[0]['departureAirport'] : 'DEL'}-${departureFlights.isNotEmpty ? departureFlights[0]['arrivalAirport'] : 'BOM'} | Economy',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          'Fri, 15 Aug | ${departureFlights.isNotEmpty ? departureFlights[0]['departureTime'] : '19:45'} - ${departureFlights.isNotEmpty ? departureFlights[0]['arrivalTime'] : '21:55'} | ${departureFlights.isNotEmpty ? departureFlights[0]['stops'] : 'Non-Stop'} | ${departureFlights.isNotEmpty ? departureFlights[0]['duration'] : '2hr 10m'}',
                                          style: TextStyle(
                                            color: Colors.white.withOpacity(
                                              0.9,
                                            ),
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                  
                              // Dashed line separator
                              Container(
                                margin: EdgeInsets.symmetric(vertical: 16),
                                child: Row(
                                  children: List.generate(
                                    30,
                                    (index) => Expanded(
                                      child: Container(
                                        height: 1,
                                        margin: EdgeInsets.symmetric(
                                          horizontal: 1,
                                        ),
                                        color: Colors.white.withOpacity(0.3),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                  
                              // Return Flight Section
                              Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: [
                                          Colors.red[600]!,
                                          Colors.orange[600]!,
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Icon(
                                      Icons.flight_land,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  ),
                                  SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Return',
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.white70,
                                          ),
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          '${returnFlights.isNotEmpty ? returnFlights[0]['departureAirport'] : 'BOM'}-${returnFlights.isNotEmpty ? returnFlights[0]['arrivalAirport'] : 'DEL'} | Economy',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          'Fri, 22 Aug | ${returnFlights.isNotEmpty ? returnFlights[0]['departureTime'] : '00:50'} - ${returnFlights.isNotEmpty ? returnFlights[0]['arrivalTime'] : '03:00'} | ${returnFlights.isNotEmpty ? returnFlights[0]['stops'] : 'Non-Stop'} | ${returnFlights.isNotEmpty ? returnFlights[0]['duration'] : '2hr 10m'}',
                                          style: TextStyle(
                                            color: Colors.white.withOpacity(
                                              0.9,
                                            ),
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              
                              // Add bottom padding to prevent text overlap with button
                              SizedBox(height: 20),
                            ],
                          ),
                        ),
                      ),
                  
                      // View Flight Details Button - positioned on the border
                      Positioned(
                        bottom: -5,
                        left: 0,
                        right: 0,
                        child: Container(
                          margin: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          child: FractionallySizedBox(
                            widthFactor: 0.5, // 50% width
                            alignment: Alignment.center, // keep it centered
                            child: ElevatedButton(
                              onPressed: _showFlightDetails,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: Colors.grey[800],
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                padding: EdgeInsets.symmetric(vertical: 12),
                                elevation: 2,
                                side: BorderSide(color: Colors.grey[300]!),
                              ),
                              child: Text(
                                'View Flight Details',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  // SizedBox(height: 20),

                  // Baggage Information
                  Container(
                    margin: EdgeInsets.all(16),
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Baggage',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[800],
                          ),
                        ),
                        SizedBox(height: 12),
                        Row(
                          children: [
                            Icon(
                              Icons.flight_takeoff,
                              color: Colors.grey[600],
                              size: 20,
                            ),
                            SizedBox(width: 12),
                            Text(
                              'Cabin bag 7 Kgs',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[700],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(Icons.work, color: Colors.grey[600], size: 20),
                            SizedBox(width: 12),
                            Text(
                              'Check-in-bag 15 Kgs',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[700],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Contact Details
                  Container(
                    margin: EdgeInsets.all(16),
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Contact Information',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[800],
                          ),
                        ),
                        SizedBox(height: 16),

                        // Mobile Number Input
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey[300]!),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text('🇮🇳', style: TextStyle(fontSize: 16)),
                                  SizedBox(width: 4),
                                  Text(
                                    '+91',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.grey[700],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              child: TextField(
                                decoration: InputDecoration(
                                  hintText: 'Enter your mobile number*',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(
                                      color: Colors.grey[300]!,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(
                                      color: Colors.grey[300]!,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.primary,
                                    ),
                                  ),
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 12,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16),

                        // WhatsApp Checkbox
                        Row(
                          children: [
                            Checkbox(
                              value: true,
                              onChanged: (value) {},
                              activeColor: Colors.green,
                            ),
                            SizedBox(width: 8),
                            Icon(Icons.message, color: Colors.green, size: 20),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Get booking details & updates on WhatsApp',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[700],
                                ),
                              ),
                            ),
                          ],
                        ),

                        // GST Checkbox
                        Row(
                          children: [
                            Checkbox(
                              value: false,
                              onChanged: (value) {},
                              activeColor: Theme.of(
                                context,
                              ).colorScheme.primary,
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'I have a GST number (optional)',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[700],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Traveler(s) Details
                  Container(
                    margin: EdgeInsets.all(16),
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Traveler(s) Details',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[800],
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Enter name as mentioned on your passport or government approved ID\'s',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                        SizedBox(height: 16),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Adults',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey[700],
                              ),
                            ),
                            ElevatedButton.icon(
                              onPressed: () {},
                              icon: Icon(
                                Icons.add,
                                color: Colors.white,
                                size: 16,
                              ),
                              label: Text(
                                'Fill Details',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red[600],
                                padding: EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Emergency Benefits Section
                  Container(
                    margin: EdgeInsets.all(16),
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Emergency Benefits',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[800],
                          ),
                        ),
                        SizedBox(height: 16),

                        // Benefits Cards
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.blue[50],
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: Colors.blue[200]!),
                                ),
                                child: Column(
                                  children: [
                                    Icon(
                                      Icons.access_time,
                                      color: Colors.blue[600],
                                      size: 24,
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      'Last-minute\nEmergency',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: Colors.blue[700],
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.amber[50],
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: Colors.amber[200]!),
                                ),
                                child: Column(
                                  children: [
                                    Icon(
                                      Icons.person,
                                      color: Colors.amber[600],
                                      size: 24,
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      'Personal\nEmergency',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: Colors.amber[700],
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.blue[50],
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: Colors.blue[200]!),
                                ),
                                child: Column(
                                  children: [
                                    Icon(
                                      Icons.home,
                                      color: Colors.blue[600],
                                      size: 24,
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      'Home\nEmergency',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: Colors.blue[700],
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 12),

                        Center(
                          child: Text(
                            'View All Benefits',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.blue[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Fixed Bottom Summary Bar
          _buildBottomSummaryBar(),
        ],
      ),
    );
  }

  String _dateLabel({String? isoDate}) {
    if (isoDate != null && isoDate.isNotEmpty) {
      return _formatDate(isoDate);
    }
    // fallback to selected date from priceGraphData if available
    try {
      return priceGraphData[selectedDateIndex]['date'] as String;
    } catch (_) {
      return '';
    }
  }

  String _formatDate(String isoDate) {
    // Expects date in 'yyyy-MM-dd', returns '12 Aug' style
    try {
      final d = DateTime.parse(isoDate);
      final months = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec',
      ];
      return '${d.day} ${months[d.month - 1]}';
    } catch (_) {
      return isoDate;
    }
  }

  Widget _buildBottomSummaryBar() {
    // Add null safety checks
    if (departureFlights.isEmpty || returnFlights.isEmpty) {
      return Container(
        color: Colors.grey[800],
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Center(
          child: Text(
            'No flights available',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
      );
    }

    // Ensure indices are within bounds
    final departureIndex = _selectedDepartureFlight < departureFlights.length
        ? _selectedDepartureFlight
        : 0;
    final returnIndex = _selectedReturnFlight < returnFlights.length
        ? _selectedReturnFlight
        : 0;

    final departureFlight = departureFlights[departureIndex];
    final returnFlight = returnFlights[returnIndex];

    final departurePrice = int.parse(
      departureFlight['price'].replaceAll('₹', '').replaceAll(',', ''),
    );
    final returnPrice = int.parse(
      returnFlight['price'].replaceAll('₹', '').replaceAll(',', ''),
    );
    final totalPrice = departurePrice + returnPrice;

    return Container(
      color: Colors.grey[800],
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Departure Price
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Builder(
                  builder: (_) {
                    final dep = departureFlights.isNotEmpty
                        ? departureFlights[departureIndex]
                        : null;
                    final depPath = dep != null
                        ? '${dep['departureAirport'] ?? ''} - ${dep['arrivalAirport'] ?? ''}'
                        : '';
                    final depDate = _dateLabel(
                      isoDate: dep != null
                          ? dep['departureDate'] as String?
                          : null,
                    );
                    return Text(
                      depPath.isNotEmpty || depDate.isNotEmpty ? depPath : '',
                      style: TextStyle(fontSize: 12, color: Colors.white),
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    );
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.flight_takeoff, color: Colors.white, size: 16),
                    SizedBox(width: 4),
                    Text(
                      'Departure',
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ],
                ),

                Text(
                  'From ${departureFlight['price']}',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          // Return Price
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Builder(
                  builder: (_) {
                    final ret = returnFlights.isNotEmpty
                        ? returnFlights[returnIndex]
                        : null;
                    final retPath = ret != null
                        ? '${ret['departureAirport'] ?? ''} - ${ret['arrivalAirport'] ?? ''}'
                        : '';
                    final retDate = _dateLabel(
                      isoDate: ret != null
                          ? ret['departureDate'] as String?
                          : null,
                    );
                    return Text(
                      retPath.isNotEmpty || retDate.isNotEmpty ? retPath : '',
                      style: TextStyle(fontSize: 12, color: Colors.white),
                      overflow: TextOverflow.ellipsis,
                    );
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.flight_land, color: Colors.white, size: 16),
                    SizedBox(width: 4),
                    Text(
                      'Return',
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ],
                ),
                Text(
                  'From ${returnFlight['price']}',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          // Total and Book Button
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Total',
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                    SizedBox(width: 8),
                    Text(
                      '₹${totalPrice.toStringAsFixed(0)}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4),
                ElevatedButton(
                  onPressed: () {
                    // Navigate to booking
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Proceeding to booking...'),
                        backgroundColor: Theme.of(context).colorScheme.primary,
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  child: Text(
                    'BOOK NOW',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
