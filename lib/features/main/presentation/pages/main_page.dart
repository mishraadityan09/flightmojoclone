import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/app_routes.dart';

class MainPage extends StatefulWidget {
  final Widget child;

  const MainPage({super.key, required this.child});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });

    // Navigate to the corresponding route
    switch (index) {
      case 0:
        context.go(AppRoutes.main);
        break;
      case 1:
        context.go(AppRoutes.search);
        break;
      case 2:
        context.go(AppRoutes.bookings);
        break;
      case 3:
        context.go(AppRoutes.profile);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Responsive font sizing based on screen width
    final double screenWidth = MediaQuery.of(context).size.width;
    // Calculate label font size based on screen width
    final double labelFontSize = (screenWidth * 0.035).clamp(10.0, 14.0);

    // Update current index based on current route
    final String location = GoRouterState.of(context).uri.path;
    if (location == AppRoutes.main) {
      _currentIndex = 0;
    } else if (location == AppRoutes.search) {
      _currentIndex = 1;
    } else if (location == AppRoutes.bookings) {
      _currentIndex = 2;
    } else if (location == AppRoutes.profile) {
      _currentIndex = 3;
    }

    final primaryColor = Theme.of(context).primaryColor;
    final unselectedColor = Colors.grey;

    final items = [
      {'icon': Icons.home, 'label': 'Home', 'index': 0},
      {'icon': Icons.search, 'label': 'Search', 'index': 1},
      {'icon': Icons.book, 'label': 'Bookings', 'index': 2},
      {'icon': Icons.person, 'label': 'Profile', 'index': 3},
    ];

    Widget buildCustomBottomNavigationBar() {
      return Material(
        elevation: 10,
        child: Container(
          color: Colors.white,
          height: 70,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: items.map((item) {
              final bool selected = _currentIndex == item['index'];
              return InkWell(
                onTap: () => _onItemTapped(item['index'] as int),
                borderRadius: BorderRadius.circular(30), // capsule shape
                splashColor: primaryColor.withValues(alpha:0.2),
                highlightColor: Colors.transparent,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: selected
                      ? BoxDecoration(
                          color: primaryColor.withValues(alpha:0.15),
                          borderRadius: BorderRadius.circular(30),
                        )
                      : null,
                  child: Row(
                    children: [
                      Icon(
                        item['icon'] as IconData,
                        color: selected ? primaryColor : unselectedColor,
                      ),
                      if (selected) ...[
                        const SizedBox(width: 8),
                        Text(
                          item['label'] as String,
                          style: TextStyle(
                            color: primaryColor,
                            fontWeight: FontWeight.w600,
                            fontSize: labelFontSize,
                          ),
                        ),
                      ]
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      );
    }

    return Scaffold(
      body: widget.child,
      bottomNavigationBar: buildCustomBottomNavigationBar(),
    );
  }
}
