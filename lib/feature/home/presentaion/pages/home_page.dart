// import 'package:flightmojo/core/theme/app_theme.dart';
import 'package:flightmojo/feature/flights/presentation/pages/flights_search.dart';
import 'package:flightmojo/feature/home/presentaion/widgets/coupon_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
  final String _hotelCity = 'Mumbai';
  final String _checkInDate = _formatDate(DateTime.now());
  final String _checkOutDate = _formatDate(
    DateTime.now().add(const Duration(days: 2)),
  );
  final int _hotelGuests = 2;
  final int _rooms = 1;

  // Cab-specific state variables
  final String _pickupLocation = 'Airport';
  final String _dropLocation = 'Hotel';
  final String _cabDate = _formatDate(DateTime.now());
  final String _cabTime = '10:00 AM';

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

  // Responsive text size getters
  double get screenWidth => MediaQuery.of(context).size.width;

  double get headingFontSize =>
      (screenWidth * 0.055).clamp(20.0, 24.0); // 5.5% width, clamp 20-24

  double get subheadingFontSize =>
      (screenWidth * 0.045).clamp(16.0, 18.0); // 4.5% width, clamp 16-18

  double get bodyFontSize =>
      (screenWidth * 0.04).clamp(14.0, 16.0); // 4% width, clamp 14-16

  double get secondaryFontSize =>
      (screenWidth * 0.032).clamp(12.0, 14.0); // 3.2% width, clamp 12-14

  double get smallFontSize =>
      (screenWidth * 0.025).clamp(10.0, 12.0); // ~2.5% width, clamp 10-12

  final double iconSize = 20; // Fixed icon size for consistency

  final List<Map<String, String>> _coupons = [
    {
      'title': 'Fly Domestic & Save Big',
      'subtitle':
          'Get up to 10% off on all domestic flights. Book your next trip and enjoy unbeatable savings!',
      'promoCode': 'FM10DOM',
    },
    {
      'title': 'Save on International Flights',
      'subtitle':
          'Enjoy up to 15% off on all international flights this season!',
      'promoCode': 'INTL15',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: _buildAppBar(),
      extendBodyBehindAppBar: false,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Modified Black background section with travel image
            Stack(
              children: [
                // Travel background image
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(40),
                    bottomRight: Radius.circular(40),
                  ),
                  child: Image.asset(
                    'assets/images/travelBg.jpg', // Your image asset
                    width: double.infinity,
                    height: 250,
                    fit: BoxFit.cover,
                  ),
                ),
                // Black semi-transparent overlay for readability
                Container(
                  width: double.infinity,
                  height: 250,
                  decoration: const BoxDecoration(
                    color: Color(0xB3000000), // Black with ~70% opacity
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(40),
                      bottomRight: Radius.circular(40),
                    ),
                  ),
                ),
                // Your existing black section layout, now with transparent color
                Container(
                  width: double.infinity,
                  height: 250,
                  decoration: const BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(40),
                      bottomRight: Radius.circular(40),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          'Hey Traveler 👋',
                          style: GoogleFonts.poppins(
                            fontSize: bodyFontSize,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Flexible(
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Flexible(
                                    child: Text(
                                      'ONLY FLIGHTS',
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.poppins(
                                        fontSize: subheadingFontSize,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    '.',
                                    style: GoogleFonts.poppins(
                                      fontSize: subheadingFontSize,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 10),
                            Flexible(
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Flexible(
                                    child: Text(
                                      'ONLY EXPERTS',
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.poppins(
                                        fontSize: subheadingFontSize,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    '.',
                                    style: GoogleFonts.poppins(
                                      fontSize: subheadingFontSize,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 120),
                    ],
                  ),
                ),
              ],
            ),

            // Service content widget
            Transform.translate(
              offset: const Offset(0, -150),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 8),
                
                child: _buildServiceContent(),
              ),
            ),

            

            const SizedBox(height: 0), // Reduced spacing
            Transform.translate(
              offset: const Offset(0, -150),
              child: _buildPopularDestinationsSection(),
            ),

            // Insert before Popular Destinations section
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.black,
      surfaceTintColor: Colors.black,
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarColor: Colors.black,
        statusBarIconBrightness: Brightness.light,
      ),
      leadingWidth: 200,
      leading: Padding(
        padding: const EdgeInsets.only(left: 16.0),
        child: Row(
          children: [
            // SvgPicture.asset(
            //   'assets/images/logo.svg',
            //   width: 32,
            //   height: 32,
            //   color: Colors.white.withValues(alpha: 1), // You can adjust opacity here
            //   //colorBlendMode: BlendMode.darken, // or try BlendMode.overlay, screen, etc.
            // )
            // Logo/Icon
            // SvgPicture.network(
            //   'http://test.flightsmojo.in/images/logo_white.svg',
            //   width: 32,
            //   height: 32,

            // ),
            // App Name
            Image.asset('assets/images/logo.png', width: 130, height: 130),
          ],
        ),
      ),
      actions: [
        // Notification Icon
        Container(
          margin: const EdgeInsets.only(right: 8),
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: Colors.grey.shade800,
            borderRadius: BorderRadius.circular(50),
          ),
          child: IconButton(
            iconSize: iconSize,
            padding: EdgeInsets.zero,
            icon: Stack(
              clipBehavior: Clip.none,
              children: [
                Icon(
                  Icons.notifications_outlined,
                  color: Colors.white,
                  size: iconSize,
                ),
                // Small dot for unread notification
                Positioned(
                  right: 3,
                  top: 4,
                  child: Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
            onPressed: () {},
          ),
        ),

        // Profile Icon
        // Container(
        //   margin: const EdgeInsets.only(right: 16),
        //   decoration: BoxDecoration(
        //     color: Colors.grey.shade800,
        //     borderRadius: BorderRadius.circular(12),
        //   ),
        //   child: IconButton(
        //     icon: const Icon(
        //       Icons.person_outline,
        //       color: Colors.white,
        //       size: 24,
        //     ),
        //     onPressed: () {},
        //   ),
        // ),
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
            Theme.of(context).primaryColor.withOpacity(0.8),
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
              fontSize: (screenWidth * 0.07).clamp(24.0, 28.0),
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Book flights, hotels & cabs at best prices',
            style: GoogleFonts.poppins(
              fontSize: bodyFontSize,
              color: Colors.white.withOpacity(0.9),
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
                      colors: [Colors.orange, Colors.orange.withOpacity(0.8)],
                    )
                  : null,
              color: isSelected ? null : Colors.grey.shade800,
              border: isSelected
                  ? null
                  : Border.all(color: Colors.grey.shade600),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: Colors.orange.withOpacity(0.3),
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
                        size: iconSize,
                        color: isSelected ? Colors.white : Colors.grey.shade300,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        label,
                        style: GoogleFonts.poppins(
                          color: isSelected
                              ? Colors.white
                              : Colors.grey.shade300,
                          fontWeight: FontWeight.w600,
                          fontSize: bodyFontSize,
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
      //     style: GoogleFonts.poppins(fontSize: bodyFontSize, fontWeight: FontWeight.w500),
      //   );
      //   break;
      // case ServiceType.cab:
      //   child = Text(
      //     'Cab search functionality will be implemented here.',
      //     style: GoogleFonts.poppins(fontSize: bodyFontSize, fontWeight: FontWeight.w500),
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
        
        padding: const EdgeInsets.all(20),
        child: child,
      ),
    );
  }

  // Hotel-specific widgets

  Widget _buildPopularDestinationsSection() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Available Coupons',
                style: GoogleFonts.poppins(
                  fontSize: headingFontSize,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _coupons.length,
                itemBuilder: (context, index) {
                  final coupon = _coupons[index];
                  return CouponCard(
                    title: coupon['title']!,
                    subtitle: coupon['subtitle']!,
                    promoCode: coupon['promoCode']!,
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Popular Destinations',
            style: GoogleFonts.poppins(
              fontSize: headingFontSize,
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
                Theme.of(context).primaryColor.withOpacity(0.8),
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
                        fontSize: subheadingFontSize,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'from ${destination['price']!}',
                      style: GoogleFonts.poppins(
                        fontSize: bodyFontSize,
                        color: Colors.white.withOpacity(0.9),
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
