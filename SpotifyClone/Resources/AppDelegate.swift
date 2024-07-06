//
//  AppDelegate.swift
//  SpotifyClone
//
//  Created by Krystian Szczepankiewicz on 6/25/24.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    // This method is called when the app has finished launching.
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        let window = UIWindow(frame: UIScreen.main.bounds) // Create a new window with the screen's bounds

        if AuthManager.shared.isSignedIn {
            // If the user is signed in, refresh the token if needed
            AuthManager.shared.refreshIfNeeded(completion: nil)
            window.rootViewController = TabBarViewController() // Set the root view controller to the main tab bar controller
        }
        else {
            // If the user is not signed in, present the welcome screen
            let navVC = UINavigationController(rootViewController: WelcomeViewController()) // Create a navigation controller with the welcome screen as the root
            navVC.navigationBar.prefersLargeTitles = true // Enable large titles for the navigation bar
            navVC.viewControllers.first?.navigationItem.largeTitleDisplayMode = .always // Always display large titles on the welcome screen
            window.rootViewController = navVC // Set the root view controller to the navigation controller
        }

        window.makeKeyAndVisible() // Make the window key and visible
        self.window = window // Assign the window to the window property

        return true // Indicate that the app has successfully launched
    }


    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
}


