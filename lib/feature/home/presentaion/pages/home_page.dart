// import 'package:flightmojo/core/theme/app_theme.dart';
import 'package:flightmojo/feature/flights/presentation/pages/flights_search.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

enum ServiceType { flight }
// enum ServiceType { flight, hotel, cab }

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Service selection state
  ServiceType _selectedService = ServiceType.flight;

  // Hotel-specific state variables
  String _hotelCity = 'Mumbai';
  String _checkInDate = _formatDate(DateTime.now());
  String _checkOutDate = _formatDate(
    DateTime.now().add(const Duration(days: 2)),
  );
  int _hotelGuests = 2;
  int _rooms = 1;

  // Cab-specific state variables
  String _pickupLocation = 'Airport';
  String _dropLocation = 'Hotel';
  String _cabDate = _formatDate(DateTime.now());
  String _cabTime = '10:00 AM';

  // Reference to the flight widget for external access
  final GlobalKey _flightWidgetKey = GlobalKey();

  // Constants
  static const List<Map<String, String>> _destinations = [
    {'name': 'Mumbai', 'price': '₹4,500'},
    {'name': 'Bangalore', 'price': '₹5,200'},
    {'name': 'Chennai', 'price': '₹4,800'},
    {'name': 'Kolkata', 'price': '₹3,900'},
  ];

  // Helper methods
  static String _formatDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // _buildHeroText(),
          const SizedBox(height: 8),
          _buildServiceChips(),
          const SizedBox(height: 12),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildServiceContent(),
                  const SizedBox(height: 20),
                  _buildPopularDestinationsSection(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: Text(
        'TravelMojo',
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
    );
  }

  Widget _buildHeroText() {
    return Container(
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
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Your Travel Companion',
            style: GoogleFonts.poppins(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Book flights, hotels & cabs at best prices',
            style: GoogleFonts.poppins(
              fontSize: 16,
              color: Colors.white.withValues(alpha: 0.9),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceChips() {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: ServiceType.values.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final service = ServiceType.values[index];
          final isSelected = service == _selectedService;

          String label;
          IconData iconData;

          switch (service) {
            case ServiceType.flight:
              label = 'Flights';
              iconData = Icons.flight;
              break;
            // case ServiceType.hotel:
            //   label = 'Hotels';
            //   iconData = Icons.hotel;
            //   break;
            // case ServiceType.cab:
            //   label = 'Cabs';
            //   iconData = Icons.directions_car;
            //   break;
          }

          return AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              gradient: isSelected
                  ? LinearGradient(
                      colors: [
                        Theme.of(context).primaryColor,
                        Theme.of(context).primaryColor.withValues(alpha: 0.8),
                      ],
                    )
                  : null,
              color: isSelected ? null : Colors.grey.shade200,
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: Theme.of(
                          context,
                        ).primaryColor.withValues(alpha: 0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ]
                  : null,
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(25),
                onTap: () {
                  setState(() {
                    _selectedService = service;
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        iconData,
                        size: 20,
                        color: isSelected ? Colors.white : Colors.black54,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        label,
                        style: GoogleFonts.poppins(
                          color: isSelected ? Colors.white : Colors.black87,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildServiceContent() {
    Widget child;
    switch (_selectedService) {
      case ServiceType.flight:
        child = FlightSearchWidget(key: _flightWidgetKey);
        break;
      // case ServiceType.hotel:
      //   child = Text(
      //     'Hotel search functionality will be implemented here.',
      //     style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500),
      //   );
      //   break;
      // case ServiceType.cab:
      //   child = Text(
      //     'Cab search functionality will be implemented here.',
      //     style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500),
      //   );
      //   break;
    }

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 400),
      transitionBuilder: (Widget child, Animation<double> animation) {
        final offsetAnimation =
            Tween<Offset>(
              begin: const Offset(1.0, 0),
              end: Offset.zero,
            ).animate(
              CurvedAnimation(parent: animation, curve: Curves.easeInOutCubic),
            );
        return SlideTransition(position: offsetAnimation, child: child);
      },
      child: Container(
        key: ValueKey<ServiceType>(_selectedService),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: child,
      ),
    );
  }

  // Hotel-specific widgets

  Widget _buildPopularDestinationsSection() {
    return Padding(
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
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.2,
            ),
            itemCount: _destinations.length,
            itemBuilder: (context, index) =>
                _buildDestinationCard(_destinations[index]),
          ),
        ],
      ),
    );
  }

  Widget _buildDestinationCard(Map<String, String> destination) {
    return GestureDetector(
      // onTap: () => _searchFlightsWithDestination(destination['name']!),
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
