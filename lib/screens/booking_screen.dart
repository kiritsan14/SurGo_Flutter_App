import 'package:flutter/material.dart';
import '../state/app_state.dart';
import '../theme/app_colors.dart';
import '../widgets/common.dart';

class BookingScreen extends StatelessWidget {
  const BookingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppState.instance;
    return Scaffold(
      body: ListenableBuilder(
        listenable: state,
        builder: (context, _) {
          return Column(
            children: [
              SbMapPlaceholder(
                height: MediaQuery.of(context).size.height * 0.36,
                child: Stack(
                  children: [
                    CustomPaint(
                      painter: _RoutePainter(),
                      size: Size.infinite,
                    ),
                    Positioned(
                      left: 34,
                      top: MediaQuery.of(context).size.height * 0.36 * 0.68,
                      child: _pin(AppColors.secondary, circle: true),
                    ),
                    Positioned(
                      right: 34,
                      top: 16,
                      child: Transform.rotate(angle: 0.78, child: _pin(AppColors.primary, circle: false)),
                    ),
                    Positioned(
                      top: 12,
                      left: 12,
                      child: SafeArea(
                        bottom: false,
                        child: SbIconButton(
                          icon: Icons.arrow_back,
                          onTap: () => Navigator.pop(context),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(18, 16, 18, 18),
                  children: [
                    SbField(
                      label: 'Pickup',
                      value: state.pickupLabel,
                      leading: const _Dot(color: AppColors.secondary, square: false),
                    ),
                    const SizedBox(height: 8),
                    SbField(
                      label: 'Destination',
                      value: state.destinationLabel,
                      leading: const _Dot(color: AppColors.primary, square: true),
                    ),
                    const SizedBox(height: 20),
                    const Text('Choose a vehicle',
                        style: TextStyle(fontWeight: FontWeight.w800, fontSize: 13, color: AppColors.muted)),
                    const SizedBox(height: 10),
                    ..._buildRideOptions(state),
                    const SizedBox(height: 18),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Est. distance 3.2 km', style: TextStyle(color: AppColors.muted, fontSize: 12)),
                        Text('Est. time 9 min', style: TextStyle(color: AppColors.muted, fontSize: 12)),
                      ],
                    ),
                    const SizedBox(height: 14),
                    SbPrimaryButton(
                      label: 'Find Ride · ₱${state.selectedRide.fare}',
                      onPressed: () => Navigator.pushNamed(context, '/matching'),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  List<Widget> _buildRideOptions(AppState state) {
    return state.rideOptions.map((option) {
      final selected = option.name == state.selectedRide.name;
      return Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: SbCard(
          borderColor: selected ? AppColors.primary : null,
          onTap: () => state.selectRide(option),
          child: Row(
            children: [
              Icon(option.icon,
                  size: 26, color: selected ? AppColors.primaryLight : AppColors.muted),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(option.name,
                        style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13)),
                    Text('${option.etaLabel} · ${option.capacityLabel}',
                        style: const TextStyle(color: AppColors.muted, fontSize: 11)),
                  ],
                ),
              ),
              Text('₱${option.fare}', style: const TextStyle(fontWeight: FontWeight.w800)),
            ],
          ),
        ),
      );
    }).toList();
  }

  Widget _pin(Color color, {required bool circle}) => Container(
        width: circle ? 14 : 16,
        height: circle ? 14 : 16,
        decoration: BoxDecoration(
          color: color,
          shape: circle ? BoxShape.circle : BoxShape.rectangle,
          borderRadius: circle ? null : BorderRadius.circular(4),
          border: Border.all(color: AppColors.bg, width: 3),
        ),
      );
}

class _Dot extends StatelessWidget {
  final Color color;
  final bool square;
  const _Dot({required this.color, required this.square});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        color: color,
        shape: square ? BoxShape.rectangle : BoxShape.circle,
        borderRadius: square ? BorderRadius.circular(2) : null,
      ),
    );
  }
}

class _RoutePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.primary
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;
    final path = Path()
      ..moveTo(size.width * 0.1, size.height * 0.73)
      ..cubicTo(
        size.width * 0.29, size.height * 0.6,
        size.width * 0.37, size.height * 0.4,
        size.width * 0.58, size.height * 0.27,
      )
      ..cubicTo(
        size.width * 0.71, size.height * 0.18,
        size.width * 0.79, size.height * 0.13,
        size.width * 0.89, size.height * 0.07,
      );
    // dashed effect
    const dashWidth = 7.0;
    const dashSpace = 6.0;
    final metrics = path.computeMetrics();
    for (final metric in metrics) {
      double distance = 0;
      while (distance < metric.length) {
        final next = distance + dashWidth;
        canvas.drawPath(
          metric.extractPath(distance, next.clamp(0, metric.length)),
          paint,
        );
        distance = next + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
