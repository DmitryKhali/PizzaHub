//
//  SelfSizingCollectionView.swift
//  PizzaHub
//
//  Created by Dmitry Khalitov on 21.02.2026.
//

import UIKit

class SelfSizingCollectionView: UICollectionView {
    
    // 1. Говорим системе: "Мой идеальный размер — это размер моего контента"
    override var intrinsicContentSize: CGSize {
//        print("@@ intrinsicContentSize: \(contentSize)")
        return contentSize
    }
    
    // 2. Каждый раз, когда контент меняется (добавили ячейки),
    // мы уведомляем Auto Layout, что размер изменился
    override var contentSize: CGSize {
        didSet {
            if oldValue != contentSize {
                print("@@ contentSize: \(contentSize)")
                invalidateIntrinsicContentSize()
                layoutIfNeeded()
            }
        }
    }
    
}
