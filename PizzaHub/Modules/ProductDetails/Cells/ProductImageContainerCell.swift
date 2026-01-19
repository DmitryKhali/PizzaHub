//
//  ProductImageContainerCell.swift
//  PizzaHub
//
//  Created by Dmitry Khalitov on 14.11.2025.
//

import UIKit
import SnapKit

final class ProductImageContainerCell: UITableViewCell {
    
    static let reuseId = "ProductImageContainerCell"
    
    private let productImageView: UIImageView = {
        var imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "hawaii")
        
        imageView.heightAnchor.constraint(equalToConstant: 350).isActive = true
        
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ProductImageContainerCell {
    private func setupViews() {
        contentView.addSubview(productImageView)
    }
    
    private func setupConstraints() {
        productImageView.snp.makeConstraints { make in
            make.edges.equalTo(contentView)
        }
    }
}
