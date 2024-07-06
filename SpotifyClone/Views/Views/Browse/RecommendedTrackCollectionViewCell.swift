//
//  RecommendedTrackCollectionViewCell.swift
//  SpotifyClone
//
//  Created by Krystian Szczepankiewicz on 6/28/24.
//

import UIKit

class RecommendedTrackCollectionViewCell: UICollectionViewCell {
    // Static identifier for cell reuse
    static let identifier = "RecommendedTrackCollectionViewCell"
    
    // UI elements
    private let albumCoverImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "photo") // Placeholder image
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let trackNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.numberOfLines = 0
        return label
    }()
    
    private let artistNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .thin)
        label.numberOfLines = 0
        return label
    }()
    
    // Initialization
    override init(frame: CGRect){
        super.init(frame: frame)
        backgroundColor = .secondarySystemBackground
        contentView.backgroundColor = .secondarySystemBackground
        contentView.addSubview(albumCoverImageView)
        contentView.addSubview(trackNameLabel)
        contentView.addSubview(artistNameLabel)
        contentView.clipsToBounds = true
    }
    
    required init?(coder: NSCoder){
        fatalError()
    }
    
    // Layout subviews
    override func layoutSubviews() {
        super.layoutSubviews()
        
        albumCoverImageView.frame = CGRect(x: 5, y: 2, width: contentView.height - 4, height: contentView.height - 4)
        trackNameLabel.frame = CGRect(x: albumCoverImageView.right + 10, y: 0, width: contentView.width - albumCoverImageView.right - 15, height: contentView.height / 2)
        artistNameLabel.frame = CGRect(x: albumCoverImageView.right + 10, y: contentView.height / 2, width: contentView.width - albumCoverImageView.right - 15, height: contentView.height / 2)
    }
    
    // Prepare for reuse
    override func prepareForReuse() {
        super.prepareForReuse()
        trackNameLabel.text = nil
        albumCoverImageView.image = nil
        artistNameLabel.text = nil
    }
    
    // Configure cell with view model
    func configure(with viewModel: RecommendedTrackCellViewModel){
        trackNameLabel.text = viewModel.name
        albumCoverImageView.sd_setImage(with: viewModel.artworkURL, completed: nil)
        artistNameLabel.text = viewModel.artistName
    }
}
