import 'package:flutter/material.dart';

class PassengersBottomSheet extends StatefulWidget {
  const PassengersBottomSheet({Key? key}) : super(key: key);

  @override
  _PassengersBottomSheetState createState() => _PassengersBottomSheetState();
}

class _PassengersBottomSheetState extends State<PassengersBottomSheet> {
  int _adultCount = 0;
  int _childCount = 0;
  int _infantCount = 0;
  String _travelClass = 'Economy';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 15),
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
            children: [Text('Traveler(s) & Class')],
          ),
          Column(
            children: [
              ListTile(
                title: Text(
                  'Adults',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                  subtitle: Text(
    'Above 12 years',
    style: TextStyle(
      fontSize: 12,
      color: Colors.grey[600],
    ),
  ),
                
                trailing: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 4),
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
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 8,
                        ),
                        child: Text(
                          _adultCount.toString(),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
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
                    color: Colors.black,
                  ),
                ),
                subtitle: Text(
    '2-12 years',
    style: TextStyle(
      fontSize: 12,
      color: Colors.grey[600],
    ),
  ),
                trailing: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 4),
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
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 8,
                        ),
                        child: Text(
                          _childCount.toString(),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
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
                    color: Colors.black,
                  ),
                ),
                  subtitle: Text(
    '0-2 years',
    style: TextStyle(
      fontSize: 12,
      color: Colors.grey[600],
    ),
  ),
                trailing: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 4),
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
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 8,
                        ),
                        child: Text(
                          _infantCount.toString(),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
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
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      // Calculate width for each chip to make them equal
                      double chipWidth =
                          (constraints.maxWidth - 24) /
                          2; // 2 chips per row with spacing

                      return Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  height: 48,
                                  child: ChoiceChip(
                                    label: Container(
                                      width: double.infinity,
                                      child: Text(
                                        'Economy',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: _travelClass == 'Economy'
                                              ? Colors.white
                                              : Colors.black,
                                        ),
                                      ),
                                    ),
                                    selected: _travelClass == 'Economy',
                                    onSelected: (selected) {
                                      if (selected)
                                        setState(
                                          () => _travelClass = 'Economy',
                                        );
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
                              SizedBox(width: 8),
                              Expanded(
                                child: Container(
                                  height: 48,
                                  child: ChoiceChip(
                                    label: Container(
                                      width: double.infinity,
                                      child: Text(
                                        'Premium Economy',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color:
                                              _travelClass == 'Premium Economy'
                                              ? Colors.white
                                              : Colors.black,
                                        ),
                                      ),
                                    ),
                                    selected: _travelClass == 'Premium Economy',
                                    onSelected: (selected) {
                                      if (selected)
                                        setState(
                                          () =>
                                              _travelClass = 'Premium Economy',
                                        );
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
                          SizedBox(height: 8),
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  height: 48,
                                  child: ChoiceChip(
                                    label: Container(
                                      width: double.infinity,
                                      child: Text(
                                        'Business',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: _travelClass == 'Business'
                                              ? Colors.white
                                              : Colors.black,
                                        ),
                                      ),
                                    ),
                                    selected: _travelClass == 'Business',
                                    onSelected: (selected) {
                                      if (selected)
                                        setState(
                                          () => _travelClass = 'Business',
                                        );
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
                              SizedBox(width: 8),
                              Expanded(
                                child: Container(
                                  height: 48,
                                  child: ChoiceChip(
                                    label: Container(
                                      width: double.infinity,
                                      child: Text(
                                        'First Class',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: _travelClass == 'First Class'
                                              ? Colors.white
                                              : Colors.black,
                                        ),
                                      ),
                                    ),
                                    selected: _travelClass == 'First Class',
                                    onSelected: (selected) {
                                      if (selected)
                                        setState(
                                          () => _travelClass = 'First Class',
                                        );
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
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text('Done'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
