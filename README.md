# Task Manager — Flutter Assessment App

Flutter task management app with authentication, JWT persistence, and CRUD — using **Cubit**, **Retrofit**, **Dio**, and **injectable/get_it**.

## Tech Stack

- `flutter_bloc` — state management
- `dio` + `retrofit` — HTTP / API layer
- `injectable` + `get_it` — dependency injection
- `shared_preferences` — JWT storage
- `json_serializable` — model serialization

## Project Structure

```text
lib/
  app/
    app.dart
    providers/
  core/
    di/
    network/
    storage/
  features/
    auth/
    tasks/
    profile/
  main.dart
```

## Code Generation

After changing Retrofit APIs, models, or injectable classes:

```bash
dart run build_runner build --delete-conflicting-outputs
```

## Backend

Start your API on port `3000`:

```bash
cd path/to/backend
npm install
npm run dev
```

## Run the App

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter run
```

## Base URL

Edit `lib/core/constants/api_constants.dart`:

```dart
const String baseUrl = 'http://localhost:3000/api';
```

| Target | URL |
|--------|-----|
| iOS Simulator | `http://localhost:3000/api` |
| Android Emulator | `http://10.0.2.2:3000/api` |
| Physical device | `http://<YOUR_LOCAL_IP>:3000/api` |

## Test Flow

1. Register → login (or auto-login if token returned)
2. Login → task list
3. Restart app → auto login
4. Profile → view name/email
5. Create / edit / delete tasks
6. Logout
# alhayat_task
