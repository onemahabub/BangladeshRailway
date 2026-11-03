# Bangladesh Railway — Flutter starter

This is the first UI + map prototype for the Bangladesh Railway app.

## Included
- Navy/white visual theme
- MapLibre interactive map
- 2D / tilted 3D-perspective camera toggle
- Demo train marker and illustrative route
- Responsive floating controls and bottom information panel

## Important
The train location and route in this prototype are demonstration data near Dhaka. They are NOT live railway data.
A real tracking release needs a verified source such as voluntary passenger GPS contributions and/or an authorized railway data feed, plus a backend that validates and timestamps reports.

## Build
Requirements: Flutter 3.29+, Dart 3.7+, Android toolchain / JDK 21.

```bash
flutter pub get
flutter run
flutter build apk --release
```

Map style: OpenFreeMap Liberty (`https://tiles.openfreemap.org/styles/liberty`).
Map tiles require an internet connection. Check the provider's current usage policy before public launch.

## Android
Create the Android platform folder if needed:
```bash
flutter create . --platforms=android
```
Then run the build commands above.

## Next milestones
1. Add official train/station timetable dataset.
2. Add Supabase backend and user-contributed GPS with consent, timestamps, and anti-spoofing checks.
3. Interpolate marker movement smoothly between verified location reports.
4. Add route search, station search, favorites, and alerts.
5. Test performance and battery use on real Android devices.
