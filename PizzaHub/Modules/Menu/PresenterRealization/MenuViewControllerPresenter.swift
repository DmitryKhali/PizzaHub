//
//  MenuViewControllerPresenter.swift
//  PizzaHub
//
//  Created by Dmitry Khalitov on 01.10.2025.
//

import UIKit
import SnapKit

protocol IMenuViewControllerPresenter: AnyObject {
    func updateView()
}

final class MenuViewControllerPresenter: UIViewController {
        
    private let presenter: IMenuPresenter
    
    var stories: [Story] = []
    var banners: [Product] = []
    var categories: [Category] = []
    var products: [Product] = []
    
    init(presenter: IMenuPresenter) {
        self.presenter = presenter
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
        
        presenter.viewDidLoad()
    }
}

//MARK: - TableDelegate
extension MenuViewControllerPresenter: UITableViewDelegate {
    
}

extension MenuViewControllerPresenter: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        MenuSection.allCases.count
    }
    
    //Метод датасорса - возвращаем количество ячеек в таблице в секции
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let menuSection = MenuSection(rawValue: section) else { return 1 }
        
        switch menuSection {
        case .products:
            return presenter.products.count
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
            cell.update(presenter.stories)
            return cell
        case .banners:
            let cell = tableView.dequeueReusableCell(withIdentifier: BannersContainerCell.reuseId, for: indexPath) as! BannersContainerCell
            cell.update(presenter.banners)
            return cell
        case .products:
            let cell = tableView.dequeueReusableCell(withIdentifier: ProductCell.reuseId, for: indexPath) as! ProductCell
            let product = presenter.products[indexPath.row]
            cell.update(product)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        guard let menuSection = MenuSection.init(rawValue: section) else { return nil }
        
        switch menuSection {
        case .products:
            guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: CategoriesContainerHeader.reuseId) as? CategoriesContainerHeader else { return UIView() }
            header.update(presenter.categories)
            return header
        default:
            return EmptyView()
        }
    }
}

//MARK: - Layout
extension MenuViewControllerPresenter {
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

//MARK: - Public methods
extension MenuViewControllerPresenter: IMenuViewControllerPresenter {
    func updateView() {
        tableView.reloadData()
    }
}
