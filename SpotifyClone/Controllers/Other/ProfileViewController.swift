//
//  ProfileViewController.swift
//  SpotifyClone
//
//  Created by Krystian Szczepankiewicz on 6/25/24.
//
import SDWebImage
import UIKit

class ProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - Properties
    
    // TableView to display profile information
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.isHidden = true
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    // Array to hold profile information
    private var models = [String]()

    // MARK: - Lifecycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Profile"  // Setting view controller title
        tableView.delegate = self  // Setting tableView delegate
        tableView.dataSource = self  // Setting tableView data source
        view.addSubview(tableView)  // Adding tableView to view hierarchy
        fetchProfile()  // Fetching user profile data
        view.backgroundColor = .systemBackground  // Setting background color
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds  // Adjusting tableView frame to fit view bounds
    }

    // MARK: - Data Fetching and UI Update Methods

    // Fetching user profile data from API
    private func fetchProfile() {
        APICaller.shared.getCurrentUserProfile { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let model):
                    self?.updateUI(with: model)  // Updating UI with fetched profile data
                case .failure(let error):
                    print("Profile Error: \(error.localizedDescription)")
                    self?.failedToGetProfile()  // Handling failure to fetch profile
                }
            }
        }
    }

    // Updating UI with profile data
    private func updateUI(with model: UserProfile) {
        tableView.isHidden = false  // Showing tableView once data is fetched
        // Populating table view models with profile information
        models.append("UserName: \(model.display_name)")
        models.append("Email Address: \(model.email)")
        models.append("User ID: \(model.id)")
        models.append("Plan: \(model.product)")
        createTableHeader(with: model.images.first?.url)  // Creating table view header with profile image
        tableView.reloadData()  // Reloading table view to reflect changes
    }

    // Creating table view header with profile image
    private func createTableHeader(with string: String?) {
        guard let urlString = string, let url = URL(string: urlString) else {
            return
        }
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.width / 1.5))
        let imageSize: CGFloat = headerView.bounds.height / 2
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: imageSize, height: imageSize))
        headerView.addSubview(imageView)
        imageView.center = headerView.center
        imageView.contentMode = .scaleAspectFill
        imageView.sd_setImage(with: url, completed: nil)  // Setting profile image using SDWebImage
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = imageSize / 2  // Applying circular mask to profile image
        
        tableView.tableHeaderView = headerView  // Setting header view for table view
    }
    
    // Handling failure to fetch profile data
    private func failedToGetProfile() {
        let label = UILabel(frame: .zero)
        label.text = "Failed to load profile"
        label.sizeToFit()
        label.textColor = .secondaryLabel
        view.addSubview(label)
        label.center = view.center  // Centering label in view
    }
    
    // MARK: - TableView Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count  // Returning number of rows in tableView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = models[indexPath.row]  // Setting cell text from models array
        cell.selectionStyle = .none  // Disabling cell selection style
        return cell
    }
}

