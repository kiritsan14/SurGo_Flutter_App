import 'dart:async';
import 'package:flutter/material.dart';
import '../data/models.dart';
import '../data/db_models.dart';
import '../data/db_service.dart';

enum UserMode { passenger, rider, vehicleOwner }

/// Everything here lives only in memory for the lifetime of the app run.
/// There is no backend, no local storage, no network — purely a UI
/// simulation of what SurGo would look and feel like. Seed data is loaded
/// once from assets/db/mock_database.json via DbService, and every "write"
/// (accepting a ride, adding a saved place, topping up a wallet, etc.) just
/// mutates these in-memory lists and calls notifyListeners().
class AppState extends ChangeNotifier {
  AppState._internal();
  static final AppState instance = AppState._internal();

  final DbService db = DbService.instance;
  bool ready = false;

  Future<void> init() async {
    if (ready) return;
    await db.load();
    ready = true;
    notifyListeners();
  }

  // ---- account mode ----
  UserMode mode = UserMode.passenger;

  void switchToRider() {
    mode = UserMode.rider;
    notifyListeners();
  }

  void switchToPassenger() {
    mode = UserMode.passenger;
    notifyListeners();
  }

  void switchToVehicleOwner() {
    mode = UserMode.vehicleOwner;
    notifyListeners();
  }

  /// Central switcher used by the 3-mode dropdown menu.
  void switchToMode(UserMode m) {
    mode = m;
    notifyListeners();
  }

  // ---- booking draft ----
  String pickupLabel = 'Purok 3, Barangay Poblacion';
  String destinationLabel = 'SM Terminal, Downtown';
  List<RideOption> rideOptions = MockData.rideOptions;
  RideOption selectedRide = MockData.rideOptions.first;

  void selectRide(RideOption option) {
    selectedRide = option;
    notifyListeners();
  }

  void setPickup(String label) {
    pickupLabel = label;
    notifyListeners();
  }

  void setDestination(String label) {
    destinationLabel = label;
    notifyListeners();
  }

  // ---- rider / driver mode ----
  bool riderOnline = true;
  List<RideRequestItem> get pendingRequests => db.rideRequests;

  /// The request the rider currently has accepted, shown as a banner above
  /// the incoming-requests list until the trip is completed or cancelled.
  RideRequestItem? activeRide;

  void toggleRiderOnline() {
    riderOnline = !riderOnline;
    notifyListeners();
  }

  void respondToRequest(RideRequestItem request, {required bool accepted}) {
    db.rideRequests.remove(request);
    if (accepted) {
      activeRide = request;
    }
    notifyListeners();
  }

  void completeActiveRide() {
    if (activeRide == null) return;
    db.riderTrips.insert(
      0,
      RiderTripItem(
        id: 'rt${DateTime.now().microsecondsSinceEpoch}',
        passengerName: activeRide!.passengerName,
        route: '${activeRide!.pickup} → ${activeRide!.dropoff}',
        date: 'Just now',
        fare: activeRide!.fare,
        distanceKm: activeRide!.distanceKm,
        status: 'Completed',
        rating: 5,
      ),
    );
    db.riderWalletBalance += activeRide!.fare;
    activeRide = null;
    notifyListeners();
  }

  void cancelActiveRide() {
    activeRide = null;
    notifyListeners();
  }

  // ---- trip rating ----
  int tripRating = 4;
  final Set<String> tripCompliments = {'Safe driving'};

  void setTripRating(int stars) {
    tripRating = stars;
    notifyListeners();
  }

  void toggleCompliment(String compliment) {
    if (tripCompliments.contains(compliment)) {
      tripCompliments.remove(compliment);
    } else {
      tripCompliments.add(compliment);
    }
    notifyListeners();
  }

  // ---- notifications ----
  List<NotificationItem> get passengerNotifications => db.passengerNotifications;
  List<NotificationItem> get riderNotifications => db.riderNotifications;

