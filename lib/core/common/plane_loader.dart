import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class FlyingScene extends StatefulWidget {
  const FlyingScene({Key? key}) : super(key: key);

  @override
  State<FlyingScene> createState() => _FlyingSceneState();
}

class _FlyingSceneState extends State<FlyingScene>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E), // Theme dark background
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          // Cloud offset: move to left and repeat
          final cloudOffset = (_controller.value * screenWidth * 2) % screenWidth;

          return Stack(
            children: [
              // Gradient sky background with theme colors
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      const Color.fromARGB(255, 255, 255, 255), // Dark at top
                      const Color.fromARGB(255, 255, 255, 255), // Slightly lighter
                       // Orange tint
                      const Color(0xFFF5F5F5), // Light at bottom
                    ],
                    stops: const [0.0, 0.3, 1.0],
                  ),
                ),
              ),

              // Moving cloud layer above plane with fade effect
              Positioned(
                top: 100,
                left: -cloudOffset,
                child: Row(
                  children: [
                    cloudSvgWithFade(-cloudOffset, 0, screenWidth),
                    SizedBox(width: screenWidth * 0.3),
                    cloudSvgWithFade(-cloudOffset, screenWidth * 0.3 + 150, screenWidth),
                    SizedBox(width: screenWidth * 0.2),
                    cloudSvgWithFade(-cloudOffset, screenWidth * 0.5 + 300, screenWidth),
                    SizedBox(width: screenWidth * 0.4),
                    cloudSvgWithFade(-cloudOffset, screenWidth * 0.9 + 450, screenWidth),
                  ],
                ),
              ),
              Positioned(
                top: 200,
                left: screenWidth - cloudOffset,
                child: Row(
                  children: [
                    cloudSvgWithFade(screenWidth - cloudOffset, 0, screenWidth),
                    SizedBox(width: screenWidth * 0.25),
                    cloudSvgWithFade(screenWidth - cloudOffset, screenWidth * 0.25 + 150, screenWidth),
                    SizedBox(width: screenWidth * 0.35),
                    cloudSvgWithFade(screenWidth - cloudOffset, screenWidth * 0.6 + 300, screenWidth),
                  ],
                ),
              ),

              // Centered plane (stationary) with orange accent
              Align(
                alignment: const Alignment(0, 0), // a bit to the right
                child: Container(
                  padding: const EdgeInsets.all(8),
                 
                  child: SvgPicture.asset(
                    'assets/images/plane.svg',
                    width: 60,
                    height: 60,
                    colorFilter: const ColorFilter.mode(
                      Color.fromARGB(255, 197, 197, 197), // White plane to match theme
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),

              // Few clouds below plane with fade effect
              Positioned(
                top: screenHeight * 0.65,
                left: -cloudOffset * 0.8, // Slightly different speed
                child: Row(
                  children: [
                    cloudSvgWithFade(-cloudOffset * 0.8, 0, screenWidth, size: 130),
                    SizedBox(width: screenWidth * 0.5),
                    cloudSvgWithFade(-cloudOffset * 0.8, screenWidth * 0.5 + 130, screenWidth, size: 110),
                  ],
                ),
              ),
              Positioned(
                top: screenHeight * 0.75,
                left: screenWidth - cloudOffset * 1.2,
                child: cloudSvgWithFade(screenWidth - cloudOffset * 1.2, 0, screenWidth, size: 140),
              ),
            ],
          );
        },
      ),
    );
  }

  // Calculate fade opacity based on cloud position
  double calculateFadeOpacity(double cloudPosition, double screenWidth) {
    const fadeZone = 200.0; // Fade distance from screen edges
    
    if (cloudPosition < -fadeZone) {
      return 0.0; // Completely hidden before entering
    } else if (cloudPosition < 0) {
      // Fade in from left
      return (cloudPosition + fadeZone) / fadeZone;
    } else if (cloudPosition > screenWidth - fadeZone) {
      // Fade out to right
      return (screenWidth - cloudPosition) / fadeZone;
    } else {
      return 1.0; // Fully visible in the middle
    }
  }

  // Cloud with fade effect
  Widget cloudSvgWithFade(double containerLeft, double cloudOffset, double screenWidth, {double size = 150}) {
    final cloudPosition = containerLeft + cloudOffset;
    final opacity = calculateFadeOpacity(cloudPosition, screenWidth);
    
    return Opacity(
      opacity: opacity.clamp(0.0, 1.0),
      child: cloudSvg(size: size),
    );
  }

  Widget cloudSvg({double size = 150}) {
    return SvgPicture.asset(
      'assets/images/cloud.svg',
      width: size,
      height: size * 0.3, // Maintain aspect ratio
      colorFilter: ColorFilter.mode(
        const Color.fromARGB(255, 165, 165, 165).withOpacity(0.95),
        BlendMode.srcIn,
      ),
    );
  }
}