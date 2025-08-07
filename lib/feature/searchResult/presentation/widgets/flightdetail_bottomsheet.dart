import 'package:flutter/material.dart';

class FlightSegment {
  final String airline;
  final String flightNumber;
  final String departureTime;
  final String arrivalTime;
  final String departureDate;
  final String arrivalDate;
  final String departureCity;
  final String arrivalCity;
  final String departureAirport;
  final String arrivalAirport;
  final String departureTerminal;
  final String arrivalTerminal;
  final String duration;
  final Color airlineLogo;
  final String classType;

  const FlightSegment({
    required this.airline,
    required this.flightNumber,
    required this.departureTime,
    required this.arrivalTime,
    required this.departureDate,
    required this.arrivalDate,
    required this.departureCity,
    required this.arrivalCity,
    required this.departureAirport,
    required this.arrivalAirport,
    required this.departureTerminal,
    required this.arrivalTerminal,
    required this.duration,
    required this.airlineLogo,
    required this.classType,
  });
}

class LayoverInfo {
  final String duration;
  final String city;
  final String airport;

  const LayoverInfo({
    required this.duration,
    required this.city,
    required this.airport,
  });
}

class FlightDetailsBottomSheet extends StatelessWidget {
  final List<FlightSegment> flightSegments;
  final List<LayoverInfo> layovers; // Will have (segments.length - 1) items
  final String totalDuration;
  final String price;
  final String cabinBaggage;
  final String checkedBaggage;

