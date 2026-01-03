import UIKit
import FirebaseCore

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // Setup crash prevention
        CrashPrevention.shared.setupGlobalExceptionHandling()
        
        // Log debug info
        DebugHelper.shared.logAppState()
        
        // Configure Firebase safely
        CrashPrevention.shared.safeExecute({
            FirebaseApp.configure()
            print("✅ Firebase configured successfully")
        }, fallback: (), context: "Firebase Configuration")
        
        // Test models
        DebugHelper.shared.testModels()
        
        // Test Firebase connection after a delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            DebugHelper.shared.testFirebaseConnection()
        }
        
        return true
    }

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    }
}