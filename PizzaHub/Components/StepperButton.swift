//
//  StepperButton.swift
//  SampleApp
//
//  Created by Dmitry Khalitov on 17.12.2025.
//

import UIKit
import SnapKit

final class StepperButton: UIControl {
    
    var value: Int = 1 {
        didSet {
            valueLabel.text = String(value)
        }
    }
    
    var minimumValue = 1
    var maximumValue = 99
    var stepValue = 1
    
    private lazy var decrementButton: UIButton = {
        var button = UIButton(type: .system)
        button.setTitle("-", for: .normal)
        button.setTitleColor(.gray, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(decrementButtonTapped), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var incrementButton: UIButton = {
        var button = UIButton(type: .system)
        button.setTitle("+", for: .normal)
        button.setTitleColor(.gray, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(incrementButtonTapped), for: .touchUpInside)
        
        return button
    }()
    
    private let valueLabel: UILabel = {
        var label = UILabel()
        label.text = "1"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .gray
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

extension StepperButton {
    private func setupViews() {
        self.addSubview(decrementButton)
        self.addSubview(valueLabel)
        self.addSubview(incrementButton)
        
        self.layer.cornerRadius = 12
        self.backgroundColor = .gray.withAlphaComponent(0.1)
    }
    
    private func setupConstraints() {
        self.snp.makeConstraints { make in // TODO: так вообще делают?
            make.width.equalTo(95)
            make.height.greaterThanOrEqualTo(28) // TODO: тут он ругался на equalTo(28), хотя у меня логика в голове была такая, что высота кнопки задает высоту контейнера. Нейронка утверждала что размер контейнера спорит с размером кнопки но как если кнопка задает его размер. Какая то дич
        }
        
        decrementButton.snp.makeConstraints { make in
            make.top.left.bottom.equalTo(self)
        }
        
        valueLabel.snp.makeConstraints { make in
            make.center.equalTo(self)
        }
        
        incrementButton.snp.makeConstraints { make in
            make.top.right.bottom.equalTo(self)
        }
    }
}

extension StepperButton {
    @objc private func decrementButtonTapped() {
        let newValue = value - stepValue
        
        if newValue >= minimumValue {
            value = newValue
            sendActions(for: .valueChanged)
        }
    }
    
    @objc private func incrementButtonTapped() {
        let newValue = value + stepValue
        
        if newValue <= maximumValue {
            value = newValue
            sendActions(for: .valueChanged)
        }
    }
}
