//
//  AlbumTrackCollectionViewCell.swift
//  SpotifyClone
//
//  Created by Krystian Szczepankiewicz on 6/29/24.
//

import Foundation
import UIKit

// Collection view cell for displaying track information within an album.
class AlbumTrackCollectionViewCell: UICollectionViewCell {
    static let identifier = "AlbumTrackCollectionViewCell"
    
    // Label for displaying the track name.
    private let trackNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.numberOfLines = 0
        return label
    }()
    
    // Label for displaying the artist name.
    private let artistNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .thin)
        label.numberOfLines = 0
        return label
    }()
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .secondarySystemBackground
        contentView.backgroundColor = .secondarySystemBackground
        contentView.addSubview(trackNameLabel)
        contentView.addSubview(artistNameLabel)
        contentView.clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: - Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        trackNameLabel.frame = CGRect(x: 10, y: 0, width: contentView.width - 15, height: contentView.height / 2)
        artistNameLabel.frame = CGRect(x: 10, y: contentView.height / 2, width: contentView.width - 15, height: contentView.height / 2)
    }
    
    // MARK: - Reuse
    
    override func prepareForReuse() {
        super.prepareForReuse()
        trackNameLabel.text = nil
        artistNameLabel.text = nil
    }
    
    // MARK: - Configuration
    
    // Configures the cell with the provided view model.
    func configure(with viewModel: AlbumCollectionViewCellViewModel) {
        trackNameLabel.text = viewModel.name
        artistNameLabel.text = viewModel.artistName
    }
}
