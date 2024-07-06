//
//  LibraryViewController.swift
//  SpotifyClone
//
//  Created by Krystian Szczepankiewicz on 6/25/24.
//

import UIKit

class LibraryViewController: UIViewController {

    // Child view controllers
    private let playlistsVC = LibraryPlaylistsViewController()
    private let albumsVC = LibraryAlbumsViewController()

    // ScrollView for paging between playlists and albums
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isPagingEnabled = true
        return scrollView
    }()

    // Toggle view for switching between playlists and albums
    private let toggleView = LibraryToggleView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        // Adding toggle view and setting delegate
        view.addSubview(toggleView)
        toggleView.delegate = self

        // Adding scrollView
        view.addSubview(scrollView)
        scrollView.contentSize = CGSize(width: view.width*2, height: scrollView.height)
        scrollView.delegate = self

        // Adding child view controllers and updating bar buttons
        addChildren()
        updateBarButtons()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        // Adjusting frames based on safe area and view size
        scrollView.frame = CGRect(
            x: 0,
            y: view.safeAreaInsets.top + 55, // 55 is the height of the toggle view
            width: view.width,
            height: view.height - view.safeAreaInsets.top - view.safeAreaInsets.bottom - 55
        )
        toggleView.frame = CGRect(
            x: 0,
            y: view.safeAreaInsets.top,
            width: 200, // Adjust this width as needed
            height: 55 // Height of the toggle view
        )
    }

    // Update navigation bar buttons based on toggle state
    private func updateBarButtons() {
        switch toggleView.state {
        case .playlist:
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapAdd))
        case .album:
            navigationItem.rightBarButtonItem = nil
        }
    }

    // Handle add button tap for playlists
    @objc private func didTapAdd() {
        playlistsVC.showCreatePlaylistAlert()
    }

    // Add child view controllers to scrollView
    private func addChildren() {
        addChild(playlistsVC)
        scrollView.addSubview(playlistsVC.view)
        playlistsVC.view.frame = CGRect(x: 0, y: 0, width: scrollView.width, height: scrollView.height)
        playlistsVC.didMove(toParent: self)

        addChild(albumsVC)
        scrollView.addSubview(albumsVC.view)
        albumsVC.view.frame = CGRect(x: view.width, y: 0, width: scrollView.width, height: scrollView.height)
        albumsVC.didMove(toParent: self)
    }
}

// MARK: - UIScrollViewDelegate

extension LibraryViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // Detect scroll position to update toggle view and navigation bar buttons
        if scrollView.contentOffset.x >= (view.width - 100) {
            toggleView.update(for: .album)
            updateBarButtons()
        } else {
            toggleView.update(for: .playlist)
            updateBarButtons()
        }
    }
}

// MARK: - LibraryToggleViewDelegate

extension LibraryViewController: LibraryToggleViewDelegate {
    // Handle toggle view tap for playlists
    func libraryToggleViewDidTapPlaylists(_ toggleView: LibraryToggleView) {
        scrollView.setContentOffset(.zero, animated: true)
        updateBarButtons()
    }

    // Handle toggle view tap for albums
    func libraryToggleViewDidTapAlbums(_ toggleView: LibraryToggleView) {
        scrollView.setContentOffset(CGPoint(x: view.width, y: 0), animated: true)
        updateBarButtons()
    }
}
