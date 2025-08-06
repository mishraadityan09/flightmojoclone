import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class FlightSearchResultsScreen extends StatelessWidget {
  final String fromCity;
  final String toCity;
  final String departureDate;
  final String returnDate;
  final String passengers;

  const FlightSearchResultsScreen({
    super.key,
    this.fromCity = "New Delhi",
    this.toCity = "Mumbai",
    this.departureDate = "15 Jul",
    this.returnDate = "16 Jul",
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
              '$departureDate - $returnDate | $passengers',
              style: TextStyle(color: Colors.white70, fontSize: 12),
            ),
          ],
        ),
        centerTitle: false,
        actions: [
          IconButton(
            icon: Icon(LucideIcons.funnel, color: Colors.white),
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
      body: CustomScrollView(
        slivers: [
          // Price graph section (will hide on scroll)
          SliverToBoxAdapter(
            child: Container(
              margin: EdgeInsets.all(8),
              child: IntrinsicHeight(
                child: Row(
                  children: [
                    Expanded(
                      flex: 4,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.15),
                              spreadRadius: 1,
                              blurRadius: 6,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: CarouselSlider(
                          options: CarouselOptions(
                            height: 50,
                            viewportFraction: 0.25,
                            enableInfiniteScroll: false,
                            enlargeCenterPage: false,
                            autoPlay: false,
                            padEnds: false,
                            scrollDirection: Axis.horizontal,
                          ),
                          items: [
                            _buildPriceGraphOptions(' 07 Aug', '₹ 4799'),
                            _buildPriceGraphOptions(' 08 Aug', '₹ 4870'),
                            _buildPriceGraphOptions(' 08 Aug', '₹ 4986'),
                            _buildPriceGraphOptions(' 09 Aug', '₹ 5267'),
                            _buildPriceGraphOptions(' 10 Aug', '₹ 5100'),
                            _buildPriceGraphOptions(' 11 Aug', '₹ 4950'),
                            _buildPriceGraphOptions(
                              ' 12 Aug',
                              '₹ 5350',
                              showSeparator: false,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: 6),
                    Expanded(
                      flex: 1,
                      child: Container(
                        padding: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.15),
                              spreadRadius: 1,
                              blurRadius: 6,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              LucideIcons.chartGantt,
                              size: 18,
                              color: Colors.blue,
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Price Graph',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 10,
                                color: const Color.fromARGB(255, 102, 102, 102),
                                fontWeight: FontWeight.w700,
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
          ),

          // All Fare section (will hide on scroll)
          SliverToBoxAdapter(
            child: Container(
              margin: EdgeInsets.fromLTRB(8, 4, 8, 8),
              // padding: EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.15),
                    spreadRadius: 1,
                    blurRadius: 6,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: IntrinsicHeight(
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                              vertical: 8,
                              horizontal: 16,
                            ),
                            child: Text(
                              'All Fare',
                              style: TextStyle(
                                fontSize: 11,
                                color: const Color.fromARGB(255, 102, 102, 102),
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          Container(
                            height: 40,
                            width: 1,
                            color: Colors.grey[300],
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 4,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 4,
                        ),
                        child: CarouselSlider(
                          options: CarouselOptions(
                            height: 50,
                            viewportFraction: 0.3,
                            enableInfiniteScroll: false,
                            enlargeCenterPage: false,
                            autoPlay: false,
                            padEnds: false,
                            scrollDirection: Axis.horizontal,
                          ),
                          items: [
                            _buildFareOptions(
                              'Indigo',
                              '₹ 4799',
                              showFirstSeparator: false,
                            ),
                            _buildFareOptions('Air India', '₹ 4870'),
                            _buildFareOptions('Air India', '₹ 4986'),
                            _buildFareOptions('Akasha Air', '₹ 5267'),
                            _buildFareOptions('Indigo', '₹ 5100'),
                            _buildFareOptions('Indigo', '₹ 4950'),
                            _buildFareOptions(
                              'Indigo',
                              '₹ 5350',
                              showSeparator: false,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Sticky Recommended header
          SliverPersistentHeader(
            pinned: true,
            floating: false,
            delegate: _StickyHeaderDelegate(
              child: Container(
                color: Colors.grey[100], // Match your background
                child: Container(
                  height: 70.0,
                  margin: EdgeInsets.fromLTRB(8, 4, 8, 4),
                  padding: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.15),
                        spreadRadius: 1,
                        blurRadius: 6,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      // First section - Recommended
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            print('Recommended tapped');
                            // Add your logic here
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Recommended',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 4),
                              Text(
                                '₹ 4,950',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue[700],
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(width: 1, height: 40, color: Colors.grey[300]),
                      // Second section - Cheapest
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            print('Cheapest tapped');
                            // Add your logic here
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Cheapest',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 4),
                              Text(
                                '₹ 4,799',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green[700],
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(width: 1, height: 40, color: Colors.grey[300]),
                      // Third section - Shortest
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            print('Shortest tapped');
                            // Add your logic here
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Shortest',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 4),
                              Text(
                                '₹ 5,350',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.orange[700],
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Flight cards list
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                // Sample flight data - you can replace this with your actual data
                final flights = [
                  {
                    'airline': 'IndiGo',
                    'flightNumber': '6E-2766',
                    'departureTime': '04:00',
                    'arrivalTime': '06:15',
                    'duration': '2h 15m',
                    'price': '₹ 4799',
                    'color': Colors.blue[800]!,
                  },
                  {
                    'airline': 'IndiGo',
                    'flightNumber': '6E-519',
                    'departureTime': '23:30',
                    'arrivalTime': '01:45',
                    'duration': '2h 15m',
                    'price': '₹ 4799',
                    'color': Colors.blue[800]!,
                  },
                  {
                    'airline': 'IndiGo',
                    'flightNumber': '6E-853',
                    'departureTime': '01:55',
                    'arrivalTime': '04:15',
                    'duration': '2h 20m',
                    'price': '₹ 4799',
                    'color': Colors.blue[800]!,
                  },
                  {
                    'airline': 'Air India',
                    'flightNumber': 'AI-2421',
                    'departureTime': '02:15',
                    'arrivalTime': '04:40',
                    'duration': '2h 25m',
                    'price': '₹ 4870',
                    'color': Colors.red[800]!,
                  },
                  {
                    'airline': 'IndiGo',
                    'flightNumber': '6E-449',
                    'departureTime': '05:00',
                    'arrivalTime': '07:20',
                    'duration': '2h 20m',
                    'price': '₹ 4950',
                    'color': Colors.blue[800]!,
                  },
                ];

                // Repeat the flights to show more items
                final flight = flights[index % flights.length];

                return Container(
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  child: _buildFlightCard(
                    airline: flight['airline'] as String,
                    flightNumber: flight['flightNumber'] as String,
                    departureTime: flight['departureTime'] as String,
                    arrivalTime: flight['arrivalTime'] as String,
                    duration: flight['duration'] as String,
                    price: flight['price'] as String,
                    airlineLogo: flight['color'] as Color,
                    onTap: () {
                      _handleFlightSelection(
                        context,
                        flight['flightNumber'] as String,
                      );
                    },
                  ),
                );
              },
              childCount: 15, // Show 15 flight cards (3 times the sample data)
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceGraphOptions(
    String date,
    String price, {
    bool showSeparator = true,
  }) {
    return Container(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(height: 40, width: 1, color: Colors.grey[300]),
          Expanded(
            child: Container(
              height: 40,
              padding: EdgeInsets.symmetric(horizontal: 6, vertical: 4),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Text(
                      date,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.black87,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                  SizedBox(height: 1),
                  Flexible(
                    child: Text(
                      price,
                      style: TextStyle(fontSize: 10, color: Colors.black54),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (showSeparator)
            Container(height: 40, width: 1, color: Colors.grey[300]),
        ],
      ),
    );
  }

  Widget _buildRecommendedOptions(
    String date,
    String price, {
    bool showSeparator = true,
  }) {
    return Container(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(height: 40, width: 1, color: Colors.grey[300]),
          Expanded(
            child: Container(
              height: 40,
              padding: EdgeInsets.symmetric(horizontal: 6, vertical: 4),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Text(
                      date,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.black87,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                  SizedBox(height: 1),
                  Flexible(
                    child: Text(
                      price,
                      style: TextStyle(fontSize: 10, color: Colors.black54),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (showSeparator)
            Container(height: 40, width: 1, color: Colors.grey[300]),
        ],
      ),
    );
  }

  Widget _buildFareOptions(
    String flightName,
    String price, {
    bool showSeparator = true,
    bool showFirstSeparator = true,
  }) {
    return Container(
      child: Row(
        mainAxisSize: MainAxisSize.min, // or MainAxisSize.max if filling parent
        children: [
          // Left vertical line
          //  if (!showFirstSeparator)
          // Container(height: 40, width: 1, color: Colors.grey[300]),
          SizedBox(width: 2),

          // SVG Icon
          Container(
            height: 12,
            width: 12,
            child: SvgPicture.network(
              'https://www.flightsmojo.in/images/airlinesSvg/6E.svg',
            ),
          ),

          SizedBox(width: 6),

          // Text Section (date + price)
          Flexible(
            // ✅ Best choice here
            child: Container(
              height: 40,
              padding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    child: Text(
                      flightName,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                  SizedBox(height: 2),
                  Flexible(
                    child: Text(
                      price,
                      style: TextStyle(fontSize: 11, color: Colors.black54),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                ],
              ),
            ),
          ),

          SizedBox(width: 6),

          // Right vertical line
          if (showSeparator)
            Container(height: 40, width: 1, color: Colors.grey[300]),
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
            margin: EdgeInsets.only(top: 8),
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
                        style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                      ),
                    ],
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    SizedBox(height: 20),
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
    print('Selected flight: $flightNumber');
  }
}

// Custom delegate for sticky header
class _StickyHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;

  _StickyHeaderDelegate({required this.child});

  @override
  double get minExtent => 78.0; // 70 + 8 margin

  @override
  double get maxExtent => 78.0; // 70 + 8 margin

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return child;
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
