//
//  coffeePointBarView.swift
//  myCoffeeShopApp
//
//  Created by Muhammet Umut Taşan on 9.09.2024.
//

import UIKit

class coffeePointBarView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    private func setupView() {
        
        let screenWidth = UIScreen.main.bounds.width
        let responsiveWidth = screenWidth * 0.8

        self.frame.size = CGSize(width: responsiveWidth, height: 50)
        layer.cornerRadius = frame.size.height / 2

      
        
        
        layer.cornerRadius = frame.size.width / 20
        layer.masksToBounds = true
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOpacity = 0.7
        layer.shadowOffset = CGSize(width: 4, height: 4)
        layer.shadowRadius = 5
        layer.masksToBounds = false

    }

}
