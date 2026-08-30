import 'dart:async';
import 'package:flutter/material.dart';
import '../data/models.dart';
import '../theme/app_colors.dart';
import '../widgets/common.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final List<String> digits = ['4', '1', '', ''];
  int secondsLeft = 42;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (secondsLeft == 0) {
        t.cancel();
        return;
      }
      setState(() => secondsLeft--);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 40, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Verify your number',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
              const SizedBox(height: 6),
              const Text.rich(
                TextSpan(
                  style: TextStyle(color: AppColors.muted, fontSize: 13),
                  children: [
                    TextSpan(text: 'Enter the 4-digit code sent to '),
                    TextSpan(
                      text: MockData.phoneNumber,
                      style: TextStyle(color: AppColors.text, fontWeight: FontWeight.w800),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 26),
              Row(
                children: List.generate(4, (i) {
                  final filled = digits[i].isNotEmpty;
                  return Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(right: i == 3 ? 0 : 10),
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: AppColors.panel,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: filled ? AppColors.primary : AppColors.borderLight,
                              width: 1.5,
                            ),
                          ),
                          child: Text(
                            digits[i],
                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 18),
              Text.rich(
                TextSpan(
                  style: const TextStyle(color: AppColors.muted, fontSize: 12),
                  children: [
                    const TextSpan(text: "Didn't get a code? "),
                    TextSpan(
                      text: secondsLeft > 0
                          ? 'Resend in 0:${secondsLeft.toString().padLeft(2, '0')}'
                          : 'Resend now',
                      style: const TextStyle(
                          color: AppColors.primaryLight, fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              SbPrimaryButton(
                label: 'Verify Code',
                onPressed: () =>
                    Navigator.pushNamedAndRemoveUntil(context, '/home', (r) => false),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
