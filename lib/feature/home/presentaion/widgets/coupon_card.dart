import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

// CustomTicketShape: for side notches (ticket effect)
class CustomTicketShape extends CustomClipper<Path> {
  final double borderRadius;
  final double notchRadius;
  final double notchY;

  CustomTicketShape(
    this.borderRadius, {
    this.notchRadius = 15,
    required this.notchY,
  });

  @override
  Path getClip(Size size) {
    final path = Path();
    final radius = Radius.circular(borderRadius);

    // Start at top-left corner
    path.moveTo(0, borderRadius);
    path.arcToPoint(Offset(borderRadius, 0), radius: radius, clockwise: true);

    // Top edge to top-right corner
    path.lineTo(size.width - borderRadius, 0);
    path.arcToPoint(
      Offset(size.width, borderRadius),
      radius: radius,
      clockwise: true,
    );

    // Right edge to notch start
    path.lineTo(size.width, notchY - notchRadius);

    // Right circular notch (inward facing)
    path.arcToPoint(
      Offset(size.width, notchY + notchRadius),
      radius: Radius.circular(notchRadius),
      clockwise: false,
    );

    // Right edge to bottom-right corner
    path.lineTo(size.width, size.height - borderRadius);
    path.arcToPoint(
      Offset(size.width - borderRadius, size.height),
      radius: radius,
      clockwise: true,
    );

    // Bottom edge to bottom-left corner
    path.lineTo(borderRadius, size.height);
    path.arcToPoint(
      Offset(0, size.height - borderRadius),
      radius: radius,
      clockwise: true,
    );

    // Left edge to notch start
    path.lineTo(0, notchY + notchRadius);

    // Left circular notch (inward facing)
    path.arcToPoint(
      Offset(0, notchY - notchRadius),
      radius: Radius.circular(notchRadius),
      clockwise: false,
    );

    // Left edge back to start
    path.lineTo(0, borderRadius);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}

// TicketBorderPainter for border
class TicketBorderPainter extends CustomPainter {
  final double borderRadius;
  final double notchRadius;
  final double notchY;

