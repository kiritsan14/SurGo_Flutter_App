import 'package:flutter/material.dart';

/// A vehicle option shown on the "choose a vehicle" step of booking.
class RideOption {
  final String name;
  final IconData icon;
  final String etaLabel;
  final String capacityLabel;
  final int fare;

  const RideOption({
    required this.name,
    required this.icon,
    required this.etaLabel,
    required this.capacityLabel,
    required this.fare,
  });
}

/// A driver / rider profile used for matches and live trips.
class Driver {
  final String name;
  final String initials;
  final double rating;
  final int trips;
  final String plate;
  final String vehicleType;

  const Driver({
    required this.name,
    required this.initials,
    required this.rating,
    required this.trips,
    required this.plate,
    required this.vehicleType,
  });
}

/// A past booking shown on the Home screen's "Recent Bookings".
class RecentBooking {
  final String route;
  final String subtitle;
  final int fare;
  final String status;

  const RecentBooking({
    required this.route,
    required this.subtitle,
    required this.fare,
    required this.status,
  });
}

/// A rentable vehicle listing.
class RentalVehicle {
  final String name;
  final String type;
  final IconData icon;
  final String location;
  final String availability;
  final int pricePerDay;
  final double rating;
  final String ownerName;
  final String ownerInitials;
  final String description;
  final int depositFee;

  const RentalVehicle({
    required this.name,
    required this.type,
    required this.icon,
    required this.location,
    required this.availability,
    required this.pricePerDay,
    required this.rating,
    required this.ownerName,
    required this.ownerInitials,
    required this.description,
    required this.depositFee,
  });
}

/// An incoming ride request shown to a rider (driver).
class RideRequest {
  final String passengerName;
  final double distanceKm;
  final String pickup;
  final String dropoff;
  final int etaMinutes;
  final int fare;

  const RideRequest({
    required this.passengerName,
    required this.distanceKm,
    required this.pickup,
    required this.dropoff,
    required this.etaMinutes,
    required this.fare,
  });
}

/// Static/mock seed data for the whole simulation.
class MockData {
  MockData._();

  static const passengerName = 'Marisol Cruz';
  static const passengerFirstName = 'Marisol';
  static const passengerInitials = 'MC';
  static const passengerRating = 4.9;
  static const memberSince = 2024;
  static const phoneNumber = '+63 917 512 4809';

  static const List<RideOption> rideOptions = [
    RideOption(
      name: 'Tricycle',
      icon: Icons.electric_rickshaw,
      etaLabel: '2 min away',
      capacityLabel: 'Fits 2',
      fare: 45,
    ),
    RideOption(
      name: 'Motorcycle',
      icon: Icons.two_wheeler,
      etaLabel: '1 min away',
      capacityLabel: 'Fits 1',
      fare: 30,
    ),
  ];

  static const Driver matchedDriver = Driver(
    name: 'Junel Ramos',
    initials: 'JR',
    rating: 4.9,
    trips: 1240,
    plate: 'NGD 4821',
    vehicleType: 'Tricycle',
  );

  static const List<RecentBooking> recentBookings = [
    RecentBooking(
      route: 'Poblacion → SM Terminal',
      subtitle: 'Yesterday, 6:40 PM · ₱65',
      fare: 65,
      status: 'Done',
    ),
    RecentBooking(
      route: 'Purok 5 → Barangay Hall',
      subtitle: 'Aug 24, 8:12 AM · ₱30',
      fare: 30,
      status: 'Done',
    ),
  ];

  static const List<RentalVehicle> rentalVehicles = [
    RentalVehicle(
      name: 'Suzuki Multicab',
      type: 'Multicab',
      icon: Icons.airport_shuttle,
      location: 'Poblacion',
      availability: 'Available today',
      pricePerDay: 900,
      rating: 4.8,
      ownerName: 'Rico D.',
      ownerInitials: 'RD',
      description:
          '7-seater, manual, good for barangay fiesta hauling or a group day trip. Full tank required on return.',
      depositFee: 500,
    ),
    RentalVehicle(
      name: 'Honda Click 125',
      type: 'Motorcycle',
      icon: Icons.two_wheeler,
      location: 'Purok 5',
      availability: 'Available today',
      pricePerDay: 350,
      rating: 4.9,
      ownerName: 'Alex Tan',
      ownerInitials: 'AT',
      description:
          'Fuel-efficient automatic scooter, easy to handle on barangay roads. Helmet included, full tank required on return.',
      depositFee: 300,
    ),
    RentalVehicle(
      name: 'Toyota HiAce Van',
      type: 'Van',
      icon: Icons.airport_shuttle,
      location: 'Downtown',
      availability: 'From tomorrow',
      pricePerDay: 3200,
      rating: 4.7,
      ownerName: 'Nena V.',
      ownerInitials: 'NV',
      description:
          '15-seater van, air-conditioned, ideal for out-of-town trips or large group transport. Driver available on request.',
      depositFee: 2000,
    ),
  ];

  static const riderName = 'Rahel Santos';
  static const riderInitials = 'RS';
  static const riderId = 'FFI03892';
  static const riderEarningsToday = 1240;
  static const riderTripsToday = 4;
  static const riderOnlineTime = '5h 20m';

  static const List<RideRequest> incomingRequests = [
    RideRequest(
      passengerName: 'Alex',
      distanceKm: 10.4,
      pickup: 'Sector V',
      dropoff: 'Riverside Mall',
      etaMinutes: 26,
      fare: 180,
    ),
    RideRequest(
      passengerName: 'Grace',
      distanceKm: 3.1,
      pickup: 'Purok 3',
      dropoff: 'Public Market',
      etaMinutes: 9,
      fare: 55,
    ),
  ];
}
