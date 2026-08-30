import 'package:flutter/material.dart';
import '../state/app_state.dart';
import '../theme/app_colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    // Load the mock JSON "database" and show the splash for a beat so the
    // transition never feels abrupt, even though loading is near-instant.
    await Future.wait([
      AppState.instance.init(),
      Future.delayed(const Duration(milliseconds: 1600)),
    ]);
    if (mounted) Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment(0, -0.4),
            radius: 0.9,
            colors: [Color(0xFF16221A), AppColors.bg],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 76,
                height: 76,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(22),
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [AppColors.primary, AppColors.primaryDark],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.35),
                      blurRadius: 34,
                      offset: const Offset(0, 14),
                    ),
                  ],
                ),
                child: const Icon(Icons.electric_rickshaw, color: AppColors.onAccent, size: 34),
              ),
              const SizedBox(height: 18),
              RichText(
                text: const TextSpan(
                  style: TextStyle(fontSize: 23, fontWeight: FontWeight.w800, letterSpacing: -0.4),
                  children: [
                    TextSpan(text: 'SUR', style: TextStyle(color: AppColors.text)),
                    TextSpan(text: 'GO', style: TextStyle(color: AppColors.secondary)),
                  ],
                ),
              ),
              const SizedBox(height: 6),
              const Text('Ride. Rent. Go.',
                  style: TextStyle(color: AppColors.muted, fontSize: 12.5)),
              const SizedBox(height: 48),
              SizedBox(
                width: 120,
                height: 4,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: Container(
                    color: AppColors.panel2,
                    alignment: Alignment.centerLeft,
                    child: FractionallySizedBox(
                      widthFactor: 0.64,
                      child: Container(color: AppColors.primary),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