  int get unreadNotifications =>
      db.passengerNotifications.where((n) => !n.read).length;
  int get unreadRiderNotifications =>
      db.riderNotifications.where((n) => !n.read).length;

  void markNotificationRead(NotificationItem n) {
    n.read = true;
    notifyListeners();
  }

  void clearNotifications() {
    for (final n in db.passengerNotifications) {
      n.read = true;
    }
    notifyListeners();
  }

  void clearRiderNotifications() {
    for (final n in db.riderNotifications) {
      n.read = true;
    }
    notifyListeners();
  }

  // ---- wallet ----
  int get passengerWalletBalance => db.passengerWalletBalance;
  List<WalletTransaction> get passengerTransactions => db.passengerTransactions;
  int get riderWalletBalance => db.riderWalletBalance;
  List<WalletTransaction> get riderTransactions => db.riderTransactions;

  void topUpPassengerWallet(int amount, String method) {
    db.passengerWalletBalance += amount;
    db.passengerTransactions.insert(
      0,
      WalletTransaction(
        id: 'wt${DateTime.now().microsecondsSinceEpoch}',
        type: 'topup',
        title: 'Wallet Top-up via $method',
        amount: amount,
        date: 'Just now',
        status: 'Completed',
      ),
    );
    notifyListeners();
  }

  void requestRiderPayout(int amount, String method) {
    if (amount > db.riderWalletBalance) return;
    db.riderWalletBalance -= amount;
    db.payoutHistory.insert(
      0,
      PayoutItem(
        id: 'po${DateTime.now().microsecondsSinceEpoch}',
        date: 'Just now',
        amount: amount,
        method: method,
        status: 'Processing',
      ),
    );
    db.riderTransactions.insert(
      0,
      WalletTransaction(
        id: 'rwt${DateTime.now().microsecondsSinceEpoch}',
        type: 'payout',
        title: 'Payout to $method',
        amount: amount,
        date: 'Just now',
        status: 'Processing',
      ),
    );
    notifyListeners();
  }

  // ---- payment methods ----
  List<PaymentMethodItem> get paymentMethods => db.paymentMethods;

  void setDefaultPaymentMethod(PaymentMethodItem method) {
    for (final m in db.paymentMethods) {
      m.isDefault = m.id == method.id;
    }
    notifyListeners();
  }

  void addPaymentMethod(PaymentMethodItem method) {
    db.paymentMethods.add(method);
    notifyListeners();
  }

  void removePaymentMethod(PaymentMethodItem method) {
    db.paymentMethods.remove(method);
    notifyListeners();
  }

  // ---- saved places ----
  List<SavedPlace> get savedPlaces => db.savedPlaces;

  void addSavedPlace(SavedPlace place) {
    db.savedPlaces.add(place);
    notifyListeners();
  }

  void removeSavedPlace(SavedPlace place) {
    db.savedPlaces.remove(place);
    notifyListeners();
  }

  // ---- favorites ----
  List<FavoriteRider> get favoriteRiders => db.favoriteRiders;
  List<FavoriteVehicle> get favoriteVehicles => db.favoriteVehicles;

  void removeFavoriteRider(FavoriteRider r) {
    db.favoriteRiders.remove(r);
    notifyListeners();
  }

  void removeFavoriteVehicle(FavoriteVehicle v) {
    db.favoriteVehicles.remove(v);
    notifyListeners();
  }

  // ---- emergency contacts ----
  List<EmergencyContactItem> get emergencyContacts => db.emergencyContacts;

  void addEmergencyContact(EmergencyContactItem c) {
    db.emergencyContacts.add(c);
    notifyListeners();
  }

  void removeEmergencyContact(EmergencyContactItem c) {
    db.emergencyContacts.remove(c);
    notifyListeners();
  }

  // ---- history ----
  List<RideHistoryItem> get rideHistory => db.rideHistory;
  List<RentalHistoryItem> get rentalHistory => db.rentalHistory;
  List<RiderTripItem> get riderTrips => db.riderTrips;

