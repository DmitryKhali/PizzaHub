//
//  AdditionalIngredientCell.swift
//  PizzaHub
//
//  Created by Dmitry Khalitov on 15.11.2025.
//

import UIKit
import SnapKit

final class AdditionalIngredientCell: UICollectionViewCell {
    
    static let reuseId = "AdditionalIngredientCell"
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.applyShadow(cornerRadius: 10)
        
        return view
    }()
    
    private let ingredientImage: UIImageView = {
        var imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "cheeze_boat")
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        imageView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        imageView.widthAnchor.constraint(equalToConstant: 120).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 120).isActive = true
        
        return imageView
    }()
    
    private let ingredientTitle: UILabel = {
        var label = UILabel()
        label.text = "Сырный бортик"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 14)
        
        return label
    }()
    
    private let ingredientPrice: UILabel = {
        var label = UILabel()
        label.text = "205 ₽"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 14)
        
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
    
}

// MARK: - Layout
extension AdditionalIngredientCell {
    private func setupViews() {
        contentView.addSubview(containerView)
        containerView.addSubview(ingredientImage)
        containerView.addSubview(ingredientTitle)
        containerView.addSubview(ingredientPrice)
    }
    
    private func setupConstraints() {
        containerView.snp.makeConstraints { make in
            make.top.right.left.bottom.equalTo(contentView)
        }
        
        ingredientImage.snp.makeConstraints { make in
            make.top.left.right.equalTo(containerView).inset(4)
        }
        
        ingredientTitle.snp.makeConstraints { make in
            make.top.equalTo(ingredientImage.snp.bottom)
            make.left.right.equalTo(containerView).inset(2)
        }
        
        ingredientPrice.snp.makeConstraints { make in
            make.top.equalTo(ingredientTitle.snp.bottom)
            make.left.right.bottom.equalTo(containerView).inset(4)
        }
    }
}

//MARK: - Public
extension AdditionalIngredientCell {
    func update(ingredient: Ingredient) {
        ingredientImage.image = UIImage(named: ingredient.image)
        ingredientTitle.text = ingredient.name
        ingredientPrice.text = ingredient.price
    }
}
