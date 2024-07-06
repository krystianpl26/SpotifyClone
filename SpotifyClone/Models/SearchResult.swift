//
//  SearchResult.swift
//  SpotifyClone
//
//  Created by Krystian Szczepankiewicz on 7/2/24.
//

import Foundation

enum SearchResult{
    case artist(model: Artist)
    case album(model: Album)
    case track(model: AudioTrack)
    case playlist(model: Playlist)
}
