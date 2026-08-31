import 'package:flutter/material.dart';
import '../state/app_state.dart';
import '../theme/app_colors.dart';
import '../widgets/common.dart';
import '../widgets/ride_request_card.dart';
import 'notifications_screen.dart';

/// The rider's home dashboard tab. When [embedded] (the normal case, inside
/// [RiderShell]) this renders without its own Scaffold/bottom nav — the
/// shell supplies those and handles the sliding Home/Trips/Earnings/Profile
/// tab transitions.
class RiderHomeScreen extends StatelessWidget {
  final bool embedded;
  const RiderHomeScreen({super.key, this.embedded = true});

  @override
  Widget build(BuildContext context) {
    final state = AppState.instance;
    final content = ListenableBuilder(
      listenable: state,
      builder: (context, _) {
        final rider = state.db.rider;
        return ListView(
          padding: const EdgeInsets.fromLTRB(18, 8, 18, 90),
          children: [
            Row(
              children: [
                SbAvatar(initials: rider.initials),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(rider.name, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14)),
                      Text('Rider ID ${rider.id}', style: const TextStyle(color: AppColors.muted, fontSize: 11)),
                    ],
                  ),
                ),
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    SbIconButton(
                      icon: Icons.notifications_none,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const NotificationsScreen(isRider: true)),
                      ),
                    ),
                    if (state.unreadRiderNotifications > 0)
                      Positioned(
                        top: -2,
                        right: -2,
                        child: Container(
                          width: 15,
                          height: 15,
                          alignment: Alignment.center,
                          decoration: const BoxDecoration(color: AppColors.secondary, shape: BoxShape.circle),
                          child: Text(
                            '${state.unreadRiderNotifications}',
                            style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w800, color: AppColors.onAccent),
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            SbCard(
              borderColor: AppColors.secondary.withValues(alpha: 0.35),
              child: Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: state.riderOnline ? AppColors.secondary : AppColors.muted2,
                      shape: BoxShape.circle,
                      boxShadow: state.riderOnline
                          ? [const BoxShadow(color: AppColors.secondarySoft, blurRadius: 0, spreadRadius: 3)]
                          : null,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(state.riderOnline ? "You're Online" : "You're Offline",
                            style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13)),
                        const Text('Visible for new ride requests',
                            style: TextStyle(color: AppColors.muted, fontSize: 11)),
                      ],
                    ),
                  ),
                  Switch(
                    value: state.riderOnline,
                    activeColor: Colors.white,
                    activeTrackColor: AppColors.secondary,
                    inactiveTrackColor: AppColors.panel2,
                    onChanged: (_) => state.toggleRiderOnline(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(child: _statBox('₱${state.earningsToday}', 'Earnings')),
                const SizedBox(width: 8),
                Expanded(child: _statBox('${state.riderTrips.where((t) => t.status == 'Completed').length}', 'Trips')),
                const SizedBox(width: 8),
                Expanded(child: _statBox('5h 20m', 'Online')),
              ],
            ),
            const SizedBox(height: 18),
            if (state.activeRide != null) SbActiveRideBanner(ride: state.activeRide!),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Incoming Requests', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 13.5)),
                SbTag('${state.pendingRequests.length} New', secondary: true),
              ],
            ),
            const SizedBox(height: 10),
            if (!state.riderOnline)
              const Padding(
                padding: EdgeInsets.only(top: 8),
                child: Text(
                  "You're offline — go online to receive ride requests.",
                  style: TextStyle(color: AppColors.muted, fontSize: 12.5),
                ),
              )
            else if (state.pendingRequests.isEmpty)
              const Padding(
                padding: EdgeInsets.only(top: 8),
                child: Text('No pending requests right now.', style: TextStyle(color: AppColors.muted, fontSize: 12.5)),
              )
            else
              ...state.pendingRequests.map(
                (r) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: SbRideRequestCard(request: r),
                ),
              ),
          ],
        );
      },
    );

    if (embedded) return SafeArea(bottom: false, child: content);

    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(automaticallyImplyLeading: false, title: const Text('Rider Mode')),
        body: content,
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
