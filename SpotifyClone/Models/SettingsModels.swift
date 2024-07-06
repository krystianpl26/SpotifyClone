//
//  SettingsModels.swift
//  SpotifyClone
//
//  Created by Krystian Szczepankiewicz on 6/26/24.
//

import Foundation
struct Section{
    let title: String
    let options: [Option]
}
struct Option{
    let title: String
    let handler: () -> Void
}
