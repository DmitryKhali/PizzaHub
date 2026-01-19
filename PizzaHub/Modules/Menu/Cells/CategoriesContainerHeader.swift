//
//  CategoriesContainerHeader.swift
//  SampleApp
//
//  Created by Dmitry Khalitov on 31.10.2025.
//

import UIKit
import SnapKit

final class CategoriesContainerHeader: UITableViewHeaderFooterView {
    
    static let reuseId = "CategoriesContainerHeader"
    
    private var categories: [Category] = []
    
    private let headerLabel: UILabel = {
        let label = UILabel()
        label.text = "Пиццы"
        label.font = .boldSystemFont(ofSize: 26)
        
        return label
    }()
    
    private lazy var collectionView: UICollectionView = {
        
        let count: CGFloat = 5
        let padding: CGFloat = 15
        let paddingCount: CGFloat = count + 1
        
        var layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = padding

        let paddingSize = padding * paddingCount
//        let cellSize = (UIScreen.main.bounds.width - paddingSize) / count
        
//        layout.itemSize = CGSize(width: cellSize, height: cellSize / 2)
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        layout.sectionInset = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(CategoryCollectionCell.self, forCellWithReuseIdentifier: CategoryCollectionCell.reusedId)
        
        return collectionView
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        setupViews()
        setupCinstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CategoriesContainerHeader {
    func update(_ categories: [Category]) {
        self.categories = categories
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
        cell.configure(with: category.title)
        
        return cell
    }
}

extension CategoriesContainerHeader {
    private func setupViews() {
        contentView.addSubview(headerLabel)
        contentView.addSubview(collectionView)
    }
    
    private func setupCinstraints() {
        collectionView.snp.makeConstraints { make in
            make.top.left.right.equalTo(contentView)
            make.height.equalTo(60)
        }
        
        headerLabel.snp.makeConstraints { make in
            make.top.equalTo(collectionView.snp.bottom)
            make.left.right.bottom.equalTo(contentView)
        }
    }
}
