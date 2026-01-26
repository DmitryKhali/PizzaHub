//
//  BannersContainerCell.swift
//  PizzaHub
//
//  Created by Dmitry Khalitov on 19.10.2025.
//

import UIKit
import SnapKit

final class BannersContainerCell: UITableViewCell {
    
    var onBannerTapped: ((Product) -> Void)?
    
    static let reuseId = "BannersContainerCell"
    
    private var banners: [Product] = []
    
    let headerLabel: UILabel = {
        var label = UILabel()
        label.text = "Часто заказывают"
        label.font = UIFont.boldSystemFont(ofSize: 26)
        
        return label
    }()
    
    private lazy var collectionView: UICollectionView = {
        let padding: CGFloat = 10
        
        var layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = padding
        layout.minimumInteritemSpacing = padding
                
        layout.sectionInset = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        layout.itemSize = CGSize.init(width: 290, height: 120)
        
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.showsHorizontalScrollIndicator = false
        view.delegate = self
        view.dataSource = self
        view.register(BannerCollectionCell.self, forCellWithReuseIdentifier: BannerCollectionCell.reuseId)
        return view
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

extension BannersContainerCell {
    func update(_ banners: [Product]) {
        self.banners = banners
        collectionView.reloadData()
    }
}

extension BannersContainerCell: UICollectionViewDelegate {
    
}

extension BannersContainerCell: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return banners.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BannerCollectionCell.reuseId, for: indexPath) as! BannerCollectionCell
        let banner = banners[indexPath.item]
        cell.configure(banner: banner)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = banners[indexPath.row]
        onBannerTapped?(cell)
    }
}

extension BannersContainerCell {
    private func setupViews() {
        contentView.addSubview(headerLabel)
        contentView.addSubview(collectionView)
    }
    
    private func setupConstraints() {
        headerLabel.snp.makeConstraints { make in
            make.left.equalTo(contentView).inset(10)
            make.top.right.equalTo(contentView)
        }
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(headerLabel.snp.bottom)
            make.left.right.bottom.equalTo(contentView)
            make.height.equalTo(140)
        }
    }
}
