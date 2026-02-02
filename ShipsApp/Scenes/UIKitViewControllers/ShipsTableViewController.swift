//
//  ShipsTableViewController.swift
//  ShipsApp
//
//  Created by Mariam Joglidze on 01.02.26.
//

import UIKit
import Combine
import SwiftUI

// MARK: - ShipsListViewController
class ShipsListViewController: UIViewController {
    
    // MARK: - Properties
    private let viewModel: ShipsViewModel
    private weak var router: MainRouter?
    private let tableView = UITableView()
    private let searchController = UISearchController(searchResultsController: nil)
    private var cancellables = Set<AnyCancellable>()
    private let refreshControl = UIRefreshControl()
    
    private var ships: [Ship] {
        viewModel.filteredShips
    }
    
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
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        tableView.contentInset = UIEdgeInsets(top: 16, left: 0, bottom: 16, right: 0)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .systemGroupedBackground
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 260
        tableView.alwaysBounceVertical = true   
        
        tableView.register(ShipTableViewCell.self,
                           forCellReuseIdentifier: ShipTableViewCell.identifier)
        tableView.dataSource = self
        tableView.delegate = self
        refreshControl.tintColor = .systemGray
        refreshControl.attributedTitle = NSAttributedString(
            string: "Refreshing ships...",
            attributes: [.foregroundColor: UIColor.gray]
        )
        refreshControl.addTarget(self,
                                 action: #selector(handleRefresh),
                                 for: .valueChanged)
        tableView.refreshControl = refreshControl
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
        
        viewModel.$searchText
            .removeDuplicates()
            .debounce(for: .milliseconds(150), scheduler: RunLoop.main)
            .sink { [weak self] _ in
                self?.tableView.reloadData()
            }
            .store(in: &cancellables)
    }
    
    @objc private func handleRefresh() {
        Task { [weak self] in
            guard let self else { return }
            do {
                await self.viewModel.loadShips()
                try? await Task.sleep(nanoseconds: 500_000_000)
            }
            await MainActor.run {
                self.tableView.reloadData()
                self.refreshControl.endRefreshing()
            }
        }
    }
}


// MARK: - UITableViewDataSource
extension ShipsListViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        viewModel.isLoading && ships.isEmpty ? 6 : ships.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(
            withIdentifier: ShipTableViewCell.identifier,
            for: indexPath
        ) as! ShipTableViewCell
        
        cell.backgroundColor = .clear
        
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
    
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        guard !viewModel.isLoading, !ships.isEmpty else { return }
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
