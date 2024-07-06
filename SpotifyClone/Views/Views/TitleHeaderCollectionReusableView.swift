//
//  TitleHeaderCollectionReusableView.swift
//  SpotifyClone
//
//  Created by Krystian Szczepankiewicz on 6/29/24.
//

import UIKit

// Reusable view for displaying a title header in a collection view.
class TitleHeaderCollectionReusableView: UICollectionReusableView {
    static let identifier = "TitleHeaderCollectionReusableView"
    
    // Label for displaying the title text.
    private let label: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 22, weight: .regular)
        return label
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        addSubview(label)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: - Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        label.frame = CGRect(x: 15, y: 0, width: width - 30, height: height)
    }
    
    // MARK: - Configuration
    
    // Configures the view with a title.
    func configure(with title: String) {
        label.text = title
    }
}

