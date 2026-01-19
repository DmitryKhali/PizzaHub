//
//  ProductOptionsContainerCell.swift
//  SampleApp
//
//  Created by Dmitry Khalitov on 15.11.2025.
//

import UIKit
import SnapKit

final class ProductOptionsContainerCell: UITableViewCell {
    
    static let reuseId = "ProductOptionsContainerCell"
    
    private let productSizeSegmentControl: UISegmentedControl = {
        var segmentControl = UISegmentedControl(items: ["20 см", "25 см", "30 см", "35 см"])
        segmentControl.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        return segmentControl
    }()
    
    private let productDoughSegmentControl: UISegmentedControl = {
        var segmentControl = UISegmentedControl(items: ["Традиционное", "Тонкое"])
        segmentControl.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        return segmentControl
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

extension ProductOptionsContainerCell {
    
    private func setupViews() {
        contentView.addSubview(productSizeSegmentControl)
        contentView.addSubview(productDoughSegmentControl)
    }
    
    private func setupConstraints() {
        productSizeSegmentControl.snp.makeConstraints { make in
            make.top.equalTo(contentView).inset(6)
            make.left.right.equalTo(contentView).inset(14)
        }
        productDoughSegmentControl.snp.makeConstraints { make in
            make.top.equalTo(productSizeSegmentControl.snp.bottom).offset(8)
            make.left.right.equalTo(contentView).inset(14)
            make.bottom.equalTo(contentView)
        }
    }
    
}
