//
//  PlaybackPresenter.swift
//  SpotifyClone
//
//  Created by Krystian Szczepankiewicz on 7/2/24.
//
import AVFoundation
import Foundation
import UIKit

// Protocol to define the data source for the player
protocol PlayerDataSource: AnyObject {
    var songName: String? { get }
    var subtitle: String? { get }
    var imageURL: URL? { get }
}

// Class to manage playback
final class PlaybackPresenter {
    static let shared = PlaybackPresenter() // instance

    private var track: AudioTrack? // Currently playing track
    private var tracks = [AudioTrack]() // List of tracks for playlist/album

    var index = 0 // Current index in the playlist

    // Computed property to get the current track
    var currentTrack: AudioTrack? {
        if let track = track, tracks.isEmpty {
            return track
        } else if let player = self.playerQueue, !tracks.isEmpty {
            return tracks[index]
        }
        return nil
    }

    var playerVC: PlayerViewController? // Reference to the player view controller

    var player: AVPlayer? // Single track player
    var playerQueue: AVQueuePlayer? // Queue player for playlists/albums

    // Function to start playback of a single track
    func startPlayback(
        from viewController: UIViewController,
        track: AudioTrack
    ) {
        guard let url = URL(string: track.preview_url ?? "") else {
            return
        }
        player = AVPlayer(url: url)
        player?.volume = 0.5

        self.track = track
        self.tracks = []
        let vc = PlayerViewController()
        vc.title = track.name
        vc.dataSource = self
        vc.delegate = self
        viewController.present(UINavigationController(rootViewController: vc), animated: true) { [weak self] in
            self?.player?.play()
        }
        self.playerVC = vc
    }

    // Function to start playback of multiple tracks (playlist/album)
    func startPlayback(
        from viewController: UIViewController,
        tracks: [AudioTrack]
    ) {
        self.tracks = tracks
        self.track = nil

        self.playerQueue = AVQueuePlayer(items: tracks.compactMap({
            guard let url = URL(string: $0.preview_url ?? "") else {
                return nil
            }
            return AVPlayerItem(url: url)
        }))
        self.playerQueue?.volume = 0.5
        self.playerQueue?.play()

        let vc = PlayerViewController()
        vc.dataSource = self
        vc.delegate = self
        viewController.present(UINavigationController(rootViewController: vc), animated: true, completion: nil)
        self.playerVC = vc
    }
}

// Extension to handle player view controller delegate methods
extension PlaybackPresenter: PlayerViewControllerDelegate {
    // Play/pause button tapped
    func didTapPlayPause() {
        if let player = player {
            if player.timeControlStatus == .playing {
                player.pause()
            } else if player.timeControlStatus == .paused {
                player.play()
            }
        } else if let player = playerQueue {
            if player.timeControlStatus == .playing {
                player.pause()
            } else if player.timeControlStatus == .paused {
                player.play()
            }
        }
    }

    // Forward button tapped
    func didTapForward() {
        if tracks.isEmpty {
            // Not a playlist or album
            player?.pause()
        } else if let player = playerQueue {
            playerQueue?.advanceToNextItem()
            index += 1
            print(index) // Print current index for debugging
            playerVC?.refreshUI() // Refresh UI to reflect the change
        }
    }

    // Backward button tapped
    func didTapBackward() {
        if tracks.isEmpty {
            // Not a playlist or album
            player?.pause()
            player?.play()
        } else if let firstItem = playerQueue?.items().first {
            playerQueue?.pause()
            playerQueue?.removeAllItems()
            playerQueue = AVQueuePlayer(items: [firstItem])
            playerQueue?.play()
            playerQueue?.volume = 0.5
        }
    }

    // Slider value changed
    func didSlideSlider(_ value: Float) {
        player?.volume = value
    }
}

// Extension to provide data source methods
extension PlaybackPresenter: PlayerDataSource {
    var songName: String? {
        return currentTrack?.name
    }

    var subtitle: String? {
        return currentTrack?.artists.first?.name
    }

    var imageURL: URL? {
        return URL(string: currentTrack?.album?.images.first?.url ?? "")
    }
}


