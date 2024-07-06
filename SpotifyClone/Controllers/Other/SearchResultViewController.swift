//
//  SearchResultViewController.swift
//  SpotifyClone
//
//  Created by Krystian Szczepankiewicz on 6/25/24.
//

import UIKit

// Structure to represent a section in the search results
struct SearchSection {
    let title: String  // Title of the section (e.g., "Songs", "Artists", etc.)
    let results: [SearchResult]  // Results belonging to this section
}

// Protocol for handling selection of search results
protocol SearchResultsViewControllerDelegate: AnyObject {
    func didTapResult(_ result: SearchResult)  // Delegate method called when a result is tapped
}

class SearchResultsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // MARK: - Properties

    weak var delegate: SearchResultsViewControllerDelegate?  // Delegate to handle result taps

    private var sections: [SearchSection] = []  // Array of sections in the search results

    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.backgroundColor = .systemBackground
        tableView.register(SearchResultDefaultTableViewCell.self,
                           forCellReuseIdentifier: SearchResultDefaultTableViewCell.identfier)
        tableView.register(SearchResultSubtitleTableViewCell.self,
                           forCellReuseIdentifier: SearchResultSubtitleTableViewCell.identfier)
        tableView.isHidden = true
        return tableView
    }()

    // MARK: - Lifecycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }

    // MARK: - Update Methods

    // Update the view with search results
    func update(with results: [SearchResult]) {
        // Separate results into different sections
        let artists = results.filter({
            switch $0 {
            case .artist: return true
            default: return false
            }
        })

        let albums = results.filter({
            switch $0 {
            case .album: return true
            default: return false
            }
        })

        let tracks = results.filter({
            switch $0 {
            case .track: return true
            default: return false
            }
        })

        let playlists = results.filter({
            switch $0 {
            case .playlist: return true
            default: return false
            }
        })

        // Assign results to their respective sections
        self.sections = [
            SearchSection(title: "Songs", results: tracks),
            SearchSection(title: "Artists", results: artists),
            SearchSection(title: "Playlists", results: playlists),
            SearchSection(title: "Albums", results: albums)
        ]

        // Reload table view with updated data and show/hide based on results
        tableView.reloadData()
        tableView.isHidden = results.isEmpty
    }

    // MARK: - UITableViewDataSource Methods

    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].results.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let result = sections[indexPath.section].results[indexPath.row]

        // Configure cell based on the type of search result
        switch result {
        case .artist(let artist):
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: SearchResultDefaultTableViewCell.identfier,
                for: indexPath
            ) as? SearchResultDefaultTableViewCell else {
                return  UITableViewCell()
            }
            let viewModel = SearchResultDefaultTableViewCellViewModel(
                title: artist.name,
                imageURL: URL(string: artist.images?.first?.url ?? "")
            )
            cell.configure(with: viewModel)
            return cell
        case .album(let album):
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: SearchResultSubtitleTableViewCell.identfier,
                for: indexPath
            ) as? SearchResultSubtitleTableViewCell else {
                return  UITableViewCell()
            }
            let viewModel = SearchResultSubtitleTableViewCellViewModel(
                title: album.name,
                subtitle: album.artists.first?.name ?? "",
                imageURL: URL(string: album.images.first?.url ?? "")
            )
            cell.configure(with: viewModel)
            return cell
        case .track(let track):
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: SearchResultSubtitleTableViewCell.identfier,
                for: indexPath
            ) as? SearchResultSubtitleTableViewCell else {
                return  UITableViewCell()
            }
            let viewModel = SearchResultSubtitleTableViewCellViewModel(
                title: track.name,
                subtitle: track.artists.first?.name ?? "-",
                imageURL: URL(string: track.album?.images.first?.url ?? "")
            )
            cell.configure(with: viewModel)
            return cell
        case .playlist(let playlist):
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: SearchResultSubtitleTableViewCell.identfier,
                for: indexPath
            ) as? SearchResultSubtitleTableViewCell else {
                return  UITableViewCell()
            }
            let viewModel = SearchResultSubtitleTableViewCellViewModel(
                title: playlist.name,
                subtitle: playlist.owner.display_name,
                imageURL: URL(string: playlist.images.first?.url ?? "")
            )
            cell.configure(with: viewModel)
            return cell
        }
    }

    // MARK: - UITableViewDelegate Methods

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let result = sections[indexPath.section].results[indexPath.row]
        // Notify delegate when a result is tapped
        delegate?.didTapResult(result)
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].title  // Return section title for headers
    }
}
