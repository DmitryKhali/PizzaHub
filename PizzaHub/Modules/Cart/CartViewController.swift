//
//  CartViewController.swift
//  PizzaHub
//
//  Created by Dmitry Khalitov on 06.12.2025.
//

import UIKit
import SnapKit

final class CartViewController: UIViewController {
    
    private let topLabel: UILabel = {
        var label = UILabel()
        label.text = "6 товаров на сумму 3500 ₽"
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        
        return label
    }()
    
    private lazy var tableView: UITableView = {
        var tableView = UITableView()
        tableView.backgroundColor = .white
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(CartProductCell.self, forCellReuseIdentifier: CartProductCell.reuseId)
        
        return tableView
    }()
    
    private let orderButton: UIButton = {
        
        var config = UIButton.Configuration.filled()
        
        config.baseBackgroundColor = .orange
        config.cornerStyle = .capsule
        config.contentInsets = .init(top: 12, leading: 20, bottom: 12, trailing: 20)
        
        config.attributedTitle = AttributedString(
            "Оформить заказ на 3500 ₽",
            attributes: AttributeContainer([
                .font: UIFont.systemFont(ofSize: 16, weight: .bold)
            ])
        )
        
        let button = UIButton(configuration: config)

        // TODO: обсудить, нейронка сказала что это устарело безбожно и надо использовать конфигурирование
//        var button = UIButton()
//        button.setTitle("Оформить заказ на 3500 ₽", for: .normal)
//        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
//        button.setTitleColor(.white, for: .normal)
//        button.backgroundColor = .orange
//        button.widthAnchor.constraint(equalToConstant: 90).isActive = true // TODO: разобраться с кейсом когда задаем и размер и контреинты (кто в итоге управляет размером?)
//        button.heightAnchor.constraint(equalToConstant: 40).isActive = true
//        button.layer.cornerRadius = 20
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupViews()
        setupConstaints()
    }
    
    private func setupViews() {
        view.addSubview(topLabel)
        view.addSubview(tableView)
        view.addSubview(orderButton)
    }
    
    private func setupConstaints() {
        topLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(20)
            make.left.right.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(topLabel.snp.bottom).offset(20)
            make.left.right.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(orderButton.snp.top).offset(-15)
        }
        
        orderButton.snp.makeConstraints { make in
            make.left.right.bottom.equalTo(view.safeAreaLayoutGuide).inset(15)
        }
    }
    
}

extension CartViewController: UITableViewDelegate { }

extension CartViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CartProductCell.reuseId, for: indexPath) as? CartProductCell else { return UITableViewCell() }
        return cell
    }
}
