import 'package:flutter/material.dart';

/// Typed wrappers around the raw JSON records in assets/db/mock_database.json.
/// Every model below has a `fromJson` factory so DbService can parse the
/// "temporary database" file once at startup. Nothing here talks to a real
/// backend — this is purely an offline UI simulation.

class NotificationItem {
  final String id;
  final String type; // promo, ride, payment, system, safety, rating
  final String title;
  final String body;
  final String time;
  bool read;

  NotificationItem({
    required this.id,
    required this.type,
    required this.title,
    required this.body,
    required this.time,
    required this.read,
  });

  factory NotificationItem.fromJson(Map<String, dynamic> j) => NotificationItem(
        id: j['id'],
        type: j['type'],
        title: j['title'],
        body: j['body'],
        time: j['time'],
        read: j['read'] ?? false,
      );

  IconData get icon {
    switch (type) {
      case 'promo':
        return Icons.local_offer_outlined;
      case 'ride':
        return Icons.electric_rickshaw;
      case 'payment':
        return Icons.account_balance_wallet_outlined;
      case 'safety':
        return Icons.shield_outlined;
      case 'rating':
        return Icons.star_border_rounded;
      default:
        return Icons.notifications_none;
    }
  }
}

class WalletTransaction {
  final String id;
  final String type; // debit, credit, topup, payout
  final String title;
  final int amount;
  final String date;
  final String status;

  const WalletTransaction({
    required this.id,
    required this.type,
    required this.title,
    required this.amount,
    required this.date,
    required this.status,
  });

  factory WalletTransaction.fromJson(Map<String, dynamic> j) => WalletTransaction(
        id: j['id'],
        type: j['type'],
        title: j['title'],
        amount: j['amount'],
        date: j['date'],
        status: j['status'],
      );

  bool get isPositive => type == 'topup' || type == 'credit';
}

class PaymentMethodItem {
  final String id;
  final String type; // cash, gcash, maya, card
  final String label;
  final String detail;
  bool isDefault;

  PaymentMethodItem({
    required this.id,
    required this.type,
    required this.label,
    required this.detail,
    required this.isDefault,
  });

  factory PaymentMethodItem.fromJson(Map<String, dynamic> j) => PaymentMethodItem(
        id: j['id'],
        type: j['type'],
        label: j['label'],
        detail: j['detail'],
        isDefault: j['isDefault'] ?? false,
      );

  IconData get icon {
    switch (type) {
      case 'gcash':
        return Icons.qr_code_2_rounded;
      case 'maya':
        return Icons.credit_card;
      case 'card':
        return Icons.credit_card;
      default:
        return Icons.payments_outlined;
    }
  }
}

class SavedPlace {
  final String id;
  final String label;
  final String address;
  final String icon; // home, work, place

  const SavedPlace({
    required this.id,
    required this.label,
    required this.address,
    required this.icon,
  });

  factory SavedPlace.fromJson(Map<String, dynamic> j) => SavedPlace(
        id: j['id'],
        label: j['label'],
        address: j['address'],
        icon: j['icon'],
      );

  IconData get iconData {
    switch (icon) {
      case 'home':
        return Icons.home_outlined;
      case 'work':
        return Icons.work_outline;
      default:
        return Icons.place_outlined;
    }
  }
}

class FavoriteRider {
  final String id;
  final String name;
  final String initials;
  final double rating;
  final int trips;
  final String vehicleType;
  final String plate;

  const FavoriteRider({
    required this.id,
    required this.name,
    required this.initials,
    required this.rating,
    required this.trips,
    required this.vehicleType,
    required this.plate,
  });

  factory FavoriteRider.fromJson(Map<String, dynamic> j) => FavoriteRider(
        id: j['id'],
        name: j['name'],
        initials: j['initials'],
        rating: (j['rating'] as num).toDouble(),
        trips: j['trips'],
        vehicleType: j['vehicleType'],
        plate: j['plate'],
      );
}

class FavoriteVehicle {
  final String id;
  final String name;
  final String type;
  final int pricePerDay;
  final String ownerName;

  const FavoriteVehicle({
    required this.id,
    required this.name,
    required this.type,
    required this.pricePerDay,
    required this.ownerName,
  });

  factory FavoriteVehicle.fromJson(Map<String, dynamic> j) => FavoriteVehicle(
        id: j['id'],
        name: j['name'],
        type: j['type'],
        pricePerDay: j['pricePerDay'],
        ownerName: j['ownerName'],
      );
}

class EmergencyContactItem {
  final String id;
  final String name;
  final String relation;
  final String phone;

  const EmergencyContactItem({
    required this.id,
    required this.name,
    required this.relation,
    required this.phone,
  });

  factory EmergencyContactItem.fromJson(Map<String, dynamic> j) => EmergencyContactItem(
        id: j['id'],
        name: j['name'],
        relation: j['relation'],
        phone: j['phone'],
      );
}

class RideHistoryItem {
  final String id;
  final String route;
  final String date;
  final int fare;
  final String status;
  final String vehicleType;
  final String driverName;
  final int rating;

  const RideHistoryItem({
    required this.id,
    required this.route,
    required this.date,
    required this.fare,
    required this.status,
    required this.vehicleType,
    required this.driverName,
    required this.rating,
  });

