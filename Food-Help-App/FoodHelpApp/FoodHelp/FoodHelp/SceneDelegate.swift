//
//  SceneDelegate.swift
//  FoodHelp
//
//  Created by BP-36-224-16 on 10/12/2025.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {

        guard let windowScene = (scene as? UIWindowScene) else { return }

        window = UIWindow(windowScene: windowScene)
        setRootViewController()
        window?.makeKeyAndVisible()
    }

    private func setRootViewController() {
        let sb = UIStoryboard(name: "Main", bundle: nil)

        guard let user = Auth.auth().currentUser else {
            let homeVC = sb.instantiateViewController(withIdentifier: "Home")
            window?.rootViewController = homeVC
            return
        }

        Firestore.firestore().collection("users").document(user.uid).getDocument { [weak self] snapshot, error in
            guard let self = self else { return }

            if error != nil {
                let homeVC = sb.instantiateViewController(withIdentifier: "Home")
                self.window?.rootViewController = homeVC
                return
            }

            let role = (snapshot?.data()?["role"] as? String ?? "").lowercased()

            switch role {
            case "donor":
                guard let uid = Auth.auth().currentUser?.uid  else {return}
                
                Firestore.firestore().collection("users").document(uid).getDocument {
                    snapshot, _ in
                    let status = snapshot?.data()?["status"] as? String ?? "pending"
                    
                    if status == "approved"{
                        let donorVC = sb.instantiateViewController(withIdentifier: "DonorHome")
                        self.window?.rootViewController = donorVC
                    }else{
                        let pendingVC = sb.instantiateViewController(withIdentifier: "HomeHome")
                        self.window?.rootViewController = pendingVC
                    }
                }

            case "ngo":
                let ngoVC = sb.instantiateViewController(withIdentifier: "NgoHome")
                self.window?.rootViewController = ngoVC

            case "admin":
                let adminVC = sb.instantiateViewController(withIdentifier: "AdminHome")
                self.window?.rootViewController = adminVC

            default:
                let homeVC = sb.instantiateViewController(withIdentifier: "Home")
                self.window?.rootViewController = homeVC
            }
        }
    }
    
}

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }




