//
//  StoriesContainerCell.swift
//  SampleApp
//
//  Created by Dmitry Khalitov on 02.11.2025.
//

import UIKit
import SnapKit

class StoriesContainerCell: UITableViewCell {
    
    static let reuseId = "StoriesContainerCell"
    
    private var stories: [Story] = []
    
    private lazy var collectionView: UICollectionView = {
        
        let count: CGFloat = 4
        let padding: CGFloat = 4
        let paddingCount = count + 1
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = padding
        
        let paddingSize = padding * paddingCount
        let cellWith = (UIScreen.currentWidth - paddingSize) / count
        
        layout.itemSize = CGSize(width: cellWith, height: cellWith * 1.5)
        layout.sectionInset = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsVerticalScrollIndicator = false
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
