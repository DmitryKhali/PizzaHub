//
//  ProductInfoContainerCell.swift
//  PizzaHub
//
//  Created by Dmitry Khalitov on 14.11.2025.
//

import UIKit
import SnapKit

final class ProductInfoContainerCell: UITableViewCell {
    
    static let reuseId = "ProductInfoContainerCell"
    
    private let productName: UILabel = {
        var label = UILabel()
        label.text = "Пепперони фреш"
        label.font = .systemFont(ofSize: 26)
        
        return label
    }()
    
    private let productDescription: UILabel = {
       var label = UILabel()
        label.text = "30см, традиционное тесто 30, 580 г"
        label.font = .systemFont(ofSize: 16)
        label.textColor = .gray
        label.numberOfLines = 0
        
        return label
    }()
    
    private let ingredients: UILabel = {
        var label = UILabel()
        label.text = "Пикантная пепперони, увеличенная порция мацареллы, томаты, фирменный томатный соус"
        label.font = .systemFont(ofSize: 16)
        label.numberOfLines = 0
        
        return label
    }()
    
    private let infoButton: UIButton = {
        var button = UIButton()
        button.setImage(UIImage(systemName: "info.circle"), for: .normal)
        button.tintColor = .gray
        button.heightAnchor.constraint(equalToConstant: 24).isActive = true
        button.widthAnchor.constraint(equalToConstant: 24).isActive = true
        
        return button
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

extension ProductInfoContainerCell {
    private func setupViews() {
        contentView.addSubview(productName)
        contentView.addSubview(productDescription)
        contentView.addSubview(ingredients)
        contentView.addSubview(infoButton)
    }
    
    private func setupConstraints() {
        productName.snp.makeConstraints { make in
            make.top.equalTo(contentView).inset(18)
            make.left.equalTo(contentView).inset(14)
        }
        
        infoButton.snp.makeConstraints { make in
            make.top.equalTo(contentView).inset(18)
            make.right.equalTo(contentView).inset(14)
            make.left.greaterThanOrEqualTo(productName.snp.right).inset(6)
        }
        
        productDescription.snp.makeConstraints { make in
            make.top.equalTo(productName.snp.bottom).offset(6)
            make.left.right.equalTo(contentView).inset(12)
        }
        
        ingredients.snp.makeConstraints { make in
            make.top.equalTo(productDescription.snp.bottom).offset(6)
            make.left.right.equalTo(contentView).inset(12)
            make.bottom.equalTo(contentView).inset(10)
        }
        
    }
}
