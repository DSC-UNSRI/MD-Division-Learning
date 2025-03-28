# Secure-MVC-Flutter-Firebase-Example

A Flutter project demonstrating a secure implementation of the Model-View-Controller (MVC) architecture integrated with Firebase for authentication and Firestore for data management. This project includes features like user authentication, cart management, and secure environment variable handling.

---

## Features

- **MVC Architecture**: Clean separation of concerns between Models, Views, and Controllers.
- **Firebase Integration**:
  - Authentication (Email/Password and Google Sign-In).
  - Firestore for real-time database operations.
- **Secure Environment Variables**: Uses `flutter_secure_dotenv` for managing sensitive keys.
- **Cross-Platform Support**: Works on Android, iOS, Web, Windows, macOS, and Linux.

---

## Prerequisites

Before running this project, ensure you have the following installed:

1. [Flutter SDK](https://docs.flutter.dev/get-started/install) (version 3.6.0 or higher).
2. [Firebase CLI](https://firebase.google.com/docs/cli) for setting up Firebase.
3. A Firebase project configured with:
   - Firebase Authentication.
   - Firestore Database.
4. A valid `encryption_key.json` file for secure environment variable handling.

---

## Getting Started

Follow these steps to set up and run the project:

### 1. Clone the Repository

```bash
git clone https://github.com/DSC-UNSRI/Secure-MVC-Flutter-Firebase-Example.git
cd Secure-MVC-Flutter-Firebase-Example
```
### 2. Install Dependencies

```bash
flutter pub get
```

### 3. Configure Gradle Properties

- Open `android/gradle.properties`
- Delete the line `org.gradle.java.home=value` or change with your defined Java Home Path.

### 4. Configure Firebase

- Download and install [Firebase CLI](https://firebase.google.com/docs/cli) (you may use npm or use standalone package).
- Make sure `firebase` command is recognized (run in CMD). If not, make sure to have the firebase tools defined in environment variable path.
- Navigate to [Firebase Console](https://console.firebase.google.com/u/0/) and click `Create a Firebase project`. Then, just follow the instructions.
- After created, navigate to `Overview` and click `Add App > Android`. Then, just follow the instructions (make sure the Android package name is the same as your `android/app/build.gradle` applicationId).
- After Android app created in Firebase Console, navigate to `Overview` and click `Build > Authentication` and `Build > Firestore Database` (just follow the instructions on creation, choose the closest server with your country (e.g. Jakarta), use Test Mode Rules at the moment).
- Back to your IDE or Code Editor, open up terminal and run `cd android` (navigate to `android` folder). Then, run `.\gradlew signingReport` or `./gradlew signingReport`. It should show your keystore's SHA1 and SHA-256.
- Copy the SHA1 and SHA-256 (enter each) to `Firebase Console > Overview > Android App (Name) > Click Settings Icon`.
- Under `General` tab, scroll to the bottom. Click `Add fingerprint` and input the SHA1 then SHA-256 value.
- Back to your IDE or Code Editor, open up terminal and run `firebase login` (just follow the instructions to login your Google Account [use the same as your Firebase Account]).
- After successfully logged in, run `dart pub global activate flutterfire_cli` then `flutterfire configure --project=YOUR-FIREBASE-PROJECT-ID` (configure only for Android, use Space to disable other platforms). It will generate and replace `lib/firebase_options.dart`.

### 5. Generate Encrypted Environment Keys

- Add all `FirebaseOptions android` values inside `lib/firebase_options.dart` to `.env`. Look at the this original repository `lib/firebase_options.dart` (before you replace it using flutterfire configure) to modify and proceed (don't push API keys to source control, bud).
- Run `dart run build_runner build --define flutter_secure_dotenv_generator:flutter_secure_dotenv=OUTPUT_FILE=encryption_key.json`.
- Change `.vscode/launch.json` `ENCRYPTION_KEY` and `IV_KEY` based on generated `encryption_key.json` (root-level folder).
- Use `Run and Debug` (CTRL + SHIFT + D) feature and debug the app using your favorite Android emulator or via USB debugging.