  void addRideToHistory(RideHistoryItem item) {
    db.rideHistory.insert(0, item);
    notifyListeners();
  }

  void addRentalToHistory(RentalHistoryItem item) {
    db.rentalHistory.insert(0, item);
    notifyListeners();
  }

  // ---- rental booking simulation (passenger) ----
  // A passenger can only have one open rental request/active rental at a
  // time in this simulation. It starts as "Pending" the moment they tap
  // Request Rental, shows up as a card on the Home tab, and — after a
  // simulated 10s owner-approval delay — flips to "Active" in place.
  RentalBooking? activeRentalBooking;
  Timer? _rentalApprovalTimer;

  RentalBooking requestRental({
    required String vehicleName,
    required String vehicleType,
    required IconData icon,
    required String ownerName,
    required String ownerInitials,
    required String pickupLabel,
    required String returnLabel,
    required int days,
    required int totalFare,
  }) {
    _rentalApprovalTimer?.cancel();
    final booking = RentalBooking(
      id: 'rb${DateTime.now().microsecondsSinceEpoch}',
      vehicleName: vehicleName,
      vehicleType: vehicleType,
      icon: icon,
      ownerName: ownerName,
      ownerInitials: ownerInitials,
      pickupLabel: pickupLabel,
      returnLabel: returnLabel,
      days: days,
      totalFare: totalFare,
      status: 'Pending',
      requestedAt: DateTime.now(),
    );
    activeRentalBooking = booking;
    db.rentalHistory.insert(
      0,
      RentalHistoryItem(
        id: booking.id,
        vehicleName: vehicleName,
        ownerName: ownerName,
        startDate: pickupLabel,
        endDate: returnLabel,
        totalFare: totalFare,
        status: 'Requested',
      ),
    );
    notifyListeners();

    _rentalApprovalTimer = Timer(const Duration(seconds: 10), () {
      if (activeRentalBooking?.id != booking.id) return; // cancelled/replaced
      booking.status = 'Active';
      final match = db.rentalHistory.where((r) => r.id == booking.id);
      if (match.isNotEmpty) {
        final i = db.rentalHistory.indexOf(match.first);
        db.rentalHistory[i] = RentalHistoryItem(
          id: booking.id,
          vehicleName: vehicleName,
          ownerName: ownerName,
          startDate: pickupLabel,
          endDate: returnLabel,
          totalFare: totalFare,
          status: 'Active',
        );
      }
      notifyListeners();
    });
    return booking;
  }

  void cancelRentalBooking() {
    _rentalApprovalTimer?.cancel();
    activeRentalBooking = null;
    notifyListeners();
  }

  void completeActiveRental() {
    final booking = activeRentalBooking;
    if (booking == null) return;
    final match = db.rentalHistory.where((r) => r.id == booking.id);
    if (match.isNotEmpty) {
      final i = db.rentalHistory.indexOf(match.first);
      db.rentalHistory[i] = RentalHistoryItem(
        id: booking.id,
        vehicleName: booking.vehicleName,
        ownerName: booking.ownerName,
        startDate: booking.pickupLabel,
        endDate: booking.returnLabel,
        totalFare: booking.totalFare,
        status: 'Completed',
      );
    }
    activeRentalBooking = null;
    notifyListeners();
  }

  // ---- favorites (toggle helpers) ----
  bool isFavoriteRiderName(String name) =>
      db.favoriteRiders.any((r) => r.name == name);

  void toggleFavoriteRiderByDriver({
    required String name,
    required String initials,
    required double rating,
    required int trips,
    required String vehicleType,
    required String plate,
  }) {
    final existing = db.favoriteRiders.where((r) => r.name == name).toList();
    if (existing.isNotEmpty) {
      db.favoriteRiders.remove(existing.first);
    } else {
      db.favoriteRiders.add(FavoriteRider(
        id: 'fr${DateTime.now().microsecondsSinceEpoch}',
        name: name,
        initials: initials,
        rating: rating,
        trips: trips,
        vehicleType: vehicleType,
        plate: plate,
      ));
    }
    notifyListeners();
  }

