//
//  UIView+Extension.swift
//  RecipeTask
//
//  Created by John Doe on 2022-07-24.
//

import UIKit
extension UIView {


    func asImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
}
