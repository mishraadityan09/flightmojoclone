import 'package:flutter/material.dart';

class DatePickerBottomSheet extends StatefulWidget {
  final DateTime? initialDate;
  final Function(DateTime)? onDateSelected;
  final Map<DateTime, double>? prices; // Add prices map

  const DatePickerBottomSheet({
    Key? key,
    this.initialDate,
    this.onDateSelected,
    this.prices, // Add this parameter
  }) : super(key: key);

  @override
  _DatePickerBottomSheetState createState() => _DatePickerBottomSheetState();
}

class _DatePickerBottomSheetState extends State<DatePickerBottomSheet> {
  late DateTime selectedDate;
  late DateTime startDate;
  late DateTime endDate;
  late List<DateTime> months;
  late ScrollController scrollController;
  int currentMonthIndex = 0;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    selectedDate = widget.initialDate ?? DateTime(now.year, now.month, now.day); // Normalize initial date
    startDate = DateTime(now.year, now.month, now.day); // Normalize start date
    endDate = DateTime(now.year, now.month, now.day).add(Duration(days: 360));
    
    // Generate list of months for next 360 days
    months = generateMonths();
    
    // Find initial month index
    currentMonthIndex = months.indexWhere((month) =>
        month.year == selectedDate.year && month.month == selectedDate.month);
    if (currentMonthIndex == -1) currentMonthIndex = 0;
    
