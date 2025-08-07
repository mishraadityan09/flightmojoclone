import 'package:flightmojo/core/common/plane_loader.dart';
import 'package:flutter/material.dart';

typedef AsyncOperation<T> = Future<T> Function();

class GenericLoadingScreen<T> extends StatefulWidget {
  final AsyncOperation<T> operation;
  final Map<String, dynamic>? infoToShow;
  final void Function(BuildContext context, T result) onSuccess;
  final void Function(BuildContext context, Object error)? onError;
  final Widget? customBackground;
  final bool showInfoHeader;

  /// [operation] - async function to execute (e.g., fetch API)
  /// [infoToShow] - simple key/value map to show in header
  /// [onSuccess] - callback to handle successful data and decide navigation
  /// [onError] - optional error handler to display error UI or retry
  /// [customBackground] - optional custom background widget (defaults to FlyingScene)
  /// [showInfoHeader] - whether to show the info header (defaults to true)
  const GenericLoadingScreen({
    super.key,
    required this.operation,
    required this.onSuccess,
    this.infoToShow,
    this.onError,
    this.customBackground,
    this.showInfoHeader = true,
  });

  @override
  _GenericLoadingScreenState<T> createState() =>
      _GenericLoadingScreenState<T>();
}

class _GenericLoadingScreenState<T> extends State<GenericLoadingScreen<T>> {
  bool _loading = true;
  Object? _error;

  @override
  void initState() {
    super.initState();
    _executeOperation();
  }

  Future<void> _executeOperation() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final result = await widget.operation();
      if (mounted) {
        setState(() => _loading = false);
        widget.onSuccess(context, result);
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _loading = false;
          _error = e;
        });
        debugPrint('GenericLoadingScreen Error: $e');
        
        if (widget.onError != null) {
          widget.onError!(context, e);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: SafeArea(
        child: Column(
          children: [
            // Info header card (if enabled and has data)
            if (widget.showInfoHeader && 
                widget.infoToShow != null && 
                widget.infoToShow!.isNotEmpty)
              _buildInfoHeader(),
            
            // Main content area
            Expanded(
              child: _error != null 
                  ? _buildErrorWidget()
                  : widget.customBackground ?? const FlyingScene(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoHeader() {
    final info = widget.infoToShow!;
    
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Airport codes and arrow
          _buildRouteInfo(info),
          const SizedBox(height: 16),
          // Travel details
          _buildTravelDetails(info),
        ],
      ),
    );
  }

  Widget _buildRouteInfo(Map<String, dynamic> info) {
    final fromCode = _getAirportCode(info['from']?.toString() ?? '');
    final toCode = _getAirportCode(info['to']?.toString() ?? '');
    final fromCity = _getCityName(info['from']?.toString() ?? '');
    final toCity = _getCityName(info['to']?.toString() ?? '');
    
    return Row(
      children: [
        // From airport
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                fromCode,
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                  letterSpacing: -1,
                ),
              ),
              Text(
                fromCity,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
        
        // Arrow
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(
            Icons.arrow_forward,
            color: Colors.white,
            size: 20,
          ),
        ),
        
        // To airport
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                toCode,
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                  letterSpacing: -1,
                ),
              ),
              Text(
                toCity,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTravelDetails(Map<String, dynamic> info) {
    final List<String> details = [];
    
    // Build the details string
    if (info['departureDate'] != null) {
      details.add(info['departureDate'].toString());
    }
    
    if (info['passengers'] != null) {
      details.add(info['passengers'].toString());
    } else if (info['passengerCount'] != null) {
      final count = info['passengerCount'];
      details.add('$count Traveler${count > 1 ? 's' : ''}');
    }
    
    if (info['travelClass'] != null) {
      details.add(info['travelClass'].toString());
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        details.join(' • '),
        style: const TextStyle(
          fontSize: 14,
          color: Colors.black87,
          fontWeight: FontWeight.w500,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  String _getAirportCode(String location) {
    // Extract airport code from location string
    // You can customize this based on your data format
    if (location.toLowerCase().contains('delhi')) return 'DEL';
    if (location.toLowerCase().contains('mumbai')) return 'BOM';
    if (location.toLowerCase().contains('bangalore')) return 'BLR';
    if (location.toLowerCase().contains('chennai')) return 'MAA';
    if (location.toLowerCase().contains('hyderabad')) return 'HYD';
    if (location.toLowerCase().contains('kolkata')) return 'CCU';
    if (location.toLowerCase().contains('pune')) return 'PNQ';
    if (location.toLowerCase().contains('ahmedabad')) return 'AMD';
    
    // If no match found, return first 3 characters in uppercase
    return location.length >= 3 ? location.substring(0, 3).toUpperCase() : location.toUpperCase();
  }

  String _getCityName(String location) {
    // Extract city name from location string
    if (location.toLowerCase().contains('delhi')) return 'New Delhi';
    if (location.toLowerCase().contains('mumbai')) return 'Mumbai';
    if (location.toLowerCase().contains('bangalore')) return 'Bangalore';
    if (location.toLowerCase().contains('chennai')) return 'Chennai';
    if (location.toLowerCase().contains('hyderabad')) return 'Hyderabad';
    if (location.toLowerCase().contains('kolkata')) return 'Kolkata';
    if (location.toLowerCase().contains('pune')) return 'Pune';
    if (location.toLowerCase().contains('ahmedabad')) return 'Ahmedabad';
    
    return location;
  }

  Widget _buildErrorWidget() {
    return Center(
      child: Container(
        margin: const EdgeInsets.all(20),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.red.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha:0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline,
              color: Colors.red.shade400,
              size: 48,
            ),
            const SizedBox(height: 16),
            Text(
              'Something went wrong',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.red.shade700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _error.toString(),
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.grey.shade600,
                  ),
                  child: const Text('Cancel'),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: _executeOperation,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Retry'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}