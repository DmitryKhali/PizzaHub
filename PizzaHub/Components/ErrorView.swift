//
//  ErrorView.swift
//  PizzaHub
//
//  Created by Dmitry Khalitov on 21.01.2026.
//

import UIKit
import SnapKit

final class ErrorView: UIView {
    
    var onRetryAction: (() -> ())?
    
    private let stackView: UIStackView = {
        var stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.alignment = .center
        
        return stackView
    }()
    
    private let errorLabel: UILabel = {
        var label = UILabel()
        label.text = "Не удалось загрузить"
        label.font = UIFont.systemFont(ofSize: 18)
        label.textAlignment = .center
        return label
    }()
    
    private let retryButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.title = "Повторить"
        config.titleAlignment = .center
        config.baseForegroundColor = .white
        config.baseBackgroundColor = .orange
        config.cornerStyle = .capsule
        config.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20)
        
        let button = UIButton(configuration: config)
        button.addTarget(nil, action: #selector(retryAction), for: .touchUpInside)
        return button
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
        self.addSubview(stackView)
        stackView.addArrangedSubview(errorLabel)
        stackView.addArrangedSubview(retryButton)
    }
    
    private func setupConstraints() {
        stackView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    @objc private func retryAction() {
        onRetryAction?()
    }
}
