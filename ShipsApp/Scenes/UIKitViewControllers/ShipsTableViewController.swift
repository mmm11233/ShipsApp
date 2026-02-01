//
//  ShipsTableViewController.swift
//  ShipsApp
//
//  Created by Mariam Joglidze on 01.02.26.
//

import UIKit
import Combine

// MARK: - ShipsListViewController
class ShipsListViewController: UIViewController {
    
    // MARK: - Properties
    private let viewModel: ShipsViewModel
    private let tableView = UITableView()
    private let searchController = UISearchController(searchResultsController: nil)
    private var cancellables = Set<AnyCancellable>()

    private var ships: [Ship] {
        viewModel.filteredShips
    }
    
    // MARK: - Init
    init(viewModel: ShipsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Ships"
        view.backgroundColor = .systemBackground
        
        setupTableView()
        setupSearchController()
        bindViewModel()
        
        Task {
            await viewModel.loadIfNeeded()
        }
    }
    
    // MARK: - Setup
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        tableView.register(ShipTableViewCell.self, forCellReuseIdentifier: ShipTableViewCell.identifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 220
        tableView.tableFooterView = UIView()
    }
    
    private func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Ships"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    private func bindViewModel() {
        viewModel.$ships
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.tableView.reloadData()
            }
            .store(in: &cancellables)
    }
}

// MARK: - UITableViewDataSource
extension ShipsListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = ships.count
        return count == 0 && viewModel.isLoading ? 3 : count // Skeleton rows if loading
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: ShipTableViewCell.identifier, for: indexPath) as! ShipTableViewCell
        
        if viewModel.isLoading || ships.isEmpty {
            cell.configureSkeleton()
        } else {
            let ship = ships[indexPath.row]
            cell.configure(with: ship) { [weak self] in
                self?.viewModel.toggleFavourite(for: ship)
            }
        }
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension ShipsListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard !viewModel.isLoading else { return }
        let ship = ships[indexPath.row]
        let detailVC = ShipDetailsView(ship: ship)
//        navigationController?.pushViewController(detailVC, animated: true)
    }
}

// MARK: - UISearchResultsUpdating
extension ShipsListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        viewModel.searchText = searchController.searchBar.text ?? ""
    }
}

// MARK: - ShipTableViewCell
class ShipTableViewCell: UITableViewCell {
    
    static let identifier = "ShipTableViewCell"
    
    private let shipImageView = UIImageView()
    private let nameLabel = UILabel()
    private let typeLabel = UILabel()
    private let statusLabel = UILabel()
    private let favouriteButton = UIButton(type: .system)
    
    private var favouriteAction: (() -> Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        contentView.layer.cornerRadius = 12
        contentView.clipsToBounds = true
        
        setupViews()
        layoutViews()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    func configure(with ship: Ship, favouriteAction: @escaping () -> Void) {
        self.favouriteAction = favouriteAction
        
        nameLabel.text = ship.name
        typeLabel.text = ship.type
        statusLabel.text = ship.status
        
        let heartImage = ship.isFavorite ? UIImage(systemName: "heart.fill") : UIImage(systemName: "heart")
        favouriteButton.setImage(heartImage, for: .normal)
        favouriteButton.tintColor = .red
        
        shipImageView.image = UIImage(systemName: "photo") // placeholder
        
        if let urlString = ship.image, let url = URL(string: urlString) {
            RemoteImageLoader.shared.load(url: url) { [weak self] image in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    self.shipImageView.image = image ?? UIImage(systemName: "photo")
                }
            }
        }
    }
    
    func configureSkeleton() {
        shipImageView.backgroundColor = .systemGray5
        nameLabel.text = " "
        typeLabel.text = " "
        statusLabel.text = " "
        favouriteButton.isHidden = true
    }
    
    @objc private func favouriteButtonTapped() {
        favouriteAction?()
    }
    
    // MARK: - Layout
    private func setupViews() {
        shipImageView.contentMode = .scaleAspectFill
        shipImageView.clipsToBounds = true
        
        nameLabel.font = .boldSystemFont(ofSize: 18)
        typeLabel.font = .systemFont(ofSize: 14)
        typeLabel.textColor = .secondaryLabel
        statusLabel.font = .systemFont(ofSize: 14)
        
        favouriteButton.addTarget(self, action: #selector(favouriteButtonTapped), for: .touchUpInside)
        
        contentView.addSubview(shipImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(typeLabel)
        contentView.addSubview(statusLabel)
        contentView.addSubview(favouriteButton)
    }
    
    private func layoutViews() {
        shipImageView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        typeLabel.translatesAutoresizingMaskIntoConstraints = false
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        favouriteButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            shipImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            shipImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            shipImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            shipImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            nameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -40),
            
            typeLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            typeLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 2),
            
            favouriteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            favouriteButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -40),
            favouriteButton.widthAnchor.constraint(equalToConstant: 24),
            favouriteButton.heightAnchor.constraint(equalToConstant: 24),
            
            statusLabel.trailingAnchor.constraint(equalTo: favouriteButton.leadingAnchor, constant: -8),
            statusLabel.centerYAnchor.constraint(equalTo: favouriteButton.centerYAnchor)
        ])
    }
}
