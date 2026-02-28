//
//  ProductOptionsContainerCell.swift
//  PizzaHub
//
//  Created by Dmitry Khalitov on 15.11.2025.
//

import UIKit
import SnapKit

final class ProductOptionsContainerCell: UITableViewCell {
    
    static let reuseId = "ProductOptionsContainerCell"
    
    var onSizeChanged: ((_ newSize: PizzaSize) -> Void)?
    var onDoughChanged: ((_ newDough: PizzaDough) -> Void)?
    
    private let pizzaSizeSegmentControl: UISegmentedControl = {
        var segmentControl = UISegmentedControl(items: PizzaSize.allCases.map { $0.displayValue })
        segmentControl.heightAnchor.constraint(equalToConstant: 30).isActive = true
        segmentControl.addTarget(self, action: #selector(pizzaSizeChanged), for: .valueChanged)
        
        return segmentControl
    }()
    
    private let pizzaDoughSegmentControl: UISegmentedControl = {
        var segmentControl = UISegmentedControl(items: PizzaDough.allCases.map{ $0.displayValue })
        segmentControl.heightAnchor.constraint(equalToConstant: 30).isActive = true
        segmentControl.addTarget(self, action: #selector(pizzaDoughChanged), for: .valueChanged)
        
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

// MARK: - Layout
extension ProductOptionsContainerCell {
    private func setupViews() {
        contentView.addSubview(pizzaSizeSegmentControl)
        contentView.addSubview(pizzaDoughSegmentControl)
    }
    
    private func setupConstraints() {
        pizzaSizeSegmentControl.snp.makeConstraints { make in
            make.top.equalTo(contentView).inset(6)
            make.left.right.equalTo(contentView).inset(14)
        }
        pizzaDoughSegmentControl.snp.makeConstraints { make in
            make.top.equalTo(pizzaSizeSegmentControl.snp.bottom).offset(8)
            make.left.right.equalTo(contentView).inset(14)
            make.bottom.equalTo(contentView)
        }
    }
}

// MARK: - Public
extension ProductOptionsContainerCell {
    func update(with product: Product) {
        pizzaSizeSegmentControl.selectedSegmentIndex = PizzaSize.allCases.firstIndex(where: { $0 == product.size }) ?? 2
        pizzaDoughSegmentControl.selectedSegmentIndex = PizzaDough.allCases.firstIndex(where: { $0 == product.dough }) ?? 0
    }
}

// MARK: - Private
extension ProductOptionsContainerCell {
    @objc private func pizzaSizeChanged() {
        let currentSize = PizzaSize.allCases[pizzaSizeSegmentControl.selectedSegmentIndex]
        onSizeChanged?(currentSize)
        
    }
    
    @objc private func pizzaDoughChanged() {
        let currentDough = PizzaDough.allCases[pizzaDoughSegmentControl.selectedSegmentIndex]
        onDoughChanged?(currentDough)
    }
}
