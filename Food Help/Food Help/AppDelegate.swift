import UIKit
import Firebase

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {

        // ✅ Firebase must be configured ONCE here
        print("🔥 AppDelegate started")
        FirebaseApp.configure()

        return true
    }
}
