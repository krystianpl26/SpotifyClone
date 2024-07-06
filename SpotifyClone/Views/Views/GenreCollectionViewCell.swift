//
//  CategoryCollectionViewCell.swift
//  SpotifyClone
//
//  Created by Krystian Szczepankiewicz on 6/30/24.
//

import UIKit
import SDWebImage

// Collection view cell for displaying category information.
class CategoryCollectionViewCell: UICollectionViewCell {
    static let identifier = "CategoryCollectionViewCell"
    
    // Image view for displaying category artwork.
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .white
        // Default image when no artwork is available
        imageView.image = UIImage(systemName: "music.note", withConfiguration: UIImage.SymbolConfiguration(pointSize: 50, weight: .regular))
        return imageView
    }()
    
    // Label for displaying the category title.
    private let label: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 22, weight: .semibold)
        return label
    }()
    
    // Array of colors for background variation.
    private let colors: [UIColor] = [
        .systemRed,
        .systemBlue,
        .systemGreen,
        .systemPink,
        .systemOrange,
        .systemYellow,
        .systemPurple,
        .darkGray,
        .systemBrown,
        .systemTeal
    ]
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.layer.cornerRadius = 8
        contentView.layer.masksToBounds = true
        contentView.addSubview(label)
        contentView.addSubview(imageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: - Reuse
    
    override func prepareForReuse() {
        super.prepareForReuse()
        label.text = nil
        // Reset image to default when reusing cell
        imageView.image = UIImage(systemName: "music.note", withConfiguration: UIImage.SymbolConfiguration(pointSize: 50, weight: .regular))
    }
    
    // MARK: - Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // Positioning the label and image view within the cell
        label.frame = CGRect(x: 10, y: contentView.height/2, width: contentView.width-20, height: contentView.height/2)
        imageView.frame = CGRect(x: contentView.width/2, y: 10, width: contentView.width/2, height: contentView.height/2)
    }
    
    // MARK: - Configuration
    
    // Configures the cell with the provided view model.
    func configure(with viewModel: CategoryCollectionViewCellViewModel) {
        label.text = viewModel.title
        imageView.sd_setImage(with: viewModel.artworkURL, completed: nil)
        // Randomly select a background color from the predefined array
        contentView.backgroundColor = colors.randomElement()
    }
}