    scrollController = ScrollController();
  }

  List<DateTime> generateMonths() {
    List<DateTime> monthsList = [];
    DateTime current = DateTime(startDate.year, startDate.month, 1);
    DateTime end = DateTime(endDate.year, endDate.month, 1);
    
    while (current.isBefore(end) || current.isAtSameMomentAs(end)) {
      monthsList.add(current);
      print(current); // Debugging line to check generated months
      current = DateTime(current.year, current.month + 1, 1);
    }
    
    return monthsList;
  }

  // Helper method to get price for a specific date
  double? _getPriceForDate(DateTime date) {
    if (widget.prices == null) return null;
    
    // Find exact match first
    for (var entry in widget.prices!.entries) {
      if (_isSameDay(entry.key, date)) {
        return entry.value;
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Select Date',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.close,color: Colors.black,),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),

          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(children: [
              Expanded(
                child: ListTile(
                  title: Text('Departure Date',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black),),
                  subtitle: Text(
                    '${selectedDate.day}/${selectedDate.month}/${selectedDate.year} ',
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),
                ),
              ),
              Expanded(
                child: ListTile(
                  title: Text('Return Date',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black),),
                  subtitle: Text(
                    '${selectedDate.day}/${selectedDate.month}/${selectedDate.year} ',
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),
                ),
              )
            ],),
          ),
          
          // Month/Year display
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Center(
              child: Text(
                'Select a Date',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          
          // Fixed weekday headers
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat']
                  .map((day) => Expanded(
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          child: Text(
                            day,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ))
                  .toList(),
            ),
          ),
          
          // Calendar months (vertically scrollable)
          Expanded(
            child: ListView.builder(
              controller: scrollController,
              itemCount: months.length,
              itemBuilder: (context, index) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Month header
                    Container(
                      padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
                      child: Text(
                        _getMonthYearText(months[index]),
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                    // Calendar grid
                    _buildCalendarMonth(months[index]),
                    SizedBox(height: 16),
                  ],
                );
              },
            ),
          ),
          
          // Bottom buttons
          Container(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
              
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      widget.onDateSelected?.call(selectedDate);
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text('Done'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarMonth(DateTime month) {
    final firstDayOfMonth = DateTime(month.year, month.month, 1);
    final lastDayOfMonth = DateTime(month.year, month.month + 1, 0);
    final startingWeekday = firstDayOfMonth.weekday % 7; // Sunday = 0
    final totalDays = lastDayOfMonth.day;
    
    List<Widget> dayWidgets = [];
    
    // Add empty cells for days before the first day of the month
    for (int i = 0; i < startingWeekday; i++) {
      dayWidgets.add(Container());
    }
    
    // Add day cells
    for (int day = 1; day <= totalDays; day++) {
      final date = DateTime(month.year, month.month, day);
      final today = DateTime.now();
      final normalizedToday = DateTime(today.year, today.month, today.day);
      final normalizedDate = DateTime(date.year, date.month, date.day);
      final normalizedStartDate = DateTime(startDate.year, startDate.month, startDate.day);
      final normalizedEndDate = DateTime(endDate.year, endDate.month, endDate.day);
      
      final isToday = _isSameDay(normalizedDate, normalizedToday);
      final isSelected = _isSameDay(normalizedDate, selectedDate);
      final isDisabled = normalizedDate.isBefore(normalizedStartDate) || normalizedDate.isAfter(normalizedEndDate);
      final price = _getPriceForDate(date);
      
      dayWidgets.add(
        GestureDetector(
          onTap: isDisabled
              ? null
              : () {
                  setState(() {
                    selectedDate = normalizedDate; // Use normalized date
                  });
                },
          child: Container(
            margin: EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: isSelected
                  ? Theme.of(context).primaryColor
                  : isToday
                      ? Theme.of(context).primaryColor.withValues(alpha: 0.1)
                      : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
              border: isToday && !isSelected
                  ? Border.all(color: Theme.of(context).primaryColor)
                  : null,
            ),
            child: Container(
              height: 60, // Increased height to accommodate price
              padding: EdgeInsets.symmetric(vertical: 4),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Date number
                  Text(
                    day.toString(),
                    style: TextStyle(
                      color: isDisabled
                          ? Colors.grey[400]
                          : isSelected
                              ? Colors.white
                              : isToday
                                  ? Theme.of(context).primaryColor
                                  : Colors.black,
                      fontWeight: isSelected || isToday
                          ? FontWeight.bold
                          : FontWeight.normal,
                      fontSize: 16,
                    ),
                  ),
                  // Price display
                  if (price != null)
                    Padding(
                      padding: EdgeInsets.only(top: 2),
                      child: Text(
                        '₹${price.toStringAsFixed(0)}',
                        style: TextStyle(
                          color: isDisabled
                              ? Colors.grey[400]
                              : isSelected
                                  ? Colors.white.withValues(alpha: 0.9)
                                  : isToday
                                      ? Theme.of(context).primaryColor
                                      : Colors.grey[600],
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      );
    }
    
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: GridView.count(
        crossAxisCount: 7,
        childAspectRatio: 0.8, // Adjusted aspect ratio for taller cells
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        children: dayWidgets,
      ),
    );
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  String _getMonthYearText(DateTime date) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return '${months[date.month - 1]} ${date.year}';
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }
}

// Updated function to accept prices
void showDatePickerBottomSheet(
  BuildContext context, {
  DateTime? initialDate,
  Function(DateTime)? onDateSelected,
  Map<DateTime, double>? prices, // Add prices parameter
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    showDragHandle: true ,
    useRootNavigator: true,
    
    builder: (context) => DatePickerBottomSheet(
      initialDate: initialDate,
      onDateSelected: onDateSelected,
      prices: prices, // Pass prices to the widget
    ),
  );
}

// Example usage:
/*
// Create a map of dates and their prices
Map<DateTime, double> samplePrices = {
  DateTime(2025, 7, 25): 150.0,
  DateTime(2025, 7, 26): 175.0,
  DateTime(2025, 7, 27): 200.0,
  DateTime(2025, 7, 28): 125.0,
  // Add more dates and prices as needed
};

// Show the date picker with prices
showDatePickerBottomSheet(
  context,
  initialDate: DateTime.now(),
  prices: samplePrices,
  onDateSelected: (selectedDate) {
    print('Selected date: $selectedDate');
    // Handle the selected date
  },
);
*/