//
//  HapticsManager.swift
//  SpotifyClone
//
//  Created by Krystian Szczepankiewicz on 6/25/24.
//

import Foundation
import UIKit

// Class to manage haptic feedback
final class HapticsManager {
    // Shared instance to access the HapticsManager
    static let shared = HapticsManager()

    // Private initializer to ensure only one instance is created
    private init() {}

    // Function to generate a selection feedback vibration
    public func vibrateForSelection() {
        // Ensure haptic feedback is generated on the main thread
        DispatchQueue.main.async {
            let generator = UISelectionFeedbackGenerator()
            generator.prepare() // Prepare the generator to reduce latency
            generator.selectionChanged() // Trigger the selection feedback
        }
    }

    // Function to generate a notification feedback vibration
    public func vibrate(for type: UINotificationFeedbackGenerator.FeedbackType) {
        // Ensure haptic feedback is generated on the main thread
        DispatchQueue.main.async {
            let generator = UINotificationFeedbackGenerator()
            generator.prepare() // Prepare the generator to reduce latency
            generator.notificationOccurred(type) // Trigger the notification feedback
        }
    }
}
