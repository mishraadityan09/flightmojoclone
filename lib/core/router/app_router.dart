import 'package:flightmojo/features/search/presentation/pages/search.dart';
import 'package:flightmojo/features/searchResult/presentation/pages/search_result.dart';
import 'package:flutter/material.dart';
import 'package:flightmojo/features/home/presentaion/pages/home_page.dart';
import 'package:flightmojo/features/main/presentation/pages/main_page.dart';
import 'package:flightmojo/features/splash/splash.dart';
import 'package:go_router/go_router.dart';

import 'app_routes.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: AppRoutes.splash,
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      // Main shell route with bottom navigation
      ShellRoute(
        builder: (context, state, child) {
          return MainPage(child: child);
        },
        routes: [
          // Home tab
          GoRoute(
            path: AppRoutes.main,
            builder: (context, state) => const HomePage(),
          ),

          // Search tab
          GoRoute(
            path: AppRoutes.search,
            builder: (context, state) => const SubSearch(),
          ),

          // Bookings tab
          GoRoute(
            path: AppRoutes.bookings,
            builder: (context, state) => const BookingsPage(),
          ),

          // Profile tab
          GoRoute(
            path: AppRoutes.profile,
            builder: (context, state) => const ProfilePage(),
          ),
        ],
      ),

      // Full-screen routes (outside bottom navigation)
      GoRoute(
        path: AppRoutes.flightSearch,
        builder: (context, state) {
          final data = state.extra as Map<String, dynamic>?;
          return SearchPage(hint: data?['hint']);
        },
      ),

      GoRoute(
        path: AppRoutes.flightResults,
        builder: (context, state) {
          // final extra = state.extra as Map<String, dynamic>?;
          return FlightSearchResultsScreen();
        },
      ),

      GoRoute(
        path: '${AppRoutes.flightDetails}/:flightId',
        builder: (context, state) {
          final flightId = state.pathParameters['flightId']!;
          return FlightDetailsPage(flightId: flightId);
        },
      ),

      GoRoute(
        path: AppRoutes.passengerDetails,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          return PassengerDetailsPage(flight: extra?['flight']);
        },
      ),

      GoRoute(
        path: AppRoutes.bookingConfirmation,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          return BookingConfirmationPage(booking: extra?['booking']);
        },
      ),

      GoRoute(
        path: '${AppRoutes.bookingDetails}/:bookingId',
        builder: (context, state) {
          final bookingId = state.pathParameters['bookingId']!;
          return BookingDetailsPage(bookingId: bookingId);
        },
      ),
    ],

    // Error handling
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              'Page not found',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'The page you are looking for does not exist.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go(AppRoutes.main),
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    ),
  );
}

// Placeholder pages - we'll create these properly later
class SubSearch extends StatelessWidget {
  const SubSearch({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Search Flights')),
      body: const Center(child: Text('Search Page - Coming Soon')),
    );
  }
}

class FlightResultsPage extends StatelessWidget {
  final Map<String, dynamic>? searchParams;

  const FlightResultsPage({super.key, this.searchParams});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Flight Results')),
      body: const Center(child: Text('Flight Results - Coming Soon')),
    );
  }
}

class FlightDetailsPage extends StatelessWidget {
  final String flightId;

  const FlightDetailsPage({super.key, required this.flightId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Flight Details')),
      body: Center(child: Text('Flight Details for ID: $flightId')),
    );
  }
}

class PassengerDetailsPage extends StatelessWidget {
  final dynamic flight;

  const PassengerDetailsPage({super.key, this.flight});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Passenger Details')),
      body: const Center(child: Text('Passenger Details - Coming Soon')),
    );
  }
}

class BookingConfirmationPage extends StatelessWidget {
  final dynamic booking;

  const BookingConfirmationPage({super.key, this.booking});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Booking Confirmation')),
      body: const Center(child: Text('Booking Confirmation - Coming Soon')),
    );
  }
}

class BookingDetailsPage extends StatelessWidget {
  final String bookingId;

  const BookingDetailsPage({super.key, required this.bookingId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Booking Details')),
      body: Center(child: Text('Booking Details for ID: $bookingId')),
    );
  }
}

class BookingsPage extends StatelessWidget {
  const BookingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Bookings')),
      body: const Center(child: Text('Bookings Page - Coming Soon')),
    );
  }
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: const Center(child: Text('Profile Page - Coming Soon')),
    );
  }
}
