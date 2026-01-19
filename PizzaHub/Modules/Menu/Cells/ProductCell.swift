//
//  ProductCell.swift
//  SampleApp
//
//  Created by Dmitry Khalitov on 01.10.2025.
//

import UIKit
import SnapKit

final class ProductCell: UITableViewCell {
    
    static let reuseId = "ProductCell"
    
    private lazy var containerView = {
        $0.backgroundColor = .white
        $0.applyShadow(cornerRadius: 10)
        return $0
    }(UIView())
    
    private let verticalStackView = {
        $0.axis = .vertical
        $0.spacing = 15
        $0.alignment = .leading
        $0.distribution = .fill
        
        $0.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 16, leading: 8, bottom: 8, trailing: 0)
        $0.isLayoutMarginsRelativeArrangement = true
        
        return $0
    }(UIStackView())
    
    private let nameLabel = {
        $0.text = "Пепперони"
        $0.font = UIFont.boldSystemFont(ofSize: 20)
        return $0
    }(UILabel())
    
    private let detailLabel = {
        $0.text = "Тесто, Цыпленок, моцарелла, томатный соус"
        $0.textColor = .darkGray
        $0.numberOfLines = 0
        $0.font = UIFont.boldSystemFont(ofSize: 15)
        return $0
    }(UILabel())
    
    private var priceButton = {
        $0.setTitle("от 469 руб", for: .normal)
        $0.backgroundColor = .orange.withAlphaComponent(0.1)
        $0.layer.cornerRadius = 20
        $0.setTitleColor(.brown, for: .normal)
        $0.contentEdgeInsets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
        $0.heightAnchor.constraint(equalToConstant: 35).isActive = true // TODO - норм?
        return $0
    }(UIButton())
    
    private var productImageView = {
        $0.image = UIImage(named: "default")
        $0.contentMode = .scaleAspectFit
        let width = UIScreen.main.bounds.width // TODO: стоит ли опираться на экран, а не на ячейку?
        $0.heightAnchor.constraint(equalToConstant: 0.40 * width).isActive = true
        $0.widthAnchor.constraint(equalToConstant: 0.40 * width).isActive = true
        return $0
    }(UIImageView())
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        print("🆕 Ячейка СОЗДАНА")
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(_ product: Product) {
        nameLabel.text = product.name
        detailLabel.text = product.detail
        priceButton.setTitle("\(product.price) р", for: .normal)
        productImageView.image = UIImage(named: product.image)
    }
}

extension ProductCell {
    
    struct Layout {
        static let offset = 8
    }
    
    private func setupViews() {
        [containerView].forEach {
            contentView.addSubview($0)
        }
        
        [productImageView, verticalStackView].forEach {
            containerView.addSubview($0)
        }
        
        [nameLabel, detailLabel, priceButton].forEach {
            verticalStackView.addArrangedSubview($0)
        }
    }
    
    private func setupConstraints() {
        containerView.snp.makeConstraints { make in
            make.left.right.equalTo(contentView).inset(16)
            make.top.bottom.equalTo(contentView).inset(8)
        }
        
        productImageView.snp.makeConstraints { make in
            make.left.equalTo(containerView).inset(Layout.offset)
            make.centerY.equalTo(containerView)
            make.top.bottom.greaterThanOrEqualTo(containerView).inset(Layout.offset)
        }
        
        verticalStackView.snp.makeConstraints { make in
            make.top.right.bottom.equalTo(containerView).inset(Layout.offset)
            make.left.equalTo(productImageView.snp.right).offset(Layout.offset)
        }
    }
}
