import 'package:flutter/material.dart';
import '../state/app_state.dart';
import '../theme/app_colors.dart';
import '../widgets/common.dart';

class RiderTripsScreen extends StatelessWidget {
  const RiderTripsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppState.instance;
    return Scaffold(
      appBar: AppBar(title: const Text('My Trips')),
      body: ListenableBuilder(
        listenable: state,
        builder: (context, _) {
          final trips = state.riderTrips;
          if (trips.isEmpty) {
            return const Center(child: Text('No trips yet', style: TextStyle(color: AppColors.muted)));
          }
          return ListView.separated(
            padding: const EdgeInsets.fromLTRB(18, 12, 18, 24),
            itemCount: trips.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, i) {
              final t = trips[i];
              final cancelled = t.status == 'Cancelled';
              return SbCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(t.passengerName,
                              style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13)),
                        ),
                        SbTag(t.status, secondary: !cancelled),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(t.route, style: const TextStyle(color: AppColors.muted, fontSize: 11.5)),
                    const SizedBox(height: 2),
                    Text('${t.date} · ${t.distanceKm} km',
                        style: const TextStyle(color: AppColors.muted2, fontSize: 10.5)),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('₱${t.fare}',
                            style: const TextStyle(fontWeight: FontWeight.w800, color: AppColors.secondaryLight)),
                        if (!cancelled)
                          Row(
                            children: [
                              const Icon(Icons.star_rounded, size: 14, color: AppColors.yellow),
                              Text('${t.rating}', style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700)),
                            ],
                          ),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