  factory RideHistoryItem.fromJson(Map<String, dynamic> j) => RideHistoryItem(
        id: j['id'],
        route: j['route'],
        date: j['date'],
        fare: j['fare'],
        status: j['status'],
        vehicleType: j['vehicleType'],
        driverName: j['driverName'],
        rating: j['rating'],
      );
}

class RentalHistoryItem {
  final String id;
  final String vehicleName;
  final String ownerName;
  final String startDate;
  final String endDate;
  final int totalFare;
  final String status;

  const RentalHistoryItem({
    required this.id,
    required this.vehicleName,
    required this.ownerName,
    required this.startDate,
    required this.endDate,
    required this.totalFare,
    required this.status,
  });

  factory RentalHistoryItem.fromJson(Map<String, dynamic> j) => RentalHistoryItem(
        id: j['id'],
        vehicleName: j['vehicleName'],
        ownerName: j['ownerName'],
        startDate: j['startDate'],
        endDate: j['endDate'],
        totalFare: j['totalFare'],
        status: j['status'],
      );
}

class RiderTripItem {
  final String id;
  final String passengerName;
  final String route;
  final String date;
  final int fare;
  final double distanceKm;
  final String status;
  final int rating;

  const RiderTripItem({
    required this.id,
    required this.passengerName,
    required this.route,
    required this.date,
    required this.fare,
    required this.distanceKm,
    required this.status,
    required this.rating,
  });

  factory RiderTripItem.fromJson(Map<String, dynamic> j) => RiderTripItem(
        id: j['id'],
        passengerName: j['passengerName'],
        route: j['route'],
        date: j['date'],
        fare: j['fare'],
        distanceKm: (j['distanceKm'] as num).toDouble(),
        status: j['status'],
        rating: j['rating'],
      );
}

class DailyEarning {
  final String day;
  final int amount;
  const DailyEarning({required this.day, required this.amount});

  factory DailyEarning.fromJson(Map<String, dynamic> j) =>
      DailyEarning(day: j['day'], amount: j['amount']);
}

class PayoutItem {
  final String id;
  final String date;
  final int amount;
  final String method;
  final String status;

  const PayoutItem({
    required this.id,
    required this.date,
    required this.amount,
    required this.method,
    required this.status,
  });

  factory PayoutItem.fromJson(Map<String, dynamic> j) => PayoutItem(
        id: j['id'],
        date: j['date'],
        amount: j['amount'],
        method: j['method'],
        status: j['status'],
      );
}

class PassengerProfile {
  final String id;
  final String name;
  final String firstName;
  final String initials;
  final String phone;
  final String email;
  final double rating;
  final int totalRides;
  final int memberSince;
  final bool verified;

  const PassengerProfile({
    required this.id,
    required this.name,
    required this.firstName,
    required this.initials,
    required this.phone,
    required this.email,
    required this.rating,
    required this.totalRides,
    required this.memberSince,
    required this.verified,
  });

  factory PassengerProfile.fromJson(Map<String, dynamic> j) => PassengerProfile(
        id: j['id'],
        name: j['name'],
        firstName: j['firstName'],
        initials: j['initials'],
        phone: j['phone'],
        email: j['email'],
        rating: (j['rating'] as num).toDouble(),
        totalRides: j['totalRides'],
        memberSince: j['memberSince'],
        verified: j['verified'] ?? false,
      );
}

class RiderProfile {
  final String id;
  final String name;
  final String initials;
  final String phone;
  final String email;
  final double rating;
  final int totalTrips;
  final int memberSince;
  final bool verified;
  final String vehicleType;
  final String vehicleModel;
  final String vehiclePlate;
  final String documentsStatus;

  const RiderProfile({
    required this.id,
    required this.name,
    required this.initials,
    required this.phone,
    required this.email,
    required this.rating,
    required this.totalTrips,
    required this.memberSince,
    required this.verified,
    required this.vehicleType,
    required this.vehicleModel,
    required this.vehiclePlate,
    required this.documentsStatus,
  });

  factory RiderProfile.fromJson(Map<String, dynamic> j) => RiderProfile(
        id: j['id'],
        name: j['name'],
        initials: j['initials'],
        phone: j['phone'],
        email: j['email'],
        rating: (j['rating'] as num).toDouble(),
        totalTrips: j['totalTrips'],
        memberSince: j['memberSince'],
        verified: j['verified'] ?? false,
        vehicleType: j['vehicleType'],
        vehicleModel: j['vehicleModel'],
        vehiclePlate: j['vehiclePlate'],
        documentsStatus: j['documentsStatus'],
      );
}

class AccountSettingsData {
  bool pushNotifications;
  bool smsAlerts;
  bool autoAcceptNearby;
  bool lowDataMode;
  String language;

  AccountSettingsData({
    required this.pushNotifications,
    this.smsAlerts = false,
    this.autoAcceptNearby = false,
    required this.lowDataMode,
    required this.language,
  });

  factory AccountSettingsData.fromJson(Map<String, dynamic> j) => AccountSettingsData(
        pushNotifications: j['pushNotifications'] ?? true,
        smsAlerts: j['smsAlerts'] ?? false,
        autoAcceptNearby: j['autoAcceptNearby'] ?? false,
        lowDataMode: j['lowDataMode'] ?? false,
        language: j['language'] ?? 'English',
      );
}
