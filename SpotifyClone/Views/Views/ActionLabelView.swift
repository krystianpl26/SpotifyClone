//
//  ActionLabelView.swift
//  SpotifyClone
//
//  Created by Krystian Szczepankiewicz on 7/3/24.
//

import UIKit

// View model for configuring an `ActionLabelView`.
struct ActionLabelViewViewModel {
    let text: String        // Text displayed in the label.
    let actionTitle: String // Title displayed on the button.
}

// Delegate protocol for `ActionLabelView` to handle button tap events.
protocol ActionLabelViewDelegate: AnyObject {
    func actionLabelViewDidTapButton(_ actionView: ActionLabelView)
}

// Custom view that displays a label and a button.
class ActionLabelView: UIView {

    weak var delegate: ActionLabelViewDelegate?

    private let label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = .secondaryLabel
        return label
    }()

    private let button: UIButton = {
        let button = UIButton()
        button.setTitleColor(.link, for: .normal)
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        clipsToBounds = true
        isHidden = true
        addSubview(button)
        addSubview(label)
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    // Action handler for button tap events.
    @objc func didTapButton() {
        delegate?.actionLabelViewDidTapButton(self)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        button.frame = CGRect(x: 0, y: height-40, width: width, height: 40)
        label.frame = CGRect(x: 0, y: 0, width: width, height: height-45)
    }

    // Configures the view with the provided view model.
    func configure(with viewModel: ActionLabelViewViewModel) {
        label.text = viewModel.text
        button.setTitle(viewModel.actionTitle, for: .normal)
    }
}
