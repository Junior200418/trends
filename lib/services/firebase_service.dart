class FirebaseService {
  // minimal stub – later wire Firebase.initializeApp() here
  static Future<void> init() async {
    // TODO: call Firebase.initializeApp() and other startup tasks
    await Future.delayed(Duration(milliseconds: 10));
  }
}
