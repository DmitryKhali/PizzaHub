//
//  CartViewController.swift
//  PizzaHub
//
//  Created by Dmitry Khalitov on 06.12.2025.
//

import UIKit
import SnapKit

final class CartViewController: UIViewController {
    
    private let cartService: ICartService
    private let router: IAppRouter
    
    private var cartItems: [Product] = [] {
        didSet {
            updateTotals()
        }
    }
    
    private let headerLabel: UILabel = {
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
//        fetchCartItems()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchCartItems()
        reloadData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(cartService: ICartService, router: IAppRouter) {
        self.cartService = cartService
        self.router = router
        super.init(nibName: nil, bundle: nil)
    }
}

extension CartViewController: UITableViewDelegate { }

extension CartViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cartItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CartProductCell.reuseId, for: indexPath) as? CartProductCell else { return UITableViewCell() }
        
        cell.selectionStyle = .none
        cell.setup(with: cartItems[indexPath.row])
        cell.onQuantityChanged = { [weak self] product, newQuantity in
            guard let self else { return }
            self.updateQuantity(for: product, with: newQuantity)
            self.fetchCartItems()
            self.updateRaw(row: indexPath.row)
        }
        cell.onChangeTapped = { [weak self] in
            guard let self else { return }
            self.router.showDetailProductScreen(cartItems[indexPath.row], sourceVC: self, mode: .edit, onProductUpdated: { [weak self] updatedProduct in
                guard let self else { return }
                self.updateProductInCart(with: cartItems[indexPath.row], updatedProduct: updatedProduct)
                self.fetchCartItems()
                self.reloadData()
            })
        }
        return cell
    }
}

// MARK: - Layout
extension CartViewController {
    private func setupViews() {
        view.addSubview(headerLabel)
        view.addSubview(tableView)
        view.addSubview(orderButton)
    }
    
    private func setupConstaints() {
        headerLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(20)
            make.left.right.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(headerLabel.snp.bottom).offset(20)
            make.left.right.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(orderButton.snp.top).offset(-15)
        }
        
        orderButton.snp.makeConstraints { make in
            make.left.right.bottom.equalTo(view.safeAreaLayoutGuide).inset(15)
        }
    }
}

// MARK: - private
extension CartViewController {
    private func fetchCartItems() {
        cartItems = cartService.getCartItems()
    }
    
    private func reloadData() {
        tableView.reloadData()
    }
    
    private func updateQuantity(for product: Product?, with newQuantity: Int) {
        guard let product = product else { return }
        cartService.updateQuantity(for: product, with: newQuantity)
    }
    
    private func updateRaw(row: Int) {
        let indexPath = IndexPath(row: row, section: 0)
        tableView.reloadRows(at: [indexPath], with: .none)
    }
    
    private func fetchCartItemsQuantity() -> Int {
        cartItems.count
    }
    
    private func updateTotals() {
        let totalItemsCount = cartService.getTotalItemsCount()
        let totalPrice = cartService.getTotalPrice()
        
        let itemsFormatted = String(localized: "item_count \(totalItemsCount)")
        let rublesFormatted = String(localized: "ruble_count \(totalPrice)")
        
        let headerFormat = String(localized: "cart_header")
        headerLabel.text = String(format: headerFormat, itemsFormatted, rublesFormatted)
        
        orderButton.updateOrderButton(totalPrice: totalPrice)
    }
    
    private func updateProductInCart(with baseProduct: Product, updatedProduct: Product) {
        cartService.updateProductInCart(with: baseProduct, updatedProduct: updatedProduct)
    }
}
