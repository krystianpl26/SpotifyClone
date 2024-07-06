//
//  LibraryPlaylistsViewController.swift
//  SpotifyClone
//
//  Created by Krystian Szczepankiewicz on 7/3/24.
//

import UIKit

class LibraryPlaylistsViewController: UIViewController {

    var playlists = [Playlist]()  // Array to hold playlists data

    public var selectionHandler: ((Playlist) -> Void)?  // Closure for handling playlist selection

    // Views
    private let noPlaylistsView = ActionLabelView()  // View to show when no playlists are available
    private let tableView: UITableView = {  // TableView to display playlists
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(
            SearchResultSubtitleTableViewCell.self,
            forCellReuseIdentifier: SearchResultSubtitleTableViewCell.identfier)
        tableView.isHidden = true  // Initially hidden until data is loaded
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        setUpNoPlaylistsView()  // Setting up the view for no playlists
        fetchData()  // Fetch playlists data

        if selectionHandler != nil {
            // Adding close button if selectionHandler is provided
            navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(didTapClose))
        }
    }

    // Function to handle close button tap
    @objc func didTapClose() {
        dismiss(animated: true, completion: nil)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // Adjusting frames for views
        noPlaylistsView.frame = CGRect(x: 0, y: 0, width: 150, height: 150)
        noPlaylistsView.center = view.center
        tableView.frame = view.bounds
    }

    // Setting up the view for no playlists
    private func setUpNoPlaylistsView() {
        view.addSubview(noPlaylistsView)
        noPlaylistsView.delegate = self
        noPlaylistsView.configure(
            with: ActionLabelViewViewModel(
                text: "You don't have any playlists yet.",
                actionTitle: "Create"
            )
        )
    }

    // Function to fetch playlists data
    private func fetchData() {
        APICaller.shared.getCurrentUserPlaylists { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let playlists):
                    self?.playlists = playlists  // Updating playlists data
                    self?.updateUI()  // Updating UI after data fetch
                case .failure(let error):
                    print(error.localizedDescription)  // Handling error
                }
            }
        }
    }

    // Function to update UI based on playlists data
    private func updateUI() {
        if playlists.isEmpty {
            // Show label when no playlists
            noPlaylistsView.isHidden = false
            tableView.isHidden = true
        }
        else {
            // Show table when playlists are available
            tableView.reloadData()
            noPlaylistsView.isHidden = true
            tableView.isHidden = false
        }
    }

    // Function to show alert for creating a new playlist
    public func showCreatePlaylistAlert() {
        let alert = UIAlertController(
            title: "New Playlist",
            message: "Enter playlist name.",
            preferredStyle: .alert
        )
        alert.addTextField { textField in
            textField.placeholder = "Playlist..."
        }

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Create", style: .default, handler: { _ in
            guard let field = alert.textFields?.first,
                  let text = field.text,
                  !text.trimmingCharacters(in: .whitespaces).isEmpty else {
                return
            }

            APICaller.shared.createPlaylist(with: text) { [weak self] success in
                if success {
                    HapticsManager.shared.vibrate(for: .success)
                    // Refresh list of playlists
                    self?.fetchData()
                }
                else {
                    HapticsManager.shared.vibrate(for: .error)
                    print("Failed to create playlist")
                }
            }
        }))

        present(alert, animated: true)
    }
}

// MARK: - ActionLabelViewDelegate
extension LibraryPlaylistsViewController: ActionLabelViewDelegate {
    // Handling action when 'Create' button is tapped in noPlaylistsView
    func actionLabelViewDidTapButton(_ actionView: ActionLabelView) {
        showCreatePlaylistAlert()  // Showing alert to create a new playlist
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension LibraryPlaylistsViewController: UITableViewDelegate, UITableViewDataSource {
    // Number of rows in tableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return playlists.count
    }

    // Cell configuration for each row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: SearchResultSubtitleTableViewCell.identfier,
            for: indexPath
        ) as? SearchResultSubtitleTableViewCell else {
            return UITableViewCell()
        }
        let playlist = playlists[indexPath.row]
        // Configuring cell with playlist data
        cell.configure(
            with: SearchResultSubtitleTableViewCellViewModel(
                title: playlist.name,
                subtitle: playlist.owner.display_name,
                imageURL: URL(string: playlist.images.first?.url ?? "")
            )
        )
        return cell
    }

    // Handling selection of a row
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)  // Deselecting row
        HapticsManager.shared.vibrateForSelection()  // Haptic feedback
        let playlist = playlists[indexPath.row]
        // Checking if selectionHandler is provided
        guard selectionHandler == nil else {
            selectionHandler?(playlist)  // Calling selectionHandler with selected playlist
            dismiss(animated: true, completion: nil)
            return
        }

        // Opening PlaylistViewController if no selectionHandler is provided
        let vc = PlaylistViewController(playlist: playlist)
        vc.navigationItem.largeTitleDisplayMode = .never
        vc.isOwner = true
        navigationController?.pushViewController(vc, animated: true)
    }

    // Height for each row in tableView
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70  // Fixed height for rows
    }
}
