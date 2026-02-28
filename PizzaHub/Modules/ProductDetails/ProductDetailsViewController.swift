//
//  ProductDetailsViewController.swift
//  PizzaHub
//
//  Created by Dmitry Khalitov on 14.11.2025.
//

import UIKit
import SnapKit

enum ProductDetailsViewSection: Int, CaseIterable {
    case productImage
    case productInfo
    case productOptions
    case additionalIngredients
}

final class ProductDetailsViewController: UIViewController {
    
    private let mode: ProductDetailsMode
    
    var onProductUpdated: ((Product) -> Void)?
    
    private let ingredientsService: IIngredientsService
    private let cartService: ICartService
    private var product: Product {
        didSet {
            updatePriceButton()
        }
    }
    
    private var additionalIngredients: [Ingredient] = [] {
        didSet {
            tableView.reloadData() // TODO: переделать на обновление секции
        }
    }
    
    private lazy var tableView: UITableView = {
        var tableView = UITableView()
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
//        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(ProductImageContainerCell.self, forCellReuseIdentifier: ProductImageContainerCell.reuseId)
        tableView.register(ProductInfoContainerCell.self, forCellReuseIdentifier: ProductInfoContainerCell.reuseId)
        tableView.register(ProductOptionsContainerCell.self, forCellReuseIdentifier: ProductOptionsContainerCell.reuseId)
        tableView.register(AdditionalIngredientsContainerCell.self, forCellReuseIdentifier: AdditionalIngredientsContainerCell.reuseId)
        
        return tableView
    }()
    
    private let addToCartButton: UIButton = {
        var config = UIButton.Configuration.filled()
        
        config.baseBackgroundColor = .orange
        config.cornerStyle = .capsule
        config.contentInsets = .init(top: 12, leading: 20, bottom: 12, trailing: 20)
        
        config.attributedTitle = AttributedString(
            "В корзину за 539 ₽",
            attributes: AttributeContainer([
                .font: UIFont.systemFont(ofSize: 16, weight: .bold)
            ])
        )
        
        let button = UIButton(configuration: config)
        button.addTarget(nil, action: #selector(addToCartTapped), for: .touchUpInside)
        return button
    }()
    
    init(product: Product, ingredientsService: IIngredientsService, cartService: ICartService, mode: ProductDetailsMode = .add) {
        self.mode = mode
        self.ingredientsService = ingredientsService
        self.cartService = cartService
        self.product = product
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupViews()
        setupConstraints()
        
        updatePriceButton()
        fetchIngredients()
    }
}

// MARK: - Setup
extension ProductDetailsViewController {
    private func setupViews() {
        view.addSubview(tableView)
        view.addSubview(addToCartButton)
    }
    
    private func setupConstraints() {
        tableView.snp.makeConstraints { make in
            make.top.left.right.equalTo(view.safeAreaLayoutGuide)
        }
        addToCartButton.snp.makeConstraints { make in
            make.top.equalTo(tableView.snp.bottom).offset(15)
            make.left.right.bottom.equalTo(view.safeAreaLayoutGuide).inset(15)
        }
    }
}

// MARK: - TableDelegate
extension ProductDetailsViewController: UITableViewDelegate {
    
}

extension ProductDetailsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        ProductDetailsViewSection.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let menuSection = ProductDetailsViewSection(rawValue: section) else { return 1 }
        
