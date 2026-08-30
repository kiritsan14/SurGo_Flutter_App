# SAKAY BAI — Flutter UI Simulation (v0.1, no backend)

This is a **pure front-end simulation** of the SAKAY BAI app, built from the
`sakay_bai_v1.html` design bible. There is no server, no database, no auth,
no network calls, and no persistence — every screen reads/writes to an
in-memory `AppState` (see `lib/state/app_state.dart`), and all sample
content lives in `lib/data/models.dart`. Close the app and everything resets.

It covers the passenger flow, rentals, and a captain (driver) view — the
web-only Admin Dashboard from the design doc isn't included since it's
explicitly a separate web console, not part of the phone app.

## Screens included
Splash → Login → OTP → Home → Book a Ride → Matching → Live Trip → Rate Trip,
plus Rentals (browse → detail → request), Profile (with a "Switch to Captain
Mode" shortcut), and Captain Home (online toggle, incoming requests).

## Running it

You'll need the Flutter SDK installed locally (this was written and
organized in an environment without Flutter/network access to pub.dev, so
it hasn't been built or run yet — do a normal first run to confirm):

```bash
flutter pub get
flutter run          # pick a connected device/simulator, or:
flutter run -d chrome # to try it in a browser
```

Minimum Flutter version: 3.24+ (uses `Color.withValues`, Material 3).
If you're on an older Flutter, swap `.withValues(alpha: x)` calls for
`.withOpacity(x)` — that's the only version-sensitive API used.

## Project structure

```
lib/
├── main.dart              // MaterialApp + named routes
├── theme/                 // colors + ThemeData (purple-on-black system)
├── data/models.dart       // all mock data lives here
├── state/app_state.dart   // in-memory state (booking draft, captain
│                           // online toggle, trip rating) — no persistence
├── widgets/common.dart    // shared components: SbCard, SbField, SbChip,
│                           // SbTag, SbAvatar, SbBottomNav, buttons, etc.
└── screens/                // one file per screen
```

## Where to go from here
- Swap `SbMapPlaceholder` for real map tiles (Google Maps / Mapbox) — it's
  already positioned to match the design bible's pins/route.
- Replace `AppState` with a real backend (auth, ride matching, payments)
  when you're ready to move past simulation.
- Wire the currently-inert bottom-nav tabs (Activity/Wallet, Trips/Earnings)
  once there's real data to show.
