//
//  StoriesContainerCell.swift
//  PizzaHub
//
//  Created by Dmitry Khalitov on 02.11.2025.
//

import UIKit
import SnapKit

class StoriesContainerCell: UITableViewCell {
    
    var onStoryTapped: ((Story) -> Void)?
    
    static let reuseId = "StoriesContainerCell"
    private var stories: [Story] = []
        
    private lazy var collectionView: UICollectionView = {
        
        let count: CGFloat = 4
        let horizontalPadding: CGFloat = 10  // отступы от краев
        let cellSpacing: CGFloat = 4    // расстояние между ячейками

        let totalHorizontalPadding = horizontalPadding * 2  // left + right
        let totalSpacing = cellSpacing * (count - 1)  // 3 промежутка между 4 ячейками
        let availableWidth = UIScreen.currentWidth - totalHorizontalPadding - totalSpacing
        let cellWidth = availableWidth / count

        var layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = cellSpacing
        
        // Проверяем: нужен ли скролл?
        let contentWidth = (cellWidth + cellSpacing) * CGFloat(stories.count) - cellSpacing + horizontalPadding * 2
        let needsScroll = contentWidth > UIScreen.currentWidth
        
        layout.sectionInset = UIEdgeInsets(
            top: 10,
            left: horizontalPadding,
            bottom: 10,
            right: needsScroll ? 0 : horizontalPadding
        )
        layout.itemSize = CGSize(width: cellWidth, height: cellWidth * 1.2)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(StoryCollectionCell.self, forCellWithReuseIdentifier: StoryCollectionCell.reusedId)
        
        return collectionView
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

extension StoriesContainerCell {
    func update(_ stories: [Story]) {
        self.stories = stories
        collectionView.reloadData()
    }
}

extension StoriesContainerCell: UICollectionViewDelegate {
    
}

extension StoriesContainerCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        stories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StoryCollectionCell.reusedId, for: indexPath) as! StoryCollectionCell
        
        let story = stories[indexPath.item]
        cell.configure(with: story)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedItem = stories[indexPath.row]
        onStoryTapped?(selectedItem)
    }
}

extension StoriesContainerCell {
    
    private func setupViews() {
        contentView.addSubview(collectionView)
    }
    
    private func setupConstraints() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(contentView.safeAreaLayoutGuide)
        }
        collectionView.snp.makeConstraints { make in
            make.height.equalTo(150)
        }
    }
}
