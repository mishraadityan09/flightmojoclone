import 'package:flutter/material.dart';

class DatePickerBottomSheet extends StatefulWidget {
  final DateTime? initialDate;
  final Function(DateTime)? onDateSelected;

  const DatePickerBottomSheet({
    Key? key,
    this.initialDate,
    this.onDateSelected,
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
    selectedDate = widget.initialDate ?? DateTime.now();
    startDate = DateTime.now();
    endDate = DateTime.now().add(Duration(days: 360));
    
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
      current = DateTime(current.year, current.month + 1, 1);
    }
    
    return monthsList;
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
                  icon: Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          
          // Month/Year display (removed navigation arrows)
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
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text('Cancel'),
                  ),
                ),
                SizedBox(width: 16),
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
                    child: Text('Select'),
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
      final isToday = _isSameDay(date, DateTime.now());
      final isSelected = _isSameDay(date, selectedDate);
      final isDisabled = date.isBefore(startDate) || date.isAfter(endDate);
      
      dayWidgets.add(
        GestureDetector(
          onTap: isDisabled
              ? null
              : () {
                  setState(() {
                    selectedDate = date;
                  });
                },
          child: Container(
            margin: EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: isSelected
                  ? Theme.of(context).primaryColor
                  : isToday
                      ? Theme.of(context).primaryColor.withOpacity(0.1)
                      : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
              border: isToday && !isSelected
                  ? Border.all(color: Theme.of(context).primaryColor)
                  : null,
            ),
            child: Container(
              height: 40,
              child: Center(
                child: Text(
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
                  ),
                ),
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
        childAspectRatio: 1,
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

// Helper function to show the bottom sheet
void showDatePickerBottomSheet(
  BuildContext context, {
  DateTime? initialDate,
  Function(DateTime)? onDateSelected,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    useRootNavigator: true,
    backgroundColor: Colors.transparent,
    builder: (context) => DatePickerBottomSheet(
      initialDate: initialDate,
      onDateSelected: onDateSelected,
    ),
  );
}

// Updated GestureDetector code for your existing implementation
// GestureDetector buildDateSelector(String label, String value) {
//   return GestureDetector(
//     onTap: () {
//       // Parse current date if available
//       DateTime? initialDate;
//       if (value != 'Select date') {
//         try {
//           List<String> parts = value.split('/');
//           if (parts.length == 3) {
//             initialDate = DateTime(
//               int.parse(parts[2]), // year
//               int.parse(parts[1]), // month
//               int.parse(parts[0]), // day
//             );
//           }
//         } catch (e) {
//           // If parsing fails, use current date
//           initialDate = DateTime.now();
//         }
//       } else {
//         initialDate = DateTime.now();
//       }

//       // Show custom date picker bottom sheet
//       showDatePickerBottomSheet(
//         context,
//         initialDate: initialDate,
//         onDateSelected: (picked) {
//           setState(() {
//             if (label == 'Departure') {
//               _departureDate = "${picked.day}/${picked.month}/${picked.year}";
//             } else {
//               _returnDate = "${picked.day}/${picked.month}/${picked.year}";
//             }
//           });
//         },
//       );
//     },
//     child: Container(
//       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
//       decoration: BoxDecoration(
//         border: Border.all(color: Colors.grey[300]!),
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: Row(
//         children: [
//           Icon(
//             Icons.calendar_today,
//             color: Theme.of(context).primaryColor,
//             size: 20,
//           ),
//           const SizedBox(width: 8),
//           Expanded(
//             child: Text(
//               value,
//               style: GoogleFonts.poppins(
//                 fontSize: 16,
//                 fontWeight: FontWeight.w500,
//               ),
//               overflow: TextOverflow.ellipsis,
//             ),
//           ),
//         ],
//       ),
//     ),
//   );
// }

// Example usage widget
class DatePickerExample extends StatefulWidget {
  @override
  _DatePickerExampleState createState() => _DatePickerExampleState();
}

class _DatePickerExampleState extends State<DatePickerExample> {
  DateTime? selectedDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Date Picker Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              selectedDate != null
                  ? 'Selected: ${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}'
                  : 'No date selected',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                showDatePickerBottomSheet(
                  context,
                  initialDate: selectedDate ?? DateTime.now(),
                  onDateSelected: (date) {
                    setState(() {
                      selectedDate = date;
                    });
                  },
                );
              },
              child: Text('Select Date'),
            ),
          ],
        ),
      ),
    );
  }
}