//
//  AdditionalIngredientsContainerCell.swift
//  PizzaHub
//
//  Created by Dmitry Khalitov on 15.11.2025.
//

import UIKit
import SnapKit

final class AdditionalIngredientsContainerCell: UITableViewCell {
    
    static let reuseId = "AdditionalIngredientsContainerCell"
    
    private var availableIngredients: [Ingredient] = []
    private var selectedIngredientIds: Set<String> = []
    
    var onIngredientSelect: ((Int) -> Void)?
    
    private let padding: CGFloat = 5
    private let cellHeight: CGFloat = 180
    
    private lazy var collectionView: UICollectionView = {
        
        let count: CGFloat = 3
        let paddingCount: CGFloat = count + 1
        
        var layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = padding
        layout.minimumInteritemSpacing = padding
        
        let paddingSize = paddingCount * padding
        let itemWith = (UIScreen.currentWidth - paddingSize) / count
        
        layout.sectionInset = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        layout.itemSize = CGSize(width: itemWith, height: cellHeight)
        
        var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isScrollEnabled = false
        collectionView.register(AdditionalIngredientCell.self, forCellWithReuseIdentifier: AdditionalIngredientCell.reuseId)
        
        return collectionView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
        setupConstarints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Delegate
extension AdditionalIngredientsContainerCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        onIngredientSelect?(indexPath.row)
    }
}

// MARK: - DataSource
extension AdditionalIngredientsContainerCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        availableIngredients.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AdditionalIngredientCell.reuseId, for: indexPath) as! AdditionalIngredientCell
        
        cell.update(ingredient: availableIngredients[indexPath.row], selectedIds: selectedIngredientIds)
        return cell
    }
}

// MARK: - Layout
extension AdditionalIngredientsContainerCell {
    
    private func setupViews() {
        contentView.addSubview(collectionView)
    }
    
    private func setupConstarints() {
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(contentView.safeAreaLayoutGuide).inset(5)
            make.left.right.bottom.equalTo(contentView.safeAreaLayoutGuide)
        }
    }
}

// MARK: - Public
extension AdditionalIngredientsContainerCell {
    func update(ingredients: [Ingredient], selectedIds: Set<String>) {
        guard !ingredients.isEmpty else { return }
        
        self.availableIngredients = ingredients
        self.selectedIngredientIds = selectedIds
        
        let rowCount: CGFloat = CGFloat(Int((Double(ingredients.count) / 3.0).rounded(.up)))
        let paddingCount: CGFloat = rowCount + 1
        let collectionHeight = (paddingCount*padding) + (cellHeight*rowCount)
        
        collectionView.heightAnchor.constraint(equalToConstant: collectionHeight).isActive = true
        collectionView.reloadData()
    }
}