  TicketBorderPainter({
    this.borderRadius = 15,
    this.notchRadius = 15,
    required this.notchY,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final path = CustomTicketShape(
      borderRadius,
      notchRadius: notchRadius,
      notchY: notchY,
    ).getClip(size);
    final paint = Paint()
      ..color = Colors.grey.shade300
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// DashedLinePainter for the horizontal dashed line
class DashedLinePainter extends CustomPainter {
  final double dashWidth;
  final double dashSpace;
  final Color color;

  DashedLinePainter({
    this.dashWidth = 5,
    this.dashSpace = 3,
    this.color = Colors.grey,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    double startX = 0;
    while (startX < size.width) {
      canvas.drawLine(Offset(startX, 0), Offset(startX + dashWidth, 0), paint);
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// CouponCard: ticket-shaped, flexible size with responsive text
class CouponCard extends StatefulWidget {
  final String title;
  final String subtitle;
  final String promoCode;

  const CouponCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.promoCode,
  });

  @override
  State<CouponCard> createState() => _CouponCardState();
}

class _CouponCardState extends State<CouponCard> {
  final GlobalKey _topContentKey = GlobalKey();
  double _notchY = 120.0; // Default notch position

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _calculateNotchPosition();
    });
  }

  void _calculateNotchPosition() {
    final RenderBox? renderBox =
        _topContentKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox != null && mounted) {
      setState(() {
        _notchY = renderBox.size.height + 10; // Top content height + spacing
      });
    }
  }

  // Responsive text size getters
  double screenWidth(BuildContext context) => MediaQuery.of(context).size.width;

  double headingFontSize(BuildContext context) =>
      (screenWidth(context) * 0.03).clamp(16.0, 18.0);

  double subheadingFontSize(BuildContext context) =>
      (screenWidth(context) * 0.03).clamp(14.0, 16.0);

  double bodyFontSize(BuildContext context) =>
      (screenWidth(context) * 0.03).clamp(12.0, 14.0);

  double secondaryFontSize(BuildContext context) =>
      (screenWidth(context) * 0.03).clamp(12.0, 14.0);

  double smallFontSize(BuildContext context) =>
      (screenWidth(context) * 0.025).clamp(10.0, 12.0);

  @override
  Widget build(BuildContext context) {
    const borderRadius = 15.0;
    const notchRadius = 15.0;
    final dynamicIconSize = (screenWidth(context) * 0.5).clamp(32.0, 80.0);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      child: Stack(
        children: [
          ClipPath(
            clipper: CustomTicketShape(
              borderRadius,
              notchRadius: notchRadius,
              notchY: _notchY,
            ),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(borderRadius),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top content section (measured)
                  Container(
                    key: _topContentKey,
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Container(
                          width: dynamicIconSize,
                          height: dynamicIconSize,
                          decoration: BoxDecoration(
                            color: Colors.orange.shade100,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: SvgPicture.network(
                            'https://www.flightsmojo.in/images/coup1.svg',
                            width: dynamicIconSize * 1,
                            height: dynamicIconSize * 1,

                            placeholderBuilder: (context) =>
                                CircularProgressIndicator(),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.title,
                                style: TextStyle(
                                  fontSize: headingFontSize(context),
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                widget.subtitle,
                                style: TextStyle(
                                  fontSize: bodyFontSize(context),
                                  color: Colors.black54,
                                  height: 1.4,
                                ),
                              ),
                              const SizedBox(height: 8),
                              GestureDetector(
                                onTap: () {
                                  // Handle T&C tap
                                },
                                child: Text(
                                  'T&C apply',
                                  style: TextStyle(
                                    fontSize: secondaryFontSize(context),
                                    color: const Color(0xFFEF6614),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Spacing before dashed line
                  const SizedBox(height: 10),

                  // Dashed line separator (positioned at notch level)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: CustomPaint(
                      size: Size(double.infinity, 1),
                      painter: DashedLinePainter(
                        color: Colors.grey.shade400,
                        dashWidth: 6,
                        dashSpace: 4,
                      ),
                    ),
                  ),

                  // Spacing after dashed line
                  const SizedBox(height: 20),

                  // Bottom section with promo code and know more
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: RichText(
                            text: TextSpan(
                              style: TextStyle(
                                fontSize: bodyFontSize(context),
                                color: Colors.black54,
                              ),
                              children: [
                                 TextSpan(
                                  text: 'Promo Code: ',
                                  style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontSize: subheadingFontSize(context)
                                  ),
                                ),
                                TextSpan(
                                  text: widget.promoCode,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                    fontSize: subheadingFontSize(context),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        GestureDetector(
                          onTap: () {
                            // Handle know more tap
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: const Color(0xFFEF6614),
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              'Know more',
                              style: TextStyle(
                                color: const Color(0xFFEF6614),
                                fontSize: secondaryFontSize(context),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Border painter
          Positioned.fill(
            child: CustomPaint(
              painter: TicketBorderPainter(
                borderRadius: borderRadius,
                notchRadius: notchRadius,
                notchY: _notchY,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Example usage
class TicketExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: Text('Ticket Widget Demo'),
        backgroundColor: Colors.orange,
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          CouponCard(
            title: "Get 20% OFF",
            subtitle:
                "Valid on all products above ₹500. Limited time offer for new customers only.",
            promoCode: "SAVE20",
          ),
          CouponCard(
            title: "Free Delivery",
            subtitle:
                "No delivery charges on orders above ₹299. This is a longer subtitle to test the dynamic height adjustment of the ticket widget.",
            promoCode: "FREEDEL",
          ),
          CouponCard(
            title: "Buy 2 Get 1 Free",
            subtitle:
                "Applicable on selected items in electronics category. This offer is valid for a limited time and cannot be combined with other offers. Terms and conditions apply for all purchases.",
            promoCode: "B2G1FREE",
          ),
        ],
      ),
    );
  }
}
