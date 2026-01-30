//
//  ProductDetailsViewController.swift
//  PizzaHub
//
//  Created by Dmitry Khalitov on 14.11.2025.
//

import UIKit
import SnapKit

final class ProductDetailsViewController: UIViewController {
    
    private let ingredientsService: IIngredientsService
    private let product: Product
    
    init(product: Product, ingredientsService: IIngredientsService = IngredientsService()) {
        self.ingredientsService = ingredientsService
        self.product = product
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var ingredients: [Ingredient] = [] {
        didSet {
            tableView.reloadData()
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
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupViews()
        setupConstraints()
        
        fetchIngredients()
    }
    
    private func fetchIngredients() {
        Task {
            do {
                let fetchedIngredients = try await ingredientsService.fetchIngredients()
                await MainActor.run {
                    ingredients = fetchedIngredients
                }
            }
            catch {
                print(error.localizedDescription)
            }
        }
    }
}

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

enum ProductDetailsViewSection: Int, CaseIterable {
    case productImage
    case productInfo
    case productOptions
    case additionalIngredients
}

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
            return cell
        case .productInfo:
            let cell = tableView.dequeueReusableCell(withIdentifier: ProductInfoContainerCell.reuseId, for: indexPath) as! ProductInfoContainerCell
            return cell
        case .productOptions:
            let cell = tableView.dequeueReusableCell(withIdentifier: ProductOptionsContainerCell.reuseId, for: indexPath) as! ProductOptionsContainerCell
            return cell
        case .additionalIngredients:
            let cell = tableView.dequeueReusableCell(withIdentifier: AdditionalIngredientsContainerCell.reuseId, for: indexPath) as! AdditionalIngredientsContainerCell
            cell.update(ingredients: ingredients)
            return cell
        }
        
    }
}


