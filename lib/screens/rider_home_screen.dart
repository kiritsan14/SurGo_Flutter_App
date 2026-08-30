import 'package:flutter/material.dart';
import '../state/app_state.dart';
import '../theme/app_colors.dart';
import '../widgets/common.dart';
import 'notifications_screen.dart';
import 'rider_earnings_screen.dart';
import 'rider_profile_screen.dart';
import 'rider_trips_screen.dart';

/// The rider's home dashboard. This is a mode "root": once a passenger
/// switches into Rider Mode, there is intentionally no back button and no
/// in-dashboard shortcut to Passenger Mode here — switching back only
/// happens from the Rider Profile tab, mirroring how the passenger side
/// only offers "Switch to Rider" from its own Profile screen.
class RiderHomeScreen extends StatelessWidget {
  const RiderHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppState.instance;
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text('Rider Mode'),
          actions: [
            ListenableBuilder(
              listenable: state,
              builder: (context, _) => Stack(
                clipBehavior: Clip.none,
                children: [
                  IconButton(
                    icon: const Icon(Icons.notifications_none),
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const NotificationsScreen(isRider: true)),
                    ),
                  ),
                  if (state.unreadRiderNotifications > 0)
                    Positioned(
                      top: 6,
                      right: 6,
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
            ),
            const SizedBox(width: 6),
          ],
        ),
        body: ListenableBuilder(
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
                      child: SbCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('${r.passengerName} wants a ride',
                                    style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13)),
                                Text('${r.distanceKm} km', style: const TextStyle(color: AppColors.muted, fontSize: 11)),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text('📍 ${r.pickup} → 🏁 ${r.dropoff} · ${r.etaMinutes} min',
                                style: const TextStyle(color: AppColors.muted, fontSize: 11.5)),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('₱${r.fare}',
                                    style: const TextStyle(fontWeight: FontWeight.w800, color: AppColors.primaryLight)),
                                Row(
                                  children: [
                                    OutlinedButton(
                                      style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9)),
                                      onPressed: () => state.respondToRequest(r, accepted: false),
                                      child: const Text('Decline'),
                                    ),
                                    const SizedBox(width: 8),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.secondary,
                                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
                                      ),
                                      onPressed: () {
                                        state.respondToRequest(r, accepted: true);
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text('Accepted ${r.passengerName}\'s ride (simulated)')),
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
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
        bottomNavigationBar: SbBottomNav(
          activeIndex: 0,
          items: const [
            SbNavItem(Icons.home_rounded, 'Home'),
            SbNavItem(Icons.view_agenda_outlined, 'Trips'),
            SbNavItem(Icons.account_balance_wallet_outlined, 'Earnings'),
            SbNavItem(Icons.person_outline, 'Profile'),
          ],
          onTap: (i) {
            if (i == 0) return;
            if (i == 1) {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const RiderTripsScreen()));
            } else if (i == 2) {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const RiderEarningsScreen()));
            } else if (i == 3) {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const RiderProfileScreen()));
            }
          },
        ),
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
