//
//  FeaturedPlaylistCollectionViewCell.swift
//  SpotifyClone
//
//  Created by Krystian Szczepankiewicz on 6/28/24.
//

import UIKit

class FeaturedPlaylistCollectionViewCell: UICollectionViewCell {
    // Static identifier for cell reuse
    static let identifier = "FeaturedPlaylistCollectionViewCell"
    
    // UI elements
    private let playlistCoverImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 4
        imageView.image = UIImage(systemName: "photo") // Placeholder image
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let playlistNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private let creatorNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .thin)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    // Initialization
    override init(frame: CGRect){
        super.init(frame: frame)
        contentView.addSubview(playlistCoverImageView)
        contentView.addSubview(playlistNameLabel)
        contentView.addSubview(creatorNameLabel)
        contentView.clipsToBounds = true
    }
    
    required init?(coder: NSCoder){
        fatalError()
    }
    
    // Layout subviews
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Adjust labels and image view positions within the cell
        creatorNameLabel.frame = CGRect(x: 3, y: contentView.height - 30, width: contentView.width - 6, height: 30)
        playlistNameLabel.frame = CGRect(x: 3, y: contentView.height - 60, width: contentView.width - 6, height: 30)
        let imageSize = contentView.height - 70
        playlistCoverImageView.frame = CGRect(x: (contentView.width - imageSize) / 2, y: 3, width: imageSize, height: imageSize)
    }
    
    // Prepare for reuse
    override func prepareForReuse() {
        super.prepareForReuse()
        playlistNameLabel.text = nil
        playlistCoverImageView.image = nil
        creatorNameLabel.text = nil
    }
    
    // Configure cell with view model
    func configure(with viewModel: FeaturedPlaylistCellViewModel){
        playlistNameLabel.text = viewModel.name
        playlistCoverImageView.sd_setImage(with: viewModel.artworkURL, completed: nil)
        creatorNameLabel.text = viewModel.creatorName
    }
}
