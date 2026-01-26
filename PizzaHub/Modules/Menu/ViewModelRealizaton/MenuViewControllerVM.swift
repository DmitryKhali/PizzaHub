//
//  MainScreenViewControllerPresenterVM.swift
//  PizzaHub
//
//  Created by Dmitry Khalitov on 01.10.2025.
//

import UIKit
import SnapKit
import Combine


final class MenuViewControllerVM: UIViewController {
        
    // MARK: Properties
    private let viewModel: MenuViewModel
    private var cancellables = Set<AnyCancellable>()
    
    private var stories: [Story] = []
    private var banners: [Product] = []
    private var categories: [Category] = []
    private var products: [Product] = []
    
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
    
    // MARK: Init
    init(viewModel: MenuViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        bindViewModel()
        
        viewModel.viewDidLoad()
    }
}

//MARK: - TableDelegate
extension MenuViewControllerVM: UITableViewDelegate {
    
}

extension MenuViewControllerVM: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        MenuSection.allCases.count
    }
    
    //Метод датасорса - возвращаем количество ячеек в таблице в секции
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let menuSection = MenuSection(rawValue: section) else { return 1 }
        
        switch menuSection {
        case .products:
            return products.count
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
            cell.update(stories)
            return cell
        case .banners:
            let cell = tableView.dequeueReusableCell(withIdentifier: BannersContainerCell.reuseId, for: indexPath) as! BannersContainerCell
            cell.update(banners)
            return cell
        case .products:
            let cell = tableView.dequeueReusableCell(withIdentifier: ProductCell.reuseId, for: indexPath) as! ProductCell
            let product = products[indexPath.row]
            cell.update(product)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        guard let menuSection = MenuSection.init(rawValue: section) else { return nil }
        
        switch menuSection {
        case .products:
            guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: CategoriesContainerHeader.reuseId) as? CategoriesContainerHeader else { return UIView() }
            header.update(categories)
            return header
        default:
            return EmptyView()
        }
    }
}

//MARK: - Layout
extension MenuViewControllerVM {
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

//MARK: - Private methods
extension MenuViewControllerVM {
    func bindViewModel() {
        viewModel.$stories
            .receive(on: DispatchQueue.main)
            .sink { [weak self] stories in
                self?.stories = stories
                self?.reloadSection(.stories)
            }
            .store(in: &cancellables)
        
        viewModel.$banners
            .receive(on: DispatchQueue.main)
            .sink { [weak self] banners in
                self?.banners = banners
                self?.reloadSection(.banners)
            }
            .store(in: &cancellables)
        
        viewModel.$categories
            .receive(on: DispatchQueue.main)
            .sink { [weak self] categories in
                self?.categories = categories
                self?.updateCategoriesHeader()
            }
            .store(in: &cancellables)
        
        viewModel.$products
            .receive(on: DispatchQueue.main)
            .sink { [weak self] products in
                self?.products = products
                self?.reloadSection(.products)
            }
            .store(in: &cancellables)
    }
    
    private func reloadSection(_ section: MenuSection) {
        tableView.reloadSections(IndexSet(integer: section.rawValue), with: .automatic)
    }
    
    private func updateCategoriesHeader() {
        guard let header = tableView.headerView(forSection: MenuSection.products.rawValue) as? CategoriesContainerHeader else { return }
        header.update(categories)
    }
}
