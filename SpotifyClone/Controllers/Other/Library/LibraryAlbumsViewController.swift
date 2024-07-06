//
//  LibraryAlbumsViewController.swift
//  SpotifyClone
//
//  Created by Krystian Szczepankiewicz on 7/3/24.
//

import UIKit

class LibraryAlbumsViewController: UIViewController {

    var albums = [Album]()  // Array to hold albums data

    // Views
    private let noAlbumsView = ActionLabelView()  // View to show when no albums are available
    private let tableView: UITableView = {  // TableView to display albums
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(
            SearchResultSubtitleTableViewCell.self,
            forCellReuseIdentifier: SearchResultSubtitleTableViewCell.identfier)
        tableView.isHidden = true  // Initially hidden until data is loaded
        return tableView
    }()

    private var observer: NSObjectProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        setUpNoAlbumsView()  // Setting up the view for no albums
        fetchData()  // Fetch albums data
        observer = NotificationCenter.default.addObserver(  // Observer for album saved notification
            forName: .albumSavedNotification,
            object: nil,
            queue: .main,
            using: { [weak self] _ in
                self?.fetchData()  // Reload data when album is saved
            }
        )
    }

    // Function to handle close button tap
    @objc func didTapClose() {
        dismiss(animated: true, completion: nil)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // Adjusting frames for views
        noAlbumsView.frame = CGRect(x: (view.width-150)/2, y: (view.height-150)/2, width: 150, height: 150)
        tableView.frame = CGRect(x: 0, y: 0, width: view.width, height: view.height)
    }

    // Setting up the view for no albums
    private func setUpNoAlbumsView() {
        view.addSubview(noAlbumsView)
        noAlbumsView.delegate = self
        noAlbumsView.configure(
            with: ActionLabelViewViewModel(
                text: "You have not saved any albums yet.",
                actionTitle: "Browse"
            )
        )
    }

    // Function to fetch albums data
    private func fetchData() {
        albums.removeAll()  // Clearing existing albums
        APICaller.shared.getCurrentUserAlbums { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let albums):
                    self?.albums = albums  // Updating albums data
                    self?.updateUI()  // Updating UI after data fetch
                case .failure(let error):
                    print(error.localizedDescription)  // Handling error
                }
            }
        }
    }

    // Function to update UI based on albums data
    private func updateUI() {
        if albums.isEmpty {
            // Show label when no albums
            noAlbumsView.isHidden = false
            tableView.isHidden = true
        }
        else {
            // Show table when albums are available
            tableView.reloadData()
            noAlbumsView.isHidden = true
            tableView.isHidden = false
        }
    }
}

// MARK: - ActionLabelViewDelegate
extension LibraryAlbumsViewController: ActionLabelViewDelegate {
    // Handling action when 'Browse' button is tapped
    func actionLabelViewDidTapButton(_ actionView: ActionLabelView) {
        tabBarController?.selectedIndex = 0  // Switching to first tab (assuming tabBarController exists)
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension LibraryAlbumsViewController: UITableViewDelegate, UITableViewDataSource {
    // Number of rows in tableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return albums.count
    }

    // Cell configuration for each row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: SearchResultSubtitleTableViewCell.identfier,
            for: indexPath
        ) as? SearchResultSubtitleTableViewCell else {
            return UITableViewCell()
        }
        let album = albums[indexPath.row]
        // Configuring cell with album data
        cell.configure(
            with: SearchResultSubtitleTableViewCellViewModel(
                title: album.name,
                subtitle: album.artists.first?.name ?? "-",
                imageURL: URL(string: album.images.first?.url ?? "")
            )
        )
        return cell
    }

    // Handling selection of a row
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)  // Deselecting row
        HapticsManager.shared.vibrateForSelection()  // Haptic feedback
        let album = albums[indexPath.row]
        let vc = AlbumViewController(album: album)  // Initializing AlbumViewController with selected album
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)  // Pushing AlbumViewController
    }

    // Height for each row in tableView
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70  // Fixed height for rows
    }
}
