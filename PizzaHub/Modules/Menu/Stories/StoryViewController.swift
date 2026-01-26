//
//  StoryViewController.swift
//  PizzaHub
//
//  Created by Dmitry Khalitov on 25.01.2026.
//

import UIKit
import SnapKit

final class StoryViewController: UIViewController {
    
    private let containerView: UIView = {
        var view = UIView()
        view.backgroundColor = .orange.withAlphaComponent(0.5)
        
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupConstraints()
    }
    
}

extension StoryViewController {
    private func setupViews() {
        view.addSubview(containerView)
    }
    
    private func setupConstraints() {
        containerView.snp.makeConstraints { make in
            make.edges.equalTo(view)
        }
    }
}
