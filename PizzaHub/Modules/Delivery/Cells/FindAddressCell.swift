//
//  FindAddressCell.swift
//  PizzaHub
//
//  Created by Dmitry Khalitov on 10.01.2026.
//

import UIKit
import SnapKit

final class FindAddressCell: UITableViewCell {
    
    static let reuseId = "FindAddressCell"
    
    private let addressLabel: UILabel = {
        var label = UILabel()
        label.text = "Адрес"
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

extension FindAddressCell {
    private func setupViews() {
        contentView.addSubview(addressLabel)
    }
    
    private func setupConstraints() {
        addressLabel.snp.makeConstraints { make in
            make.top.bottom.equalTo(contentView).inset(12)
            make.left.right.equalTo(contentView).inset(16)
        }
    }
}

extension FindAddressCell {
    func configure(with addressName: String) {
        addressLabel.text = addressName
    }
}
