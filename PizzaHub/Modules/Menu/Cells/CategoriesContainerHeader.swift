//
//  CategoriesContainerHeader.swift
//  PizzaHub
//
//  Created by Dmitry Khalitov on 31.10.2025.
//

import UIKit
import SnapKit

final class CategoriesContainerHeader: UITableViewHeaderFooterView {
    
    static let reuseId = "CategoriesContainerHeader"
    var onCategorySelected: ((String) -> Void)?
    
    private var categories: [Category] = []
    private var selectedCategoryId: String?
    
//    private let headerLabel: UILabel = {
//        let label = UILabel()
//        label.text = "Пицца"
//        label.font = .boldSystemFont(ofSize: 26)
//        
//        return label
//    }()
    
    private lazy var collectionView: UICollectionView = {
        
        let count: CGFloat = 5
        let padding: CGFloat = 15
        let paddingCount: CGFloat = count + 1
        
        var layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = padding
        
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        layout.sectionInset = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(CategoryCollectionCell.self, forCellWithReuseIdentifier: CategoryCollectionCell.reusedId)
        
        return collectionView
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = .white
        backgroundView = UIView()
        backgroundView?.backgroundColor = .white
                
        setupViews()
        setupCinstraints()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
        
    }
}

extension CategoriesContainerHeader {
    func update(_ categories: [Category], selectedCategoryId: String?) {
        self.categories = categories
        if let categoryId = selectedCategoryId {
            self.selectedCategoryId = categoryId
        }
        else if let firstCategory = categories.first {
            self.selectedCategoryId = firstCategory.categoryId
        }
        collectionView.reloadData()
    }
}

extension CategoriesContainerHeader: UICollectionViewDelegate {
    
}

extension CategoriesContainerHeader: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCollectionCell.reusedId, for: indexPath) as! CategoryCollectionCell

        let category = categories[indexPath.item]
        let isSelected = category.categoryId == selectedCategoryId
        cell.configure(with: category.title, isSelected: isSelected)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let categoryId = categories[indexPath.row].categoryId
        onCategorySelected(categoryId: categoryId)
    }
}

extension CategoriesContainerHeader {
    private func setupViews() {
//        contentView.addSubview(headerLabel)
        contentView.addSubview(collectionView)
    }
    
    private func setupCinstraints() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(contentView)
            make.height.equalTo(55)
        }
        
//        headerLabel.snp.makeConstraints { make in
//            make.top.equalTo(collectionView.snp.bottom)
//            make.left.equalTo(contentView).inset(10)
//            make.right.bottom.equalTo(contentView)
//        }
    }
}

// MARK: - Private
extension CategoriesContainerHeader {
    private func onCategorySelected(categoryId: String) {
        selectedCategoryId = categoryId
        onCategorySelected?(categoryId)
        collectionView.reloadData()
    }
}
