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

class VehicleOwnerProfile {
  final String id;
  final String name;
  final String initials;
  final String phone;
  final String email;
  final double rating;
  final int totalVehicles;
  final int totalRentals;
  final int memberSince;
  final bool verified;

  const VehicleOwnerProfile({
    required this.id,
    required this.name,
    required this.initials,
    required this.phone,
    required this.email,
    required this.rating,
    required this.totalVehicles,
    required this.totalRentals,
    required this.memberSince,
    required this.verified,
  });

  factory VehicleOwnerProfile.fromJson(Map<String, dynamic> j) => VehicleOwnerProfile(
        id: j['id'],
        name: j['name'],
        initials: j['initials'],
        phone: j['phone'],
        email: j['email'],
        rating: (j['rating'] as num).toDouble(),
        totalVehicles: j['totalVehicles'],
        totalRentals: j['totalRentals'],
        memberSince: j['memberSince'],
        verified: j['verified'] ?? false,
      );
}

/// One barangay in Tandag City, together with its puroks — used to power
/// the pickup/destination barangay + purok picker.
class Barangay {
  final String name;
  final List<String> puroks;

  const Barangay({required this.name, required this.puroks});

  factory Barangay.fromJson(Map<String, dynamic> j) => Barangay(
        name: j['barangay'],
        puroks: (j['puroks'] as List).map((e) => e.toString()).toList(),
      );
}

/// A rich incoming ride request shown to a rider, with enough detail to
/// support an expandable "view details / map" card.
class RideRequestItem {
  final String id;
  final String passengerName;
  final String passengerInitials;
  final double passengerRating;
  final String pickupBarangay;
  final String pickupPurok;
  final String pickup;
  final String dropoffBarangay;
  final String dropoffPurok;
  final String dropoff;
  final double distanceKm;
  final int etaMinutes;
  final int fare;
  final String paymentMethod;
  final String note;
  final String requestedAt;

  const RideRequestItem({
    required this.id,
    required this.passengerName,
    required this.passengerInitials,
    required this.passengerRating,
    required this.pickupBarangay,
    required this.pickupPurok,
    required this.pickup,
    required this.dropoffBarangay,
    required this.dropoffPurok,
    required this.dropoff,
    required this.distanceKm,
    required this.etaMinutes,
    required this.fare,
    required this.paymentMethod,
    required this.note,
    required this.requestedAt,
  });

  factory RideRequestItem.fromJson(Map<String, dynamic> j) => RideRequestItem(
        id: j['id'],
        passengerName: j['passengerName'],
        passengerInitials: j['passengerInitials'],
        passengerRating: (j['passengerRating'] as num).toDouble(),
        pickupBarangay: j['pickupBarangay'],
        pickupPurok: j['pickupPurok'],
        pickup: j['pickup'],
        dropoffBarangay: j['dropoffBarangay'],
        dropoffPurok: j['dropoffPurok'],
        dropoff: j['dropoff'],
        distanceKm: (j['distanceKm'] as num).toDouble(),
        etaMinutes: j['etaMinutes'],
        fare: j['fare'],
        paymentMethod: j['paymentMethod'],
        note: j['note'] ?? '',
        requestedAt: j['requestedAt'] ?? 'Just now',
      );
}

/// A verified rider/vehicle compliance document (driver's license, OR/CR…).
class VehicleDocumentItem {
  final String id;
  final String title;
  final String number;
  final String status;
  final String expiry;
  final String icon;

  const VehicleDocumentItem({
    required this.id,
    required this.title,
    required this.number,
    required this.status,
    required this.expiry,
    required this.icon,
  });

  factory VehicleDocumentItem.fromJson(Map<String, dynamic> j) => VehicleDocumentItem(
        id: j['id'],
        title: j['title'],
        number: j['number'],
        status: j['status'],
        expiry: j['expiry'],
        icon: j['icon'] ?? 'file',
      );

  IconData get iconData {
    switch (icon) {
      case 'license':
        return Icons.badge_outlined;
      case 'orcr':
        return Icons.description_outlined;
      case 'insurance':
        return Icons.shield_outlined;
      case 'clearance':
        return Icons.verified_user_outlined;
      case 'nbi':
        return Icons.fingerprint;
      default:
        return Icons.insert_drive_file_outlined;
    }
  }
}

/// A vehicle owned by the current user in Vehicle Owner mode.
class OwnedVehicle {
  final String id;
  final String name;
  final String type;
  final String category; // 2-Wheel, 3-Wheel, 4-Wheel, Truck
  final String plate;
  final int pricePerDay;
  String status; // Listed, Rented, Maintenance
  final double rating;
  final int totalRentals;

  OwnedVehicle({
    required this.id,
    required this.name,
    required this.type,
    required this.category,
    required this.plate,
    required this.pricePerDay,
    required this.status,
    required this.rating,
    required this.totalRentals,
  });

