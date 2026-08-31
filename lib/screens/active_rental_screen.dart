import 'package:flutter/material.dart';
import '../state/app_state.dart';
import '../theme/app_colors.dart';
import '../widgets/common.dart';

/// Full detail view for the passenger's current rental request/active
/// rental — pushed from the pending/active card on the Home tab. Reflects
/// [AppState.activeRentalBooking] live, so if the 10s simulated owner
/// approval fires while this screen is open it flips from Pending to
/// Active in place.
class ActiveRentalScreen extends StatelessWidget {
  const ActiveRentalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppState.instance;
    return Scaffold(
      body: ListenableBuilder(
        listenable: state,
        builder: (context, _) {
          final booking = state.activeRentalBooking;
          if (booking == null) {
            // Booking was completed/cancelled elsewhere while this screen
            // was open (e.g. returned from another device in a real app).
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (Navigator.canPop(context)) Navigator.pop(context);
            });
            return const SizedBox.shrink();
          }
          final isPending = booking.status == 'Pending';
          return SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 8, 18, 0),
                  child: Row(
                    children: [
                      SbIconButton(icon: Icons.arrow_back, onTap: () => Navigator.pop(context)),
                      const SizedBox(width: 10),
                      const Text('Your Rental', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                SbMapPlaceholder(
                  height: 200,
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            if (isPending)
                              SizedBox(
                                width: 84,
                                height: 84,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                  valueColor: const AlwaysStoppedAnimation(AppColors.primary),
                                  backgroundColor: AppColors.panel2,
                                ),
                              ),
                            Container(
                              width: 64,
                              height: 64,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: AppColors.panel,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: isPending ? AppColors.primary : AppColors.secondary,
                                  width: 2,
                                ),
                              ),
                              child: Icon(booking.icon, size: 28, color: AppColors.primaryLight),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          isPending ? 'Waiting for owner approval…' : 'Rental is active',
                          style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(18, 16, 18, 18),
                    child: Column(
                      children: [
                        SbCard(
                          borderColor: (isPending ? AppColors.primary : AppColors.secondary).withValues(alpha: 0.3),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  SbTag(booking.status, secondary: !isPending),
                                  Text(booking.vehicleType,
                                      style: const TextStyle(color: AppColors.muted, fontSize: 11.5)),
                                ],
                              ),
                              const SizedBox(height: 14),
                              Row(
                                children: [
                                  SbAvatar(initials: booking.ownerInitials),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(booking.vehicleName,
                                            style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14)),
                                        Text('Owned by ${booking.ownerName}',
                                            style: const TextStyle(color: AppColors.muted, fontSize: 11.5)),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 14),
                              Row(
                                children: [
                                  Expanded(child: SbField(label: 'Pick-up', value: booking.pickupLabel)),
                                  const SizedBox(width: 8),
                                  Expanded(child: SbField(label: 'Return', value: booking.returnLabel)),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('${booking.days} day${booking.days > 1 ? 's' : ''} total',
                                      style: const TextStyle(color: AppColors.muted, fontSize: 12)),
                                  Text('₱${booking.totalFare}',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w800, color: AppColors.primaryLight, fontSize: 15)),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          isPending
                              ? '${booking.ownerName} has been notified of your request. This usually takes a few minutes — we\'ll update this screen the moment it\'s approved.'
                              : 'Your rental is active. Ride safe, and tap "Return Vehicle" once you bring it back to the owner.',
                          style: const TextStyle(color: AppColors.muted, fontSize: 12, height: 1.6),
                        ),
                        const SizedBox(height: 18),
                        if (isPending)
                          SbOutlineButton(
                            label: 'Cancel Request',
                            icon: Icons.close,
                            onPressed: () {
                              state.cancelRentalBooking();
                              Navigator.pop(context);
                            },
                          )
                        else
                          SbPrimaryButton(
                            label: 'Return Vehicle',
                            icon: Icons.check_circle_outline,
                            onPressed: () {
                              state.completeActiveRental();
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('${booking.vehicleName} returned — thanks for riding with SurGo!')),
                              );
                            },
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
