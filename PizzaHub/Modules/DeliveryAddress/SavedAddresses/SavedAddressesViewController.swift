//
//  SavedAddressesViewController.swift
//  PizzaHub
//
//  Created by Dmitry Khalitov on 14.02.2026.
//

import UIKit
import SnapKit

final class SavedAddressesViewController: UIViewController {
    
    private let moscowAddresses = [
        "ул. Тверская, д. 12",
        "проспект Мира, д. 45, корп. 2",
        "ул. Арбат, д. 23",
        "Ленинский проспект, д. 67",
        "Новинский бульвар, д. 8, стр. 1",
        "ул. Большая Дмитровка, д. 34",
        "Садовническая наб., д. 56",
        "ул. Профсоюзная, д. 123А",
        "Ярославское шоссе, д. 15, корп. 3",
        "ул. Новый Арбат, д. 21"
    ]
    
    private var selectedAddress: String? = nil
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(SavedAddressesCell.self, forCellReuseIdentifier: SavedAddressesCell.reuseId)
        
        return tableView
    }()
    
    private let emptyListLabel: UILabel = {
        var label = UILabel()
        label.text = "Добавьте адрея доставки"
        label.font = UIFont.systemFont(ofSize: 18)
        label.textAlignment = .center
        return label
    }()
    
    private let bottomContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        
        return view
    }()
    
    private let addAddressButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = .orange
        config.cornerStyle = .capsule
        config.contentInsets = .init(top: 12, leading: 20, bottom: 12, trailing: 20)
        
        config.attributedTitle = AttributedString(
            "Добавить адрес +",
            attributes: AttributeContainer([
                .font: UIFont.systemFont(ofSize: 16, weight: .bold)
            ])
        )
        
        let button = UIButton(configuration: config)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        setupConstraints()
    }
}

// MARK: - setup
extension SavedAddressesViewController {
    private func setupViews() {
        view.addSubview(tableView)
        view.addSubview(bottomContainerView)
        view.addSubview(emptyListLabel)
        
        bottomContainerView.addSubview(addAddressButton)
    }
    
    private func setupConstraints() {
        tableView.snp.makeConstraints { make in
            make.top.left.right.equalTo(view)
        }
        
        bottomContainerView.snp.makeConstraints { make in
            make.left.bottom.right.equalTo(view)
            make.top.equalTo(tableView.snp.bottom)
            make.height.equalTo(100)
        }
        
        addAddressButton.snp.makeConstraints { make in
            make.top.left.right.equalTo(bottomContainerView).inset(15)
            make.bottom.equalTo(bottomContainerView).inset(40)
        }
    }
}

// MARK: TableViewDelegate
extension SavedAddressesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("selectedAddress = \(selectedAddress ?? "nil")")
        selectedAddress = moscowAddresses[indexPath.row]
        print("NEWselectedAddress = \(selectedAddress ?? "nil")")
        tableView.reloadData()
    }
}

extension SavedAddressesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        moscowAddresses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SavedAddressesCell.reuseId, for: indexPath) as? SavedAddressesCell else { return UITableViewCell() }
        
        cell.selectionStyle = .none
        
        var isSelected = false
        if let selectedAddress = selectedAddress {
            if moscowAddresses[indexPath.row] == selectedAddress {
                isSelected = true
            }
        }
        
        cell.configure(with: moscowAddresses[indexPath.row], isSelected: isSelected)
        return cell
    }
}
