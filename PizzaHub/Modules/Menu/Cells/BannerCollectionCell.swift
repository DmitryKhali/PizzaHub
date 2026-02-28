//
//  BannerCollectionCell.swift
//  PizzaHub
//
//  Created by Dmitry Khalitov on 07.11.2025.
//

import UIKit
import SnapKit

final class BannerCollectionCell: UICollectionViewCell {
    
    static let reuseId = "BannerCollectionCell"
    
    private var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.applyShadow(cornerRadius: 12, shadowRadius: 8)
        
        return view
    }()
    
    private var verticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.alignment = .leading
        
        stackView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 8, leading: 15, bottom: 8, trailing: 10)
        stackView.isLayoutMarginsRelativeArrangement = true
        
        return stackView
    }()
    
    private var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        //        imageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        //        imageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        //        imageView.snp.makeConstraints { make in
        //            make.width.height.equalTo(100)
        //        }
        //        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    private var nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Болгарская пицца"
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        
        return label
    }()
    
    private var priceLabel: UILabel = {
        let label = UILabel()
        label.text = "от 399 ₽"
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        contentView.addSubview(containerView)
        
        containerView.addSubview(imageView)
        containerView.addSubview(verticalStackView)
        
        verticalStackView.addArrangedSubview(nameLabel)
        verticalStackView.addArrangedSubview(priceLabel)
    }
    
    func setupConstraints() {
        containerView.snp.makeConstraints { make in
            make.edges.equalTo(contentView)
        }
        
        imageView.snp.makeConstraints { make in
            make.left.top.bottom.equalTo(containerView).inset(8)
            make.width.lessThanOrEqualTo(120)
        }
        
        verticalStackView.snp.makeConstraints { make in
            make.left.equalTo(imageView.snp.right).offset(4)
            make.right.equalTo(containerView).inset(16)
            make.centerY.equalTo(containerView)
        }
    }
}

extension BannerCollectionCell {
    
    func configure(banner: Product) {
        imageView.image = UIImage(named: banner.image)
        nameLabel.text = banner.name
        priceLabel.text = "от \(banner.minimumPrice) ₽"
    }
    
}
