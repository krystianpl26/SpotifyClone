//
//  SearchResultResponse.swift
//  SpotifyClone
//
//  Created by Krystian Szczepankiewicz on 7/2/24.
//

import Foundation

struct SearchResultResponse: Codable{
    let albums: SearchAlbumResponse
    let artists: SearchArtistsResponse
    let playlists: SearchPlaylistsResponse
    let tracks: SearchTracksResponse

}

struct SearchAlbumResponse: Codable{
    let items: [Album]
}

struct SearchArtistsResponse: Codable{
    let items: [Artist]
}

struct SearchPlaylistsResponse: Codable{
    let items: [Playlist]
}

struct SearchTracksResponse: Codable{
    let items: [AudioTrack]
}
