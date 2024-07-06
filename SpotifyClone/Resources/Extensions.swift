//
//  Extensions.swift
//  SpotifyClone
//
//  Created by Krystian Szczepankiewicz on 6/25/24.
//

import Foundation
import UIKit

// Extension to add convenient computed properties to UIView for accessing dimensions and positions
extension UIView {
    var width: CGFloat {
        return frame.size.width // Get the width of the view
    }
    var height: CGFloat {
        return frame.size.height // Get the height of the view
    }
    var left: CGFloat {
        return frame.origin.x // Get the left (x-coordinate) of the view
    }
    var right: CGFloat {
        return left + width // Get the right (x-coordinate + width) of the view
    }
    var top: CGFloat {
        return frame.origin.y // Get the top (y-coordinate) of the view
    }
    var bottom: CGFloat {
        return top + height // Get the bottom (y-coordinate + height) of the view
    }
}

// Extension to add static DateFormatter properties for consistent date formatting throughout the app
extension DateFormatter {
    static let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd" // Standard date format
        return dateFormatter
    }()
    
    static let displayDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium // Display style for user-friendly dates
        return dateFormatter
    }()
}

// Extension to add a convenient method for formatting date strings
extension String {
    static func formattedDate(string: String) -> String {
        guard let date = DateFormatter.dateFormatter.date(from: string) else {
            return string // Return original string if date conversion fails
        }
        return DateFormatter.displayDateFormatter.string(from: date) // Return formatted date string
    }
}

// Extension to add a custom notification name for album saved events
extension Notification.Name {
    static let albumSavedNotification = Notification.Name("albumSavedNotification") // Custom notification name for when an album is saved
}

