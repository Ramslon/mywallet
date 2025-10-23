# My Pocket Wallet

A Flutter wallet app with Firebase Auth and Firestore. It features fast startup, a real‑time dashboard, and card management (add/edit/delete). Built with performance in mind: sliver layouts, minimized rebuilds, and non‑blocking initialization.

## Features

- Firebase auth (email/password) with registration and login
- Firestore user profile: displayName and real‑time balance stream
- Cards & Accounts
	- Add a card (users/{uid}/cards)
	- Edit a card (prefilled form)
	- Delete a card (with confirmation)
	- Live list updates via Firestore streams
- Home dashboard
	- Personalized greeting from Firestore profile
	- Real‑time balance display
	- Pull‑to‑refresh and AppBar refresh action
- Smooth UX and performance
	- Deferred Firebase initialization on Splash (first frame fast)
	- Sliver-based, scroll-safe layouts to avoid bottom overflow
	- RepaintBoundary and IndexedStack where appropriate

## Tech Stack

- Flutter (Dart SDK ^3.5)
- Firebase packages:
	- firebase_core 3.x
	- firebase_auth 5.x
	- cloud_firestore 5.x

## Project Structure (excerpt)

```
lib/
	main.dart
	classes/
		homecontent.dart            # Real-time dashboard (greeting, balance, grid)
	screens/
		splashscreen.dart           # Non-blocking Firebase init, Retry, login link
		auth/
			register.dart             # Create user + Firestore profile {balance, name}
		pages/
			login_screen.dart         # Email/password login
			account.dart              # Live list of user cards (edit/delete)
			add_acard.dart            # Add & edit card (users/{uid}/cards)
			transfer.dart             # Transfer UI (IndexedStack)
			withdraw.dart             # Scroll-safe form
			pay_bill.dart             # Scroll-safe form
			mobile_recharge.dart      # List/detail flow
```

## Prerequisites

- Flutter SDK installed (stable channel recommended)
- Dart SDK 3.5+
- A Firebase project with Firestore and Authentication (Email/Password) enabled

## Firebase setup

1) Configure Firebase for your app (Android/iOS/web as needed):
	 - Install the CLI and run the config tool:

```powershell
# From the project root (Windows PowerShell)
dart pub global activate flutterfire_cli
flutterfire configure
```

2) Ensure `lib/firebase_options.dart` exists and includes your platforms (Android options for Android, etc.).

3) Authentication: enable Email/Password in Firebase Console.

4) Firestore: enable the API in Firebase Console.

5) Security rules (recommended minimal rules for this app):

```
rules_version = '2';
service cloud.firestore {
	match /databases/{database}/documents {
		// Allow each user to manage all documents under their own user doc
		match /users/{userId}/{document=**} {
			allow read, write: if request.auth != null && request.auth.uid == userId;
		}
	}
}
```

## Running the app

Install dependencies and run on a device or emulator:

```powershell
flutter pub get
flutter run
```

Tips:
- Android: ensure Google Play services are available/up to date on the emulator/device for Firebase Auth.
- If you change Firestore rules, allow up to ~1 minute for propagation.

## Common troubleshooting

- PERMISSION_DENIED on writes to `users/{uid}/cards/...`
	- Verify you published rules like above and that you are signed in.
	- Confirm the Firebase project in your app matches the one where you edited rules.

- “Missing or insufficient permissions.” after configuring rules
	- Check that `firebase_options.dart` matches this project and platform entries exist.
	- Confirm Firestore API is enabled in the same project.

- “Bottom overflowed by XX pixels”
	- Most pages are scroll-safe (SingleChildScrollView/Slivers). If you add new forms, wrap in SafeArea + SingleChildScrollView.

- Slow first frame due to Firebase initialization
	- Initialization occurs after the first frame on the Splash screen. If you moved it back to `main`, consider deferring again for faster startup.

## Development notes

- Navigation uses named routes for the core flows (splash, home, register, login).
- Home dashboard uses a Firestore stream to render profile and balance in real time.
- Cards are stored at `users/{uid}/cards`. Add/Edit uses the same screen with optional `cardId` and `initial` data.

## License

This project does not specify a license. Consider adding one (e.g., MIT) if you plan to share or open source.
