//
//  EmptyView.swift
//  SampleApp
//
//  Created by Dmitry Khalitov on 08.11.2025.
//

import UIKit
import SnapKit

final class EmptyView: UIView {
    
    let emptyView: UIView = {
        var view = UIView()
        view.heightAnchor.constraint(equalToConstant: 1).isActive = true
        return view
    }()
    
    init() {
        super.init(frame: .zero)
        
        setupViews()
        setupConstaints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        self.addSubview(emptyView)
    }
    
    private func setupConstaints() {
        emptyView.snp.makeConstraints { make in
            make.edges.equalTo(self)
        }
    }
}
