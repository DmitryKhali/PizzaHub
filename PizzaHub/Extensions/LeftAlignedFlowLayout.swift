//
//  LeftAlignedFlowLayout.swift
//  PizzaHub
//
//  Created by Dmitry Khalitov on 21.02.2026.
//

import UIKit

class LeftAlignedFlowLayout: UICollectionViewFlowLayout {
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let attributes = super.layoutAttributesForElements(in: rect)
        
        var leftMargin = sectionInset.left
        var maxY: CGFloat = -1
        
        attributes?.forEach { attribute in
            if attribute.frame.origin.y >= maxY {
                leftMargin = sectionInset.left
            }
            
            attribute.frame.origin.x = leftMargin
            leftMargin += attribute.frame.width + minimumInteritemSpacing
            maxY = attribute.frame.maxY
        }
        
        return attributes
    }
}
