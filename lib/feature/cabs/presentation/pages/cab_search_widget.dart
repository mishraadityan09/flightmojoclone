import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flightmojo/core/theme/app_theme.dart';

class CabSearchWidget extends StatelessWidget {
  final String pickupLocation;
  final String dropLocation;
  final String cabDate;
  final String cabTime;
  final VoidCallback onSelectPickupLocation;
  final VoidCallback onSelectDropLocation;
  final VoidCallback onSelectCabDate;
  final VoidCallback onSelectCabTime;
  final VoidCallback onSearchCabs;

  const CabSearchWidget({
    super.key,
    required this.pickupLocation,
    required this.dropLocation,
    required this.cabDate,
    required this.cabTime,
    required this.onSelectPickupLocation,
    required this.onSelectDropLocation,
    required this.onSelectCabDate,
    required this.onSelectCabTime,
    required this.onSearchCabs,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  decoration: AppTheme.gradientContainerDecoration,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: Row(
                    children: [
                      const Icon(Icons.directions_car, color: Colors.white, size: 16),
                      const SizedBox(width: 6),
                      Text(
                        'Cabs',
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Locations
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Pickup', style: GoogleFonts.poppins(fontWeight: FontWeight.w500, color: Colors.grey[600])),
                      const SizedBox(height: 4),
                      GestureDetector(
                        onTap: onSelectPickupLocation,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey[300]!),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.my_location, color: Theme.of(context).primaryColor, size: 20),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  pickupLocation,
                                  style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Drop', style: GoogleFonts.poppins(fontWeight: FontWeight.w500, color: Colors.grey[600])),
                      const SizedBox(height: 4),
                      GestureDetector(
                        onTap: onSelectDropLocation,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey[300]!),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.location_on, color: Theme.of(context).primaryColor, size: 20),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  dropLocation,
                                  style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Date and Time
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Date', style: GoogleFonts.poppins(fontWeight: FontWeight.w500, color: Colors.grey[600])),
                      const SizedBox(height: 4),
                      GestureDetector(
                        onTap: onSelectCabDate,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey[300]!),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.calendar_today, color: Theme.of(context).primaryColor, size: 20),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  cabDate,
                                  style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Time', style: GoogleFonts.poppins(fontWeight: FontWeight.w500, color: Colors.grey[600])),
                      const SizedBox(height: 4),
                      GestureDetector(
                        onTap: onSelectCabTime,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey[300]!),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.access_time_filled, color: Theme.of(context).primaryColor, size: 20),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  cabTime,
                                  style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Search button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onSearchCabs,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Text('Search Cabs', style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 18)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
