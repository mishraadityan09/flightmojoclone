import 'package:flutter/material.dart';

class PassengersBottomSheet extends StatefulWidget {
  const PassengersBottomSheet({super.key});

  @override
  _PassengersBottomSheetState createState() => _PassengersBottomSheetState();
}

class _PassengersBottomSheetState extends State<PassengersBottomSheet> {
  int _adultCount = 0;
  int _childCount = 0;
  int _infantCount = 0;
  String _travelClass = 'Economy';

  // Responsive font size getters based on MediaQuery width
  double _getScreenWidth(BuildContext context) => MediaQuery.of(context).size.width;

  double _getHeaderFontSize(BuildContext context) =>
      (_getScreenWidth(context) * 0.04).clamp(14.0, 16.0); // Header font size

  double _getTitleFontSize(BuildContext context) =>
      (_getScreenWidth(context) * 0.03).clamp(14.0, 16.0); // Titles like "Adults", "Children"

  double _getSubtitleFontSize(BuildContext context) =>
      (_getScreenWidth(context) * 0.03).clamp(10.0, 12.0); // Age descriptions

  double _getCounterFontSize(BuildContext context) =>
      (_getScreenWidth(context) * 0.03).clamp(14.0, 16.0); // Counter numbers

  double _getTravelClassTitleFontSize(BuildContext context) =>
      (_getScreenWidth(context) * 0.04).clamp(14.0, 16.0); // Travel class title

  double _getChoiceChipFontSize(BuildContext context) =>
      (_getScreenWidth(context) * 0.03).clamp(12.0, 16.0); // Choice chip labels

  double _getButtonFontSize(BuildContext context) =>
      (_getScreenWidth(context) * 0.04).clamp(14.0, 18.0); // Button text

