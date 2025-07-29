import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flightmojo/core/theme/app_theme.dart';

class HotelSearchWidget extends StatelessWidget {
  final String hotelCity;
  final String checkInDate;
  final String checkOutDate;
  final int guests;
  final int rooms;
  final VoidCallback onSelectHotelCity;
  final VoidCallback onSelectCheckInDate;
  final VoidCallback onSelectCheckOutDate;
  final VoidCallback onShowGuestsSelector;
  final VoidCallback onShowRoomsSelector;
  final VoidCallback onSearchHotels;

  const HotelSearchWidget({
    super.key,
    required this.hotelCity,
    required this.checkInDate,
    required this.checkOutDate,
    required this.guests,
    required this.rooms,
    required this.onSelectHotelCity,
    required this.onSelectCheckInDate,
    required this.onSelectCheckOutDate,
    required this.onShowGuestsSelector,
    required this.onShowRoomsSelector,
    required this.onSearchHotels,
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
                      const Icon(Icons.hotel, color: Colors.white, size: 16),
                      const SizedBox(width: 6),
                      Text(
                        'Hotels',
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
            // Location
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Location', style: GoogleFonts.poppins(fontWeight: FontWeight.w500, color: Colors.grey[600])),
                const SizedBox(height: 4),
                GestureDetector(
                  onTap: onSelectHotelCity,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[300]!),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.location_city, color: Theme.of(context).primaryColor, size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            hotelCity,
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
            const SizedBox(height: 16),
            // Dates
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Check In', style: GoogleFonts.poppins(fontWeight: FontWeight.w500, color: Colors.grey[600])),
                      const SizedBox(height: 4),
                      GestureDetector(
                        onTap: onSelectCheckInDate,
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
                                  checkInDate,
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
                      Text('Check Out', style: GoogleFonts.poppins(fontWeight: FontWeight.w500, color: Colors.grey[600])),
                      const SizedBox(height: 4),
                      GestureDetector(
                        onTap: onSelectCheckOutDate,
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
                                  checkOutDate,
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
            // Guests and Rooms
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Guests', style: GoogleFonts.poppins(fontWeight: FontWeight.w500, color: Colors.grey[600])),
                      const SizedBox(height: 4),
                      GestureDetector(
                        onTap: onShowGuestsSelector,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey[300]!),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.person, color: Theme.of(context).primaryColor, size: 20),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  '$guests Guest${guests > 1 ? 's' : ''}',
                                  style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500),
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
                      Text('Rooms', style: GoogleFonts.poppins(fontWeight: FontWeight.w500, color: Colors.grey[600])),
                      const SizedBox(height: 4),
                      GestureDetector(
                        onTap: onShowRoomsSelector,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey[300]!),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.king_bed, color: Theme.of(context).primaryColor, size: 20),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  '$rooms Room${rooms > 1 ? 's' : ''}',
                                  style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500),
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
                onPressed: onSearchHotels,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Text('Search Hotels', style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 18)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
