import 'package:flutter/material.dart';
import '../data/models.dart';
import '../theme/app_colors.dart';
import '../widgets/common.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 40, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Let's get you started",
                  style: TextStyle(fontSize: 23, fontWeight: FontWeight.w800)),
              const SizedBox(height: 6),
              const Text(
                'Enter your number to book, ride, or rent today.',
                style: TextStyle(color: AppColors.muted, fontSize: 13),
              ),
              const SizedBox(height: 26),
              const SbField(
                label: 'Phone Number',
                value: MockData.phoneNumber,
                leading: Icon(Icons.phone, size: 18, color: AppColors.text),
              ),
              const SizedBox(height: 22),
              SbPrimaryButton(
                label: 'Next',
                onPressed: () => Navigator.pushNamed(context, '/otp'),
              ),
              const SizedBox(height: 22),
              Row(
                children: const [
                  Expanded(child: Divider(color: AppColors.border)),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Text('OR',
                        style: TextStyle(color: AppColors.muted2, fontSize: 11.5)),
                  ),
                  Expanded(child: Divider(color: AppColors.border)),
                ],
              ),
              const SizedBox(height: 22),
              const SbOutlineButton(label: 'Continue with Google'),
              const Spacer(),
              const Padding(
                padding: EdgeInsets.only(bottom: 10),
                child: Text.rich(
                  TextSpan(
                    style: TextStyle(color: AppColors.muted2, fontSize: 11),
                    children: [
                      TextSpan(text: "By continuing you agree to SurGo's "),
                      TextSpan(
                        text: 'Terms',
                        style: TextStyle(color: AppColors.primaryLight),
                      ),
                      TextSpan(text: ' & '),
                      TextSpan(
                        text: 'Privacy Policy',
                        style: TextStyle(color: AppColors.primaryLight),
                      ),
                      TextSpan(text: '.'),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
