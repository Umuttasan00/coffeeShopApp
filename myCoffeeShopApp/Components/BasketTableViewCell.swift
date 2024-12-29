//
//  BasketTableViewCell.swift
//  myCoffeeShopApp
//
//  Created by Muhammet Umut Taşan on 8.10.2024.
//

import UIKit
import SwipeCell

class BasketTableViewCell: UITableViewCell {

    @IBOutlet weak var productImageOnBasket: UIImageView!
    @IBOutlet weak var productNameOnBasket: UILabel!
    @IBOutlet weak var productSizeOnBasket: UILabel!
    @IBOutlet weak var productPriceOnBasket: UILabel!
    
    
    var removeProductOnBasketBtnClcted: (() -> Void)?
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor? = UIColor.clear
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func removeProductOnBasketBtnClc(_ sender: Any) {
        
        removeProductOnBasketBtnClcted?()
    }
    

}
