//
//  creditCardsCollectionViewCell.swift
//  myCoffeeShopApp
//
//  Created by Muhammet Umut Taşan on 5.12.2024.
//

import UIKit


class creditCardsCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var cartNoLbl: UILabel!
    @IBOutlet weak var ownerNameLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var cvcLbl: UILabel!
    
    var removeCardBtnClc: (() -> Void)?
    
    @IBAction func removeBtnClc(_ sender: Any) {
        removeCardBtnClc?()
    }
    
    
}
