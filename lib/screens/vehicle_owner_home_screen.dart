import 'package:flutter/material.dart';
import '../data/db_models.dart';
import '../state/app_state.dart';
import '../theme/app_colors.dart';
import '../widgets/common.dart';

/// Vehicle Owner mode — Home tab. Shows the owner's fleet at a glance and
/// any incoming rental booking requests that need a response.
class VehicleOwnerHomeScreen extends StatelessWidget {
  final bool embedded;
  const VehicleOwnerHomeScreen({super.key, this.embedded = true});

  @override
  Widget build(BuildContext context) {
    final state = AppState.instance;
    final content = ListenableBuilder(
      listenable: state,
      builder: (context, _) {
        final owner = state.db.vehicleOwner;
        final pending = state.ownerBookingRequests.where((b) => b.status == 'Pending').toList();
        return ListView(
          padding: const EdgeInsets.fromLTRB(18, 8, 18, 90),
          children: [
            Row(
              children: [
                SbAvatar(initials: owner.initials),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(owner.name, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14)),
                      Text('Vehicle Owner · ${owner.id}',
                          style: const TextStyle(color: AppColors.muted, fontSize: 11)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: _statBox('₱${state.ownerEarningsToday}', 'Today')),
                const SizedBox(width: 8),
                Expanded(child: _statBox('₱${state.ownerEarningsWeek}', 'This Week')),
                const SizedBox(width: 8),
                Expanded(child: _statBox('${state.ownerVehicles.length}', 'Vehicles')),
              ],
            ),
            const SizedBox(height: 20),
            const Text('My Fleet', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 13.5)),
            const SizedBox(height: 10),
            ...state.ownerVehicles.map(
              (v) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: SbCard(
                  padding: const EdgeInsets.all(13),
                  child: Row(
                    children: [
                      Container(
                        width: 42,
                        height: 42,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(color: AppColors.panel2, borderRadius: BorderRadius.circular(12)),
                        child: Icon(v.icon, size: 20, color: AppColors.primaryLight),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(v.name, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 12.5)),
                            Text('Plate ${v.plate} · ₱${v.pricePerDay}/day',
                                style: const TextStyle(color: AppColors.muted, fontSize: 11)),
                          ],
                        ),
                      ),
                      SbTag(v.status, secondary: v.status == 'Listed'),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Booking Requests', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 13.5)),
                SbTag('${pending.length} New', secondary: true),
              ],
            ),
            const SizedBox(height: 10),
            if (pending.isEmpty)
              const Padding(
                padding: EdgeInsets.only(top: 8),
                child: Text('No pending booking requests right now.',
                    style: TextStyle(color: AppColors.muted, fontSize: 12.5)),
              )
            else
              ...pending.map((b) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: _bookingCard(context, state, b),
                  )),
          ],
        );
      },
    );
    if (embedded) return SafeArea(bottom: false, child: content);
    return Scaffold(body: content);
  }

  Widget _bookingCard(BuildContext context, AppState state, OwnerBookingRequest b) {
    return SbCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SbAvatar(initials: b.renterInitials, size: 32),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${b.renterName} wants to rent',
                        style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13)),
                    Text(b.vehicleName, style: const TextStyle(color: AppColors.muted, fontSize: 11.5)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text('${b.startDate} → ${b.endDate}', style: const TextStyle(color: AppColors.muted, fontSize: 11.5)),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('₱${b.totalFare}',
                  style: const TextStyle(fontWeight: FontWeight.w800, color: AppColors.primaryLight)),
              Row(
                children: [
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9)),
                    onPressed: () => state.respondToOwnerBooking(b, accepted: false),
                    child: const Text('Decline'),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
                    ),
                    onPressed: () {
                      state.respondToOwnerBooking(b, accepted: true);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Accepted ${b.renterName}\'s booking (simulated)')),
                      );
                    },
                    child: const Text('Accept'),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _statBox(String value, String label) {
    return SbCard(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        children: [
          Text(value, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15, color: AppColors.primaryLight)),
          const SizedBox(height: 2),
          Text(label, style: const TextStyle(color: AppColors.muted, fontSize: 10)),
        ],
      ),
    );
  }
}
