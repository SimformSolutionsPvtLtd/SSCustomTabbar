//
//  UIView+Extenstion.swift
//  SSCustomTabBar
//
//  Created by Sumit Goswami on 27/03/19.
//  Copyright © 2019 SimformSolutions. All rights reserved.
//

import UIKit

extension UIView {
    func viewCenter(usePresentationLayerIfPossible: Bool) -> CGPoint {
        if usePresentationLayerIfPossible, let presentationLayer = layer.presentation() {
            return presentationLayer.position
        }
        return center
    }
}