  const FlightDetailsBottomSheet({
    Key? key,
    required this.flightSegments,
    required this.layovers,
    required this.totalDuration,
    required this.price,
    required this.cabinBaggage,
    required this.checkedBaggage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height:
          MediaQuery.of(context).size.height *
          0.75, // Increased height for multiple segments
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            margin: EdgeInsets.only(top: 8),
            width: 60,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[400],
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header with close button
          Padding(
            padding: EdgeInsets.all(12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Review Flight Details',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: EdgeInsets.all(4),
                    child: Icon(Icons.close, color: Colors.red, size: 20),
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Route header
                  _buildRouteHeader(),

                  SizedBox(height: 8),

                  // Multiple flight segments with layovers
                  ..._buildFlightSegments(),

                  // SizedBox(height: 8),

                  // // Total journey info
                  // _buildTotalJourneyInfo(),
                  SizedBox(height: 100), // Extra space for bottom button
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRouteHeader() {
    final firstSegment = flightSegments.first;
    final lastSegment = flightSegments.last;
    final stopCount = layovers.length;

    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color.fromARGB(206, 231, 239, 255),
      ),
      child: Row(
        children: [
          Icon(Icons.flight_takeoff, color: Colors.grey[600], size: 16),
          SizedBox(width: 8),
          Text(
            stopCount == 0
                ? 'Non-Stop'
                : '$stopCount Stop${stopCount > 1 ? 's' : ''}',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          Spacer(),
          Text(
            '${_getCityCode(firstSegment.departureCity)}',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(width: 8),
          Icon(Icons.flight_takeoff, color: Colors.grey[400], size: 12),
          SizedBox(width: 8),
          Text(
            '${_getCityCode(lastSegment.arrivalCity)}',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildFlightSegments() {
    List<Widget> segments = [];

    for (int i = 0; i < flightSegments.length; i++) {
      // Add flight segment
      segments.add(_buildFlightSegmentCard(flightSegments[i], i + 1));

      // Add layover if not the last segment
      if (i < layovers.length) {
        segments.add(SizedBox(height: 8));
        segments.add(_buildLayoverCard(layovers[i]));
      }

      if (i < flightSegments.length - 1) {
        segments.add(SizedBox(height: 8));
      }
    }

    return segments;
  }

  Widget _buildFlightSegmentCard(FlightSegment segment, int segmentNumber) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8),
      padding: EdgeInsets.all(8),
    
      child: Column(
        children: [
          // Segment number and airline info
          Row(
            children: [
              // Container(
              //   padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              //   decoration: BoxDecoration(
              //     color: Colors.grey[100],
              //     borderRadius: BorderRadius.circular(12),
              //   ),
              //   child: Text(
              //     'Segment $segmentNumber',
              //     style: TextStyle(
              //       fontSize: 9,
              //       fontWeight: FontWeight.bold,
              //       color: Colors.grey[600],
              //     ),
              //   ),
              // ),
              // SizedBox(width: 8),
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: segment.airlineLogo,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    _getAirlineCode(segment.airline),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  '${segment.airline} | ${segment.flightNumber} | ${segment.classType}',
                  style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),

          SizedBox(height: 16),

          // Flight timeline
          Row(
            children: [
              // Departure
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      segment.departureTime,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800],
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      segment.departureDate,
                      style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                    ),
                    SizedBox(height: 4),
                    Text(
                      segment.departureCity,
                      style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      segment.departureAirport,
                      style: TextStyle(fontSize: 9, color: Colors.grey[500]),
                    ),
                    Text(
                      'Terminal ${segment.departureTerminal}',
                      style: TextStyle(fontSize: 9, color: Colors.grey[500]),
                    ),
                  ],
                ),
              ),

              // Flight path
              Expanded(
                flex: 2,
                child: Column(
                  children: [
                    Text(
                      segment.duration,
                      style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                    ),
                    SizedBox(height: 4),
                    Row(
                      children: [
                        Expanded(
                          child: Container(height: 1, color: Colors.grey[300]),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 4),
                          child: Icon(
                            Icons.flight_takeoff,
                            size: 12,
                            color: Colors.grey[400],
                          ),
                        ),
                        Expanded(
                          child: Container(height: 1, color: Colors.grey[300]),
                        ),
                      ],
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Non Stop',
                      style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),

              // Arrival
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      segment.arrivalTime,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800],
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      segment.arrivalDate,
                      style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                      textAlign: TextAlign.end,
                    ),
                    SizedBox(height: 4),
                    Text(
                      segment.arrivalCity,
                      style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                      textAlign: TextAlign.end,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      segment.arrivalAirport,
                      style: TextStyle(fontSize: 9, color: Colors.grey[500]),
                      textAlign: TextAlign.end,
                    ),
                    Text(
                      'Terminal ${segment.arrivalTerminal}',
                      style: TextStyle(fontSize: 9, color: Colors.grey[500]),
                      textAlign: TextAlign.end,
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 8),

          // Baggage information
          _buildBaggageInfo(),
        ],
      ),
    );
  }

  Widget _buildLayoverCard(LayoverInfo layover) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.orange[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.orange[200]!),
      ),
      child: Row(
        children: [
          Icon(Icons.schedule, color: Colors.orange[600], size: 16),
          SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Layover • ${layover.duration}',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange[700],
                  ),
                ),
                Text(
                  '${layover.city} (${layover.airport})',
                  style: TextStyle(fontSize: 10, color: Colors.orange[600]),
                ),
              ],
            ),
          ),
          Icon(Icons.info_outline, color: Colors.orange[400], size: 14),
        ],
      ),
    );
  }

  Widget _buildTotalJourneyInfo() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue[200]!),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            children: [
              Icon(Icons.schedule, color: Colors.blue[600], size: 16),
              SizedBox(height: 4),
              Text(
                'Total Duration',
                style: TextStyle(fontSize: 9, color: Colors.blue[600]),
              ),
              Text(
                totalDuration,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[800],
                ),
              ),
            ],
          ),
          Container(height: 30, width: 1, color: Colors.blue[200]),
          Column(
            children: [
              Icon(
                Icons.connecting_airports,
                color: Colors.blue[600],
                size: 16,
              ),
              SizedBox(height: 4),
              Text(
                'Stops',
                style: TextStyle(fontSize: 9, color: Colors.blue[600]),
              ),
              Text(
                '${layovers.length}',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[800],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBaggageInfo() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: [
          // Cabin baggage
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
              child: Column(
                children: [
                  Icon(Icons.luggage, color: Colors.grey[600], size: 16),
                  SizedBox(height: 4),
                  Text(
                    cabinBaggage,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),

          // Checked baggage
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
              child: Column(
                children: [
                  Icon(Icons.work, color: Colors.grey[600], size: 16),
                  SizedBox(height: 4),
                  Text(
                    checkedBaggage,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),

          // Fare rules
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
              margin: EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                color: const Color.fromARGB(206, 231, 239, 255),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Column(
                children: [
                  Icon(Icons.description, color: Colors.grey[600], size: 16),
                  SizedBox(height: 4),
                  Text(
                    'Fare Rules',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getCityCode(String city) {
    return city.length >= 3
        ? city.substring(0, 3).toUpperCase()
        : city.toUpperCase();
  }

  String _getAirlineCode(String airline) {
    return airline.length >= 2
        ? airline.substring(0, 2).toUpperCase()
        : airline.toUpperCase();
  }
}

// Bottom section with price and continue button
class BottomPriceSection extends StatelessWidget {
  final String price;
  final VoidCallback onContinue;

  const BottomPriceSection({
    Key? key,
    required this.price,
    required this.onContinue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  price,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
                Text(
                  'For 1 Adult',
                  style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                ),
              ],
            ),
            Spacer(),
            ElevatedButton(
              onPressed: onContinue,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Continue',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Function to show the bottom sheet
void showFlightDetailsBottomSheet(
  BuildContext context, {
  required List<FlightSegment> flightSegments,
  required List<LayoverInfo> layovers,
  required String totalDuration,
  required String price,
  required String cabinBaggage,
  required String checkedBaggage,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => Stack(
      children: [
        FlightDetailsBottomSheet(
          flightSegments: flightSegments,
          layovers: layovers,
          totalDuration: totalDuration,
          price: price,
          cabinBaggage: cabinBaggage,
          checkedBaggage: checkedBaggage,
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: BottomPriceSection(
            price: price,
            onContinue: () {
              Navigator.pop(context);
              // Handle continue action
            },
          ),
        ),
      ],
    ),
  );
}