  bool isFavoriteVehicleName(String name) =>
      db.favoriteVehicles.any((v) => v.name == name);

  void toggleFavoriteVehicleByListing({
    required String name,
    required String type,
    required int pricePerDay,
    required String ownerName,
  }) {
    final existing = db.favoriteVehicles.where((v) => v.name == name).toList();
    if (existing.isNotEmpty) {
      db.favoriteVehicles.remove(existing.first);
    } else {
      db.favoriteVehicles.add(FavoriteVehicle(
        id: 'fv${DateTime.now().microsecondsSinceEpoch}',
        name: name,
        type: type,
        pricePerDay: pricePerDay,
        ownerName: ownerName,
      ));
    }
    notifyListeners();
  }

  // ---- rider earnings ----
  int get earningsToday => db.earningsToday;
  int get earningsWeek => db.earningsWeek;
  int get earningsMonth => db.earningsMonth;
  List<DailyEarning> get dailyEarnings => db.dailyEarnings;
  List<PayoutItem> get payoutHistory => db.payoutHistory;

  // ---- account settings ----
  AccountSettingsData get passengerSettings => db.passengerSettings;
  AccountSettingsData get riderSettings => db.riderSettings;

  void updatePassengerSettings(void Function(AccountSettingsData s) update) {
    update(db.passengerSettings);
    notifyListeners();
  }

  void updateRiderSettings(void Function(AccountSettingsData s) update) {
    update(db.riderSettings);
    notifyListeners();
  }

  // ---- Tandag City locations (barangay + purok) ----
  List<Barangay> get barangays => db.barangays;

  // ---- vehicle documents ----
  List<VehicleDocumentItem> get vehicleDocuments => db.vehicleDocuments;

  // ---- vehicle owner mode ----
  List<OwnedVehicle> get ownerVehicles => db.ownerVehicles;
  List<OwnerBookingRequest> get ownerBookingRequests => db.ownerBookingRequests;
  int get ownerEarningsToday => db.ownerEarningsToday;
  int get ownerEarningsWeek => db.ownerEarningsWeek;
  int get ownerEarningsMonth => db.ownerEarningsMonth;

  void respondToOwnerBooking(OwnerBookingRequest request, {required bool accepted}) {
    request.status = accepted ? 'Accepted' : 'Declined';
    if (accepted) {
      final vehicle = db.ownerVehicles.where((v) => v.name == request.vehicleName);
      if (vehicle.isNotEmpty) vehicle.first.status = 'Rented';
    }
    notifyListeners();
  }

  // ---- vehicle owner fleet management ----
  void addOwnedVehicle(OwnedVehicle vehicle) {
    db.ownerVehicles.add(vehicle);
    notifyListeners();
  }

  void removeOwnedVehicle(OwnedVehicle vehicle) {
    db.ownerVehicles.remove(vehicle);
    notifyListeners();
  }

  void setOwnedVehicleStatus(OwnedVehicle vehicle, String status) {
    vehicle.status = status;
    notifyListeners();
  }

  // ---- vehicle owner wallet ----
  int get ownerWalletBalance => db.ownerWalletBalance;
  List<WalletTransaction> get ownerTransactions => db.ownerTransactions;

  void requestOwnerPayout(int amount, String method) {
    if (amount > db.ownerWalletBalance) return;
    db.ownerWalletBalance -= amount;
    db.ownerTransactions.insert(
      0,
      WalletTransaction(
        id: 'owt${DateTime.now().microsecondsSinceEpoch}',
        type: 'payout',
        title: 'Payout to $method',
        amount: amount,
        date: 'Just now',
        status: 'Processing',
      ),
    );
    notifyListeners();
  }
}
