import 'package:flutter/material.dart';

// class FlightSegment {
//   final String airline;
//   final String flightNumber;
//   final String departureTime;
//   final String arrivalTime;
//   final String departureDate;
//   final String arrivalDate;
//   final String departureCity;
//   final String arrivalCity;
//   final String departureAirport;
//   final String arrivalAirport;
//   final String departureTerminal;
//   final String arrivalTerminal;
//   final String duration;
//   final Color airlineLogo;
//   final String classType;

//   const FlightSegment({
//     required this.airline,
//     required this.flightNumber,
//     required this.departureTime,
//     required this.arrivalTime,
//     required this.departureDate,
//     required this.arrivalDate,
//     required this.departureCity,
//     required this.arrivalCity,
//     required this.departureAirport,
//     required this.arrivalAirport,
//     required this.departureTerminal,
//     required this.arrivalTerminal,
//     required this.duration,
//     required this.airlineLogo,
//     required this.classType,
//   });
// }

// class LayoverInfo {
//   final String duration;
//   final String city;
//   final String airport;

//   const LayoverInfo({
//     required this.duration,
//     required this.city,
//     required this.airport,
//   });
// }

class CheckboxInfo {
  final String label;
  final double minimumPrice;
  bool? selected;
  final String? iconUrl;

  CheckboxInfo({
    required this.label,
    required this.minimumPrice,
    this.selected,
    this.iconUrl,
  });
}

List<CheckboxInfo> checkboxOptions = [
  CheckboxInfo(label: 'Non Stop', minimumPrice: 4500.0, selected: false),
  CheckboxInfo(label: '1 Stop', minimumPrice: 3800.0, selected: false),
  CheckboxInfo(label: '2 Stops', minimumPrice: 3200.0, selected: false),
];

List<CheckboxInfo> airlineOptions = [
  CheckboxInfo(label: 'Indigo', minimumPrice: 4500.0, selected: false),
  CheckboxInfo(label: 'Air India', minimumPrice: 3800.0, selected: false),
  CheckboxInfo(label: 'Akasha Air', minimumPrice: 3200.0, selected: false),
    CheckboxInfo(label: 'Spice Jet', minimumPrice: 3200.0, selected: false)
];

class FilterBottomSheet extends StatefulWidget {
  // final List<FlightSegment> flightSegments;
  // final List<LayoverInfo> layovers; // Will have (segments.length - 1) items
  // final String totalDuration;
  // final String price;
  // final String cabinBaggage;
  // final String checkedBaggage;

  const FilterBottomSheet({
    super.key,
    // required this.flightSegments,
    // required this.layovers,
    // required this.totalDuration,
    // required this.price,
    // required this.cabinBaggage,
    // required this.checkedBaggage,
  });

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(
        context,
      ).size.height, // Increased height for multiple segments
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          SizedBox(height: 10),

          // Handle bar
          // Container(
          //   margin: EdgeInsets.only(top: 8),
          //   width: 60,
          //   height: 4,
          //   decoration: BoxDecoration(
          //     color: Colors.grey[400],
          //     borderRadius: BorderRadius.circular(2),
          //   ),
          // ),

          // Header with close button
          Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Filter',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
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
                  _buildStopsSection(),

                  // SizedBox(height: 8),
                  Divider(
                    thickness: 1,
                    color: Colors.black,
                    indent: 16, // left padding
                    endIndent: 16, // right padding
                  ),

                  _airlineSection(),

                  Divider(
                    thickness: 1,
                    color: Colors.black,
                    indent: 16, // left padding
                    endIndent: 16, // right padding
                  ),

                  _priceSlider(),
                  

                  // Multiple flight segments with layovers
                  // ..._buildFlightSegments(),

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

  Widget _buildStopsSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 6), // Match checkbox area
            child: Text(
              "Stops",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 8),
          ...checkboxOptions.map((item) {
            return Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 4,
              ), // space between rows
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Checkbox(
                        value: item.selected,
                        onChanged: (value) {
                          setState(() {
                            item.selected = value ?? false;
                          });
                        },
                        side: const BorderSide(color: Colors.black, width: 2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                        activeColor: Colors.blue,
                        checkColor: Colors.white,
                        materialTapTargetSize: MaterialTapTargetSize
                            .shrinkWrap, // Keeps checkbox tight
                        visualDensity: VisualDensity.compact, // Reduces height
                      ),
                      Text(
                        item.label,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    item.minimumPrice.toString(),
                    style: const TextStyle(fontSize: 14, color: Colors.black),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _priceSlider() {
  RangeValues _currentRangeValues = const RangeValues(4000, 80000);

  return StatefulBuilder(
    builder: (context, setState) {
      return Container(
        padding: const EdgeInsets.all(16),
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Price Range",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            // Always visible values above slider
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("₹${_currentRangeValues.start.round()}"),
                Text("₹${_currentRangeValues.end.round()}"),
              ],
            ),

            RangeSlider(
              min: 4000,
              max: 80000,
              divisions: 1000,
              activeColor: Colors.orange,
              inactiveColor: Colors.grey[300],
              values: _currentRangeValues,
              // labels: RangeLabels(
              //   _currentRangeValues.start.round().toString(),
              //   _currentRangeValues.end.round().toString(),
              // ),
              onChanged: (RangeValues values) {
                setState(() {
                  _currentRangeValues = values;
                });
              },
            ),
          ],
        ),
      );
    },
  );
}


  Widget _departureSection() {
    return Container();
  }

  Widget _arrivalSection() {
    return Container();
  }

  Widget _airlineSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 6), // Match checkbox area
            child: Text(
              "Airlines",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 8),
          ...airlineOptions.map((item) {
            return Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 4,
              ), // space between rows
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Checkbox(
                        value: item.selected,
                        onChanged: (value) {
                          setState(() {
                            item.selected = value ?? false;
                          });
                        },
                        side: const BorderSide(color: Colors.black, width: 2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                        activeColor: Colors.blue,
                        checkColor: Colors.white,
                        materialTapTargetSize: MaterialTapTargetSize
                            .shrinkWrap, // Keeps checkbox tight
                        visualDensity: VisualDensity.compact, // Reduces height
                      ),
                      Text(
                        item.label,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    item.minimumPrice.toString(),
                    style: const TextStyle(fontSize: 14, color: Colors.black),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}

// Bottom section with price and continue button
class BottomPriceSection extends StatelessWidget {
  final String price;
  final VoidCallback onContinue;

  const BottomPriceSection({
    super.key,
    required this.price,
    required this.onContinue,
  });

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
void showFilterBottomSheet(BuildContext context, {required String filterlist}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => Stack(
      children: [
        FilterBottomSheet(
          // flightSegments: flightSegments,
          // layovers: layovers,
          // totalDuration: totalDuration,
          // price: price,
          // cabinBaggage: cabinBaggage,
          // checkedBaggage: checkedBaggage,
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: BottomPriceSection(
            price: '',
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