  // Responsive padding
  double _getPadding(BuildContext context) {
    final screenWidth = _getScreenWidth(context);
    return (screenWidth * 0.025).clamp(8.0, 16.0);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(_getPadding(context), 0, _getPadding(context), 15),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                icon: Icon(Icons.close, color: Colors.black),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                'Traveler(s) & Class',
                style: TextStyle(
                  fontSize: _getHeaderFontSize(context),
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              )
            ],
          ),
          Column(
            children: [
              ListTile(
                title: Text(
                  'Adults',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: _getTitleFontSize(context),
                    color: Colors.black,
                  ),
                ),
                subtitle: Text(
                  'Above 12 years',
                  style: TextStyle(
                    fontSize: _getSubtitleFontSize(context), 
                    color: Colors.grey[600]
                  ),
                ),
                trailing: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: _getPadding(context) * 0.5),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.remove, color: Colors.black),
                        onPressed: () {
                          if (_adultCount > 0) {
                            setState(() {
                              _adultCount--;
                              // Adjust child and infant counts if needed
                              if (_childCount > _adultCount * 2) {
                                _childCount = _adultCount * 2;
                              }
                              if (_infantCount > _adultCount) {
                                _infantCount = _adultCount;
                              }
                            });
                          }
                        },
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: _getPadding(context),
                          vertical: _getPadding(context),
                        ),
                        child: Text(
                          _adultCount.toString(),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: _getCounterFontSize(context),
                            color: Colors.black,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.add, color: Colors.black),
                        onPressed:
                            (_adultCount + _childCount + _infantCount) < 9
                            ? () {
                                setState(() {
                                  _adultCount++;
                                });
                              }
                            : null,
                      ),
                    ],
                  ),
                ),
              ),
              ListTile(
                title: Text(
                  'Children',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: _getTitleFontSize(context),
                    color: Colors.black,
                  ),
                ),
                subtitle: Text(
                  '2-12 years',
                  style: TextStyle(
                    fontSize: _getSubtitleFontSize(context), 
                    color: Colors.grey[600]
                  ),
                ),
                trailing: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: _getPadding(context) * 0.5),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.remove, color: Colors.black),
                        onPressed: _childCount > 0
                            ? () {
                                setState(() {
                                  _childCount--;
                                });
                              }
                            : null,
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: _getPadding(context),
                          vertical: _getPadding(context),
                        ),
                        child: Text(
                          _childCount.toString(),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: _getCounterFontSize(context),
                            color: Colors.black,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.add, color: Colors.black),
                        onPressed:
                            (_childCount < _adultCount * 2) &&
                                (_adultCount + _childCount + _infantCount) < 9
                            ? () {
                                setState(() {
                                  _childCount++;
                                });
                              }
                            : null,
                      ),
                    ],
                  ),
                ),
              ),
              ListTile(
                title: Text(
                  'Infants',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: _getTitleFontSize(context),
                    color: Colors.black,
                  ),
                ),
                subtitle: Text(
                  '0-2 years',
                  style: TextStyle(
                    fontSize: _getSubtitleFontSize(context), 
                    color: Colors.grey[600]
                  ),
                ),
                trailing: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: _getPadding(context) * 0.5),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.remove, color: Colors.black),
                        onPressed: _infantCount > 0
                            ? () {
                                setState(() {
                                  _infantCount--;
                                });
                              }
                            : null,
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: _getPadding(context),
                          vertical: _getPadding(context),
                        ),
                        child: Text(
                          _infantCount.toString(),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: _getCounterFontSize(context),
                            color: Colors.black,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.add, color: Colors.black),
                        onPressed:
                            (_infantCount < _adultCount) &&
                                (_adultCount + _childCount + _infantCount) < 9
                            ? () {
                                setState(() {
                                  _infantCount++;
                                });
                              }
                            : null,
                      ),
                    ],
                  ),
                ),
              ),
              ListTile(
                title: Text(
                  'Travel Class',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: _getTravelClassTitleFontSize(context),
                    color: Colors.black,
                  ),
                ),
                subtitle: Padding(
                  padding: EdgeInsets.only(top: _getPadding(context)),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: SizedBox(
                                  height: 48,
                                  child: ChoiceChip(
                                    label: SizedBox(
                                      width: double.infinity,
                                      child: Text(
                                        'Economy',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: _getChoiceChipFontSize(context),
                                          color: _travelClass == 'Economy'
                                              ? Colors.white
                                              : Colors.black,
                                        ),
                                      ),
                                    ),
                                    selected: _travelClass == 'Economy',
                                    onSelected: (selected) {
                                      if (selected) {
                                        setState(
                                          () => _travelClass = 'Economy',
                                        );
                                      }
                                    },
                                    backgroundColor: Colors.grey[200],
                                    selectedColor: Theme.of(
                                      context,
                                    ).primaryColor,
                                    side: BorderSide(
                                      width: 1.5,
                                      color: _travelClass == 'Economy'
                                          ? Theme.of(context).primaryColor
                                          : Colors.grey[300]!,
                                    ),
                                    showCheckmark: false,
                                  ),
                                ),
                              ),
                              SizedBox(width: _getPadding(context)),
                              Expanded(
                                child: SizedBox(
                                  height: 48,
                                  child: ChoiceChip(
                                    label: SizedBox(
                                      width: double.infinity,
                                      child: Text(
                                        'Premium Economy',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: _getChoiceChipFontSize(context),
                                          color:
                                              _travelClass == 'Premium Economy'
                                              ? Colors.white
                                              : Colors.black,
                                        ),
                                      ),
                                    ),
                                    selected: _travelClass == 'Premium Economy',
                                    onSelected: (selected) {
                                      if (selected) {
                                        setState(
                                          () =>
                                              _travelClass = 'Premium Economy',
                                        );
                                      }
                                    },
                                    backgroundColor: Colors.grey[200],
                                    selectedColor: Theme.of(
                                      context,
                                    ).primaryColor,
                                    side: BorderSide(
                                      width: 1.5,
                                      color: _travelClass == 'Premium Economy'
                                          ? Theme.of(context).primaryColor
                                          : Colors.grey[300]!,
                                    ),
                                    showCheckmark: false,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: _getPadding(context)),
                          Row(
                            children: [
                              Expanded(
                                child: SizedBox(
                                  height: 48,
                                  child: ChoiceChip(
                                    label: SizedBox(
                                      width: double.infinity,
                                      child: Text(
                                        'Business',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: _getChoiceChipFontSize(context),
                                          color: _travelClass == 'Business'
                                              ? Colors.white
                                              : Colors.black,
                                        ),
                                      ),
                                    ),
                                    selected: _travelClass == 'Business',
                                    onSelected: (selected) {
                                      if (selected) {
                                        setState(
                                          () => _travelClass = 'Business',
                                        );
                                      }
                                    },
                                    backgroundColor: Colors.grey[200],
                                    selectedColor: Theme.of(
                                      context,
                                    ).primaryColor,
                                    side: BorderSide(
                                      width: 1.5,
                                      color: _travelClass == 'Business'
                                          ? Theme.of(context).primaryColor
                                          : Colors.grey[300]!,
                                    ),
                                    showCheckmark: false,
                                  ),
                                ),
                              ),
                              SizedBox(width: _getPadding(context)),
                              Expanded(
                                child: SizedBox(
                                  height: 48,
                                  child: ChoiceChip(
                                    label: SizedBox(
                                      width: double.infinity,
                                      child: Text(
                                        'First Class',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: _getChoiceChipFontSize(context),
                                          color: _travelClass == 'First Class'
                                              ? Colors.white
                                              : Colors.black,
                                        ),
                                      ),
                                    ),
                                    selected: _travelClass == 'First Class',
                                    onSelected: (selected) {
                                      if (selected) {
                                        setState(
                                          () => _travelClass = 'First Class',
                                        );
                                      }
                                    },
                                    backgroundColor: Colors.grey[200],
                                    selectedColor: Theme.of(
                                      context,
                                    ).primaryColor,
                                    side: BorderSide(
                                      width: 1.5,
                                      color: _travelClass == 'First Class'
                                          ? Theme.of(context).primaryColor
                                          : Colors.grey[300]!,
                                    ),
                                    showCheckmark: false,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: _getPadding(context) * 2),
                child: ElevatedButton(
                  onPressed: () {
                    // Pass the selected data back as a Map
                    Navigator.of(context).pop({
                      'adultCount': _adultCount,
                      'childCount': _childCount,
                      'infantCount': _infantCount,
                      'travelClass': _travelClass,
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Done',
                    style: TextStyle(
                      fontSize: _getButtonFontSize(context),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
