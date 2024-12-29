//
//  SelectedOrderHistory.swift
//  myCoffeeShopApp
//
//  Created by Muhammet Umut Taşan on 12.12.2024.
//

import Foundation
class SelectedOrderHistory{
    public static var order = Orders(id: 0,
                                     date: Date(),
                                     totalPrice: 0,
                                     status: "",
                                     branchName: "",
                                     userNote: "",
                                     paymentType: "",
                                     userFeedback: "",
                                     products: [])
}
