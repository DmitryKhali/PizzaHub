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
        view.backgroundColor = .orange.withAlphaComponent(0.5)
        view.applyShadow(cornerRadius: 16, shadowRadius: 0)
        
        return view
    }()
    
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        
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
    func configure(with title: String, isSelected: Bool = false) {
        titleLabel.text = title
        if isSelected {
            containerView.backgroundColor = .orange.withAlphaComponent(0.8)
            titleLabel.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        }
        else {
            containerView.backgroundColor = .orange.withAlphaComponent(0.5)
            titleLabel.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        }
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
            make.leading.trailing.equalTo(containerView).inset(12)
            make.bottom.top.equalTo(containerView).inset(6)
        }
    }
}