  factory OwnedVehicle.fromJson(Map<String, dynamic> j) => OwnedVehicle(
        id: j['id'],
        name: j['name'],
        type: j['type'],
        category: j['category'] ?? categoryForType(j['type']),
        plate: j['plate'],
        pricePerDay: j['pricePerDay'],
        status: j['status'],
        rating: (j['rating'] as num).toDouble(),
        totalRentals: j['totalRentals'],
      );

  /// Best-guess category for vehicles that predate the `category` field.
  static String categoryForType(String type) {
    switch (type) {
      case 'Motorcycle':
      case 'Scooter':
      case 'E-bike':
        return '2-Wheel';
      case 'Tricycle':
        return '3-Wheel';
      case 'Truck':
      case 'Pickup':
        return 'Truck';
      default:
        return '4-Wheel';
    }
  }

  static const categories = ['2-Wheel', '3-Wheel', '4-Wheel', 'Truck'];

  static const typesByCategory = {
    '2-Wheel': ['Motorcycle', 'Scooter', 'E-bike'],
    '3-Wheel': ['Tricycle'],
    '4-Wheel': ['Car', 'Sedan', 'SUV', 'Van', 'Multicab'],
    'Truck': ['Truck', 'Pickup'],
  };

  IconData get icon {
    switch (category) {
      case '2-Wheel':
        return Icons.two_wheeler;
      case '3-Wheel':
        return Icons.electric_rickshaw;
      case 'Truck':
        return Icons.local_shipping_outlined;
      default:
        return type == 'Van' || type == 'Multicab' ? Icons.airport_shuttle : Icons.directions_car;
    }
  }
}

/// An incoming rental booking request for one of the owner's vehicles.
class OwnerBookingRequest {
  final String id;
  final String renterName;
  final String renterInitials;
  final String vehicleName;
  final String startDate;
  final String endDate;
  final int totalFare;
  String status; // Pending, Accepted, Declined

  OwnerBookingRequest({
    required this.id,
    required this.renterName,
    required this.renterInitials,
    required this.vehicleName,
    required this.startDate,
    required this.endDate,
    required this.totalFare,
    required this.status,
  });

