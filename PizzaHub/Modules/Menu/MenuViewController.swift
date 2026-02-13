//
//  MenuViewController.swift
//  PizzaHub
//
//  Created by Dmitry Khalitov on 01.10.2025.
//

import UIKit
import SnapKit
import Combine

enum MenuSection: Int, CaseIterable {
    case stories
    case banners
    case products
}

final class MenuViewController: UIViewController {
        
    private let viewModel: MenuViewModel
    private let router: IAppRouter
    private var cancellables = Set<AnyCancellable>()
            
    private var isProgrammaticScroll = false
    private var selectedCategoryId: String?
    
    init(viewModel: MenuViewModel, router: IAppRouter) {
        self.viewModel = viewModel
        self.router = router
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
                
    private let showMapButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.title = "Укажите адрес доставки"
        config.titleAlignment = .leading
        config.baseForegroundColor = .black
        
        if let basket = UIImage(named: "delivery_bike") {
            config.image = basket.resized(to: CGSize(width: 24, height: 24))
        }
        
        config.imagePlacement = .leading
        config.imagePadding = 10
        config.contentInsets = .init(top: 12, leading: 20, bottom: 12, trailing: 20)

        let button = UIButton(configuration: config)
        return button
    }()
    
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
    
    private let loadingView: UIActivityIndicatorView = {
        var indicator = UIActivityIndicatorView(style: .large)
        indicator.hidesWhenStopped = true
        indicator.color = .gray
        return indicator
    }()
    
    private lazy var errorView: ErrorView = {
        var errorView = ErrorView()
        errorView.onRetryAction = { [weak self] in
            guard let self else { return }
            self.viewModel.fetchData()
        }
        
        return errorView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        setupBindings()
                
        viewModel.fetchData()
    }
}

// MARK: - UI state
extension MenuViewController {
    private func render(_ state: MenuViewState) {
        switch state {
        case .initial, .loading:
            loadingView.startAnimating()
            errorView.isHidden = true
            tableView.isHidden = true
        case .loaded:
            loadingView.stopAnimating()
            errorView.isHidden = true
            tableView.isHidden = false
        case .error:
            loadingView.stopAnimating()
            errorView.isHidden = false
            tableView.isHidden = true
        }
    }
    
    private func reloadData() {
        tableView.reloadData()
    }
}

//MARK: - Table Delegate
extension MenuViewController: UITableViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print("scrollViewDidScroll start")
        guard !isProgrammaticScroll,
            let firstCategory = getActiveCategoryIdFromVisibleCells(),
              selectedCategoryId != firstCategory else { return }
        
        selectedCategoryId = firstCategory
        
        updateHeaderForSelectedCategory()
        print("scrollViewDidScroll end")
    }
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
            return viewModel.products.count
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
            cell.selectionStyle = .none
            cell.onStoryTapped = { [weak self] story, storyIndex in
                guard let self else { return }
                self.router.showStory(stories: viewModel.stories, selectedStoryIndex: storyIndex, sourceVC: self)
            }
            cell.update(viewModel.stories)
            return cell
        case .banners:
            let cell = tableView.dequeueReusableCell(withIdentifier: BannersContainerCell.reuseId, for: indexPath) as! BannersContainerCell
            cell.selectionStyle = .none
            cell.onBannerTapped = { [weak self] banner in
                guard let self else { return }
                self.router.showProductDetails(banner, sourceVC: self)
            }
            cell.update(viewModel.banners)
            return cell
        case .products:
            let cell = tableView.dequeueReusableCell(withIdentifier: ProductCell.reuseId, for: indexPath) as! ProductCell
            let product = viewModel.products[indexPath.row]
            cell.selectionStyle = .none
            cell.update(product)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        guard let menuSection = MenuSection.init(rawValue: section) else { return nil }
        
        switch menuSection {
        case .products:
            guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: CategoriesContainerHeader.reuseId) as? CategoriesContainerHeader else { return UIView() }
            header.onCategorySelected = { [weak self] categoryId in
                guard let self else { return }
                self.onCategoryTapped(category: categoryId)
            }
            header.update(viewModel.categories, selectedCategoryId: selectedCategoryId)
            return header
        default:
            return EmptyView()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let menuSection = MenuSection(rawValue: indexPath.section), menuSection == .products else { return }
        
        let product = viewModel.products[indexPath.row]
        router.showProductDetails(product, sourceVC: self)
    }
    
}

extension MenuViewController {
    private func onCategoryTapped(category: String) {
        print("📱 Пользователь тапнул на категорию: \(category)")
        isProgrammaticScroll = true
        guard let indexPath = findFirstProductIndexPath(for: category) else {
            return
        }
        
        print("🔄 Начинаем программный скролл к категории")
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            print("animate START")
            self?.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
        }, completion: { [weak self] _ in
            print("animate END")
            self?.isProgrammaticScroll = false
        })
    }
    
    private func findFirstProductIndexPath(for categoryId: String) -> IndexPath? {
        guard let firstIndex = viewModel.products.firstIndex (where: { $0.category == categoryId }) else {
            return nil
        }
        return IndexPath(row: firstIndex, section: MenuSection.products.rawValue)
    }
    
    private func updateHeaderForSelectedCategory() {
        guard let header = tableView.headerView(forSection: MenuSection.products.rawValue) as? CategoriesContainerHeader else {
            return
        }
        header.update(viewModel.categories, selectedCategoryId: selectedCategoryId)
    }
    
    private func getActiveCategoryIdFromVisibleCells() -> String? {
        let headerRect = tableView.rectForHeader(inSection: MenuSection.products.rawValue)
        
        let visibleRect = CGRect(
            x: tableView.contentOffset.x,
            y: tableView.contentOffset.y + headerRect.height + 5,
            width: tableView.bounds.width,
            height: tableView.bounds.height - headerRect.height + 5
        )
        
        let visibleIndexPaths = tableView.indexPathsForRows(in: visibleRect) ?? []
        guard let firstIndexPath = visibleIndexPaths.first else { return nil }
        
        return viewModel.products[firstIndexPath.row].category
    }
}

//MARK: - Setup
extension MenuViewController {
    //Для установки UI элементов на корневую вью контроллера
    private func setupViews() {
        view.addSubview(tableView)
        view.addSubview(loadingView)
        view.addSubview(errorView)
        view.addSubview(showMapButton)
    }
    
    //Для установки констрэйнтов (креплений) для позиционирования элементов на вью
    private func setupConstraints() {
        showMapButton.snp.makeConstraints { make in
            make.top.left.equalTo(view.safeAreaLayoutGuide)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(showMapButton.snp.bottom)
            make.left.right.bottom.equalTo(view)
        }
        loadingView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        errorView.snp.makeConstraints { make in
            make.edges.equalTo(view)
        }
    }
    
    private func setupBindings() {
        viewModel.$state
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                guard let self else { return }
                self.render(state)
                self.reloadData()
            }
            .store(in: &cancellables)
    }
}
