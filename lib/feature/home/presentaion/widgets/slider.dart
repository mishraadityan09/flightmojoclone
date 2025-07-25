import 'package:flutter/material.dart';

class CustomSlidingSegmentedControl<T> extends StatefulWidget {
  final T initialValue;
  final Map<T, Widget> children;
  final BoxDecoration? decoration;
  final BoxDecoration? thumbDecoration;
  final Duration duration;
  final Curve curve;
  final ValueChanged<T?>? onValueChanged;
  final double? minHeight;
  final EdgeInsetsGeometry? padding;

  const CustomSlidingSegmentedControl({
    Key? key,
    required this.initialValue,
    required this.children,
    this.decoration,
    this.thumbDecoration,
    this.duration = const Duration(milliseconds: 400),
    this.curve = Curves.easeInOutCubic,
    this.onValueChanged,
    this.minHeight,
    this.padding,
  }) : super(key: key);

  @override
  State<CustomSlidingSegmentedControl<T>> createState() =>
      _CustomSlidingSegmentedControlState<T>();
}

class _CustomSlidingSegmentedControlState<T>
    extends State<CustomSlidingSegmentedControl<T>>
    with TickerProviderStateMixin {
  late T _selectedValue;
  late AnimationController _animationController;
  late Animation<double> _animation;
  final GlobalKey _containerKey = GlobalKey();
  double _thumbPosition = 0.0;
  double _segmentWidth = 0.0;

  @override
  void initState() {
    super.initState();
    _selectedValue = widget.initialValue;
    _animationController = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: widget.curve),
    );
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _calculateInitialPosition();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _calculateInitialPosition() {
    if (_containerKey.currentContext != null) {
      final RenderBox renderBox =
          _containerKey.currentContext!.findRenderObject() as RenderBox;
      final containerWidth = renderBox.size.width;
      final segmentCount = widget.children.length;
      
      setState(() {
        _segmentWidth = containerWidth / segmentCount;
        _thumbPosition = _getSelectedIndex() * _segmentWidth;
      });
    }
  }

  int _getSelectedIndex() {
    final keys = widget.children.keys.toList();
    return keys.indexOf(_selectedValue);
  }

  void _onSegmentTapped(T value) {
    if (value != _selectedValue) {
      final newIndex = widget.children.keys.toList().indexOf(value);
      final newPosition = newIndex * _segmentWidth;
      
      setState(() {
        _selectedValue = value;
      });
      
      // Animate thumb position
      final animation = Tween<double>(
        begin: _thumbPosition,
        end: newPosition,
      ).animate(_animation);
      
      animation.addListener(() {
        setState(() {
          _thumbPosition = animation.value;
        });
      });
      
      _animationController.reset();
      _animationController.forward();
      
      widget.onValueChanged?.call(value);
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Calculate responsive dimensions
        final availableWidth = constraints.maxWidth;
        final segmentCount = widget.children.length;
        final calculatedSegmentWidth = availableWidth / segmentCount;
        
        // Update segment width if container size changed
        if (_segmentWidth != calculatedSegmentWidth) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            setState(() {
              _segmentWidth = calculatedSegmentWidth;
              _thumbPosition = _getSelectedIndex() * _segmentWidth;
            });
          });
        }
        
        return Container(
          key: _containerKey,
          width: double.infinity,
          constraints: BoxConstraints(
            minHeight: widget.minHeight ?? 44.0,
          ),
          decoration: widget.decoration ??
              BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Colors.grey.shade300,
                  width: 1,
                ),
              ),
          child: Padding(
            padding: widget.padding ?? const EdgeInsets.all(2.0),
            child: Stack(
              children: [
                // Animated thumb
                AnimatedPositioned(
                  duration: widget.duration,
                  curve: widget.curve,
                  left: _thumbPosition + 2, // Account for padding
                  top: 2,
                  bottom: 2,
                  child: Container(
                    width: _segmentWidth - 4, // Account for padding
                    decoration: widget.thumbDecoration ??
                        BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 3,
                              spreadRadius: 0,
                              offset: const Offset(0, 1),
                            ),
                          ],
                        ),
                  ),
                ),
                // Segments
                Row(
                  children: widget.children.entries.map((entry) {
                    final isSelected = entry.key == _selectedValue;
                    return Expanded(
                      child: GestureDetector(
                        onTap: () => _onSegmentTapped(entry.key),
                        behavior: HitTestBehavior.opaque,
                        child: Container(
                          constraints: BoxConstraints(
                            minHeight: widget.minHeight ?? 44.0,
                          ),
                          child: Center(
                            child: AnimatedDefaultTextStyle(
                              duration: widget.duration,
                              curve: widget.curve,
                              style: TextStyle(
                                color: isSelected 
                                    ? Colors.black87 
                                    : Colors.black54,
                                fontWeight: isSelected 
                                    ? FontWeight.w600 
                                    : FontWeight.w500,
                              ),
                              child: entry.value,
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