  factory OwnerBookingRequest.fromJson(Map<String, dynamic> j) => OwnerBookingRequest(
        id: j['id'],
        renterName: j['renterName'],
        renterInitials: j['renterInitials'],
        vehicleName: j['vehicleName'],
        startDate: j['startDate'],
        endDate: j['endDate'],
        totalFare: j['totalFare'],
        status: j['status'],
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

// ============================================================================
// Map V1 — typed wrappers around assets/data/surgo_map_v1_mock_data.json.
// Fixed mock coordinates for riders/rentals/passengers/ride-requests; the
// live device GPS position is resolved separately at runtime by
// LocationService and is never read from this file.
// ============================================================================

/// A point on the map. Kept as a plain lat/lng pair (instead of pulling in
/// latlong2's LatLng here) so this model file has no Flutter-map dependency.
class MapPoint {
  final double latitude;
  final double longitude;
  const MapPoint(this.latitude, this.longitude);

  factory MapPoint.fromJson(Map<String, dynamic> j) => MapPoint(
        (j['latitude'] as num).toDouble(),
        (j['longitude'] as num).toDouble(),
      );
}

class MapConfigData {
  final MapPoint defaultCenter;
  final double defaultZoom;
  final String city;
  final String province;

  const MapConfigData({
    required this.defaultCenter,
    required this.defaultZoom,
    required this.city,
    required this.province,
  });

  factory MapConfigData.fromJson(Map<String, dynamic> j) => MapConfigData(
        defaultCenter: MapPoint.fromJson(j['default_center']),
        defaultZoom: (j['default_zoom'] as num).toDouble(),
        city: j['city'] ?? 'Tandag City',
        province: j['province'] ?? 'Surigao del Sur',
      );
}

/// A fixed mock rider/driver shown on the map (motorcycle or tricycle).
class MapRider {
  final String id;
  final String name;
  final String vehicleType; // motorcycle, tricycle
  final String vehicleModel;
  final String markerType;
  final MapPoint position;
  final String barangay;
  final String purok;
  final double rating;
  final bool available;
  final bool verified;
  final int estimatedFare;

  const MapRider({
    required this.id,
    required this.name,
    required this.vehicleType,
    required this.vehicleModel,
    required this.markerType,
    required this.position,
    required this.barangay,
    required this.purok,
    required this.rating,
    required this.available,
    required this.verified,
    required this.estimatedFare,
  });

  factory MapRider.fromJson(Map<String, dynamic> j) => MapRider(
        id: j['id'],
        name: j['name'],
        vehicleType: j['vehicle_type'],
        vehicleModel: j['vehicle_model'],
        markerType: j['marker_type'] ?? j['vehicle_type'],
        position: MapPoint(
          (j['latitude'] as num).toDouble(),
          (j['longitude'] as num).toDouble(),
        ),
        barangay: j['barangay'] ?? '',
        purok: j['purok'] ?? '',
        rating: (j['rating'] as num?)?.toDouble() ?? 0,
        available: j['available'] ?? false,
        verified: j['verified'] ?? false,
        estimatedFare: (j['estimated_fare'] as num?)?.toInt() ?? 0,
      );
}

/// A fixed mock rental vehicle shown on the map.
class MapRentalVehicle {
  final String id;
  final String ownerId;
  final String name;
  final String vehicleType; // motorcycle, tricycle, van, multicab
  final String markerType;
  final MapPoint position;
  final String barangay;
  final String purok;
  final int pricePerDay;
  final int pricePerHour;
  final double rating;
  final bool available;
  final bool verified;

  const MapRentalVehicle({
    required this.id,
    required this.ownerId,
    required this.name,
    required this.vehicleType,
    required this.markerType,
    required this.position,
    required this.barangay,
    required this.purok,
    required this.pricePerDay,
    required this.pricePerHour,
    required this.rating,
    required this.available,
    required this.verified,
  });

  factory MapRentalVehicle.fromJson(Map<String, dynamic> j) => MapRentalVehicle(
        id: j['id'],
        ownerId: j['owner_id'] ?? '',
        name: j['name'],
        vehicleType: j['vehicle_type'],
        markerType: j['marker_type'] ?? 'rental',
        position: MapPoint(
          (j['latitude'] as num).toDouble(),
          (j['longitude'] as num).toDouble(),
        ),
        barangay: j['barangay'] ?? '',
        purok: j['purok'] ?? '',
        pricePerDay: (j['price_per_day'] as num?)?.toInt() ?? 0,
        pricePerHour: (j['price_per_hour'] as num?)?.toInt() ?? 0,
        rating: (j['rating'] as num?)?.toDouble() ?? 0,
        available: j['available'] ?? false,
        verified: j['verified'] ?? false,
      );
}

/// A fixed mock passenger shown on the map (rider-mode view).
class MapPassenger {
  final String id;
  final String name;
  final MapPoint position;
  final String barangay;
  final String purok;
  final double rating;
  final bool verified;
  final String requestStatus;

  const MapPassenger({
    required this.id,
    required this.name,
    required this.position,
    required this.barangay,
    required this.purok,
    required this.rating,
    required this.verified,
    required this.requestStatus,
  });

  factory MapPassenger.fromJson(Map<String, dynamic> j) => MapPassenger(
        id: j['id'],
        name: j['name'],
        position: MapPoint(
          (j['latitude'] as num).toDouble(),
          (j['longitude'] as num).toDouble(),
        ),
        barangay: j['barangay'] ?? '',
        purok: j['purok'] ?? '',
        rating: (j['rating'] as num?)?.toDouble() ?? 0,
        verified: j['verified'] ?? false,
        requestStatus: j['request_status'] ?? 'waiting',
      );
}

/// A fixed mock incoming ride request, linked to a [MapPassenger] by id.
class MapRideRequest {
  final String id;
  final String passengerId;
  final String preferredVehicleType;
  final MapPoint pickup;
  final String pickupBarangay;
  final String pickupPurok;
  final String destinationBarangay;
  final String destinationPurok;
  final double estimatedDistanceKm;
  final int estimatedFare;
  final String paymentMethod;
  final String status;

  const MapRideRequest({
    required this.id,
    required this.passengerId,
    required this.preferredVehicleType,
    required this.pickup,
    required this.pickupBarangay,
    required this.pickupPurok,
    required this.destinationBarangay,
    required this.destinationPurok,
    required this.estimatedDistanceKm,
    required this.estimatedFare,
    required this.paymentMethod,
    required this.status,
  });

  factory MapRideRequest.fromJson(Map<String, dynamic> j) {
    final pickup = j['pickup'] as Map<String, dynamic>;
    final dest = j['destination'] as Map<String, dynamic>;
    return MapRideRequest(
      id: j['id'],
      passengerId: j['passenger_id'],
      preferredVehicleType: j['preferred_vehicle_type'] ?? '',
      pickup: MapPoint(
        (pickup['latitude'] as num).toDouble(),
        (pickup['longitude'] as num).toDouble(),
      ),
      pickupBarangay: pickup['barangay'] ?? '',
      pickupPurok: pickup['purok'] ?? '',
      destinationBarangay: dest['barangay'] ?? '',
      destinationPurok: dest['purok'] ?? '',
      estimatedDistanceKm: (j['estimated_distance_km'] as num?)?.toDouble() ?? 0,
      estimatedFare: (j['estimated_fare'] as num?)?.toInt() ?? 0,
      paymentMethod: j['payment_method'] ?? 'cash',
      status: j['status'] ?? 'incoming',
    );
  }
}
