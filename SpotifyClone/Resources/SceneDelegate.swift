//
//  SceneDelegate.swift
//  SpotifyClone
//
//  Created by Krystian Szczepankiewicz on 6/25/24.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    // This method is called when the scene is about to be connected to the app session.
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return } // Ensure the scene is a UIWindowScene
        
        let window = UIWindow(windowScene: windowScene) // Create a new window for the window scene
        
        if AuthManager.shared.isSignedIn {
            // If the user is signed in, set the root view controller to the main tab bar controller
            window.rootViewController = TabBarViewController()
        } else {
            // If the user is not signed in, present the welcome screen
            let navVC = UINavigationController(rootViewController: WelcomeViewController()) // Create a navigation controller with the welcome screen as the root
            navVC.navigationBar.prefersLargeTitles = true // Enable large titles for the navigation bar
            navVC.viewControllers.first?.navigationItem.largeTitleDisplayMode = .always // Always display large titles on the welcome screen
            window.rootViewController = navVC // Set the root view controller to the navigation controller
        }
        
        window.makeKeyAndVisible() // Make the window key and visible
        self.window = window // Assign the window to the window property
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


}

