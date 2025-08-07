import 'package:carousel_slider/carousel_slider.dart';
import 'package:flightmojo/feature/searchResult/presentation/widgets/flightdetail_bottomsheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class FlightSearchResultsScreen extends StatefulWidget {
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
  State<FlightSearchResultsScreen> createState() =>
      _FlightSearchResultsScreenState();
}

class _FlightSearchResultsScreenState extends State<FlightSearchResultsScreen> {
  // State variables for tracking selections
  int selectedDateIndex = 0;
  int selectedFareIndex = 0;
  int selectedRecommendedIndex = 0;

  // Sample data that changes based on selections
  final List<Map<String, dynamic>> priceGraphData = [
    {'date': '07 Aug', 'price': '₹ 4799'},
    {'date': '08 Aug', 'price': '₹ 4870'},
    {'date': '09 Aug', 'price': '₹ 4986'},
    {'date': '10 Aug', 'price': '₹ 5267'},
    {'date': '11 Aug', 'price': '₹ 5100'},
    {'date': '12 Aug', 'price': '₹ 4950'},
    {'date': '13 Aug', 'price': '₹ 5350'},
  ];

  final List<Map<String, dynamic>> fareData = [
    {'airline': 'Indigo', 'price': '₹ 4799'},
    {'airline': 'Air India', 'price': '₹ 4870'},
    {'airline': 'SpiceJet', 'price': '₹ 4986'},
    {'airline': 'Akasha Air', 'price': '₹ 5267'},
    {'airline': 'Vistara', 'price': '₹ 5100'},
    {'airline': 'GoAir', 'price': '₹ 4950'},
    {'airline': 'Alliance', 'price': '₹ 5350'},
  ];

  final List<Map<String, dynamic>> recommendedData = [
    {'type': 'Recommended', 'price': '₹ 4,950', 'color': Colors.blue},
    {'type': 'Cheapest', 'price': '₹ 4,799', 'color': Colors.green},
    {'type': 'Shortest', 'price': '₹ 5,350', 'color': Colors.orange},
  ];

