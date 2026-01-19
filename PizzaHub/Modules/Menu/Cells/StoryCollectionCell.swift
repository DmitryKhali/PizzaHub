//
//  StoryCollectionCell.swift
//  SampleApp
//
//  Created by Dmitry Khalitov on 07.11.2025.
//

import UIKit
import SnapKit

final class StoryCollectionCell: UICollectionViewCell {
    
    static let reusedId = "StoryCollectionCell"
    
    private let containerView: UIView = {
        var view = UIView()
        view.layer.cornerRadius = 16
        
        return view
    }()
    
    private let imageView: UIImageView = {
        var imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 16
        
        imageView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    private let label: UILabel = {
        var label = UILabel()
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.numberOfLines = 0
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
        containerView.addSubview(imageView)
        containerView.addSubview(label)
    }
    
    private func setupConstraints() {
        containerView.snp.makeConstraints { make in
            make.edges.equalTo(contentView)
        }
        
        imageView.snp.makeConstraints { make in
            make.edges.equalTo(containerView)
        }
        
        label.snp.makeConstraints { make in
            make.bottom.left.right.equalTo(containerView).inset(8)
        }
    }
}

extension StoryCollectionCell {
    
    func configure(with story: Story) {
        imageView.image = UIImage(named: story.imageName)
        label.text = story.title
    }
    
}
