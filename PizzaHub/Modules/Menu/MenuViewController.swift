//
//  MenuViewController.swift
//  PizzaHub
//
//  Created by Dmitry Khalitov on 01.10.2025.
//

import UIKit
import SnapKit

final class MenuViewController: UIViewController {
    
//    private let storiesService: IStoriesService
//    private let bannersService: IBannersService
//    private let categoriesService: ICategoriesService
//    private let productsService: IProductsService
//    private let productsArchiver: ICartService
//    
//    init(
//        storiesService: IStoriesService,
//        bannersService: IBannersService,
//        categoriesService: ICategoriesService,
//        productsService: IProductsService,
//        productsArchiver: ICartService
//    ) {
//        self.storiesService = storiesService
//        self.bannersService = bannersService
//        self.categoriesService = categoriesService
//        self.productsService = productsService
//        self.productsArchiver = productsArchiver
//        
//        super.init(nibName: nil, bundle: nil)
//    }
    
    private let provider: MenuProvider
    
    init(provider: MenuProvider) {
        self.provider = provider
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
//    private var stories: [Story] = []
//    private var banners: [Banner] = []
//    private var categories: [Category] = []
//    private var products: [Product] = []
        
    //Создали UI-элемент таблицы
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
        
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }
        
        tableView.register(StoriesContainerCell.self, forCellReuseIdentifier: StoriesContainerCell.reuseId)
        tableView.register(BannersContainerCell.self, forCellReuseIdentifier: BannersContainerCell.reuseId)
        tableView.register(CategoriesContainerHeader.self, forHeaderFooterViewReuseIdentifier: CategoriesContainerHeader.reuseId)
        tableView.register(ProductCell.self, forCellReuseIdentifier: ProductCell.reuseId)
        
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        
//        fetchStories()
//        fetchBanners()
//        fetchCategories()
//        fetchProducts()
        
        loadData()
    }
}

//MARK: - Business Logic
private extension MenuViewController {
    
    private func loadData() {
        provider.loadData { result in
            switch result {
            case .success(let success):
                self.tableView.reloadData()
            case .failure(let failure):
                print(failure.localizedDescription)
            }
        }
    }
    
//    func fetchStories() {
//        storiesService.fetchStories { [weak self] result in
//            guard let self else { return }
//            switch result {
//            case .success(let stories):
//                self.stories = stories
//            case .failure(let error):
//                print(error)
//            }
//        }
//    }
//    
//    func fetchBanners() {
//        bannersService.fetchBanners { [weak self] result in
//            guard let self else { return }
//            switch result {
//            case .success(let banners):
//                self.banners = banners
//            case .failure(let error):
//                print(error)
//            }
//        }
//    }
//    
//    func fetchCategories() {
//        categoriesService.fetchCategories { [weak self] result in
//            guard let self else { return }
//            switch result {
//            case .success(let categories):
//                self.categories = categories
//            case .failure(let error):
//                print(error)
//            }
//        }
//    }
//    
//    func fetchProducts() {
//        productsService.fetchProducts { [weak self] result in
//            guard let self else { return }
//            switch result {
//            case .success(let products):
//                self.products = products
//            case .failure(let error):
//                print(error)
//            }
//        }
//    }
    
}

//MARK: - TableDelegate
extension MenuViewController: UITableViewDelegate {
    
}

//MARK: - TableDataSource
enum MenuSection: Int, CaseIterable {
    case stories
    case banners
    case products
}

extension MenuViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        MenuSection.allCases.count
    }
    
    //Метод датасорса - возвращаем количество ячеек в таблице в секции
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let menuSection = MenuSection(rawValue: section) else { return 1 }
        
        switch menuSection {
        case .products:
            return provider.products.count ?? 0
        default:
            return 1
        }
    }
    
    //Метод датасораса - возвращаем конкретную ячейку
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let menuSection = MenuSection(rawValue: indexPath.section) else { return UITableViewCell() }
        
        switch menuSection {
        case .stories:
            let cell = tableView.dequeueReusableCell(withIdentifier: StoriesContainerCell.reuseId, for: indexPath) as! StoriesContainerCell
            cell.update(provider.stories)
            return cell
        case .banners:
            let cell = tableView.dequeueReusableCell(withIdentifier: BannersContainerCell.reuseId, for: indexPath) as! BannersContainerCell
            cell.update(provider.banners)
            return cell
        case .products:
            let cell = tableView.dequeueReusableCell(withIdentifier: ProductCell.reuseId, for: indexPath) as! ProductCell
            let product = provider.products[indexPath.row]
            cell.update(product)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        guard let menuSection = MenuSection.init(rawValue: section) else { return nil }
        
        switch menuSection {
        case .products:
            guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: CategoriesContainerHeader.reuseId) as? CategoriesContainerHeader else { return UIView() }
            header.update(provider.categories)
            return header
        default:
            return EmptyView()
        }
    }
}

//MARK: - Layout
extension MenuViewController {
    //Для установки UI элементов на корневую вью контроллера
    private func setupViews() {
        view.addSubview(tableView)
    }
    
    //Для установки констрэйнтов (креплений) для позиционирования элементов на вью
    private func setupConstraints() {
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
}
