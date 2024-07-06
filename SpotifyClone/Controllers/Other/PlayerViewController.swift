//
//  PlayerViewController.swift
//  SpotifyClone
//
//  Created by Krystian Szczepankiewicz on 6/25/24.
//

import UIKit
import SDWebImage

// Protocol to define delegate methods for player controls interactions
protocol PlayerViewControllerDelegate: AnyObject {
    func didTapPlayPause()
    func didTapForward()
    func didTapBackward()
    func didSlideSlider(_ value: Float)
}

class PlayerViewController: UIViewController {

    // MARK: - Properties

    weak var dataSource: PlayerDataSource?  // Data source for player information
    weak var delegate: PlayerViewControllerDelegate?  // Delegate for player control interactions

    // Image view to display album artwork
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    // Controls view for play/pause, forward, backward buttons and slider
    private let controlsView = PlayerControlsView()

    // MARK: - Lifecycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(imageView)  // Adding image view to view hierarchy
        view.addSubview(controlsView)  // Adding controls view to view hierarchy
        controlsView.delegate = self  // Setting delegate for controls view
        configureBarButtons()  // Configuring navigation bar buttons
        configure()  // Configuring initial UI
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // Setting frame for image view
        imageView.frame = CGRect(x: 0, y: view.safeAreaInsets.top, width: view.width, height: view.width)
        // Setting frame for controls view below image view
        controlsView.frame = CGRect(
            x: 10,
            y: imageView.bottom + 10,
            width: view.width - 20,
            height: view.height - imageView.height - view.safeAreaInsets.top - view.safeAreaInsets.bottom - 15
        )
    }

    // Configure UI with data from data source
    private func configure() {
        imageView.sd_setImage(with: dataSource?.imageURL, completed: nil)  // Setting image using SDWebImage
        controlsView.configure(  // Configuring controls view with view model
            with: PlayerControlsViewViewModel(
                title: dataSource?.songName,
                subtitle: dataSource?.subtitle
            )
        )
    }

    // Configure navigation bar buttons
    private func configureBarButtons() {
        // Close button on left side of navigation bar
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(didTapClose))
        // Action button on right side of navigation bar
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(didTapAction))
    }

    // Dismiss view controller when close button is tapped
    @objc private func didTapClose() {
        dismiss(animated: true, completion: nil)
    }

    // Handle action when action button is tapped
    @objc private func didTapAction() {
        // Implement actions here if needed
    }

    // Refresh UI when needed
    func refreshUI() {
        configure()  // Reconfigure UI with latest data
    }
}

// MARK: - PlayerControlsViewDelegate

extension PlayerViewController: PlayerControlsViewDelegate {
    // Delegate method for play/pause button tap
    func playerControlsViewDidTapPlayPauseButton(_ playerControlsView: PlayerControlsView) {
        delegate?.didTapPlayPause()  // Notify delegate of play/pause action
    }

    // Delegate method for forward button tap
    func playerControlsViewDidTapForwardButton(_ playerControlsView: PlayerControlsView) {
        delegate?.didTapForward()  // Notify delegate of forward action
    }

    // Delegate method for backward button tap
    func playerControlsViewDidTapBackwardsButton(_ playerControlsView: PlayerControlsView) {
        delegate?.didTapBackward()  // Notify delegate of backward action
    }

    // Delegate method for slider value change
    func playerControlsView(_ playerControlsView: PlayerControlsView, didSlideSlider value: Float) {
        delegate?.didSlideSlider(value)  // Notify delegate of slider value change
    }
}
