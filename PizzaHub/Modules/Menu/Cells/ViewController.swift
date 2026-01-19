//
//  ViewController.swift
//  PizzaHub
//
//  Created by Dmitry Khalitov on 12.10.2025.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    
    lazy var collectionView: UICollectionView = {
        
        let itemsCount: CGFloat = 3
        let padding: CGFloat = 20
        let paddingCount: CGFloat = itemsCount + 1
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = padding
        layout.minimumInteritemSpacing = padding
        
        let paddingSize = paddingCount * padding
        let cellSize = (UIScreen.main.bounds.width - paddingSize) / itemsCount
        
        layout.sectionInset = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        layout.itemSize = CGSize.init(width: cellSize, height: cellSize+80)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(PhotoCollectionCell.self, forCellWithReuseIdentifier: PhotoCollectionCell.reuseId)
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupConstraints()
    }
    
    private func setupViews() {
        view.addSubview(collectionView)
    }
    
    private func setupConstraints() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

extension ViewController: UICollectionViewDelegate {
    
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionCell.reuseId, for: indexPath) as! PhotoCollectionCell
        return cell
    }
}


class PhotoCollectionCell: UICollectionViewCell {
    
    static let reuseId = "PhotoCollectionCell"
    
    var containerView: UIView = {
        let view = UIView()
        view.applyShadow(cornerRadius: 6)
        view.backgroundColor = .yellow
        
        return view
    }()
    
    var photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .blue
        imageView.image = UIImage(named: "cucumber")
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 6
        imageView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    var nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Маринованные огурчики"
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 2
        label.textAlignment = .center
        
        return label
    }()
    
    var priceLabel: UILabel = {
        let label = UILabel()
        label.text = "79р"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textAlignment = .center
        
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
    
    private func setupViews() {
        contentView.addSubview(containerView)
        
        [photoImageView, nameLabel, priceLabel].forEach {
            containerView.addSubview($0)
        }
    }
    
    private func setupConstraints() {
        containerView.snp.makeConstraints { make in
            make.edges.equalTo(contentView)
        }
        
        photoImageView.snp.makeConstraints { make in
            make.top.left.right.equalTo(containerView)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(photoImageView.snp.bottom).offset(5)
            make.left.right.equalTo(containerView)
        }
        
        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(8)
            make.left.right.equalTo(containerView)
        }
    }
}
