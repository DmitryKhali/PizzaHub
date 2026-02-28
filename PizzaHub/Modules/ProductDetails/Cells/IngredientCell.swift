//
//  IngredientCell.swift
//  PizzaHub
//
//  Created by Dmitry Khalitov on 18.02.2026.
//

import UIKit
import SnapKit

final class IngredientCell: UICollectionViewCell {
    
    static let reuseId = "IngredientCell"
    
//    var onIngredientIsRequiredToggle: ((Int) -> Void)?
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 0
        stackView.alignment = .leading
//        stackView.backgroundColor = .blue
        
        return stackView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
//        label.backgroundColor = .brown
        return label
    }()
    
    private let toggleButton: UIButton = {
        let button = UIButton()
//        button.setImage(UIImage(systemName: "xmark.circle"), for: .normal)
        button.tintColor = .lightGray
        button.isUserInteractionEnabled = true
        return button
    }()
    
    let comaLabel: UILabel = {
        let label = UILabel()
        label.text = ","
//        label.backgroundColor = .orange
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
        setupConstraints()
//        self.backgroundColor = .systemPink
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - Layout
extension IngredientCell {
    private func setupViews() {
        contentView.addSubview(stackView)
        stackView.addArrangedSubview(nameLabel)
        stackView.addArrangedSubview(toggleButton)
        stackView.addArrangedSubview(comaLabel)
    }
    
    private func setupConstraints() {
        stackView.snp.makeConstraints { make in
            make.edges.equalTo(contentView)
            make.height.equalTo(23)
        }
    }
}

//// MARK: - Private
//extension IngredientCell {
//    @objc private func toggleTapped() {
//        onOptionalIngredientTapped?()
//    }
//}

// MARK: - Public
extension IngredientCell {
    func update(with ingredient: Ingredient, isLastCell: Bool = false) {
        nameLabel.text = ingredient.name
        
        if let required = ingredient.required, required {
            toggleButton.isHidden = true
        }
        else {
            if let isIncluded = ingredient.isIncluded, isIncluded {
                toggleButton.setImage(UIImage(systemName: "xmark.circle"), for: .normal)
            }
            else {
                toggleButton.setImage(UIImage(systemName: "plus.circle"), for: .normal)
                nameLabel.textColor = .lightGray
                let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: nameLabel.text ?? "")
                attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: NSUnderlineStyle.single.rawValue, range: NSMakeRange(0, attributeString.length))

                nameLabel.attributedText = attributeString
            }
        }
        
        comaLabel.isHidden = isLastCell
    }
}
