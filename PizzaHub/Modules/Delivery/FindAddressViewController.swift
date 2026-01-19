//
//  FindAddressViewController.swift
//  SampleApp
//
//  Created by Dmitry Khalitov on 10.01.2026.
//

import UIKit
import SnapKit

final class FindAddressViewController: UIViewController {
    
    private let addressSuggestionService: IAddressSuggestionService
    private var suggestions: [Suggestion] = []
    private var searchTimer: Timer?
    
    init(addressSuggestionService: IAddressSuggestionService) {
        self.addressSuggestionService = addressSuggestionService
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let addressField: UITextField = {
        var field = UITextField()
        field.placeholder = "Введите адрес"
        field.borderStyle = .roundedRect
        field.backgroundColor = .systemGray6
        field.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        return field
    }()
    
    private lazy var addressList: UITableView = {
        var tableView = UITableView()
        tableView.backgroundColor = .white
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(FindAddressCell.self, forCellReuseIdentifier: "FindAddressCell")
                
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Поиск адреса"
        setupViews()
        setupConstraints()
        setupStyles()
        setupTextField()
    }
    
}

extension FindAddressViewController {
    
    private func setupViews() {
        view.addSubview(addressField)
        view.addSubview(addressList)
    }
    
    private func setupConstraints() {
        addressField.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(4)
            make.left.right.equalTo(view.safeAreaLayoutGuide).inset(16)
        }
        
        addressList.snp.makeConstraints { make in
            make.top.equalTo(addressField.snp.bottom).offset(16)
            make.left.right.bottom.equalTo(view)
        }
    }
    
    private func setupStyles() {
        view.backgroundColor = .white
    }
    
}

extension FindAddressViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        suggestions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FindAddressCell.reuseId, for: indexPath) as? FindAddressCell else {
            return UITableViewCell()
        }
        cell.configure(with: suggestions[indexPath.row].value)
        return cell
    }
}

extension FindAddressViewController: UITextFieldDelegate {
    private func setupTextField() {
        addressField.delegate = self
        addressField.addTarget(self, action: #selector(textFieldDidChangeWithDebounce), for: .editingChanged)
    }
    
    @objc private func textFieldDidChangeWithDebounce() {
        searchTimer?.invalidate()
        
        let query: String = addressField.text ?? ""
        
        if query.isEmpty { // почистить список, если юзер все удалил из textField
            suggestions.removeAll()
            addressList.reloadData()
            return
        }
        else if query.count > 2 { // если юзер ввел 3+ символа - запускаем поиск с небольшой задержкой
            searchTimer = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false, block: { [weak self] _ in
                guard let self = self, let query = addressField.text else { return } // обсудить оптимизацию let query = addressField
                self.searchAddress(with: query)
            })
        }
    }
    
    private func showLoading(_ isLoading: Bool) {
        if isLoading {
            let containerView = UIView(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
            
            let indicator = UIActivityIndicatorView(style: .medium)
            indicator.startAnimating()
            indicator.center = containerView.center
            
            containerView.addSubview(indicator)
            addressField.rightView = containerView
            addressField.rightViewMode = .always
        }
        else {
            addressField.rightView = nil
        }
    }
}

extension FindAddressViewController {
    private func searchAddress(with query: String) {
        showLoading(true)
        
        addressSuggestionService.suggestAddreses(for: query) { [weak self] result in // TODO: разобраться, где в итоге вызывать DispatchQueue.main..
            guard let self = self else { return }
            self.showLoading(false)
            switch result {
            case .success(let result):
                self.suggestions = result.suggestions
                self.addressList.reloadData()
            case .failure(let failure):
                print("failure")
            }
        }
    }
}
