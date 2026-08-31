import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'db_models.dart';

/// Loads `assets/db/mock_database.json` once and exposes it as typed
/// in-memory lists/objects. This is the app's "temporary database" — every
/// screen reads its mock data through here and edits/mutations only ever
/// happen in memory (nothing is written back to disk).
class DbService {
  DbService._internal();
  static final DbService instance = DbService._internal();

  bool _loaded = false;
  bool get isLoaded => _loaded;

  late PassengerProfile passenger;
  late RiderProfile rider;
  late VehicleOwnerProfile vehicleOwner;

  late List<Barangay> barangays;
  late List<RideRequestItem> rideRequests;
  late List<VehicleDocumentItem> vehicleDocuments;
  late List<OwnedVehicle> ownerVehicles;
  late List<OwnerBookingRequest> ownerBookingRequests;
  late int ownerEarningsToday;
  late int ownerEarningsWeek;
  late int ownerEarningsMonth;

  late List<NotificationItem> passengerNotifications;
  late List<NotificationItem> riderNotifications;

  late int passengerWalletBalance;
  late List<WalletTransaction> passengerTransactions;
  late int riderWalletBalance;
  late List<WalletTransaction> riderTransactions;
  late int ownerWalletBalance;
  late List<WalletTransaction> ownerTransactions;

  late List<PaymentMethodItem> paymentMethods;
  late List<SavedPlace> savedPlaces;
  late List<FavoriteRider> favoriteRiders;
  late List<FavoriteVehicle> favoriteVehicles;
  late List<EmergencyContactItem> emergencyContacts;
  late List<RideHistoryItem> rideHistory;
  late List<RentalHistoryItem> rentalHistory;
  late List<RiderTripItem> riderTrips;

  late int earningsToday;
  late int earningsWeek;
  late int earningsMonth;
  late List<DailyEarning> dailyEarnings;
  late List<PayoutItem> payoutHistory;

  late AccountSettingsData passengerSettings;
  late AccountSettingsData riderSettings;

  Future<void> load() async {
    if (_loaded) return;
    final raw = await rootBundle.loadString('assets/db/mock_database.json');
    final Map<String, dynamic> j = json.decode(raw);

    passenger = PassengerProfile.fromJson(j['passenger']);
    rider = RiderProfile.fromJson(j['rider']);
    vehicleOwner = VehicleOwnerProfile.fromJson(j['vehicleOwner']);

    final locations = j['locations'] as Map<String, dynamic>;
    barangays =
        (locations['barangays'] as List).map((e) => Barangay.fromJson(e)).toList();

    rideRequests =
        (j['rideRequests'] as List).map((e) => RideRequestItem.fromJson(e)).toList();
    vehicleDocuments = (j['vehicleDocuments'] as List)
        .map((e) => VehicleDocumentItem.fromJson(e))
        .toList();
    ownerVehicles =
        (j['ownerVehicles'] as List).map((e) => OwnedVehicle.fromJson(e)).toList();
    ownerBookingRequests = (j['ownerBookingRequests'] as List)
        .map((e) => OwnerBookingRequest.fromJson(e))
        .toList();
    final ownerEarnings = j['ownerEarnings'] as Map<String, dynamic>;
    ownerEarningsToday = ownerEarnings['today'];
    ownerEarningsWeek = ownerEarnings['week'];
    ownerEarningsMonth = ownerEarnings['month'];

    final notif = j['notifications'] as Map<String, dynamic>;
    passengerNotifications = (notif['passenger'] as List)
        .map((e) => NotificationItem.fromJson(e))
        .toList();
    riderNotifications =
        (notif['rider'] as List).map((e) => NotificationItem.fromJson(e)).toList();

    final wallet = j['wallet'] as Map<String, dynamic>;
    final pw = wallet['passenger'] as Map<String, dynamic>;
    passengerWalletBalance = pw['balance'];
    passengerTransactions =
        (pw['transactions'] as List).map((e) => WalletTransaction.fromJson(e)).toList();
    final rw = wallet['rider'] as Map<String, dynamic>;
    riderWalletBalance = rw['balance'];
    riderTransactions =
        (rw['transactions'] as List).map((e) => WalletTransaction.fromJson(e)).toList();
    final ow = wallet['owner'] as Map<String, dynamic>? ?? const {'balance': 0, 'transactions': []};
    ownerWalletBalance = ow['balance'] ?? 0;
    ownerTransactions =
        (ow['transactions'] as List).map((e) => WalletTransaction.fromJson(e)).toList();

    paymentMethods =
        (j['paymentMethods'] as List).map((e) => PaymentMethodItem.fromJson(e)).toList();
    savedPlaces = (j['savedPlaces'] as List).map((e) => SavedPlace.fromJson(e)).toList();

    final fav = j['favorites'] as Map<String, dynamic>;
    favoriteRiders = (fav['riders'] as List).map((e) => FavoriteRider.fromJson(e)).toList();
    favoriteVehicles =
        (fav['vehicles'] as List).map((e) => FavoriteVehicle.fromJson(e)).toList();

    emergencyContacts = (j['emergencyContacts'] as List)
        .map((e) => EmergencyContactItem.fromJson(e))
        .toList();
    rideHistory =
        (j['rideHistory'] as List).map((e) => RideHistoryItem.fromJson(e)).toList();
    rentalHistory =
        (j['rentalHistory'] as List).map((e) => RentalHistoryItem.fromJson(e)).toList();
    riderTrips = (j['riderTrips'] as List).map((e) => RiderTripItem.fromJson(e)).toList();

    final earnings = j['riderEarnings'] as Map<String, dynamic>;
    earningsToday = earnings['today'];
    earningsWeek = earnings['week'];
    earningsMonth = earnings['month'];
    dailyEarnings =
        (earnings['daily'] as List).map((e) => DailyEarning.fromJson(e)).toList();
    payoutHistory =
        (earnings['payoutHistory'] as List).map((e) => PayoutItem.fromJson(e)).toList();

    final settings = j['accountSettings'] as Map<String, dynamic>;
    passengerSettings = AccountSettingsData.fromJson(settings['passenger']);
    riderSettings = AccountSettingsData.fromJson(settings['rider']);

    _loaded = true;
  }
}
