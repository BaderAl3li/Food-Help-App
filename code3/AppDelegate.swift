//
//  AppDelegate.swift
//  code3
//
//  Created by BP-19-114-09 on 21/12/2025.
//

import UIKit
import FirebaseAuth
import SwiftUI
import FirebaseCore


class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
      print("Firebase configured")

      if Auth.auth().currentUser == nil {
          Auth.auth().signInAnonymously { result, error in
              if let error = error {
                  print("Anonymous sign-in failed:", error)
              } else {
                  print("Signed in uid:", result?.user.uid ?? "nil")
              }
          }
      } else {
          print("Already signed in uid:", Auth.auth().currentUser?.uid ?? "nil")
      }
    return true
  }
}

@main
struct YourApp: App {
  // register app delegate for Firebase setup
  @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate


  var body: some Scene {
    WindowGroup {
      NavigationView {
        ContentView()
      }
    }
  }
}

