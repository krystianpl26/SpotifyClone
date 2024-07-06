//
//  SettingsViewController.swift
//  SpotifyClone
//
//  Created by Krystian Szczepankiewicz on 6/25/24.
//

import UIKit

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // MARK: - Properties

    // TableView for displaying settings options
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()

    // Data model for sections and options
    private var sections = [Section]()

    // MARK: - Lifecycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        configureModels()
        title = "Settings"  // Setting title
        view.backgroundColor = .systemBackground  // Setting background color
        view.addSubview(tableView)  // Adding tableView to view hierarchy
        tableView.dataSource = self  // Setting dataSource
        tableView.delegate = self  // Setting delegate
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds  // Adjusting tableView frame to fit view bounds
    }

    // MARK: - Configuration Methods

    // Configuring sections and options
    private func configureModels() {
        // Profile section
        sections.append(Section(title: "Profile", options: [
            Option(title: "View Your Profile", handler: { [weak self] in
                DispatchQueue.main.async {
                    self?.viewProfile()
                }
            })
        ]))

        // Account section
        sections.append(Section(title: "Account", options: [
            Option(title: "Sign Out", handler: { [weak self] in
                DispatchQueue.main.async {
                    self?.signOutTapped()
                }
            })
        ]))
    }

    // MARK: - Action Methods

    // Action when sign out option is tapped
    private func signOutTapped() {
        let alert = UIAlertController(title: "Sign Out", message: "Are you sure?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Sign Out", style: .destructive, handler: { _ in
            // Perform sign out action
            AuthManager.shared.signOut { [weak self] signedOut in
                if signedOut {
                    DispatchQueue.main.async {
                        // Present welcome view controller after signing out
                        let navVC = UINavigationController(rootViewController: WelcomeViewController())
                        navVC.navigationBar.prefersLargeTitles = true
                        navVC.viewControllers.first?.navigationItem.largeTitleDisplayMode = .always
                        navVC.modalPresentationStyle = .fullScreen
                        self?.present(navVC, animated: true, completion: {
                            self?.navigationController?.popToRootViewController(animated: false)
                        })
                    }
                }
            }
        }))
        present(alert, animated: true)
    }

    // Action to view user profile
    private func viewProfile() {
        let vc = ProfileViewController()
        vc.title = "Profile"
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }

    // MARK: - TableView Methods

    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].options.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = sections[indexPath.section].options[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = model.title  // Setting cell text from model
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        // Call handler for selected option
        let model = sections[indexPath.section].options[indexPath.row]
        model.handler()
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let model = sections[section]
        return model.title  // Setting section header title
    }
}

