import 'package:flutter/material.dart';
import '../data/models.dart';
import '../state/app_state.dart';
import '../theme/app_colors.dart';
import '../widgets/common.dart';

class LiveTripScreen extends StatelessWidget {
  const LiveTripScreen({super.key});

  void _showSosDialog(BuildContext context) {
    final contacts = AppState.instance.emergencyContacts;
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.panel,
        title: const Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Color(0xFFFFB3B3), size: 20),
            SizedBox(width: 8),
            Text('Send SOS alert?'),
          ],
        ),
        content: Text(
          contacts.isEmpty
              ? 'You have no emergency contacts saved yet. Add one from your profile so we know who to alert.'
              : 'This will share your live location and trip details with:\n\n'
                  '${contacts.map((c) => '• ${c.name} (${c.relation})').join('\n')}',
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          if (contacts.isNotEmpty)
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Alert sent to your emergency contacts (simulated)')),
                );
              },
              child: const Text('Send Alert', style: TextStyle(color: Color(0xFFFFB3B3))),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final driver = MockData.matchedDriver;
    final mapHeight = MediaQuery.of(context).size.height * 0.5;
    return Scaffold(
      body: Column(
        children: [
          SbMapPlaceholder(
            height: mapHeight,
            child: Stack(
              children: [
                CustomPaint(painter: _RoutePainter(), size: Size.infinite),
                Positioned(
                  left: 38,
                  top: mapHeight * 0.72,
                  child: Container(
                    width: 14,
                    height: 14,
                    decoration: BoxDecoration(
                      color: AppColors.secondary,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.bg, width: 3),
                    ),
                  ),
                ),
                Positioned(
                  right: 38,
                  top: mapHeight * 0.09,
                  child: Transform.rotate(
                    angle: 0.78,
                    child: Container(
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: AppColors.bg, width: 3),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: MediaQuery.of(context).size.width * 0.4,
                  top: mapHeight * 0.4,
                  child: Container(
                    width: 22,
                    height: 22,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: AppColors.panel,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.secondary, width: 2),
                    ),
                    child: const Icon(Icons.electric_rickshaw, size: 12, color: AppColors.secondaryLight),
                  ),
                ),
                Positioned(
                  top: 12,
                  left: 12,
                  right: 12,
                  child: SafeArea(
                    bottom: false,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SbIconButton(icon: Icons.arrow_back, onTap: () => Navigator.pop(context)),
                        GestureDetector(
                          onTap: () => _showSosDialog(context),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                            decoration: BoxDecoration(
                              color: AppColors.dangerSoft,
                              borderRadius: BorderRadius.circular(999),
                              border: Border.all(color: AppColors.danger.withValues(alpha: 0.4)),
                            ),
                            child: Row(
                              children: const [
                                Icon(Icons.warning_amber_rounded, size: 14, color: Color(0xFFFFB3B3)),
                                SizedBox(width: 6),
                                Text('SOS',
                                    style: TextStyle(
                                        color: Color(0xFFFFB3B3), fontSize: 11, fontWeight: FontWeight.w800)),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(18, 16, 18, 18),
              child: Column(
                children: [
                  SbCard(
                    borderColor: AppColors.secondary.withValues(alpha: 0.3),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const SbTag('On the way · 4 min', secondary: true),
                            Text('${driver.vehicleType} · ${driver.plate}',
                                style: const TextStyle(color: AppColors.muted, fontSize: 11.5)),
                          ],
                        ),
                        const SizedBox(height: 14),
                        Row(
                          children: [
                            SbAvatar(initials: driver.initials),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(driver.name,
                                      style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14)),
                                  Text('⭐ ${driver.rating} · ${driver.trips} trips',
                                      style: const TextStyle(color: AppColors.muted, fontSize: 11.5)),
                                ],
                              ),
                            ),
                            SbIconButton(
                              icon: Icons.call_outlined,
                              onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Simulated call to ${driver.name}')),
                              ),
                            ),
                            const SizedBox(width: 8),
                            SbIconButton(
                              icon: Icons.message_outlined,
                              onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Chat is not wired up in this simulation')),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                  SbOutlineButton(
                    label: 'Share this trip',
                    icon: Icons.shield_outlined,
                    onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Trip link copied (simulated)')),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SbPrimaryButton(
                    label: 'Complete Trip',
                    onPressed: () => Navigator.pushReplacementNamed(context, '/rate'),
                  ),
                ],
              ),
            ),
          ),
        ],
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
      ..moveTo(size.width * 0.12, size.height * 0.76)
      ..cubicTo(
        size.width * 0.29, size.height * 0.62,
        size.width * 0.4, size.height * 0.42,
        size.width * 0.58, size.height * 0.27,
      )
      ..cubicTo(
        size.width * 0.68, size.height * 0.19,
        size.width * 0.74, size.height * 0.16,
        size.width * 0.81, size.height * 0.13,
      );
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
