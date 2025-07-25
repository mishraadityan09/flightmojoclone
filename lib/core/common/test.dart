import 'package:flutter/material.dart';

enum DateSelectionMode {
  departure,
  returnDate,
}

class DatePickerBottomSheet extends StatefulWidget {
  final DateTime? initialDepartureDate;
  final DateTime? initialReturnDate;
  final Function(DateTime, DateTime?)? onDatesSelected;
  final Map<DateTime, double>? prices;

  const DatePickerBottomSheet({
    Key? key,
    this.initialDepartureDate,
    this.initialReturnDate,
    this.onDatesSelected,
    this.prices,
  }) : super(key: key);

  @override
  _DatePickerBottomSheetState createState() => _DatePickerBottomSheetState();
}

class _DatePickerBottomSheetState extends State<DatePickerBottomSheet> {
  DateTime? departureDate;
  DateTime? returnDate;
  DateSelectionMode currentMode = DateSelectionMode.departure;
  late DateTime startDate;
  late DateTime endDate;
  late List<DateTime> months;
  late ScrollController scrollController;
  int currentMonthIndex = 0;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    
    // Initialize dates - normalize to remove time component
    departureDate = widget.initialDepartureDate ?? DateTime(now.year, now.month, now.day);
    returnDate = widget.initialReturnDate;
    
    startDate = DateTime(now.year, now.month, now.day);
    endDate = DateTime(now.year, now.month, now.day).add(Duration(days: 360));
    
    // Generate list of months for next 360 days
    months = generateMonths();
    
    // Find initial month index
    currentMonthIndex = months.indexWhere((month) =>
        month.year == departureDate!.year && month.month == departureDate!.month);
    if (currentMonthIndex == -1) currentMonthIndex = 0;
    
