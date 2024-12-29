//
//  mainScreenCollectionCellView.swift
//  myCoffeeShopApp
//
//  Created by Muhammet Umut Taşan on 29.12.2024.
//

import Foundation
import UIKit

class mainScreenCollectionCellView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    private func setupView() {
        layer.backgroundColor = UIColor.white.withAlphaComponent(0.3).cgColor

        let screenBounds = UIScreen.main.bounds
        
        layer.cornerRadius = frame.size.width / 8
        layer.masksToBounds = true
        
        layer.masksToBounds = false

    }
    
   
}
