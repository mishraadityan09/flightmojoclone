import 'package:flutter/material.dart';

class FlightDealCard extends StatelessWidget {
  final String fromCity;
  final String toCity;
  final String date;
  final String price;
  final VoidCallback? onTap;

  const FlightDealCard({
    Key? key,
    required this.fromCity,
    required this.toCity,
    required this.date,
    required this.price,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 160,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFF8F8F8),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFFE5E5E5), width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Route Section
            _buildRouteSection(),
            const SizedBox(height: 16),

            // Price Section
            _buildPriceSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildRouteSection() {
    return Column(
      children: [
        // From City
        _buildRouteItem(cityCode: fromCity, date: date, isLast: false),
        const SizedBox(height: 12),

        // To City
        _buildRouteItem(cityCode: toCity, date: null, isLast: true),
      ],
    );
  }

  Widget _buildRouteItem({
    required String cityCode,
    String? date,
    required bool isLast,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Dot and Connected Line
        SizedBox(
          width: 24,
          child: Column(
            children: [
              // Dot
              Container(
                width: 6,
                height: 6,
                decoration: const BoxDecoration(
                  color: Color(0xFFFF4444),
                  shape: BoxShape.circle,
                ),
              ),
              if (!isLast)
                Container(
                  width: 1,
                  height: 40,
                  color: const Color(0xFFDDDDDD),
                  margin: const EdgeInsets.only(top: 4),
                ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        // City and Date
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                cityCode,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF333333),
                ),
              ),
              if (date != null) ...[
                const SizedBox(height: 2),
                Text(
                  date,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF999999),
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPriceSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Starting From',
          style: TextStyle(
            fontSize: 12,
            color: Color(0xFF999999),
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          price,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Color(0xFFFF4444),
          ),
        ),
      ],
    );
  }
}

class FlightDealsSection extends StatelessWidget {
  const FlightDealsSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // International Routes Section
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            'Popular International Routes',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Color(0xFF333333),
            ),
          ),
        ),
        SizedBox(
          height: 140,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: const [
              FlightDealCard(
                fromCity: 'DEL',
                toCity: 'KTM',
                date: 'Tue, 26 Aug',
                price: '4010',
              ),
              SizedBox(width: 12),
              FlightDealCard(
                fromCity: 'TRV',
                toCity: 'KUL',
                date: 'Thu, 11 Dec',
                price: '5476',
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 24),
        
        // Domestic Routes Section
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            'Popular Domestic Routes',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Color(0xFF333333),
            ),
          ),
        ),
        SizedBox(
          height: 140,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: const [
              FlightDealCard(
                fromCity: 'CCU',
                toCity: 'PAT',
                date: 'Sat, 18 Oct',
                price: '5000',
              ),
              SizedBox(width: 12),
              FlightDealCard(
                fromCity: 'HYD',
                toCity: 'LKO',
                date: 'Tue, 02 Sep',
                price: '5000',
              ),
            ],
          ),
        ),
      ],
    );
  }
}
