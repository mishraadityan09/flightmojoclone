import 'package:flightmojo/core/common/datepicker_bottomsheet.dart';
import 'package:flightmojo/core/theme/app_theme.dart';
import 'package:flightmojo/feature/home/presentaion/widgets/passengers_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
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

  String _departureDate =
      "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}";
  String _returnDate =
      "${DateTime.now().add(const Duration(days: 1)).day}/${DateTime.now().add(const Duration(days: 1)).month}/${DateTime.now().add(const Duration(days: 1)).year}";

  final int _passengers = 1;
  bool _isRoundTrip = false;
  final GlobalKey bottomPassengersSheet = GlobalKey();

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
            onPressed: () {},
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
                        color: Colors.white.withValues(alpha: 0.9),
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
                            Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: Colors.grey.shade300),
                                color: Colors.grey.shade100,
                              ),
                              child: Stack(
                                children: [
                                  // Sliding background indicator
                                  AnimatedPositioned(
                                    duration: const Duration(milliseconds: 10),
                                    curve: Curves.easeInOutCubic,
                                    left: _isRoundTrip ? null : 2,
                                    right: _isRoundTrip ? 2 : null,
                                    top: 2,
                                    bottom: 2,
                                    width:
                                        (MediaQuery.of(context).size.width -
                                            36) /
                                        2.5, // Adjust based on your container width
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(14),
                                        color: Colors.white,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(
                                              0.1,
                                            ),
                                            blurRadius: 3,
                                            offset: const Offset(0, 1),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  // Text buttons
                                  Row(
                                    children: [
                                      Expanded(
                                        child: GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              _isRoundTrip = false;
                                            });
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 16,
                                              vertical: 12,
                                            ),
                                            child: Center(
                                              child: AnimatedDefaultTextStyle(
                                                duration: const Duration(
                                                  milliseconds: 10,
                                                ),
                                                style: TextStyle(
                                                  color: !_isRoundTrip
                                                      ? Colors.black
                                                      : Colors.grey.shade600,
                                                  fontWeight: !_isRoundTrip
                                                      ? FontWeight.w500
                                                      : FontWeight.normal,
                                                  fontSize: 16,
                                                ),
                                                child: const Text('One Way'),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              _isRoundTrip = true;
                                            });
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 16,
                                              vertical: 12,
                                            ),
                                            child: Center(
                                              child: AnimatedDefaultTextStyle(
                                                duration: const Duration(
                                                  milliseconds: 600,
                                                ),
                                                style: TextStyle(
                                                  color: _isRoundTrip
                                                      ? Colors.black
                                                      : Colors.grey.shade600,
                                                  fontWeight: _isRoundTrip
                                                      ? FontWeight.w500
                                                      : FontWeight.normal,
                                                  fontSize: 16,
                                                ),
                                                child: const Text(
                                                  'Round Trip',
                                                  style: TextStyle(),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
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
                                    _isRoundTrip,
                                  ),
                                ),
                                const SizedBox(width: 16),

                                if (!_isRoundTrip)
                                  Expanded(
                                    child: _buildEmptyReturnField(
                                      context,
                                      'Return',
                                      _returnDate,
                                      _isRoundTrip,
                                    ),
                                  ),

                                if (_isRoundTrip) const SizedBox(width: 16),
                                if (_isRoundTrip)
                                  Expanded(
                                    child: _buildDateField(
                                      context,
                                      'Return',
                                      _returnDate,
                                      _isRoundTrip,
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

  Widget _buildDateField(
    BuildContext context,
    String label,
    String value,
    bool isReturn,
  ) {
    print(label);
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
          onTap: () {
            // Parse current date if available
            DateTime? initialDate;
            if (value != 'Select date') {
              try {
                List<String> parts = value.split('/');
                if (parts.length == 3) {
                  initialDate = DateTime(
                    int.parse(parts[2]), // year
                    int.parse(parts[1]), // month
                    int.parse(parts[0]), // day
                  );
                }
              } catch (e) {
                // If parsing fails, use current date
                initialDate = DateTime.now();
              }
            } else {
              initialDate = DateTime.now();
            }

            Map<DateTime, double> samplePrices = {
              DateTime(2025, 7, 25): 150.0,
              DateTime(2025, 7, 26): 175.0,
              DateTime(2025, 7, 27): 200.0,
              DateTime(2025, 7, 28): 125.0,
              DateTime(2025, 7, 29): 180.0,
              DateTime(2025, 7, 30): 160.0,
            };

            showDatePickerBottomSheet(
              context,
              initialDepartureDate: DateTime.now(),
              initialReturnDate: DateTime.now().add(const Duration(days: 1)),
              prices: samplePrices,
              isAddingReturnDate: label == 'Return' ? true : false,
              onDatesSelected: (departureDate, returnDate) {
                setState(() {
                  if (label == 'Departure') {
                    _departureDate =
                        "${departureDate.day}/${departureDate.month}/${departureDate.year}";
                  } else {
                    _returnDate =
                        "${returnDate?.day}/${returnDate?.month}/${returnDate?.year ?? ''}";
                  }
                });
                print(
                  'Departure: ${departureDate.day}/${departureDate.month}/${departureDate.year}',
                );
                print(
                  'Return: ${returnDate?.day}/${returnDate?.month}/${returnDate?.year}',
                );
                // Handle the selected dates
              },
            );
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

  Widget _buildEmptyReturnField(
    BuildContext context,
    String label,
    String value,
    bool isReturn,
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
          onTap: () {
            // Parse current date if available
            DateTime? initialDate;
            if (value != 'Select date') {
              try {
                List<String> parts = value.split('/');
                if (parts.length == 3) {
                  initialDate = DateTime(
                    int.parse(parts[2]), // year
                    int.parse(parts[1]), // month
                    int.parse(parts[0]), // day
                  );
                }
              } catch (e) {
                // If parsing fails, use current date
                initialDate = DateTime.now();
              }
            } else {
              initialDate = DateTime.now();
            }

            Map<DateTime, double> samplePrices = {
              DateTime(2025, 7, 25): 150.0,
              DateTime(2025, 7, 26): 175.0,
              DateTime(2025, 7, 27): 200.0,
              DateTime(2025, 7, 28): 125.0,
              DateTime(2025, 7, 29): 180.0,
              DateTime(2025, 7, 30): 160.0,
            };

            showDatePickerBottomSheet(
              context,
              initialDepartureDate: DateTime.now(),
              initialReturnDate: null,
              prices: samplePrices,
              isAddingReturnDate: true,
              onDatesSelected: (departureDate, returnDate) {
                print('Departure: $departureDate');
                print('Return: $returnDate');
                // Handle the selected dates
              },
            );
          },
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
                const SizedBox(width: 8),
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

  // Widget _buildReturnDateField(BuildContext context, String label, String value, bool isReturn) {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       Text(
  //         label,
  //         style: GoogleFonts.poppins(
  //           fontSize: 14,
  //           fontWeight: FontWeight.w500,
  //           color: Colors.grey[600],
  //         ),
  //       ),
  //       const SizedBox(height: 4),
  //       GestureDetector(
  //         onTap: () {
  //           // Parse current date if available
  //           DateTime? initialDate;
  //           if (value != 'Select date') {
  //             try {
  //               List<String> parts = value.split('/');
  //               if (parts.length == 3) {
  //                 initialDate = DateTime(
  //                   int.parse(parts[2]), // year
  //                   int.parse(parts[1]), // month
  //                   int.parse(parts[0]), // day
  //                 );
  //               }
  //             } catch (e) {
  //               // If parsing fails, use current date
  //               initialDate = DateTime.now();
  //             }
  //           } else {
  //             initialDate = DateTime.now();
  //           }

  //           // Show custom date picker bottom sheet
  //           // showDatePickerBottomSheet(
  //           //   context,
  //           //   initialDate: initialDate,
  //           //   onDateSelected: (picked) {
  //           //     setState(() {
  //           //       if (label == 'Departure') {
  //           //         _departureDate = "${picked.day}/${picked.month}/${picked.year}";
  //           //       } else {
  //           //         _returnDate = "${picked.day}/${picked.month}/${picked.year}";
  //           //       }
  //           //     });
  //           //   },
  //           // );

  //           // Example usage:

  //           Map<DateTime, double> samplePrices = {
  //             DateTime(2025, 7, 25): 150.0,
  //             DateTime(2025, 7, 26): 175.0,
  //             DateTime(2025, 7, 27): 200.0,
  //             DateTime(2025, 7, 28): 125.0,
  //             DateTime(2025, 7, 29): 180.0,
  //             DateTime(2025, 7, 30): 160.0,
  //           };

  //           showDatePickerBottomSheet(
  //             context,
  //             initialDepartureDate: DateTime.now(),
  //             initialReturnDate: null,
  //             prices: samplePrices,
  //             onDatesSelected: (departureDate, returnDate) {
  //               print('Departure: $departureDate');
  //               print('Return: $returnDate');
  //               // Handle the selected dates
  //             },
  //           );
  //         },
  //         child: Container(
  //           padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
  //           decoration: BoxDecoration(
  //             border: Border.all(color: Colors.grey[300]!),
  //             borderRadius: BorderRadius.circular(8),
  //           ),
  //           child:isReturn? Row(
  //             children: [
  //               Icon(
  //                 Icons.calendar_today,
  //                 color: Theme.of(context).primaryColor,
  //                 size: 20,
  //               ),
  //               const SizedBox(width: 8),
  //               Expanded(
  //                 child: Text(
  //                   value,
  //                   style: GoogleFonts.poppins(
  //                     fontSize: 16,
  //                     fontWeight: FontWeight.w500,
  //                   ),
  //                   overflow: TextOverflow.ellipsis,
  //                 ),
  //               ),
  //             ],
  //           ):null,
  //         ),
  //       ),
  //     ],
  //   );
  // }

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
            showModalBottomSheet(
              showDragHandle: true,
              useRootNavigator: true,
              isScrollControlled: true,
              context: context,
              builder: (context) {
                return PassengersBottomSheet();
              },
            );
            // _showPassengerDialog(context);
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
}