    scrollController = ScrollController();
  }

  List<DateTime> generateMonths() {
    List<DateTime> monthsList = [];
    DateTime current = DateTime(startDate.year, startDate.month, 1);
    DateTime end = DateTime(endDate.year, endDate.month, 1);
    
    while (current.isBefore(end) || current.isAtSameMomentAs(end)) {
      monthsList.add(current);
      current = DateTime(current.year, current.month + 1, 1);
    }
    
    return monthsList;
  }

  double? _getPriceForDate(DateTime date) {
    if (widget.prices == null) return null;
    
    for (var entry in widget.prices!.entries) {
      if (_isSameDay(entry.key, date)) {
        return entry.value;
      }
    }
    return null;
  }

  bool _isDateInRange(DateTime date) {
    if (departureDate == null || returnDate == null) return false;
    
    final normalizedDate = DateTime(date.year, date.month, date.day);
    final normalizedDeparture = DateTime(departureDate!.year, departureDate!.month, departureDate!.day);
    final normalizedReturn = DateTime(returnDate!.year, returnDate!.month, returnDate!.day);
    
    return normalizedDate.isAfter(normalizedDeparture) && normalizedDate.isBefore(normalizedReturn);
  }

  void _handleDateTap(DateTime tappedDate) {
    final normalizedTappedDate = DateTime(tappedDate.year, tappedDate.month, tappedDate.day);
    
    if (currentMode == DateSelectionMode.departure) {
      setState(() {
        departureDate = normalizedTappedDate;
        // Clear return date if it's before the new departure date
        if (returnDate != null && returnDate!.isBefore(normalizedTappedDate)) {
          returnDate = null;
        }
      });
    } else {
      // Return date mode
      if (departureDate != null && 
          (normalizedTappedDate.isAfter(departureDate!) || 
           normalizedTappedDate.isAtSameMomentAs(departureDate!))) {
        setState(() {
          returnDate = normalizedTappedDate;
        });
      } else if (departureDate != null && normalizedTappedDate.isBefore(departureDate!)) {
        // If selected date is before departure, make it the new departure and clear return
        setState(() {
          departureDate = normalizedTappedDate;
          returnDate = null;
          currentMode = DateSelectionMode.departure;
        });
      }
    }
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
                  'Select Dates',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.close, color: Colors.black),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),

          // Date selection tiles
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        currentMode = DateSelectionMode.departure;
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: currentMode == DateSelectionMode.departure 
                            ? Theme.of(context).primaryColor.withOpacity(0.1)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: currentMode == DateSelectionMode.departure 
                              ? Theme.of(context).primaryColor
                              : Colors.grey.shade300,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Departure Date',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: currentMode == DateSelectionMode.departure 
                                  ? Theme.of(context).primaryColor
                                  : Colors.black,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            departureDate != null
                                ? '${departureDate!.day}/${departureDate!.month}/${departureDate!.year}'
                                : 'Select date',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        // Ensure departure date is set before switching to return mode
                        if (departureDate == null) {
                          final now = DateTime.now();
                          departureDate = DateTime(now.year, now.month, now.day);
                        }
                        currentMode = DateSelectionMode.returnDate;
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: currentMode == DateSelectionMode.returnDate 
                            ? Theme.of(context).primaryColor.withOpacity(0.1)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: currentMode == DateSelectionMode.returnDate 
                              ? Theme.of(context).primaryColor
                              : Colors.grey.shade300,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Return Date',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: currentMode == DateSelectionMode.returnDate 
                                  ? Theme.of(context).primaryColor
                                  : Colors.black,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            returnDate != null
                                ? '${returnDate!.day}/${returnDate!.month}/${returnDate!.year}'
                                : 'Select date',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Mode indicator
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Center(
              child: Text(
                currentMode == DateSelectionMode.departure 
                    ? 'Select Departure Date' 
                    : 'Select Return Date',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).primaryColor,
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
                if (departureDate != null || returnDate != null)
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        setState(() {
                          departureDate = null;
                          returnDate = null;
                          currentMode = DateSelectionMode.departure;
                        });
                      },
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text('Clear'),
                    ),
                  ),
                if (departureDate != null || returnDate != null)
                  SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: departureDate != null
                        ? () {
                            widget.onDatesSelected?.call(departureDate!, returnDate);
                            Navigator.pop(context);
                          }
                        : null,
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
    final startingWeekday = firstDayOfMonth.weekday % 7;
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
      final isDeparture = departureDate != null && _isSameDay(normalizedDate, departureDate!);
      final isReturn = returnDate != null && _isSameDay(normalizedDate, returnDate!);
      final isInRange = _isDateInRange(date);
      final normalizedDepartureDate = departureDate != null 
          ? DateTime(departureDate!.year, departureDate!.month, departureDate!.day)
          : null;
      
      final isDisabled = normalizedDate.isBefore(normalizedStartDate) || 
                        normalizedDate.isAfter(normalizedEndDate) ||
                        (currentMode == DateSelectionMode.returnDate && 
                         normalizedDepartureDate != null && 
                         normalizedDate.isBefore(normalizedDepartureDate));
      final price = _getPriceForDate(date);
      
      Color? backgroundColor;
      Color? borderColor;
      Color textColor = Colors.black;
      
      if (isDisabled) {
        textColor = Colors.grey.shade400;
      } else if (isDeparture || isReturn) {
        backgroundColor = Theme.of(context).primaryColor;
        textColor = Colors.white;
      } else if (isInRange) {
        backgroundColor = Theme.of(context).primaryColor.withOpacity(0.2);
        textColor = Theme.of(context).primaryColor;
      } else if (isToday) {
        backgroundColor = Theme.of(context).primaryColor.withOpacity(0.1);
        borderColor = Theme.of(context).primaryColor;
        textColor = Theme.of(context).primaryColor;
      }
      
      dayWidgets.add(
        GestureDetector(
          onTap: isDisabled ? null : () => _handleDateTap(date),
          child: Container(
            margin: EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(8),
              border: borderColor != null ? Border.all(color: borderColor) : null,
            ),
            child: Container(
              height: 60,
              padding: EdgeInsets.symmetric(vertical: 4),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Date number
                  Text(
                    day.toString(),
                    style: TextStyle(
                      color: textColor,
                      fontWeight: (isDeparture || isReturn || isToday)
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
                              ? Colors.grey.shade400
                              : (isDeparture || isReturn)
                                  ? Colors.white.withOpacity(0.9)
                                  : isInRange || isToday
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
        childAspectRatio: 0.8,
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

// Updated function to accept both departure and return dates
void showDatePickerBottomSheet(
  BuildContext context, {
  DateTime? initialDepartureDate,
  DateTime? initialReturnDate,
  Function(DateTime, DateTime?)? onDatesSelected,
  Map<DateTime, double>? prices,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    useRootNavigator: true,
    builder: (context) => DatePickerBottomSheet(
      initialDepartureDate: initialDepartureDate,
      initialReturnDate: initialReturnDate,
      onDatesSelected: onDatesSelected,
      prices: prices,
    ),
  );
}

// Example usage:
/*
Map<DateTime, double> samplePrices = {
  DateTime(2025, 7, 25): 150.0,
  DateTime(2025, 7, 26): 175.0,
  DateTime(2025, 7, 27): 200.0,
  DateTime(2025, 7, 28): 125.0,
  DateTime(2025, 7, 29): 180.0,
  DateTime(2025, 7, 30): 160.0,
};

showDatePickerBottomSheet(
  context,
  initialDepartureDate: DateTime.now(),
  initialReturnDate: null,
  prices: samplePrices,
  onDatesSelected: (departureDate, returnDate) {
    print('Departure: $departureDate');
    print('Return: $returnDate');
    // Handle the selected dates
  },
);
*/