  // Flight data that changes based on selections
  List<Map<String, dynamic>> get currentFlights {
    // This would typically come from an API based on selected date/fare/recommendation
    final baseFlights = [
      {
        'airline': 'IndiGo',
        'flightNumber': '6E-2766',
        'departureTime': '04:00',
        'arrivalTime': '06:15',
        'duration': '2h 15m',
        'price': priceGraphData[selectedDateIndex]['price'],
        'color': Colors.blue[800]!,
      },
      {
        'airline': 'Air India',
        'flightNumber': 'AI-519',
        'departureTime': '23:30',
        'arrivalTime': '01:45',
        'duration': '2h 15m',
        'price':
            '₹ ${int.parse(priceGraphData[selectedDateIndex]['price'].replaceAll('₹ ', '').replaceAll(',', '')) + 200}',
        'color': Colors.red[800]!,
      },
      {
        'airline': 'SpiceJet',
        'flightNumber': 'SG-853',
        'departureTime': '01:55',
        'arrivalTime': '04:15',
        'duration': '2h 20m',
        'price':
            '₹ ${int.parse(priceGraphData[selectedDateIndex]['price'].replaceAll('₹ ', '').replaceAll(',', '')) + 150}',
        'color': Colors.orange[800]!,
      },
    ];

    return baseFlights;
  }

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
              '${widget.fromCity} to ${widget.toCity}',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            Text(
              '${widget.departureDate} - ${widget.returnDate} | ${widget.passengers}',
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
                          items: priceGraphData.asMap().entries.map((entry) {
                            int index = entry.key;
                            Map<String, dynamic> data = entry.value;
                            return _buildPriceGraphOptions(
                              data['date'],
                              data['price'],
                              isSelected: selectedDateIndex == index,
                              onTap: () {
                                setState(() {
                                  selectedDateIndex = index;
                                });
                              },
                              showSeparator: index != priceGraphData.length - 1,
                            );
                          }).toList(),
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
                              LucideIcons.chartNoAxesColumn,
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

          // All Fare section
          SliverToBoxAdapter(
            child: Container(
              margin: EdgeInsets.fromLTRB(8, 4, 8, 8),
              child: IntrinsicHeight(
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: GestureDetector(
                        onTap: () {},
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
                                LucideIcons.plane,
                                size: 18,
                                color: Colors.blue,
                              ),
                              SizedBox(height: 4),
                              Text(
                                'All Fare',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 10,
                                  color: const Color.fromARGB(
                                    255,
                                    102,
                                    102,
                                    102,
                                  ),
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 6),
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
                            viewportFraction: 0.3,
                            enableInfiniteScroll: false,
                            enlargeCenterPage: false,
                            autoPlay: false,
                            padEnds: false,
                            scrollDirection: Axis.horizontal,
                          ),
                          items: fareData.asMap().entries.map((entry) {
                            int index = entry.key;
                            Map<String, dynamic> data = entry.value;
                            return _buildFareOptions(
                              data['airline'],
                              data['price'],
                              isSelected: selectedFareIndex == index,
                              onTap: () {
                                setState(() {
                                  selectedFareIndex = index;
                                });
                              },
                              showSeparator: index != fareData.length - 1,
                            );
                          }).toList(),
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
              selectedIndex: selectedRecommendedIndex,
              recommendedData: recommendedData,
              onTap: (index) {
                if (mounted) {
                  // Check if widget is still mounted
                  setState(() {
                    selectedRecommendedIndex = index;
                  });
                }
              },
            ),
          ),

          // Flight cards list
          SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              final flight = currentFlights[index % currentFlights.length];

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
            }, childCount: 15),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceGraphOptions(
    String date,
    String price, {
    bool showSeparator = true,
    bool isSelected = false,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
          border: isSelected ? Border.all(color: Colors.blue, width: 2) : null,
        ),
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
                          color: isSelected ? Colors.blue : Colors.black87,
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
                        style: TextStyle(
                          fontSize: 10,
                          color: isSelected ? Colors.blue : Colors.black54,
                        ),
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
      ),
    );
  }

  Widget _buildFareOptions(
    String flightName,
    String price, {
    bool showSeparator = true,
    bool isSelected = false,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: isSelected
              ? Colors.green.withOpacity(0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
          border: isSelected ? Border.all(color: Colors.green, width: 2) : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(width: 2),
            Container(
              height: 12,
              width: 12,
              child: SvgPicture.network(
                'https://www.flightsmojo.in/images/airlinesSvg/6E.svg',
              ),
            ),
            SizedBox(width: 6),
            Flexible(
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
                          color: isSelected ? Colors.green : Colors.black87,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                    SizedBox(height: 2),
                    Flexible(
                      child: Text(
                        price,
                        style: TextStyle(
                          fontSize: 11,
                          color: isSelected ? Colors.green : Colors.black54,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(width: 6),
            if (showSeparator)
              Container(height: 40, width: 1, color: Colors.grey[300]),
          ],
        ),
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
            padding: EdgeInsets.all(8),
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
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 30,
                  width: 30,
                  child: SvgPicture.network(
                    'https://www.flightsmojo.in/images/airlinesSvg/6E.svg',
                  ),
                ),
                SizedBox(width: 8),
                Flexible(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        airline,
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      SizedBox(height: 2),
                      Text(
                        flightNumber,
                        style: TextStyle(fontSize: 10, color: Colors.grey[500]),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  flex: 4,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        duration,
                        style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                      ),
                      SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(
                            child: Text(
                              departureTime,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[800],
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          SizedBox(width: 4),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Container(
                                    height: 1,
                                    color: Colors.grey[300],
                                  ),
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
                                  child: Container(
                                    height: 1,
                                    color: Colors.grey[300],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              arrivalTime,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[800],
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
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
                SizedBox(width: 8),
                Container(
                  width: 60,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        price,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[800],
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        textAlign: TextAlign.end,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 0,
            right: 16,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.green[100],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.green[300]!),
              ),
              child: Text(
                'Saver Fare',
                style: TextStyle(
                  color: Colors.green[700],
                  fontSize: 9,
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
    // Example usage with multiple segments
    final segments = [
      FlightSegment(
        airline: "Emirates",
        flightNumber: "EK545",
        departureTime: "14:30",
        arrivalTime: "18:45",
        departureDate: "Dec 15",
        arrivalDate: "Dec 15",
        departureCity: "New York",
        arrivalCity: "Dubai",
        departureAirport: "JFK",
        arrivalAirport: "DXB",
        departureTerminal: "4",
        arrivalTerminal: "3",
        duration: "4h 15m",
        airlineLogo: Colors.red,
        classType: "Economy",
      ),
      FlightSegment(
        airline: "Emirates",
        flightNumber: "EK364",
        departureTime: "22:15",
        arrivalTime: "09:30+1",
        departureDate: "Dec 15",
        arrivalDate: "Dec 16",
        departureCity: "Dubai",
        arrivalCity: "Mumbai",
        departureAirport: "DXB",
        arrivalAirport: "BOM",
        departureTerminal: "3",
        arrivalTerminal: "2",
        duration: "3h 15m",
        airlineLogo: Colors.red,
        classType: "Economy",
      ),
      FlightSegment(
        airline: "Emirates",
        flightNumber: "EK364",
        departureTime: "22:15",
        arrivalTime: "09:30+1",
        departureDate: "Dec 15",
        arrivalDate: "Dec 16",
        departureCity: "Dubai",
        arrivalCity: "Mumbai",
        departureAirport: "DXB",
        arrivalAirport: "BOM",
        departureTerminal: "3",
        arrivalTerminal: "2",
        duration: "3h 15m",
        airlineLogo: Colors.red,
        classType: "Economy",
      ),
    ];

    final layovers = [
      LayoverInfo(duration: "3h 30m", city: "Dubai", airport: "DXB"),
      LayoverInfo(duration: "3h 30m", city: "Dubai", airport: "DXB"),
    ];

    showFlightDetailsBottomSheet(
      context,
      flightSegments: segments,
      layovers: layovers,
      totalDuration: "11h 00m",
      price: "\$1,250",
      cabinBaggage: "7kg",
      checkedBaggage: "23kg",
    );
  }
}

// Custom delegate for sticky header
class _StickyHeaderDelegate extends SliverPersistentHeaderDelegate {
  final int selectedIndex;
  final List<Map<String, dynamic>> recommendedData;
  final Function(int) onTap;

  _StickyHeaderDelegate({
    this.selectedIndex = 0,
    required this.recommendedData,
    required this.onTap,
  });

  @override
  double get minExtent => 78.0;

  @override
  double get maxExtent => 78.0;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      color: Colors.grey[100],
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
          children: recommendedData.asMap().entries.map((entry) {
            int index = entry.key;
            Map<String, dynamic> data = entry.value;
            bool isSelected = selectedIndex == index;

            return Expanded(
              child: GestureDetector(
                onTap: () => onTap(index),
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 2),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? data['color'].withOpacity(0.1)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                    border: isSelected
                        ? Border.all(color: data['color'], width: 2)
                        : null,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        data['type'],
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: isSelected ? data['color'] : Colors.black87,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 4),
                      Text(
                        data['price'],
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: isSelected
                              ? data['color']
                              : data['color'][700],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    if (oldDelegate is _StickyHeaderDelegate) {
      return selectedIndex != oldDelegate.selectedIndex;
    }
    return true;
  }
}
