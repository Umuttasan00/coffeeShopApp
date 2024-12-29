//
//  Orders.swift
//  myCoffeeShopApp
//
//  Created by Muhammet Umut Taşan on 10.12.2024.
//

import Foundation

struct Orders {
    
    var id: Int
    var date: Date
    var totalPrice: Int
    var status: String
    var branchName: String
    var userNote: String
    var paymentType: String
    var userFeedback: String
    var products: [Product]
    
}
