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
    
    private var ingredients: [Ingredient] = []
    
    var onIngredientIsRequiredToggle: ((Int) -> Void)?
    
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
    
    private lazy var ingredientsCollectionView: UICollectionView = {
        let layout = LeftAlignedFlowLayout()
        layout.minimumInteritemSpacing = 4
//        layout.minimumLineSpacing = 8
        
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
//        layout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        
        let collectionView = SelfSizingCollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(IngredientCell.self, forCellWithReuseIdentifier: IngredientCell.reuseId)
        collectionView.delegate = self
        collectionView.dataSource = self
        
//        collectionView.backgroundColor = .green
        collectionView.isScrollEnabled = false
        
        return collectionView
    }()
    
    private let infoButton: UIButton = {
        var button = UIButton()
        button.setImage(UIImage(systemName: "info.circle"), for: .normal)
        button.tintColor = .gray
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        print("@@@@ ProductInfoContainerCell init")
        
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - Layout
extension ProductInfoContainerCell {
    private func setupViews() {
        contentView.addSubview(productName)
        contentView.addSubview(productDescription)
        contentView.addSubview(ingredientsCollectionView)
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
        
        ingredientsCollectionView.snp.makeConstraints { make in
            make.top.equalTo(productDescription.snp.bottom).offset(6)
            make.left.right.equalTo(contentView).inset(12)
            make.bottom.equalTo(contentView).inset(10)
        }
    }
}

// MARK: - Public
extension ProductInfoContainerCell {
    func update(with product: Product) {
        productName.text = product.name
        productDescription.text = "\(product.size?.displayValue ?? ""), \(product.dough?.displayValue ?? "")"
        if let baseIngredients = product.baseIngredients {
            ingredients = baseIngredients
        }
        
        
//        print("@@@ 0 contentSize: \(ingredientsCollectionView.contentSize)")
//        print("@@@ 0 contentSize: \(ingredientsCollectionView.intrinsicContentSize)")
//        reloadData()
        ingredientsCollectionView.invalidateIntrinsicContentSize()
        ingredientsCollectionView.layoutIfNeeded()
//        print("@@@ 1 contentSize: \(ingredientsCollectionView.contentSize)")
//        print("@@@ 1 contentSize: \(ingredientsCollectionView.intrinsicContentSize)")
    }
}

// MARK: - Private
extension ProductInfoContainerCell {
    func reloadData() {
        ingredientsCollectionView.reloadData()
//        ingredientsCollectionView.collectionViewLayout.invalidateLayout()
    }
}

// MARK: - CollectionViewDelegate, DataSource
extension ProductInfoContainerCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        onIngredientIsRequiredToggle?(indexPath.row)
    }
}

extension ProductInfoContainerCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        ingredients.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = ingredientsCollectionView.dequeueReusableCell(withReuseIdentifier: IngredientCell.reuseId, for: indexPath) as? IngredientCell else { return UICollectionViewCell() }
        
        let isLastCell = ingredients.last == ingredients[indexPath.row]
        cell.update(with: ingredients[indexPath.row], isLastCell: isLastCell)
        
        return cell
    }
}

extension ProductInfoContainerCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
}
