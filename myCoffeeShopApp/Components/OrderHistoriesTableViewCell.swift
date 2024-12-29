//
//  OrderHistoriesTableViewCell.swift
//  myCoffeeShopApp
//
//  Created by Muhammet Umut Taşan on 10.12.2024.
//

import UIKit

class OrderHistoriesTableViewCell: UITableViewCell {

    
    
    @IBOutlet weak var orderDateLbl: UILabel!
    @IBOutlet weak var orderTotalPriceLbl: UILabel!
    @IBOutlet weak var OrderDrinkCountLbl: UILabel!
    
    @IBOutlet weak var orderStatusLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
      
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }

}