        switch menuSection {
        default:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let menuSection = ProductDetailsViewSection(rawValue: indexPath.section) else { return UITableViewCell() }
        
        switch menuSection {
        case .productImage:
            let cell = tableView.dequeueReusableCell(withIdentifier: ProductImageContainerCell.reuseId, for: indexPath) as! ProductImageContainerCell
            cell.selectionStyle = .none
            cell.update(with: product)
            return cell
        case .productInfo:
            let cell = tableView.dequeueReusableCell(withIdentifier: ProductInfoContainerCell.reuseId, for: indexPath) as! ProductInfoContainerCell
            cell.selectionStyle = .none
            cell.update(with: product)
            cell.onIngredientIsRequiredToggle = { [weak self] baseIngredientIndex in
                guard let self, let baseIngredients = self.product.baseIngredients else { return }
                let ingredient = baseIngredients[baseIngredientIndex]
                guard ingredient.required != true else { return }
                self.updateProduct(withBaseIngredient: baseIngredientIndex)
            }
            return cell
        case .productOptions:
            let cell = tableView.dequeueReusableCell(withIdentifier: ProductOptionsContainerCell.reuseId, for: indexPath) as! ProductOptionsContainerCell
            cell.selectionStyle = .none
            cell.update(with: product)
            cell.onSizeChanged = { [weak self] newSize in
                guard let self else { return }
                self.updateProduct(with: newSize)
            }
            cell.onDoughChanged = { [weak self] newDough in
                guard let self else { return }
                self.updateProduct(with: newDough)
            }
            return cell
        case .additionalIngredients:
            let cell = tableView.dequeueReusableCell(withIdentifier: AdditionalIngredientsContainerCell.reuseId, for: indexPath) as! AdditionalIngredientsContainerCell
            cell.selectionStyle = .none
            cell.update(ingredients: additionalIngredients, selectedIds: product.selectedAdditionalIngredientsIds)
            cell.onIngredientSelect = { [weak self] index in
                guard let self else { return }
                self.updateProduct(withAdditionalIngredient: index)
            }
            return cell
        }
        
    }
}

// MARK: - Private
extension ProductDetailsViewController {
    private func fetchIngredients() {
        Task {
            do {
                let fetchedIngredients = try await ingredientsService.fetchIngredients()
                await MainActor.run {
                    additionalIngredients = fetchedIngredients
                }
            }
            catch {
                print(error.localizedDescription)
            }
        }
    }
    
    private func reloadData() {
        tableView.reloadData()
    }
    
    private func updatePriceButton() {
        addToCartButton.updateAddToCartButton(totalPrice: product.totalPrice)
    }
    
    private func update(section: Int) {
        tableView.reloadSections([section], with: .none)
    }
    
    private func updateProduct(with newSize: PizzaSize) {
        product = product.changeSize(newSize)
        update(section: ProductDetailsViewSection.productInfo.rawValue)
    }
    private func updateProduct(with newDough: PizzaDough) {
        product = product.changeDough(newDough)
        update(section: ProductDetailsViewSection.productInfo.rawValue)
    }
    private func updateProduct(withBaseIngredient index: Int) {
        guard let baseIngredients = product.baseIngredients else { return }
        
        let updatedIngredient = baseIngredients[index].withIncludedToggled()
        var updatedBaseIngredients = baseIngredients
        updatedBaseIngredients[index] = updatedIngredient
        
        product = product.changeBaseIngredients(with: updatedBaseIngredients)
        
        // Обновляет всю секцию целиком. Это включает в себя: Все ячейки внутри секции. Header (заголовок) секции. Footer (подвал) секции.
        // update(section: ProductDetailsViewSection.productInfo.rawValue)
        
        // reloadRows: Обновляет только конкретную ячейку (или список ячеек). Все остальные ячейки в этой секции не затрагиваются.
        let indexPath = IndexPath(row: 0, section: ProductDetailsViewSection.productInfo.rawValue)
        UIView.performWithoutAnimation {
            tableView.reloadRows(at: [indexPath], with: .none)
        }
    }
    
    private func updateProduct(withAdditionalIngredient index: Int) {
        let ingredient = additionalIngredients[index]
        var actualIngredients: [Ingredient] = product.additionalIngredients ?? []
        
        if let currentIndex = actualIngredients.firstIndex(where: { $0 == ingredient }) {
            actualIngredients.remove(at: currentIndex)
        }
        else {
            actualIngredients.append(ingredient)
        }
        
        product = product.updateAdditionalIngredients(with: actualIngredients)
        
        // Обновляет всю секцию целиком. Это включает в себя: Все ячейки внутри секции. Header (заголовок) секции. Footer (подвал) секции.
        update(section: ProductDetailsViewSection.additionalIngredients.rawValue)
        
        // reloadRows: Обновляет только конкретную ячейку (или список ячеек). Все остальные ячейки в этой секции не затрагиваются.
//        let indexPath = IndexPath(row: index, section: ProductDetailsViewSection.additionalIngredients.rawValue)
//        tableView.reloadRows(at: [indexPath], with: .none)
    }
    
    @objc private func addToCartTapped() {
        addToCartButton.isEnabled = false
        
        switch mode {
        case .add:
            cartService.addToCart(product)
        case .edit:
            onProductUpdated?(product)
        }
        
        dismiss(animated: true)
    }
}
