import 'package:flutter/material.dart';
import '../state/app_state.dart';
import '../theme/app_colors.dart';
import '../widgets/common.dart';
import 'wallet_screen.dart';

class RiderEarningsScreen extends StatelessWidget {
  const RiderEarningsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppState.instance;
    return Scaffold(
      appBar: AppBar(title: const Text('Earnings')),
      body: ListenableBuilder(
        listenable: state,
        builder: (context, _) {
          final maxAmount = state.dailyEarnings.map((d) => d.amount).reduce((a, b) => a > b ? a : b);
          return ListView(
            padding: const EdgeInsets.fromLTRB(18, 12, 18, 24),
            children: [
              Row(
                children: [
                  Expanded(child: _statCard('₱${state.earningsToday}', 'Today')),
                  const SizedBox(width: 8),
                  Expanded(child: _statCard('₱${state.earningsWeek}', 'This Week')),
                  const SizedBox(width: 8),
                  Expanded(child: _statCard('₱${state.earningsMonth}', 'This Month')),
                ],
              ),
              const SizedBox(height: 20),
              const Text('This Week', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 13.5)),
              const SizedBox(height: 14),
              SbCard(
                child: SizedBox(
                  height: 140,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: state.dailyEarnings.map((d) {
                      final heightFactor = maxAmount == 0 ? 0.0 : d.amount / maxAmount;
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text('${d.amount}', style: const TextStyle(fontSize: 9.5, color: AppColors.muted)),
                          const SizedBox(height: 4),
                          Container(
                            width: 20,
                            height: 90 * heightFactor.clamp(0.05, 1.0),
                            decoration: BoxDecoration(
                              color: AppColors.secondary,
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(d.day, style: const TextStyle(fontSize: 10.5, color: AppColors.muted, fontWeight: FontWeight.w700)),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SbPrimaryButton(
                label: 'Cash Out to GCash',
                icon: Icons.account_balance_wallet,
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const WalletScreen(isRider: true)),
                ),
              ),
              const SizedBox(height: 20),
              const Text('Payout History', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 13.5)),
              const SizedBox(height: 10),
              ...state.payoutHistory.map((p) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: SbCard(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          Container(
                            width: 36,
                            height: 36,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: AppColors.secondarySoft,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(Icons.arrow_downward_rounded, size: 16, color: AppColors.secondaryLight),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Payout via ${p.method}',
                                    style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12.5)),
                                Text('${p.date} · ${p.status}',
                                    style: const TextStyle(color: AppColors.muted, fontSize: 11)),
                              ],
                            ),
                          ),
                          Text('₱${p.amount}', style: const TextStyle(fontWeight: FontWeight.w800)),
                        ],
                      ),
                    ),
                  )),
            ],
          );
        },
      ),
    );
  }

  Widget _statCard(String value, String label) {
    return SbCard(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Column(
        children: [
          Text(value, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15, color: AppColors.secondaryLight)),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(color: AppColors.muted, fontSize: 10.5)),
        ],
      ),
    );
  }
}
