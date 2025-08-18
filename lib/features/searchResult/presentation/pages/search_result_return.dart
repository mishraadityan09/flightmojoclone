import 'package:flightmojo/core/router/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class SearchResultReturn extends StatefulWidget {
  const SearchResultReturn({super.key});

  @override
  _SearchResultReturnState createState() => _SearchResultReturnState();
}

class _SearchResultReturnState extends State<SearchResultReturn>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedDepartureFlight = 0;
  int _selectedReturnFlight = 0;
  int selectedDateIndex = 0;
  int selectedFareIndex = 0;

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

  // Responsive font size getters based on MediaQuery width
  double get screenWidth => MediaQuery.of(context).size.width;

  double get headingFontSize =>
      (screenWidth * 0.055).clamp(14.0, 16.0); // 5.5% width, clamp 20-24

  double get buttonLabelFontSize =>
      (screenWidth * 0.03).clamp(12.0, 14.0); // 3.5% width, clamp 16-18

  double get bodyTextFontSize =>
      (screenWidth * 0.03).clamp(12.0, 14.0); // 4% width, clamp 12-16

  double get secondaryLabelFontSize =>
      (screenWidth * 0.03).clamp(12.0, 14.0); // 3.2% width, clamp 12-14

  double get secondaryFontSize =>
      (screenWidth * 0.032).clamp(12.0, 14.0); // 3.2% width, clamp 12-14

  double get smallFontSize =>
      (screenWidth * 0.025).clamp(10.0, 12.0); // ~2.5% width, clamp 10-12

  double get iconSize => 20.0; // Fixed icon size for consistency

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Column(
        children: [
          // Top Header
          Container(
            color: Colors.grey[800],
            padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
            child: Column(
              children: [
                // Main header
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'DEL - BOM • 1 Traveler',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: headingFontSize,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              '13 Aug - 23 Aug • Economy',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: secondaryLabelFontSize,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
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
                    ],
                  ),
                ),

                // Flight Type Tabs
                Container(
                  color: Colors.white,
                  child: TabBar(
                    controller: _tabController,
                    indicator: UnderlineTabIndicator(
                      borderSide: BorderSide(color: Theme.of(context).colorScheme.primary, width: 2),
                    ),
                    labelColor: Colors.grey[800],
                    unselectedLabelColor: Colors.grey[600],
                    labelStyle: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                    tabs: [
                      Tab(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('DEPARTURE',style: TextStyle(fontSize: secondaryLabelFontSize),),
                            SizedBox(height: 2),
                            Builder(
                              builder: (_) {
                                final dep = departureFlights.isNotEmpty
                                    ? departureFlights[_selectedDepartureFlight]
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
                                  depPath.isNotEmpty || depDate.isNotEmpty
                                      ? '$depPath  •  $depDate'
                                      : '',
                                  style: TextStyle(
                                    fontSize: smallFontSize,
                                    color: Colors.grey[600],
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      Tab(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('RETURN',style: TextStyle(fontSize: secondaryLabelFontSize),),
                            SizedBox(height: 2),
                            Builder(
                              builder: (_) {
                                final ret = returnFlights.isNotEmpty
                                    ? returnFlights[_selectedReturnFlight]
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
                                  retPath.isNotEmpty || retDate.isNotEmpty
                                      ? '$retPath  •  $retDate'
                                      : '',
                                  style: TextStyle(
                                    fontSize: smallFontSize,
                                    color: Colors.grey[600],
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Flight cards section
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [_buildDepartureTab(), _buildReturnTab()],
            ),
          ),

          // Bottom Summary Bar
          _buildBottomSummaryBar(),
        ],
      ),
    );
  }

  Widget _buildDepartureTab() {
    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: departureFlights.length,
      itemBuilder: (context, index) {
        final flight = departureFlights[index];
        final isSelected = _selectedDepartureFlight == index;
        return Container(
          margin: EdgeInsets.only(bottom: 12),
          child: _buildFlightCard(
            airline: flight['airline'] as String,
            flightNumber: flight['flightNumber'] as String,
            departureTime: flight['departureTime'] as String,
            arrivalTime: flight['arrivalTime'] as String,
            duration: flight['duration'] as String,
            price: flight['price'] as String,
            airlineLogo: flight['color'] as Color,
            isSelected: isSelected,
            departureAirport: flight['departureAirport'] as String,
            arrivalAirport: flight['arrivalAirport'] as String,
            departureDate: (flight['departureDate'] as String?) ?? '',
            arrivalDate: (flight['arrivalDate'] as String?) ?? '',
            discount: (flight['discount'] as String?) ?? '',
            onTap: () {
              setState(() {
                _selectedDepartureFlight = index;
              });
            },
          ),
        );
      },
    );
  }

  Widget _buildReturnTab() {
    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: returnFlights.length,
      itemBuilder: (context, index) {
        final flight = returnFlights[index];
        final isSelected = _selectedReturnFlight == index;
        return Container(
          margin: EdgeInsets.only(bottom: 12),
          child: _buildFlightCard(
            airline: flight['airline'] as String,
            flightNumber: flight['flightNumber'] as String,
            departureTime: flight['departureTime'] as String,
            arrivalTime: flight['arrivalTime'] as String,
            duration: flight['duration'] as String,
            price: flight['price'] as String,
            airlineLogo: flight['color'] as Color,
            isSelected: isSelected,
            departureAirport: (flight['departureAirport'] as String?) ?? '',
            arrivalAirport: (flight['arrivalAirport'] as String?) ?? '',
            departureDate: (flight['departureDate'] as String?) ?? '',
            arrivalDate: (flight['arrivalDate'] as String?) ?? '',
            discount: (flight['discount'] as String?) ?? '',
            onTap: () {
              setState(() {
                _selectedReturnFlight = index;
              });
            },
          ),
        );
      },
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


  Widget _buildFlightCard({
    required String airline,
    required String flightNumber,
    required String departureTime,
    required String arrivalTime,
    required String duration,
    required String price,
    required Color airlineLogo,
    required bool isSelected,
    required String departureAirport,
    required String arrivalAirport,
    required String departureDate,
    required String arrivalDate,
    required String discount,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? Colors.blue : Colors.grey[300]!,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.1),
              spreadRadius: 1,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            // Airline Info Row
            Row(
              children: [
                Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: airlineLogo,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(Icons.flight, color: Colors.white, size: 20),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        airline,
                        style: TextStyle(fontSize: bodyTextFontSize, color: Colors.grey[600]),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      SizedBox(width: 4),
                      Container(
                        decoration: BoxDecoration(color: Colors.grey),
                        height: 12,
                        width: 1,
                      ),
                      SizedBox(width: 4),
                      Text(
                        flightNumber,
                        style: TextStyle(fontSize: smallFontSize, color: Colors.grey[500]),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ],
                  ),
                ),
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        price,
                        style: TextStyle(
                          fontSize: bodyTextFontSize,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[800],
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        textAlign: TextAlign.end,
                      ),
                      Text(
                        'per adult',
                        style: TextStyle(fontSize: smallFontSize, color: Colors.grey[500]),
                        textAlign: TextAlign.end,
                      ),
                    ],
                  ),
                ),
                // Container(
                //   width: 24,
                //   height: 24,
                //   decoration: BoxDecoration(
                //     shape: BoxShape.circle,
                //     color: isSelected ? Theme.of(context).colorScheme.primary : Colors.transparent,
                //     border: Border.all(
                //       color: isSelected ? Theme.of(context).colorScheme.primary  : Colors.grey[400]!,
                //       width: 2,
                //     ),
                //   ),
                //   child: isSelected
                //       ? Icon(Icons.check, color: Colors.white, size: 16)
                //       : null,
                // ),
              ],
            ),

            SizedBox(height: 8),

            // Flight Route
            Row(
              children: [
                // Departure
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        departureAirport,
                        style: TextStyle(
                          fontSize: smallFontSize,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        departureTime,
                        style: TextStyle(
                          fontSize: bodyTextFontSize,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[800],
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      // if (departureDate.isNotEmpty)
                      //   Text(
                      //     departureDate,
                      //     style: TextStyle(
                      //       fontSize: 12,
                      //       color: Colors.grey[600],
                      //     ),
                      //   ),
                    ],
                  ),
                ),

                // Flight Path
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        duration,
                        style: TextStyle(fontSize: smallFontSize, color: Colors.grey[600]),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Container(
                              height: 1,
                              decoration: BoxDecoration(
                                border: Border(
                                  top: BorderSide(
                                    color: Colors.grey[400]!,
                                    width: 1,
                                    style: BorderStyle.solid,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.flight_takeoff,
                              color: Colors.grey[600],
                              size: 16,
                            ),
                          ),
                          Expanded(
                            child: Container(
                              height: 1,
                              decoration: BoxDecoration(
                                border: Border(
                                  top: BorderSide(
                                    color: Colors.grey[400]!,
                                    width: 1,
                                    style: BorderStyle.solid,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      // SizedBox(height: 4),
                      Text(
                        'Non-Stop',
                        style: TextStyle(fontSize: smallFontSize, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),

                // Arrival
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        arrivalAirport,
                        style: TextStyle(
                          fontSize: smallFontSize,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        arrivalTime,
                        style: TextStyle(
                          fontSize: bodyTextFontSize,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[800],
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      // if (arrivalDate.isNotEmpty)
                      //   Text(
                      //     arrivalDate,
                      //     style: TextStyle(
                      //       fontSize: 12,
                      //       color: Colors.grey[600],
                      //     ),
                      //   ),
                    ],
                  ),
                ),
              ],
            ),

            // Discount
            // if (discount.isNotEmpty)
            //   Container(
            //     width: double.infinity,
            //     padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            //     decoration: BoxDecoration(
            //       color: Colors.green[50],
            //       borderRadius: BorderRadius.circular(8),
            //     ),
            //     child: Text(
            //       discount,
            //       style: TextStyle(
            //         fontSize: 12,
            //         color: Colors.green[700],
            //         fontWeight: FontWeight.w500,
            //       ),
            //     ),
            //   ),

            // SizedBox(height: 12),

            // Price and Actions
            // Row(
            //   children: [
            //     // Expanded(
            //     //   child: Column(
            //     //     crossAxisAlignment: CrossAxisAlignment.start,
            //     //     children: [
            //     //       Text(
            //     //         price,
            //     //         style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey[800]),
            //     //         overflow: TextOverflow.ellipsis,
            //     //         maxLines: 2,
            //     //         textAlign: TextAlign.end,
            //     //       ),
            //     //       Text(
            //     //         'per adult',
            //     //         style: TextStyle(fontSize: 9, color: Colors.grey[500]),
            //     //         textAlign: TextAlign.end,
            //     //       ),
            //     //     ],
            //     //   ),
            //     // ),
            //     // TextButton(
            //     //   onPressed: () {},
            //     //   child: Row(
            //     //     mainAxisSize: MainAxisSize.min,
            //     //     children: [
            //     //       Text(
            //     //         'Flight Details',
            //     //         style: TextStyle(color: Colors.blue, fontSize: 14),
            //     //       ),
            //     //       SizedBox(width: 4),
            //     //       Icon(
            //     //         Icons.keyboard_arrow_up,
            //     //         color: Colors.blue,
            //     //         size: 16,
            //     //       ),
            //     //     ],
            //     //   ),
            //     // ),
            //     // SizedBox(width: 8),
            //     // ElevatedButton(
            //     //   onPressed: onTap,
            //     //   style: ElevatedButton.styleFrom(
            //     //     backgroundColor: Theme,
            //     //     foregroundColor: Colors.white,
            //     //     shape: RoundedRectangleBorder(
            //     //       borderRadius: BorderRadius.circular(8),
            //     //     ),
            //     //   ),
            //     //   child: Text(
            //     //     'Select',
            //     //     style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
            //     //   ),
            //     // ),
            //   ],
            // ),
          ],
        ),
      ),
    );
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
            style: TextStyle(color: Colors.white, fontSize: headingFontSize),
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
                      depPath.isNotEmpty || depDate.isNotEmpty
                          ? depPath
                          : '',
                      style: TextStyle(fontSize: bodyTextFontSize, color: Colors.white),
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
                      style: TextStyle(color: Colors.white, fontSize: bodyTextFontSize),
                    ),
                  ],
                ),

                Text(
                  'From ${departureFlight['price']}',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: buttonLabelFontSize,
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
                      retPath.isNotEmpty || retDate.isNotEmpty
                          ? retPath
                          : '',
                      style: TextStyle(fontSize: bodyTextFontSize, color: Colors.white),
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
                      style: TextStyle(color: Colors.white, fontSize: bodyTextFontSize),
                    ),
                  ],
                ),
                Text(
                  'From ${returnFlight['price']}',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: buttonLabelFontSize,
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
                      style: TextStyle(color: Colors.white, fontSize: bodyTextFontSize),
                    ),
                    SizedBox(width: 8),
                    Text(
                      '₹${totalPrice.toStringAsFixed(0)}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: buttonLabelFontSize,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4),
                ElevatedButton(
                  onPressed: () {
                    // Navigate to booking
                    // ScaffoldMessenger.of(context).showSnackBar(
                    //   SnackBar(
                    //     content: Text('Proceeding to booking...'),
                    //     backgroundColor: Theme,
                    //   ),
                    // );
                    context.go(AppRoutes.bookingConfirmation);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  ),
                  child: Text(
                    'BOOK NOW',
                    style: TextStyle(fontSize: buttonLabelFontSize, fontWeight: FontWeight.w600),
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
