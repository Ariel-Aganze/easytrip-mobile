# EasyTrip mobile

Flutter app for travellers (search, seats, Mobile Money, QR e-tickets, bookings,
reviews) and for boarding agents / operators (ticket scanning). Clean architecture
(data / domain / presentation), BLoC, GoRouter, Dio, get_it.

## Run
Requires **Flutter 3.22.3** (the version CI uses; `intl 0.19.0` is pinned to it).

```bash
flutter pub get
flutter run --dart-define=API_BASE_URL=http://10.0.2.2:8000/api/v1   # Android emulator
flutter run --dart-define=API_BASE_URL=http://localhost:8000/api/v1  # iOS simulator
```
On a physical phone use your computer's LAN IP. For demo data, run
`python manage.py seed_demo --reset` in the backend (password `Demo-Passw0rd!`;
customer `+243 900000004`, agent `+243 900000003`).

## Navigation
All screens are GoRouter routes (`lib/core/router/`). Tabs: Search, Tickets,
Bookings, Account. Deep-linkable: `/trips/:id?passengers=N`, `/tickets/:id`
(opens from the offline copy), `/bookings/:id`, `/payments/:id`.

## Offline tickets
Tickets are cached encrypted on the device after each successful load, so the QR
code shows at boarding without a signal. The cache is wiped on logout.

## Tests
```bash
flutter analyze
flutter test                         # unit + widget tests
LIVE_API=1 flutter test test/live    # contract test against a running backend + seed_demo
```

## Release
- **Android signing:** create `android/key.properties` (gitignored) pointing at your
  upload keystore — see the comment at the top of `android/app/build.gradle`.
  Without it, release builds fall back to the debug key (fine locally, rejected by Play).
- **Push notifications:** add Firebase (`google-services.json`,
  `GoogleService-Info.plist`, `firebase_messaging`) and send the FCM token with
  `NotificationsRepository.registerDevice`. The backend side is ready.
- **App icons / splash:** not generated yet (needs the final artwork).
