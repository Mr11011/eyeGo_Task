# Product Listing App

A Flutter app that fetches products from the [FakeStore API](https://fakestoreapi.com/), displays them, and allows searching and filtering by category, price, and rating. Uses Firebase Authentication for sign-up/sign-in/sign-out.

## Features
- Firebase Authentication.
- Fetch and display products.
- Search by title.
- Filter by category, price, and rating.


## Setup Instructions

### Prerequisites
- Flutter SDK (3.0.0+)
- Firebase account
- IDE with Flutter/Dart plugins

### 1. Clone the Repo
```bash
git clone https://github.com/Mr11011/eyeGo_Task.git
```

### 2. Install Dependencies
```bash
flutter pub get
```

### 3. Set Up Firebase
The `firebase_options.dart` and `google-services.json` files are not included. Set up Firebase:

- Create a Firebase project at [Firebase Console](https://console.firebase.google.com/).
- Add an Android app (package: `com.example.task_eyego`), download `google-services.json`, and place it in `android/app/`.
- Enable **Email/Password** sign-in in Firebase Authentication.
- Generate `firebase_options.dart`:
  ```bash
  flutter pub global activate flutterfire_cli
  flutterfire configure
  ```

### 4. Run the App
```bash
flutter run
```
Sign in with Firebase to view products.

## Implementation Overview
- **Architecture:** Combination use of BLoC & Cubit for state management. `ProductCubit` handles product fetching, searching, and filtering; `AuthCubit` manages authentication.
- **Phases:**
  1. Firebase: Handles user sign-up,sign-in,sign-out.
  2. Fetch and display products in a `ListView`.
  3. Add search by title.
  4. Filter by category, price, and rating.

- **UI:** Search bar, filter with slider or dropdown list, and product list. Uses `shimmer` for loading effects and `device_preview` for responsive testing.

## Notes
- Requires internet for FakeStore API.
- Ensure Firebase setup for authentication.

