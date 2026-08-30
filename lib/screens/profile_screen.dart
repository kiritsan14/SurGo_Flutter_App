import 'package:flutter/material.dart';
import '../state/app_state.dart';
import '../theme/app_colors.dart';
import '../widgets/common.dart';
import 'account_settings_screen.dart';
import 'activity_screen.dart';
import 'emergency_contacts_screen.dart';
import 'favorites_screen.dart';
import 'payment_methods_screen.dart';
import 'saved_places_screen.dart';
import 'wallet_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppState.instance;
    return Scaffold(
      body: ListenableBuilder(
        listenable: state,
        builder: (context, _) {
          final passenger = state.db.passenger;
          return SafeArea(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(18, 16, 18, 90),
              children: [
                Center(
                  child: Column(
                    children: [
                      SbAvatar(initials: passenger.initials, size: 64),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(passenger.name, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
                          if (passenger.verified) ...[
                            const SizedBox(width: 6),
                            const Icon(Icons.verified, size: 16, color: AppColors.primaryLight),
                          ],
                        ],
                      ),
                      Text('⭐ ${passenger.rating} · Member since ${passenger.memberSince}',
                          style: const TextStyle(color: AppColors.muted, fontSize: 12)),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    Expanded(
                      child: _quickAction(
                        context,
                        icon: Icons.receipt_long,
                        label: 'Ride History',
                        color: AppColors.primaryLight,
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ActivityScreen())),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _quickAction(
                        context,
                        icon: Icons.account_balance_wallet_outlined,
                        label: 'Wallet',
                        color: AppColors.secondaryLight,
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const WalletScreen())),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _quickAction(
                        context,
                        icon: Icons.place_outlined,
                        label: 'Saved Places',
                        color: AppColors.muted,
                        onTap: () =>
                            Navigator.push(context, MaterialPageRoute(builder: (_) => const SavedPlacesScreen())),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                _settingsRow(context, 'Payment Methods',
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PaymentMethodsScreen()))),
                const SizedBox(height: 8),
                _settingsRow(context, 'Favorites',
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const FavoritesScreen()))),
                const SizedBox(height: 8),
                _settingsRow(context, 'Emergency Contacts',
                    onTap: () =>
                        Navigator.push(context, MaterialPageRoute(builder: (_) => const EmergencyContactsScreen()))),
                const SizedBox(height: 8),
                _settingsRow(context, 'Account Settings',
                    onTap: () =>
                        Navigator.push(context, MaterialPageRoute(builder: (_) => const AccountSettingsScreen()))),
                const SizedBox(height: 20),
                SbCard(
                  onTap: () {
                    state.switchToRider();
                    Navigator.pushNamedAndRemoveUntil(context, '/rider', (route) => false);
                  },
                  borderColor: AppColors.secondary.withValues(alpha: 0.35),
                  child: const Row(
                    children: [
                      Icon(Icons.swap_horiz, color: AppColors.secondaryLight, size: 20),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text('Switch to Rider', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                      ),
                      Icon(Icons.chevron_right, color: AppColors.muted, size: 18),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: SbBottomNav(
        activeIndex: 3,
        items: const [
          SbNavItem(Icons.home_rounded, 'Home'),
          SbNavItem(Icons.receipt_long, 'Activity'),
          SbNavItem(Icons.account_balance_wallet_outlined, 'Wallet'),
          SbNavItem(Icons.person_outline, 'Profile'),
        ],
        onTap: (i) {
          if (i == 3) return;
          if (i == 0) {
            Navigator.popUntil(context, ModalRoute.withName('/home'));
          } else if (i == 1) {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const ActivityScreen()));
          } else if (i == 2) {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const WalletScreen()));
          }
        },
      ),
    );
  }

  Widget _quickAction(BuildContext context,
      {required IconData icon, required String label, required Color color, VoidCallback? onTap}) {
    return SbCard(
      padding: const EdgeInsets.symmetric(vertical: 12),
      onTap: onTap,
      child: Column(
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(height: 6),
          Text(label, textAlign: TextAlign.center, style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }

  Widget _settingsRow(BuildContext context, String label, {VoidCallback? onTap}) {
    return SbCard(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
          const Icon(Icons.chevron_right, size: 16, color: AppColors.muted),
        ],
      ),
    );
  }
}
