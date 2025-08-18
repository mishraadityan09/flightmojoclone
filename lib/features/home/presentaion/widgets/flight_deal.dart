import 'package:flutter/material.dart';

class FlightDealCard extends StatelessWidget {
  final String fromCity;
  final String toCity;
  final String date;
  final String price;
  final VoidCallback? onTap;

  const FlightDealCard({
    super.key,
    required this.fromCity,
    required this.toCity,
    required this.date,
    required this.price,
    this.onTap,
  });

  // Responsive font size getters based on MediaQuery width
  double _getScreenWidth(BuildContext context) => MediaQuery.of(context).size.width;

  double _getCityFontSize(BuildContext context) =>
      (_getScreenWidth(context) * 0.03).clamp(12.0, 16.0); // 4% width, clamp 12-16

  double _getDateFontSize(BuildContext context) =>
      (_getScreenWidth(context) * 0.030).clamp(11.0, 14.0); // 3% width, clamp 11-14

  double _getPriceFontSize(BuildContext context) =>
      (_getScreenWidth(context) * 0.03).clamp(12.0, 16.0); // 4% width, clamp 12-16

  double _getPriceLabelFontSize(BuildContext context) =>
      (_getScreenWidth(context) * 0.030).clamp(11.0, 14.0); // 3% width, clamp 11-14

  // Responsive sizing for visual elements
  double _getDotSize(BuildContext context) =>
      (_getScreenWidth(context) * 0.015).clamp(5.0, 7.0); // 1.5% width, clamp 5-7

  double _getLineWidth(BuildContext context) =>
      (_getScreenWidth(context) * 0.005).clamp(1.5, 2.5); // 0.5% width, clamp 1.5-2.5

  double _getLineHeight(BuildContext context) =>
      (_getScreenWidth(context) * 0.17).clamp(60.0, 80.0); // 17% width, clamp 60-80

  double _getCardWidth(BuildContext context) {
    final screenWidth = _getScreenWidth(context);
    if (screenWidth < 360) return 140; // Very small screens
    if (screenWidth < 400) return 150; // Small screens
    return 160; // Default for larger screens
  }

  double _getPadding(BuildContext context) {
    final screenWidth = _getScreenWidth(context);
    return (screenWidth * 0.04).clamp(12.0, 18.0); // 4% width, clamp 12-18
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: _getCardWidth(context),
        padding: EdgeInsets.all(_getPadding(context)),
        decoration: BoxDecoration(
          color: const Color(0xFFF8F8F8),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFFE5E5E5), width: 1),
          // boxShadow: [
          //   BoxShadow(
          //     offset: const Offset(0, 4),
          //     blurRadius: 4,
          //     spreadRadius: 1,
          //     color: const Color(0xFF000000).withValues(alpha:0.1),
          //   ),
          // ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Route Section (now includes price)
            _buildRouteSection(context),
          ],
        ),
      ),
    );
  }

  Widget _buildRouteSection(BuildContext context) {
    final dotSize = _getDotSize(context);
    final lineWidth = _getLineWidth(context);
    final lineHeight = _getLineHeight(context);
    
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Dots and connecting line column
        Column(
          children: [
            // First dot
            Container(
              width: dotSize,
              height: dotSize,
              decoration: const BoxDecoration(
                color: Color(0xFFFF4444),
                shape: BoxShape.circle,
              ),
            ),
            // Connecting line with responsive height
            Container(
              width: lineWidth,
              height: lineHeight,
              color: const Color(0xFFDDDDDD),
              margin: const EdgeInsets.symmetric(vertical: 0),
            ),
            // Second dot
            Container(
              width: dotSize,
              height: dotSize,
              decoration: const BoxDecoration(
                color: Color(0xFFFF4444),
                shape: BoxShape.circle,
              ),
            ),
          ],
        ),
        SizedBox(width: _getPadding(context) * 0.5), // Responsive spacing
        // Cities, dates, and price column
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // From city
              _buildCityInfo(context, cityCode: fromCity, date: date),
              SizedBox(height: _getPadding(context) * 1.3), // Responsive spacing
              // To city
              _buildCityInfo(context, cityCode: toCity, date: null),
              SizedBox(height: _getPadding(context) * 1.3), // Responsive spacing
              // Price section
              _buildPriceSection(context),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCityInfo(BuildContext context, {
    required String cityCode,
    String? date,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          cityCode,
          style: TextStyle(
            fontSize: _getCityFontSize(context),
            fontWeight: FontWeight.w600,
            color: const Color(0xFF333333),
          ),
        ),
        if (date != null) ...[
          SizedBox(height: _getPadding(context) * 0.125), // Responsive tiny spacing
          Text(
            date,
            style: TextStyle(
              fontSize: _getDateFontSize(context),
              color: const Color(0xFF999999),
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildPriceSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Starting From',
          style: TextStyle(
            fontSize: _getPriceLabelFontSize(context),
            color: const Color(0xFF999999),
            fontWeight: FontWeight.w400,
          ),
        ),
        SizedBox(height: _getPadding(context) * 0.125), // Responsive tiny spacing
        Text(
          '\u{20B9}$price',
          style: TextStyle(
            fontSize: _getPriceFontSize(context),
            fontWeight: FontWeight.w600,
            color: const Color(0xFFFF4444),
          ),
        ),
      ],
    );
  }
}