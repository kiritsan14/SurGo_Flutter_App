# SurGo Map V1 — files changed in this pass

Status: Map V1 core is wired up and should compile, but I have NOT been able to
run `flutter analyze` / `flutter build` in this sandbox (no Flutter SDK here),
so please run `flutter pub get` and do a build/analyze pass before trusting it
fully. Three call sites still use the OLD fake map placeholder and were NOT
converted in this pass (see "Not yet done" below).

## New files
- `assets/data/surgo_map_v1_mock_data.json` — your Map V1 mock data, copied in as-is.
- `lib/services/location_service.dart` — live GPS via `geolocator`, full permission
  flow, returns `null` (never throws) on denial/timeout so callers can fall back
  to Tandag City.
- `lib/widgets/surgo_map.dart` — the reusable map widget: real OSM tiles via
  `flutter_map`, custom purple "filled location pin" markers (CustomPaint) with
  the right icon inside per type, tap-to-info bottom sheet, locate-me button,
  blue "you are here" dot for the live user position. Also exports
  `surgoMarkerIcon(type)` and `SurgoMapMarker`.
- `lib/screens/passenger_map_screen.dart` — passenger's live map: nearby riders
  + rental vehicles, with an All/Riders/Rentals filter.
- `lib/screens/rider_map_screen.dart` — rider's live map: nearby mock passengers
  and their ride requests (read-only preview; accept/decline still happens on
  the existing Home tab request list, since that list uses a different mock
  dataset/IDs than the map JSON).
- `lib/screens/vehicle_owner_map_screen.dart` — owner's live map: their listed
  rental vehicles.

## Changed files
- `pubspec.yaml` — added `flutter_map`, `latlong2`, `geolocator`,
  `permission_handler`; registered the new JSON asset.
- `android/app/src/main/AndroidManifest.xml` — added `INTERNET`,
  `ACCESS_FINE_LOCATION`, `ACCESS_COARSE_LOCATION` permissions.
- `ios/Runner/Info.plist` — added `NSLocationWhenInUseUsageDescription` /
  `NSLocationAlwaysAndWhenInUseUsageDescription`.
- `lib/data/db_models.dart` — appended Map V1 model classes: `MapPoint`,
  `MapConfigData`, `MapRider`, `MapRentalVehicle`, `MapPassenger`,
  `MapRideRequest`.
- `lib/data/db_service.dart` — added typed fields (`mapConfig`, `mapRiders`,
  `mapRentalVehicles`, `mapPassengers`, `mapRideRequests`) and loads the new
  JSON asset inside the existing `load()` method (same DbService, not a
  separate data system).
- `lib/main.dart` — registered `/map/passenger`, `/map/rider`, `/map/owner`
  routes.
- `lib/screens/home_screen.dart` (passenger) — added a map icon button next to
  the notification bell, opens `/map/passenger`.
- `lib/screens/rider_home_screen.dart` — added a map icon button next to the
  notification bell, opens `/map/rider`.
- `lib/screens/vehicle_owner_home_screen.dart` — added a map icon button in the
  header, opens `/map/owner`.
- `lib/screens/booking_screen.dart` — replaced the fake `SbMapPlaceholder` +
  hand-drawn route/pins with a real `SurgoMap` centered on live GPS (no
  pickup/destination markers yet, since pickup/destination in this screen are
  barangay/purok **text labels** with no lat/lng — see "Not yet done"). Also
  removed the now-dead `_pin()` helper and `_RoutePainter` class.

## Not yet done (still using the old SbMapPlaceholder)
- `lib/screens/live_trip_screen.dart`
- `lib/screens/active_rental_screen.dart`
- `lib/widgets/ride_request_card.dart`

These three still show the old fake grid/pin map — I ran out of tool budget
before converting them. `widgets/common.dart`'s `SbMapPlaceholder` class was
NOT removed, since these three still depend on it.

## How to apply
Drop these files into your project at the same relative paths (overwriting
the existing ones), then:

```
flutter pub get
flutter run
```
