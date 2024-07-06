//
//  LibraryAlbumsResponse.swift
//  SpotifyClone
//
//  Created by Krystian Szczepankiewicz on 7/3/24.
//

import Foundation

struct LibraryAlbumsResponse: Codable {
    let items: [SavedAlbum]
}

struct SavedAlbum: Codable {
    let added_at: String
    let album: Album
}
