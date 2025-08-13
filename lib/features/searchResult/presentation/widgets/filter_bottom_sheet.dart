import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CheckboxInfo {
  final String label;
  final double minimumPrice;
  bool selected;
  final String? iconUrl;

  CheckboxInfo({
    required this.label,
    required this.minimumPrice,
    this.selected = false,
    this.iconUrl,
  });
}

List<CheckboxInfo> checkboxOptions = [
  CheckboxInfo(label: 'Non Stop', minimumPrice: 4500.0),
  CheckboxInfo(label: '1 Stop', minimumPrice: 3800.0),
  CheckboxInfo(label: '2 Stops', minimumPrice: 3200.0),
];

List<CheckboxInfo> airlineOptions = [
  CheckboxInfo(label: 'Indigo', minimumPrice: 4500.0),
  CheckboxInfo(label: 'Air India', minimumPrice: 3800.0),
  CheckboxInfo(label: 'Akasha Air', minimumPrice: 3200.0),
  CheckboxInfo(label: 'Spice Jet', minimumPrice: 3200.0),
];

class FilterBottomSheet extends StatefulWidget {
  const FilterBottomSheet({super.key});

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  RangeValues _currentRangeValues = const RangeValues(4000, 80000);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Filter',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
                ),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(Icons.close, color: Colors.red, size: 20),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildStopsSection(),
                  _divider(),
                  _airlineSection(),
                  _divider(),
                  _priceSlider(),
                  _divider(),
                  _departureSection(),
                  _divider(),
                  _arrivalSection(),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _divider() => const Divider(thickness: 1, color: Colors.black, indent: 16, endIndent: 16);

  Widget _buildStopsSection() {
    return _checkboxListSection("Stops", checkboxOptions);
  }

  Widget _airlineSection() {
    return _checkboxListSection("Airlines", airlineOptions);
  }

  Widget _checkboxListSection(String title, List<CheckboxInfo> items) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: Text(title, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 8),
          ...items.map((item) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Checkbox(
                        value: item.selected,
                        onChanged: (value) {
                          setState(() => item.selected = value ?? false);
                        },
                        side: const BorderSide(color: Colors.black, width: 2),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                        activeColor: Colors.blue,
                        visualDensity: VisualDensity.compact,
                      ),
                      Text(item.label, style: const TextStyle(fontSize: 12, color: Colors.black87)),
                    ],
                  ),
                  Text(item.minimumPrice.toString(),
                      style: const TextStyle(fontSize: 12, color: Colors.black)),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _priceSlider() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Price Range", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("₹${_currentRangeValues.start.round()}",style: TextStyle(fontSize: 12),),
              Text("₹${_currentRangeValues.end.round()}",style: TextStyle(fontSize: 12),),
            ],
          ),
          RangeSlider(
            min: 4000,
            max: 80000,
            divisions: 1000,
            activeColor: Colors.orange,
            inactiveColor: Colors.grey[300],
            values: _currentRangeValues,
            onChanged: (values) => setState(() => _currentRangeValues = values),
          ),
        ],
      ),
    );
  }

  Widget _departureSection() {
    return _timeFilterSection("Departure");
  }

  Widget _arrivalSection() {
    return _timeFilterSection("Arrival");
  }

  Widget _timeFilterSection(String title) {
    final List<Map<String, String>> chipData = [
      {'label': 'Before 6 AM', 'iconUrl': 'assets/images/sunrise.svg'},
      {'label': '6 AM - 12 PM', 'iconUrl': 'assets/images/afternoon.svg'},
      {'label': '12 PM - 6 PM', 'iconUrl': 'assets/images/sunset.svg'},
      {'label': 'After 6 PM', 'iconUrl': 'assets/images/night.svg'},
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.fromLTRB(16,0,0,0),
            child: Wrap(
              spacing: 36,
              runSpacing: 16,
              children: chipData.map((item) {
                return ChoiceChip(
                  labelPadding: const EdgeInsets.symmetric(horizontal: 8),
                  avatar: SvgPicture.asset(item['iconUrl']!, width: 18, height: 18,
                      placeholderBuilder: (context) => const Icon(Icons.image, size: 18)),
                  label: Text(item['label']!, style: const TextStyle(color: Colors.black,fontSize: 12)),
                  selected: false,
                  onSelected: (_) {},
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class BottomPriceSection extends StatelessWidget {
  final VoidCallback onContinue;

  const BottomPriceSection({super.key, required this.onContinue});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 4, offset: const Offset(0, -2))],
      ),
      child: SafeArea(
        child: ElevatedButton(
          onPressed: onContinue,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          child: const Text('Apply filter', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }
}

void showFilterBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Colors.transparent,
    builder: (context) => Stack(
      children: [
        const FilterBottomSheet(),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: BottomPriceSection(
            onContinue: () => Navigator.pop(context),
          ),
        ),
      ],
    ),
  );
}
