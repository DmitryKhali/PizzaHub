//
//  SavedAddressesCell.swift
//  PizzaHub
//
//  Created by Dmitry Khalitov on 14.02.2026.
//

import UIKit
import SnapKit

final class SavedAddressesCell: UITableViewCell {
    
    static let reuseId = "SavedAddressesCell"
    
    private let addressLabel: UILabel = {
        var label = UILabel()
        label.text = "Какой то адрес"
        label.numberOfLines = 0
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - Setup
extension SavedAddressesCell {
    private func setupViews() {
        contentView.addSubview(addressLabel)
    }
    
    private func setupConstraints() {
        addressLabel.snp.makeConstraints { make in
            make.edges.equalTo(contentView).inset(15)
        }
    }
}

// MARK: - Public
extension SavedAddressesCell {
    func configure(with address: String, isSelected: Bool) {
        addressLabel.text = address
        
        accessoryType = isSelected ? .checkmark : .none
    }
}
