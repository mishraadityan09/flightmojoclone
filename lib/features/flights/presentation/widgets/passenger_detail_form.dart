import 'package:flutter/material.dart';


class PassengerDetailForm extends StatefulWidget {
  final int passengerIndex;
  final String passengerType;
  final int numberOfPassengers;
  final Function(int, Map<String, dynamic>) onDataChanged;

  const PassengerDetailForm({
    super.key,
    required this.passengerIndex,
    this.passengerType = 'Adult',
    required this.numberOfPassengers,
    required this.onDataChanged,
  });

  @override
  State<PassengerDetailForm> createState() => _PassengerDetailFormState();
}

class _PassengerDetailFormState extends State<PassengerDetailForm> {
  String? selectedAge;
  DateTime? selectedDate;
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;

  String selectedCountryCode = '+91'; // Default to India
  String selectedCountryFlag = '🇮🇳'; // Default to India flag

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    emailController = TextEditingController();
    phoneController = TextEditingController();

    //Listen to the changes and notify the parent
    nameController.addListener(_handleDataChanged);
    emailController.addListener(_handleDataChanged);
    phoneController.addListener(_handleDataChanged);
  }

  void _handleDataChanged() {
    // Combine country code and phone number
    String fullPhoneNumber = phoneController.text.isNotEmpty 
        ? '$selectedCountryCode${phoneController.text}' 
        : '';
    
    widget.onDataChanged(widget.passengerIndex, {
      'name': nameController.text,
      'email': emailController.text,
      'phone': fullPhoneNumber,
      'age': selectedAge,
    });
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    super.dispose();
  }

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

  // List of all countries
  List<Map<String, String>> get allCountries => [
    {'flag': '🇮🇳', 'name': 'India', 'code': '+91'},
    {'flag': '🇺🇸', 'name': 'United States', 'code': '+1'},
    {'flag': '🇬🇧', 'name': 'United Kingdom', 'code': '+44'},
    {'flag': '🇨🇦', 'name': 'Canada', 'code': '+1'},
    {'flag': '🇦🇺', 'name': 'Australia', 'code': '+61'},
    {'flag': '🇩🇪', 'name': 'Germany', 'code': '+49'},
    {'flag': '🇫🇷', 'name': 'France', 'code': '+33'},
    {'flag': '🇯🇵', 'name': 'Japan', 'code': '+81'},
    {'flag': '🇨🇳', 'name': 'China', 'code': '+86'},
    {'flag': '🇧🇷', 'name': 'Brazil', 'code': '+55'},
    {'flag': '🇷🇺', 'name': 'Russia', 'code': '+7'},
    {'flag': '🇰🇷', 'name': 'South Korea', 'code': '+82'},
    {'flag': '🇸🇬', 'name': 'Singapore', 'code': '+65'},
    {'flag': '🇦🇪', 'name': 'UAE', 'code': '+971'},
    {'flag': '🇸🇦', 'name': 'Saudi Arabia', 'code': '+966'},
    {'flag': '🇮🇹', 'name': 'Italy', 'code': '+39'},
    {'flag': '🇪🇸', 'name': 'Spain', 'code': '+34'},
    {'flag': '🇳🇱', 'name': 'Netherlands', 'code': '+31'},
    {'flag': '🇧🇪', 'name': 'Belgium', 'code': '+32'},
    {'flag': '🇨🇭', 'name': 'Switzerland', 'code': '+41'},
    {'flag': '🇦🇹', 'name': 'Austria', 'code': '+43'},
    {'flag': '🇵🇹', 'name': 'Portugal', 'code': '+351'},
    {'flag': '🇸🇪', 'name': 'Sweden', 'code': '+46'},
    {'flag': '🇳🇴', 'name': 'Norway', 'code': '+47'},
    {'flag': '🇩🇰', 'name': 'Denmark', 'code': '+45'},
    {'flag': '🇫🇮', 'name': 'Finland', 'code': '+358'},
    {'flag': '🇵🇱', 'name': 'Poland', 'code': '+48'},
    {'flag': '🇨🇿', 'name': 'Czech Republic', 'code': '+420'},
    {'flag': '🇭🇺', 'name': 'Hungary', 'code': '+36'},
    {'flag': '🇷🇴', 'name': 'Romania', 'code': '+40'},
    {'flag': '🇧🇬', 'name': 'Bulgaria', 'code': '+359'},
    {'flag': '🇬🇷', 'name': 'Greece', 'code': '+30'},
    {'flag': '🇹🇷', 'name': 'Turkey', 'code': '+90'},
    {'flag': '🇮🇱', 'name': 'Israel', 'code': '+972'},
    {'flag': '🇪🇬', 'name': 'Egypt', 'code': '+20'},
    {'flag': '🇿🇦', 'name': 'South Africa', 'code': '+27'},
    {'flag': '🇳🇬', 'name': 'Nigeria', 'code': '+234'},
    {'flag': '🇰🇪', 'name': 'Kenya', 'code': '+254'},
    {'flag': '🇲🇽', 'name': 'Mexico', 'code': '+52'},
    {'flag': '🇦🇷', 'name': 'Argentina', 'code': '+54'},
    {'flag': '🇨🇱', 'name': 'Chile', 'code': '+56'},
    {'flag': '🇨🇴', 'name': 'Colombia', 'code': '+57'},
    {'flag': '🇵🇪', 'name': 'Peru', 'code': '+51'},
    {'flag': '🇻🇪', 'name': 'Venezuela', 'code': '+58'},
    {'flag': '🇹🇭', 'name': 'Thailand', 'code': '+66'},
    {'flag': '🇻🇳', 'name': 'Vietnam', 'code': '+84'},
    {'flag': '🇵🇭', 'name': 'Philippines', 'code': '+63'},
    {'flag': '🇲🇾', 'name': 'Malaysia', 'code': '+60'},
    {'flag': '🇮🇩', 'name': 'Indonesia', 'code': '+62'},
    {'flag': '🇳🇿', 'name': 'New Zealand', 'code': '+64'},
  ];

  // Country selection bottom sheet with search
  void _showCountryPicker() {
    String searchQuery = '';
    List<Map<String, String>> filteredCountries = List.from(allCountries);
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.8,
              child: Column(
                children: [
                  // Header
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Colors.grey[200]!),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Select Country',
                          style: TextStyle(
                            fontSize: headingFontSize,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Icon(Icons.close, size: 24),
                        ),
                      ],
                    ),
                  ),
                  
                  // Search Field
                  Container(
                    padding: EdgeInsets.all(16),
                    child: TextFormField(
                      initialValue: searchQuery,
                      style: TextStyle(
                        fontSize: bodyTextFontSize,
                        color: Colors.grey[800],
                      ),
                      decoration: InputDecoration(
                        hintText: 'Search country...',
                        hintStyle: TextStyle(
                          fontSize: bodyTextFontSize,
                          color: Colors.grey[500],
                        ),
                        prefixIcon: Icon(
                          Icons.search,
                          color: Colors.grey[600],
                          size: 20,
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
                      onChanged: (value) {
                        setModalState(() {
                          searchQuery = value;
                          filteredCountries = allCountries
                              .where((country) =>
                                  country['name']!
                                      .toLowerCase()
                                      .contains(value.toLowerCase()) ||
                                  country['code']!
                                      .toLowerCase()
                                      .contains(value.toLowerCase()))
                              .toList();
                        });
                      },
                    ),
                  ),
                  
                  // Countries List
                  Expanded(
                    child: ListView.builder(
                      itemCount: filteredCountries.length,
                      itemBuilder: (context, index) {
                        final country = filteredCountries[index];
                        return _buildCountryTile(
                          country['flag']!,
                          country['name']!,
                          country['code']!,
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildCountryTile(String flag, String country, String code) {
    return ListTile(
      leading: Text(flag, style: TextStyle(fontSize: 24)),
      title: Text(
        country,
        style: TextStyle(
          fontSize: bodyTextFontSize,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: Text(
        code,
        style: TextStyle(
          fontSize: bodyTextFontSize,
          color: Colors.grey[600],
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: () {
        setState(() {
          selectedCountryCode = code;
          selectedCountryFlag = flag;
        });
        _handleDataChanged();
        Navigator.pop(context);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        controller: nameController,
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
                            initialDate: DateTime.now().subtract(
                              Duration(
                                days: widget.passengerType == 'Adult'
                                    ? 365 * 20
                                    : 365 * 5,
                              ),
                            ),
                            firstDate: DateTime.now().subtract(
                              Duration(days: 365 * 100),
                            ),
                            lastDate: DateTime.now(),
                            helpText: 'Select Date of Birth',
                            confirmText: 'CONFIRM',
                            cancelText: 'CANCEL',
                            builder: (context, child) {
                              return Theme(
                                data: Theme.of(context).copyWith(
                                  textTheme: TextTheme(
                                    // Calendar header (year/month)
                                    headlineMedium: TextStyle(
                                      fontSize: bodyTextFontSize,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.grey[800],
                                    ),
                                    // Calendar day labels (Mon, Tue, etc.)
                                    labelSmall: TextStyle(
                                      fontSize: bodyTextFontSize * 0.9,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.grey[600],
                                    ),
                                    // Calendar day numbers
                                    bodyMedium: TextStyle(
                                      fontSize: bodyTextFontSize,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.grey[800],
                                    ),
                                    // Help text
                                    bodyLarge: TextStyle(
                                      fontSize: bodyTextFontSize,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.grey[800],
                                    ),
                                  ),
                                  colorScheme: ColorScheme.light(
                                    primary: Theme.of(context).primaryColor,
                                    onPrimary: Colors.white,
                                    onSurface: Colors.grey[800]!,
                                    surface: Colors.white,
                                  ),
                                  textButtonTheme: TextButtonThemeData(
                                    style: TextButton.styleFrom(
                                      foregroundColor: Theme.of(
                                        context,
                                      ).primaryColor,
                                      textStyle: TextStyle(
                                        fontSize: bodyTextFontSize,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  // Ensure consistent button styling
                                  elevatedButtonTheme:
                                      ElevatedButtonThemeData(
                                        style: ElevatedButton.styleFrom(
                                          textStyle: TextStyle(
                                            fontSize: bodyTextFontSize,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                  // Calendar day picker theme
                                  datePickerTheme: DatePickerThemeData(
                                    headerHelpStyle: TextStyle(
                                      fontSize: bodyTextFontSize,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.grey[800],
                                    ),
                                    headerHeadlineStyle: TextStyle(
                                      fontSize: bodyTextFontSize,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.grey[800],
                                    ),
                                    dayStyle: TextStyle(
                                      fontSize: bodyTextFontSize,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.grey[800],
                                    ),
                                    weekdayStyle: TextStyle(
                                      fontSize: bodyTextFontSize * 0.9,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                  // Dialog theme for consistent styling
                                  dialogTheme: DialogThemeData(
                                    titleTextStyle: TextStyle(
                                      fontSize: bodyTextFontSize,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.grey[800],
                                    ),
                                    contentTextStyle: TextStyle(
                                      fontSize: bodyTextFontSize,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.grey[800],
                                    ),
                                  ),
                                ),
                                child: Container(child: child),
                              );
                            },
                          );
                          if (picked != null) {
                            setState(() {
                              final age = calculateAge(picked);
                              selectedAge = age;
                              _handleDataChanged(); // Add this line to notify parent of age change
                            });
                          }
                        },
                        child: AbsorbPointer(
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey[300]!),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    selectedAge ?? 'Select Date of Birth',
                                    style: TextStyle(
                                      fontSize: bodyTextFontSize,
                                      color: selectedAge != null ? Colors.grey[800] : Colors.grey[500],
                                    ),
                                  ),
                                ),
                                Icon(
                                  Icons.calendar_today,
                                  size: 20,
                                  color: Colors.grey[600],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: emailController,
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
                      
                      // Phone Number Section with Two Separate Boxes
                      Text(
                        'Phone Number',
                        style: TextStyle(
                          fontSize: bodyTextFontSize,
                          color: Colors.grey[700],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Country Code Box
                          GestureDetector(
                            onTap: _showCountryPicker,
                            child: Container(
                              height: 48, // Fixed height to match TextFormField
                              padding: EdgeInsets.symmetric(
                                horizontal: 12,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey[300]!),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    selectedCountryFlag,
                                    style: TextStyle(fontSize: 20),
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    selectedCountryCode,
                                    style: TextStyle(
                                      fontSize: bodyTextFontSize,
                                      color: Colors.grey[800],
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(width: 4),
                                  Icon(
                                    Icons.arrow_drop_down,
                                    color: Colors.grey[600],
                                    size: 20,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          // Phone Number Input Box
                          Expanded(
                            child: TextFormField(
                              controller: phoneController,
                              keyboardType: TextInputType.phone,
                              style: TextStyle(
                                fontSize: bodyTextFontSize,
                                color: Colors.grey[800],
                              ),
                              decoration: InputDecoration(
                                hintText: 'Enter phone number',
                                hintStyle: TextStyle(
                                  fontSize: bodyTextFontSize,
                                  color: Colors.grey[500],
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
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
            
               
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class PassengerFormWidget extends StatefulWidget {
  final int numberOfPassengers;
  final String passengerType;

  const PassengerFormWidget({
    super.key,
    required this.numberOfPassengers,
    required this.passengerType,
  });
  @override
  State<PassengerFormWidget> createState() => _PassengerFormWidgetState();
}

class _PassengerFormWidgetState extends State<PassengerFormWidget> {
  Map<int, Map<String, dynamic>> passengerData = {};

  // Responsive font size getters based on MediaQuery width
  double get screenWidth => MediaQuery.of(context).size.width;

  double get headingFontSize =>
      (screenWidth * 0.04).clamp(12.0, 16.0); // 4% width, clamp 12-16


  double get buttonFontSize =>
      (screenWidth * 0.035).clamp(10.0, 14.0); // 3.5% width, clamp 10-14

  void _onPassengerDataChanged(int index, Map<String, dynamic> data) {
    setState(() {
      passengerData[index] = data;
    });
  }

  void _handleSubmit() {
    // Check if all required fields are filled
    bool allFieldsFilled = true;
    String missingFields = '';
    
    for (int i = 0; i < widget.numberOfPassengers; i++) {
      if (passengerData[i] == null) {
        allFieldsFilled = false;
        missingFields += '${widget.passengerType} ${i + 1}, ';
        continue;
      }
      
      Map<String, dynamic> data = passengerData[i]!;
      if (data['name']?.toString().trim().isEmpty ?? true) {
        allFieldsFilled = false;
        missingFields += '${widget.passengerType} ${i + 1} Name, ';
      }
      if (data['age'] == null) {
        allFieldsFilled = false;
        missingFields += '${widget.passengerType} ${i + 1} Age, ';
      }
      if (data['phone']?.toString().trim().isEmpty ?? true) {
        allFieldsFilled = false;
        missingFields += '${widget.passengerType} ${i + 1} Phone, ';
      }
    }
    
    if (!allFieldsFilled) {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please fill all required fields: ${missingFields.substring(0, missingFields.length - 2)}'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );
      return;
    }
    
    // All fields are filled, proceed with submission
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Passenger details submitted successfully!'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );
    
    // You can add your submission logic here
    // For example, send data to API, navigate to next screen, etc.
    print('Passenger Data: $passengerData');
    
    // Close the bottom sheet after successful submission
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
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
          child: ListView.builder(
            itemBuilder: (context, index) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Passenger Label (shows above the form)
                Container(
                  padding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    border: Border(
                      bottom: BorderSide(color: Colors.grey[200]!, width: 1),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Theme.of(context).primaryColor.withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: Text(
                          '${widget.passengerType} ${index + 1}',
                          style: TextStyle(
                            fontSize: headingFontSize * 0.9,
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
                     
                    ],
                  ),
                ),
                // Passenger Form
                PassengerDetailForm(
                  passengerIndex: index,
                  passengerType: widget.passengerType,
                  numberOfPassengers: widget.numberOfPassengers,
                  onDataChanged: _onPassengerDataChanged,
                ),
              ],
            ),
            itemCount: widget.numberOfPassengers,
          ),
        ),
         // Submit Button
         Container(
           padding: EdgeInsets.all(20),
           decoration: BoxDecoration(
             color: Colors.white,
             border: Border(
               top: BorderSide(color: Colors.grey[200]!, width: 1),
             ),
           ),
           child: SizedBox(
             width: screenWidth*0.5,
             child: ElevatedButton(
               onPressed: () {
                 // Handle submit action
                 _handleSubmit();
               },
               style: ElevatedButton.styleFrom(
                 backgroundColor: Theme.of(context).primaryColor,
                 foregroundColor: Colors.white,
                 padding: EdgeInsets.symmetric(vertical: 8),
                 shape: RoundedRectangleBorder(
                   borderRadius: BorderRadius.circular(12),
                 ),
                 elevation: 2,
               ),
               child: Text(
                 'Submit Passenger Details',
                 style: TextStyle(
                   fontSize: buttonFontSize,
                   fontWeight: FontWeight.w600,
                 ),
               ),
             ),
           ),
         ),
      ],
    );
  }
}

void showPassengersBottomSheet(BuildContext context, int numberOfPassengers, String passengerType) {
  showModalBottomSheet(
    isScrollControlled: true,
    useSafeArea: true,
    constraints: BoxConstraints(
      maxHeight: MediaQuery.of(context).size.height * 0.8,
    ),
    context: context,
    builder: (context) {
      return PassengerFormWidget(
        numberOfPassengers: numberOfPassengers,
        passengerType: passengerType,
      );
    },
  );
}