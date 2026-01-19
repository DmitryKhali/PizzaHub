//
//  CartProductCell.swift
//  PizzaHub
//
//  Created by Dmitry Khalitov on 06.12.2025.
//

import UIKit
import SnapKit

final class CartProductCell: UITableViewCell {
        
    static let reuseId = "CartProductCell"
    
    private let containerView: UIView = {
        var view = UIView()
        return view
    }()
    
    private let productImage: UIImageView = {
        var image = UIImageView()
        image.image = UIImage(named: "margarita")
        image.contentMode = .scaleAspectFill
        
        image.heightAnchor.constraint(equalToConstant: 90).isActive = true
        image.widthAnchor.constraint(equalToConstant: 90).isActive = true
        return image
    }()
    
    private let verticalStackView: UIStackView = {
        var stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 15
        stackView.alignment = .leading
        
        stackView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 14, leading: 14, bottom: 0, trailing: 12)
        stackView.isLayoutMarginsRelativeArrangement = true
        
        return stackView
    }()
    
    private let productName: UILabel = {
        var label = UILabel()
        label.text = "Деревенская с Бужениной"
        label.font = UIFont.systemFont(ofSize: 18, weight: .heavy)
        
        return label
    }()
    
    private let productIngredients: UILabel = {
        var label = UILabel()
        label.text = "Тесто, Сыр, Буженина"
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 0
        
        return label
    }()
    
    private let productOptions: UILabel = {
        var label = UILabel()
        label.text = "Средняя 30 см, традиционное тесто"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .lightGray
        label.numberOfLines = 0
        
        return label
    }()
    
    private let bottomContainerView: UIView = {
        let view = UIView()
        return view
    }()
    
    private let priceLabel = {
        var label = UILabel()
        label.text = "500 ₽"
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        
        return label
    }()
    
    private let changeProductButton: UIButton = {
        var button = UIButton(type: .system)
        button.setTitle("Изменить", for: .normal)
        button.setTitleColor(.orange, for: .normal)
        button.backgroundColor = .clear
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        return button
    }()
    
    private let changeCountButton: StepperButton = {
        var stepper = StepperButton()
        stepper.minimumValue = 1
        stepper.maximumValue = 99
        stepper.stepValue = 1
        stepper.value = 1
        
        return stepper
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        contentView.addSubview(containerView)
        
        containerView.addSubview(productImage)
        containerView.addSubview(verticalStackView)
        containerView.addSubview(bottomContainerView)
        
        verticalStackView.addArrangedSubview(productName)
        verticalStackView.addArrangedSubview(productIngredients)
        verticalStackView.addArrangedSubview(productOptions)
        
        verticalStackView.setCustomSpacing(12, after: productName)
        verticalStackView.setCustomSpacing(1, after: productIngredients)
        
        bottomContainerView.addSubview(priceLabel)
        bottomContainerView.addSubview(changeProductButton)
        bottomContainerView.addSubview(changeCountButton)
    }
    
    private func setupConstraints() {
        containerView.snp.makeConstraints { make in
            make.top.equalTo(contentView).inset(20)
            make.bottom.equalTo(contentView).inset(12)
            make.left.right.equalTo(contentView)
        }
        
        productImage.snp.makeConstraints { make in
            make.top.equalTo(containerView)
            make.left.equalTo(containerView).inset(20)
        }
        verticalStackView.snp.makeConstraints { make in
            make.top.equalTo(containerView)
            make.left.equalTo(productImage.snp.right)
            make.right.equalTo(containerView)
        }
        bottomContainerView.snp.makeConstraints { make in
            make.top.equalTo(productImage.snp.bottom).offset(30)
            make.left.right.equalTo(containerView).inset(20)
            make.bottom.equalTo(containerView)
        }
        
        priceLabel.snp.makeConstraints { make in
            make.centerY.equalTo(bottomContainerView.snp.centerY)
            make.left.equalTo(bottomContainerView.snp.left)
        }
        changeProductButton.snp.makeConstraints { make in
            make.centerY.equalTo(bottomContainerView.snp.centerY)
            make.right.equalTo(changeCountButton.snp.left).offset(-12)
        }
        changeCountButton.snp.makeConstraints { make in
            make.top.right.bottom.equalTo(bottomContainerView)
        }
    }
}

/*
TODO: Вопросы:
 - в ячейке не используем safeAreaLayoutGuide?
 - нейронка сказала: плохо применять NSLayoutConstraint + SnapKit. Она врет?
 - я сомневаюсь как правильно организовать констрейнты. Текущая огика кажется простой / понятной для меня, но не факт что это best practice, нужно обстучать чтобы сформировать более широкое представление
 - все таки отступы настраивать лучше внутри stackView или снаружи его? я настроил внутри, но хз как best practice
 */
