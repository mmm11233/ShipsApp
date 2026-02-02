//
//  ShipTableViewCell.swift
//  ShipsApp
//
//  Created by Mariam Joglidze on 01.02.26.
//

import UIKit

class ShipTableViewCell: UITableViewCell {
    
    static let identifier = "ShipTableViewCell"
    
    private let containerView = UIView()
    private let shipImageView = UIImageView()
    private let nameLabel = UILabel()
    private let typeLabel = UILabel()
    private let statusLabel = UILabel()
    private let favouriteButton = UIButton(type: .system)
    
    private var favouriteAction: (() -> Void)?
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .clear
        selectionStyle = .none
        
        setupViews()
        layoutViews()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        shipImageView.image = nil
        shipImageView.backgroundColor = .clear
        nameLabel.text = nil
        typeLabel.text = nil
        statusLabel.text = nil
        nameLabel.backgroundColor = .clear
        typeLabel.backgroundColor = .clear
        statusLabel.backgroundColor = .clear
        favouriteButton.isHidden = false
    }
    
    // MARK: - Public
    func configure(with ship: Ship, favouriteAction: @escaping () -> Void) {
        self.favouriteAction = favouriteAction
        
        nameLabel.text = ship.name
        typeLabel.text = ship.type
        statusLabel.text = ship.status
        
        let heartImage = UIImage(systemName: ship.isFavorite ? "heart.fill" : "heart")
        favouriteButton.setImage(heartImage, for: .normal)
        favouriteButton.tintColor = .red
        
        shipImageView.image = UIImage(systemName: "photo") 
        
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
        shipImageView.image = nil
        
        nameLabel.text = nil
        typeLabel.text = nil
        statusLabel.text = nil
        
        nameLabel.backgroundColor = .systemGray5
        typeLabel.backgroundColor = .systemGray5
        statusLabel.backgroundColor = .systemGray5
        
        favouriteButton.isHidden = true
    }
    
    // MARK: - Actions
    @objc private func favouriteButtonTapped() {
        favouriteAction?()
    }
    
    // MARK: - Layout setup
    private func setupViews() {
        containerView.backgroundColor = .secondarySystemBackground
        containerView.layer.cornerRadius = 16
        containerView.layer.masksToBounds = true
        
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.1
        layer.shadowRadius = 6
        layer.shadowOffset = CGSize(width: 0, height: 4)
        layer.masksToBounds = false
        
        shipImageView.contentMode = .scaleAspectFill
        shipImageView.clipsToBounds = true
        
        nameLabel.font = .boldSystemFont(ofSize: 18)
        typeLabel.font = .systemFont(ofSize: 14)
        typeLabel.textColor = .secondaryLabel
        statusLabel.font = .systemFont(ofSize: 14)
        statusLabel.textColor = .secondaryLabel
        
        favouriteButton.addTarget(self,
                                  action: #selector(favouriteButtonTapped),
                                  for: .touchUpInside)
        
        contentView.addSubview(containerView)
        containerView.addSubview(shipImageView)
        containerView.addSubview(nameLabel)
        containerView.addSubview(typeLabel)
        containerView.addSubview(statusLabel)
        containerView.addSubview(favouriteButton)
    }
    
    private func layoutViews() {
        containerView.translatesAutoresizingMaskIntoConstraints = false
        shipImageView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        typeLabel.translatesAutoresizingMaskIntoConstraints = false
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        favouriteButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            shipImageView.topAnchor.constraint(equalTo: containerView.topAnchor),
            shipImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            shipImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            shipImageView.heightAnchor.constraint(equalToConstant: 180),
            
            favouriteButton.topAnchor.constraint(equalTo: shipImageView.bottomAnchor, constant: 12),
            favouriteButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),
            
            nameLabel.topAnchor.constraint(equalTo: shipImageView.bottomAnchor, constant: 12),
            nameLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            nameLabel.trailingAnchor.constraint(lessThanOrEqualTo: favouriteButton.leadingAnchor, constant: -8),
            
            typeLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            typeLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            typeLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),
            
            statusLabel.topAnchor.constraint(equalTo: typeLabel.bottomAnchor, constant: 8),
            statusLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            statusLabel.trailingAnchor.constraint(lessThanOrEqualTo: containerView.trailingAnchor, constant: -12),
            statusLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -12)
        ])
    }
}
