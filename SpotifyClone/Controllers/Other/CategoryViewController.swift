//
//  CategoryViewController.swift
//  SpotifyClone
//
//  Created by Krystian Szczepankiewicz on 6/30/24.
//

import UIKit

// ViewController to display playlists for a specific category
class CategoryViewController: UIViewController {

    // MARK: - Properties

    let category: Category  // Category model

    private let collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewCompositionalLayout(sectionProvider: { _, _ -> NSCollectionLayoutSection? in
            // Define layout for collection view section
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
            )

            item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)

            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .absolute(250)
                ),
                subitem: item,
                count: 2
            )
            group.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)

            return NSCollectionLayoutSection(group: group)
        })
    )

    private var playlists = [Playlist]()  // Array to store playlists

    // MARK: - Init

    init(category: Category) {
        self.category = category
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        title = category.name  // Set view controller title
        view.addSubview(collectionView)  // Add collection view to the view hierarchy
        view.backgroundColor = .systemBackground  // Set background color
        collectionView.backgroundColor = .systemBackground  // Set collection view background color
        collectionView.register(
            FeaturedPlaylistCollectionViewCell.self,
            forCellWithReuseIdentifier: FeaturedPlaylistCollectionViewCell.identifier
        )  // Register cell for collection view
        collectionView.delegate = self  // Set delegate
        collectionView.dataSource = self  // Set data source

        // Fetch playlists for the category from API
        APICaller.shared.getCategoryPlaylists(category: category) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let playlists):
                    self?.playlists = playlists  // Update playlists array with fetched data
                    self?.collectionView.reloadData()  // Reload collection view
                case .failure(let error):
                    print(error.localizedDescription)  // Print error message
                }
            }
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds  // Adjust collection view frame to fit view bounds
    }
}

// MARK: - UICollectionViewDataSource Methods

extension CategoryViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return playlists.count  // Number of playlists
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: FeaturedPlaylistCollectionViewCell.identifier,
            for: indexPath
        ) as? FeaturedPlaylistCollectionViewCell else {
            return UICollectionViewCell()
        }
        let playlist = playlists[indexPath.row]  // Get playlist at index
        // Configure cell with playlist view model
        cell.configure(with: FeaturedPlaylistCellViewModel(
            name: playlist.name,
            artworkURL: URL(string: playlist.images.first?.url ?? ""),
            creatorName: playlist.owner.display_name
            )
        )
        return cell
    }
}

// MARK: - UICollectionViewDelegate Methods

extension CategoryViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)  // Deselect selected item
        // Create and push PlaylistViewController with selected playlist
        let vc = PlaylistViewController(playlist: playlists[indexPath.row])
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
}

