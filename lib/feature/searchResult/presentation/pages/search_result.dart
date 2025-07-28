import 'package:flutter/material.dart';

class FlightSearchResultsScreen extends StatelessWidget {
  final String fromCity;
  final String toCity;
  final String date;
  final String passengers;

  const FlightSearchResultsScreen({
    super.key,
    this.fromCity = "New Delhi",
    this.toCity = "Mumbai",
    this.date = "15 Jul",
    this.passengers = "1 Adult",
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.grey[800],
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$fromCity to $toCity',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            Text(
              '$date | $passengers',
              style: TextStyle(color: Colors.white70, fontSize: 12),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.tune, color: Colors.white),
            onPressed: () {
              // Add filter functionality
            },
          ),
          IconButton(
            icon: Icon(Icons.edit, color: Colors.white),
            onPressed: () {
              // Add edit search functionality
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Top airline options bar
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildAirlineOption('IndiGo', '₹ 4799', Colors.blue[800]!),
                _buildAirlineOption('Air India', '₹ 4870', Colors.red[800]!),
                _buildAirlineOption('SpiceJet', '₹ 4986', Colors.orange[800]!),
                _buildAirlineOption('Air India E...', '₹ 5267', Colors.orange[600]!),
              ],
            ),
          ),
          
          // Flight results list
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(16),
              children: [
                _buildFlightCard(
                  airline: 'IndiGo',
                  flightNumber: '6E-2766',
                  departureTime: '04:00',
                  arrivalTime: '06:15',
                  duration: '2h 15m',
                  price: '₹ 4799',
                  airlineLogo: Colors.blue[800]!,
                  onTap: () {
                    // Handle flight selection
                    _handleFlightSelection(context, '6E-2766');
                  },
                ),
                SizedBox(height: 12),
                _buildFlightCard(
                  airline: 'IndiGo',
                  flightNumber: '6E-519',
                  departureTime: '23:30',
                  arrivalTime: '01:45',
                  duration: '2h 15m',
                  price: '₹ 4799',
                  airlineLogo: Colors.blue[800]!,
                  onTap: () {
                    _handleFlightSelection(context, '6E-519');
                  },
                ),
                SizedBox(height: 12),
                _buildFlightCard(
                  airline: 'IndiGo',
                  flightNumber: '6E-853',
                  departureTime: '01:55',
                  arrivalTime: '04:15',
                  duration: '2h 20m',
                  price: '₹ 4799',
                  airlineLogo: Colors.blue[800]!,
                  onTap: () {
                    _handleFlightSelection(context, '6E-853');
                  },
                ),
                SizedBox(height: 12),
                _buildFlightCard(
                  airline: 'Air India',
                  flightNumber: 'AI-2421',
                  departureTime: '02:15',
                  arrivalTime: '04:40',
                  duration: '2h 25m',
                  price: '₹ 4870',
                  airlineLogo: Colors.red[800]!,
                  onTap: () {
                    _handleFlightSelection(context, 'AI-2421');
                  },
                ),
                SizedBox(height: 12),
                _buildFlightCard(
                  airline: 'IndiGo',
                  flightNumber: '6E-449',
                  departureTime: '05:00',
                  arrivalTime: '07:20',
                  duration: '2h 20m',
                  price: '₹ 4950',
                  airlineLogo: Colors.blue[800]!,
                  onTap: () {
                    _handleFlightSelection(context, '6E-449');
                  },
                ),
                  SizedBox(height: 12),
                _buildFlightCard(
                  airline: 'IndiGo',
                  flightNumber: '6E-449',
                  departureTime: '05:00',
                  arrivalTime: '07:20',
                  duration: '2h 20m',
                  price: '₹ 4950',
                  airlineLogo: Colors.blue[800]!,
                  onTap: () {
                    _handleFlightSelection(context, '6E-449');
                  },
                ),
                  SizedBox(height: 12),
                _buildFlightCard(
                  airline: 'IndiGo',
                  flightNumber: '6E-449',
                  departureTime: '05:00',
                  arrivalTime: '07:20',
                  duration: '2h 20m',
                  price: '₹ 4950',
                  airlineLogo: Colors.blue[800]!,
                  onTap: () {
                    _handleFlightSelection(context, '6E-449');
                  },
                ),
                  SizedBox(height: 12),
                _buildFlightCard(
                  airline: 'IndiGo',
                  flightNumber: '6E-449',
                  departureTime: '05:00',
                  arrivalTime: '07:20',
                  duration: '2h 20m',
                  price: '₹ 4950',
                  airlineLogo: Colors.blue[800]!,
                  onTap: () {
                    _handleFlightSelection(context, '6E-449');
                  },
                ),
                  SizedBox(height: 12),
                _buildFlightCard(
                  airline: 'IndiGo',
                  flightNumber: '6E-449',
                  departureTime: '05:00',
                  arrivalTime: '07:20',
                  duration: '2h 20m',
                  price: '₹ 4950',
                  airlineLogo: Colors.blue[800]!,
                  onTap: () {
                    _handleFlightSelection(context, '6E-449');
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAirlineOption(String airline, String price, Color color) {
    return GestureDetector(
      onTap: () {
        // Handle airline filter
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                airline.substring(0, 2).toUpperCase(),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          SizedBox(height: 2),
          Text(
            airline,
            style: TextStyle(fontSize: 9, color: Colors.grey[600]),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
          Text(
            price,
            style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold),
            maxLines: 1,
          ),
        ],
      ),
    );
  }

  Widget _buildFlightCard({
    required String airline,
    required String flightNumber,
    required String departureTime,
    required String arrivalTime,
    required String duration,
    required String price,
    required Color airlineLogo,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          Container(
            padding: EdgeInsets.all(16),
            margin: EdgeInsets.only(top: 8), // Add margin to accommodate the badge
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
            child: Row(
              children: [
                // Airline logo
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: airlineLogo,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      airline.substring(0, 2).toUpperCase(),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12),
                
                // Flight details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            departureTime,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[800],
                            ),
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: Container(
                              height: 1,
                              color: Colors.grey[300],
                              margin: EdgeInsets.symmetric(horizontal: 8),
                            ),
                          ),
                          Icon(
                            Icons.flight_takeoff,
                            size: 16,
                            color: Colors.grey[400],
                          ),
                          Expanded(
                            child: Container(
                              height: 1,
                              color: Colors.grey[300],
                              margin: EdgeInsets.symmetric(horizontal: 8),
                            ),
                          ),
                          SizedBox(width: 8),
                          Text(
                            arrivalTime,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[800],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 4),
                      Row(
                        children: [
                          Text(
                            airline,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                          SizedBox(width: 16),
                          Text(
                            duration,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                          SizedBox(width: 4),
                          Text(
                            '| Non Stop',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 4),
                      Text(
                        flightNumber,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Price
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    SizedBox(height: 20), // Space for the badge
                    Text(
                      price,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Saver Fare badge positioned at top-right border
          Positioned(
            top: 0,
            right: 16,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.green[100],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.green[300]!),
              ),
              child: Text(
                'Saver Fare',
                style: TextStyle(
                  color: Colors.green[700],
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _handleFlightSelection(BuildContext context, String flightNumber) {
    // Handle flight selection - you can navigate to booking page or show details
    print('Selected flight: $flightNumber');
    // Example: Navigate to booking page
    // Navigator.push(context, MaterialPageRoute(builder: (context) => BookingPage()));
  }
}