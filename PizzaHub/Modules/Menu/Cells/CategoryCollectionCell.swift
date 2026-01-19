//
//  CategoryCollectionCell.swift
//  PizzaHub
//
//  Created by Dmitry Khalitov on 07.11.2025.
//

import UIKit
import SnapKit

final class CategoryCollectionCell: UICollectionViewCell {
    
    static let reusedId = "CategoryCollectionCell"
    
    private var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .brown
        view.applyShadow(cornerRadius: 12, shadowRadius: 0)
        
        return view
    }()
    
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Пиццы"
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
}

extension CategoryCollectionCell {
    func configure(with title: String) {
        titleLabel.text = title
    }
}

extension CategoryCollectionCell {
    private func setupViews() {
        contentView.addSubview(containerView)
        containerView.addSubview(titleLabel)
    }
    
    private func setupConstraints() {
        containerView.snp.makeConstraints { make in
            make.edges.equalTo(contentView)
            make.height.equalTo(30)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.trailing.equalTo(containerView).inset(8)
            make.bottom.top.equalTo(containerView).inset(4)
        }
    }
}
