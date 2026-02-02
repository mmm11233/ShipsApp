//
//  ShipsTableViewController.swift
//  ShipsApp
//
//  Created by Mariam Joglidze on 01.02.26.
//

import UIKit
import Combine

final class ShipsListViewController: UIViewController {
    // MARK: - Properties
    private let viewModel: ShipsViewModel
    private weak var router: MainRouter?
    private var cancellables = Set<AnyCancellable>()
    private let tableView = UITableView()
    private let refreshControl = UIRefreshControl()
    private var skeletonActive = false
    private var ships: [Ship] { viewModel.filteredShips }
    
    // MARK: - Init
    init(viewModel: ShipsViewModel, router: MainRouter) {
        self.viewModel = viewModel
        self.router = router
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        bindViewModel()
        configureSearch()
        Task { await viewModel.loadIfNeeded() }
    }
    
    // MARK: - Setup
    private func setupLayout() {
        title = "Ships"
        view.backgroundColor = .systemBackground
        
        tableView.backgroundColor = .systemGroupedBackground
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 260
        tableView.contentInset = .init(top: 16, left: 0, bottom: 16, right: 0)
        
        tableView.register(ShipTableViewCell.self,
                           forCellReuseIdentifier: ShipTableViewCell.identifier)
        
        refreshControl.tintColor = .systemGray
        refreshControl.attributedTitle = NSAttributedString(
            string: "Refreshing ships...",
            attributes: [.foregroundColor: UIColor.gray]
        )
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        tableView.refreshControl = refreshControl
        
        tableView.dataSource = self
        tableView.delegate = self
        
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func configureSearch() {
        let searchController = UISearchController(searchResultsController: nil)
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
        
        viewModel.$isLoading
            .receive(on: RunLoop.main)
            .sink { [weak self] loading in
                self?.updateLoadingState(isLoading: loading)
            }
            .store(in: &cancellables)
        
        viewModel.$searchText
            .removeDuplicates()
            .debounce(for: .milliseconds(150), scheduler: RunLoop.main)
            .sink { [weak self] _ in
                self?.tableView.reloadData()
            }
            .store(in: &cancellables)
    }
    
    // MARK: - State Handling
    private func updateLoadingState(isLoading: Bool) {
        skeletonActive = isLoading
        tableView.reloadData()
    }
    
    @objc private func handleRefresh() {
        Task {
            await viewModel.loadShips()
            try? await Task.sleep(nanoseconds: 400_000_000)
            await MainActor.run {
                self.refreshControl.endRefreshing()
                self.tableView.reloadData()
            }
        }
    }
}

// MARK: - UITableViewDataSource
extension ShipsListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        skeletonActive ? 6 : ships.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: ShipTableViewCell.identifier,
            for: indexPath
        ) as? ShipTableViewCell else {
            return UITableViewCell()
        }
        
        if skeletonActive {
            cell.configureSkeleton()
        } else if ships.indices.contains(indexPath.row) {
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
        guard !skeletonActive, ships.indices.contains(indexPath.row) else { return }
        let ship = ships[indexPath.row]
        router?.goToShipDetails(ship: ship)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - UISearchResultsUpdating
extension ShipsListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        viewModel.searchText = searchController.searchBar.text ?? ""
    }
}
