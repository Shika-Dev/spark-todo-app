//
//  GradientView.swift
//  spark-todo-list
//
//  Created by Parama Artha on 15/04/25.
//


import UIKit
import SwiftUI

@IBDesignable
class GradientView: UIView {

    @IBInspectable var startColor: UIColor = .white {
        didSet {
            updateView()
        }
    }

    @IBInspectable var endColor: UIColor = UIColor(Color(hex: "#67ADFF")) {
        didSet {
            updateView()
        }
    }

    @IBInspectable var isHorizontal: Bool = false {
        didSet {
            updateView()
        }
    }

    override class var layerClass: AnyClass {
        return CAGradientLayer.self
    }

    private func updateView() {
        guard let gradientLayer = self.layer as? CAGradientLayer else { return }
        gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
        if isHorizontal {
            gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
            gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        } else {
            gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
            gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        updateView()
    }
}
