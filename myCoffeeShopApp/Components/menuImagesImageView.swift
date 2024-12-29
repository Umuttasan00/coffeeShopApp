//
//  menuImagesImageView.swift
//  myCoffeeShopApp
//
//  Created by Muhammet Umut Taşan on 22.09.2024.
//

import UIKit

class menuImagesImageView: UIImageView {

    override func layoutSubviews() {
           super.layoutSubviews()
           
           // Bulunduğu view'ın köşe radius'una uygun olarak ayarla
           if let parentView = superview {
               layer.cornerRadius = parentView.layer.cornerRadius
           }

           // Görüntünün dışarı taşmaması için
           clipsToBounds = true
       }

}
