import 'package:flutter/material.dart';

class PassengerDetailForm extends StatefulWidget {
  final String passengerType;
  
  const PassengerDetailForm({
    Key? key,
    this.passengerType = 'Adult',
  }) : super(key: key);

  @override
  State<PassengerDetailForm> createState() => _PassengerDetailFormState();
}

class _PassengerDetailFormState extends State<PassengerDetailForm> {
  String? selectedAge;
  DateTime? selectedDate;

  // Responsive font size getters based on MediaQuery width
  double get screenWidth => MediaQuery.of(context).size.width;

  double get headingFontSize =>
      (screenWidth * 0.04).clamp(12.0, 16.0); // 4% width, clamp 12-16

  double get buttonLabelFontSize =>
      (screenWidth * 0.03).clamp(10.0, 14.0); // 3.5% width, clamp 10-14

  double get bodyTextFontSize =>
      (screenWidth * 0.03).clamp(10.0, 14.0); // 4% width, clamp 10-14

  double get secondaryLabelFontSize =>
      (screenWidth * 0.03).clamp(10.0, 14.0); // 3.2% width, clamp 10-14

  String calculateAge(DateTime birthDate) {
    DateTime currentDate = DateTime.now();
    int age = currentDate.year - birthDate.year;
    int month1 = currentDate.month;
    int month2 = birthDate.month;
    if (month2 > month1) {
      age--;
    } else if (month1 == month2) {
      int day1 = currentDate.day;
      int day2 = birthDate.day;
      if (day2 > day1) {
        age--;
      }
    }

    // For infants, show age in months
    if (age == 0) {
      int months = currentDate.month - birthDate.month;
      if (currentDate.day < birthDate.day) {
        months--;
      }
      if (months < 0) {
        months += 12;
      }
      return '$months months';
    }

    return '$age years';
  }

  bool isValidAge(DateTime birthDate) {
    String age = calculateAge(birthDate);
    if (widget.passengerType == 'Adult') {
      return int.parse(age.split(' ')[0]) >= 12;
    } else if (widget.passengerType == 'Child') {
      int years = int.parse(age.split(' ')[0]);
      return years >= 2 && years < 12;
    } else if (widget.passengerType == 'Infant') {
      if (age.contains('months')) {
        return int.parse(age.split(' ')[0]) < 24;
      }
      return false;
    }
    return true;
  }

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
                Text(
                  'Passenger Details',
                  style: TextStyle(
                    fontSize: headingFontSize,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[800],
                  ),
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
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextField(
                          style: TextStyle(
                            fontSize: bodyTextFontSize,
                            color: Colors.grey[800],
                          ),
                          decoration: InputDecoration(
                            labelText: 'Full Name',
                            labelStyle: TextStyle(
                              fontSize: bodyTextFontSize,
                              color: Colors.grey[700],
                              fontWeight: FontWeight.w500,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: Colors.grey[300]!),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: Colors.grey[300]!),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 12,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Age Selector with Date Picker
                        GestureDetector(
                          onTap: () async {
                            final DateTime? picked = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now().subtract(Duration(days: widget.passengerType == 'Adult' ? 365 * 20 : 365 * 5)),
                              firstDate: DateTime.now().subtract(Duration(days: 365 * 100)),
                              lastDate: DateTime.now(),
                              helpText: 'Select Date of Birth',
                              confirmText: 'CONFIRM',
                              cancelText: 'CANCEL',
                              builder: (context, child) {
                                return Theme(
                                  data: Theme.of(context).copyWith(
                                    textTheme: TextTheme(
                                      labelSmall: TextStyle(
                                        fontSize: bodyTextFontSize,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    colorScheme: ColorScheme.light(
                                      primary: Theme.of(context).primaryColor,
                                      onPrimary: Colors.white,
                                      onSurface: Colors.grey[800]!,
                                    ),
                                    textButtonTheme: TextButtonThemeData(
                                      style: TextButton.styleFrom(
                                        foregroundColor: Theme.of(context).primaryColor,
                                        textStyle: TextStyle(
                                          fontSize: bodyTextFontSize,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),
                                  child: Container(
                                    child: child,
                                  ),
                                );
                              },
                            );
                            if (picked != null) {
                              setState(() {
                                final age = calculateAge(picked);
                                selectedAge = age;
                              });
                            }
                          },
                          child: AbsorbPointer(
                            child: TextField(
                              controller: TextEditingController(text: selectedAge ?? ''),
                              style: TextStyle(
                                fontSize: bodyTextFontSize,
                                color: Colors.grey[800],
                              ),
                              decoration: InputDecoration(
                                labelText: 'Date of Birth / Age',
                                labelStyle: TextStyle(
                                  fontSize: bodyTextFontSize,
                                  color: Colors.grey[700],
                                  fontWeight: FontWeight.w500,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(color: Colors.grey[300]!),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(color: Colors.grey[300]!),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                                suffixIcon: Icon(
                                  Icons.calendar_today,
                                  size: 20,
                                  color: Colors.grey[600],
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 12,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          style: TextStyle(
                            fontSize: bodyTextFontSize,
                            color: Colors.grey[800],
                          ),
                          decoration: InputDecoration(
                            labelText: 'Email',
                            labelStyle: TextStyle(
                              fontSize: bodyTextFontSize,
                              color: Colors.grey[700],
                              fontWeight: FontWeight.w500,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: Colors.grey[300]!),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: Colors.grey[300]!),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 12,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Phone Number with Country Code
                        IntrinsicHeight(
                          child: Row(
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 12,
                                ),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey[300]!),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text('🇮🇳', 
                                      style: TextStyle(
                                        fontSize: bodyTextFontSize,
                                      )
                                    ),
                                    SizedBox(width: 4),
                                    Text(
                                      '+91',
                                      style: TextStyle(
                                        fontSize: bodyTextFontSize,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.grey[700],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 8),
                              Expanded(
                                child: TextField(
                                  style: TextStyle(
                                    fontSize: bodyTextFontSize,
                                    color: Colors.grey[800],
                                  ),
                                  decoration: InputDecoration(
                                    labelText: 'Phone Number',
                                    labelStyle: TextStyle(
                                      fontSize: bodyTextFontSize,
                                      color: Colors.grey[700],
                                      fontWeight: FontWeight.w500,
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: BorderSide(color: Colors.grey[300]!),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: BorderSide(color: Colors.grey[300]!),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: BorderSide(
                                        color: Theme.of(context).primaryColor,
                                      ),
                                    ),
                                    contentPadding: EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 12,
                                    ),
                                  ),
                                  keyboardType: TextInputType.phone,
                                ),
                              ),
                            ],
                          ),
                        ),
                        
                      ],
                    ),
                  ),
                 
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}



void showPassengersBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    builder: (context) {
      return PassengerDetailForm();
    },
  );
}