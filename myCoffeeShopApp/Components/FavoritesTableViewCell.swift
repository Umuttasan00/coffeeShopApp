//
//  FavoritesTableViewCell.swift
//  myCoffeeShopApp
//
//  Created by Muhammet Umut Taşan on 25.11.2024.
//

import UIKit

class FavoritesTableViewCell: UITableViewCell {

    @IBOutlet weak var favoriteProductImage: UIImageView!
    @IBOutlet weak var favoriteProductName: UILabel!
    @IBOutlet weak var favoriteProductDesc: UILabel!
    
    
    var removeFavoritesButtonClc: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func removeFavoritesBtnClc(_ sender: Any) {
        removeFavoritesButtonClc?()
    }
    
}
