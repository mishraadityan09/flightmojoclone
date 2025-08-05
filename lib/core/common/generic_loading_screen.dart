import 'package:flightmojo/core/common/plane_loader.dart';
import 'package:flutter/material.dart';

typedef AsyncOperation<T> = Future<T> Function();

class GenericLoadingScreen<T> extends StatefulWidget {
  final AsyncOperation<T> operation;
  final Map<String, dynamic>? infoToShow;
  final void Function(BuildContext context, T result) onSuccess;
  final void Function(BuildContext context, Object error)? onError;

  /// [operation] - async function to execute (e.g., fetch API)
  /// [infoToShow] - simple key/value map to show on top of loader
  /// [onSuccess] - callback to handle successful data and decide navigation
  /// [onError] - optional error handler to display error UI or retry
  const GenericLoadingScreen({
    Key? key,
    required this.operation,
    required this.onSuccess,
    this.infoToShow,
    this.onError,
  }) : super(key: key);

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
          print(e);
          _error = e;
        });
        if (widget.onError != null) {
          widget.onError!(context, e);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final info = widget.infoToShow;
    final from = info?['from']?.toString() ?? '';
    final to = info?['to']?.toString() ?? '';
    final departureDate = info?['departureDate']?.toString() ?? '';
    final returnDate = info?['returnDate']?.toString();
    final passengers = info?['passengers'];
    final travelClass = info?['travelClass']?.toString() ?? '';
    final isRoundTrip = info?['isRoundTrip'] as bool? ?? false;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Colors.white,
        elevation: 0,
        titleSpacing: 0,
        title: null,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(10),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Route line
                Text(
                  '$from → $to',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 6),
                // Details line
                Row(
                  children: [
                    // Dates
                    Text(
                      isRoundTrip && returnDate != null && returnDate.isNotEmpty
                          ? '$departureDate - $returnDate'
                          : departureDate,
                      style: const TextStyle(fontSize: 15, color: Colors.black87),
                    ),
                    const SizedBox(width: 10),
                    const Text('|', style: TextStyle(color: Colors.grey)),
                    const SizedBox(width: 10),
                    // Passengers
                    Text(
                      passengers != null
                          ? '$passengers ${passengers > 1 ? "Passengers" : "Passenger"}'
                          : '',
                      style: const TextStyle(fontSize: 15, color: Colors.black87),
                    ),
                    const SizedBox(width: 10),
                    const Text('|', style: TextStyle(color: Colors.grey)),
                    const SizedBox(width: 10),
                    // Class
                    Text(
                      travelClass,
                      style: const TextStyle(fontSize: 15, color: Colors.black87),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          const FlyingScene(),
          if (_error != null) _errorWidget(),
          // if (_loading) const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }

  Widget _errorWidget() {
    return Center(
      child: Card(
        color: Colors.white.withOpacity(0.9),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 6,
        margin: const EdgeInsets.all(20),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Error: $_error',
                  style: const TextStyle(color: Colors.red, fontSize: 16)),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: _executeOperation,
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            Text('$label:',
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(width: 10),
            Expanded(child: Text(value, style: const TextStyle(fontSize: 16))),
          ],
        ),
      );
}
