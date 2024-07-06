//
//  WelcomeViewController.swift
//  SpotifyClone
//
//  Created by Krystian Szczepankiewicz on 6/25/24.
//

import UIKit

class WelcomeViewController: UIViewController {

    // UI elements
    private let signInButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.setTitle("Sign into Spotify", for: .normal)
        button.setTitleColor(.black, for: .normal)
        return button
    }()

    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "albums_background")
        return imageView
    }()

    private let overlayView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.alpha = 0.7
        return view
    }()

    private let logoImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "AppIcon"))
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private let label: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = .white
        label.font = .systemFont(ofSize: 32, weight: .semibold)
        label.text = "Listen to Millions\nof Songs on\nthe go."
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Spotify"
        view.addSubview(imageView)  // Adding background image view
        view.addSubview(overlayView)  // Adding overlay view for darkening background
        view.backgroundColor = .blue  // Setting background color
        view.addSubview(signInButton)  // Adding sign-in button
        signInButton.addTarget(self, action: #selector(didTapSignIn), for: .touchUpInside)  // Adding action for sign-in button
        view.addSubview(label)  // Adding label
        view.addSubview(logoImageView)  // Adding logo image view
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        imageView.frame = view.bounds  // Adjusting background image view frame
        overlayView.frame = view.bounds  // Adjusting overlay view frame
        signInButton.frame = CGRect(  // Adjusting sign-in button frame
            x: 20,
            y: view.height-50-view.safeAreaInsets.bottom,
            width: view.width-40,
            height: 50
        )

        logoImageView.frame = CGRect(x: (view.width-120)/2, y: (view.height-350)/2, width: 120, height: 120)  // Adjusting logo image view frame
        label.frame = CGRect(x: 30, y: logoImageView.bottom+30, width: view.width-60, height: 150)  // Adjusting label frame
    }

    // Action when sign-in button is tapped
    @objc func didTapSignIn() {
        let vc = AuthViewController()  // Initializing authentication view controller
        vc.completionHandler = { [weak self] success in
            DispatchQueue.main.async {
                self?.handleSignIn(success: success)  // Handling sign-in completion
            }
        }
        vc.navigationItem.largeTitleDisplayMode = .never  // Configuring navigation item
        navigationController?.pushViewController(vc, animated: true)  // Presenting authentication view controller
    }

    // Handling sign-in completion
    private func handleSignIn(success: Bool) {
        // Determine next steps based on sign-in success
        guard success else {
            let alert = UIAlertController(title: "Oops",
                                          message: "Something went wrong when signing in.",
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
            present(alert, animated: true)  // Presenting error alert
            return
        }

        let mainAppTabBarVC = TabBarViewController()  // Initializing main app tab bar controller
        mainAppTabBarVC.modalPresentationStyle = .fullScreen
        present(mainAppTabBarVC, animated: true)  // Presenting main app tab bar controller
    }
}
