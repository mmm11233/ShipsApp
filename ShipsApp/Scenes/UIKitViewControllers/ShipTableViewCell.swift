//
//  ShipTableViewCell.swift
//  ShipsApp
//
//  Created by Mariam Joglidze on 01.02.26.
//

import UIKit

final class ShipTableViewCell: UITableViewCell {
    // MARK: - Properties
    static let identifier = "ShipTableViewCell"
    private let containerView = UIView()
    private let shipImageView = UIImageView()
    private let nameLabel = UILabel()
    private let typeLabel = UILabel()
    private let statusLabel = UILabel()
    private let favouriteButton = UIButton(type: .system)
    private var favouriteAction: (() -> Void)?
    private var shimmerLayer: CAGradientLayer?
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = .clear
        setupLayout()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) not implemented") }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        shipImageView.image = nil
        shimmerLayer?.removeFromSuperlayer()
        shimmerLayer = nil
    }
    
    // MARK: - Public API
    func configure(with ship: Ship, favouriteAction: @escaping () -> Void) {
        self.favouriteAction = favouriteAction
        
        nameLabel.text = ship.name
        typeLabel.text = ship.type
        statusLabel.text = ship.status
        
        let heartImage = UIImage(systemName: ship.isFavorite == true ? "heart.fill" : "heart")
        favouriteButton.setImage(heartImage, for: .normal)
        favouriteButton.tintColor = .systemRed
        
        // Placeholder color
        shipImageView.backgroundColor = .secondarySystemFill
        if let urlString = ship.image, let url = URL(string: urlString) {
            RemoteImageLoader.shared.load(url: url) { [weak self] image in
                DispatchQueue.main.async {
                    self?.shipImageView.image = image ?? UIImage(systemName: "photo")
                    self?.shipImageView.backgroundColor = .clear
                }
            }
        }
    }
    
    func configureSkeleton() {
        nameLabel.text = nil; typeLabel.text = nil; statusLabel.text = nil
        favouriteButton.isHidden = true
        startShimmer()
    }
    
    // MARK: - Layout Setup
    private func setupLayout() {
        containerView.backgroundColor = .secondarySystemBackground
        containerView.layer.cornerRadius = 16
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOpacity = 0.1
        containerView.layer.shadowRadius = 6
        containerView.layer.shadowOffset = CGSize(width: 0, height: 4)
        containerView.layer.masksToBounds = false
        
        shipImageView.contentMode = .scaleAspectFill
        shipImageView.layer.cornerRadius = 16
        shipImageView.clipsToBounds = true
        
        nameLabel.font = .boldSystemFont(ofSize: 18)
        typeLabel.font = .systemFont(ofSize: 14)
        typeLabel.textColor = .secondaryLabel
        statusLabel.font = .systemFont(ofSize: 14)
        statusLabel.textColor = .secondaryLabel
        
        favouriteButton.addTarget(self, action: #selector(favouriteTapped), for: .touchUpInside)
        
        contentView.addSubview(containerView)
        [shipImageView, nameLabel, typeLabel, statusLabel, favouriteButton]
            .forEach(containerView.addSubview)
        
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
    
    // MARK: - Actions
    @objc private func favouriteTapped() {
        // Simple spring bounce animation
        UIView.animate(withDuration: 0.15,
                       animations: {
            self.favouriteButton.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        }) { _ in
            UIView.animate(withDuration: 0.15) {
                self.favouriteButton.transform = .identity
            }
        }
        favouriteAction?()
    }
    
    // MARK: - Shimmer animation
    private func startShimmer() {
        let gradient = CAGradientLayer()
        gradient.colors = [
            UIColor.systemGray5.cgColor,
            UIColor.systemGray4.cgColor,
            UIColor.systemGray5.cgColor
        ]
        gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradient.frame = containerView.bounds
        gradient.locations = [0.0, 0.5, 1.0]
        
        let animation = CABasicAnimation(keyPath: "locations")
        animation.fromValue = [-1.0, -0.5, 0.0]
        animation.toValue = [1.0, 1.5, 2.0]
        animation.duration = 1.2
        animation.repeatCount = .infinity
        gradient.add(animation, forKey: "shimmer")
        
        containerView.layer.addSublayer(gradient)
        shimmerLayer = gradient
    }
}
