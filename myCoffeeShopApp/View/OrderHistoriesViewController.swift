//
//  OrderHistoriesViewController.swift
//  myCoffeeShopApp
//
//  Created by Muhammet Umut Taşan on 10.12.2024.
//

import UIKit

class OrderHistoriesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        SignedUser.user.orderHistory.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderHistories", for: indexPath) as! OrderHistoriesTableViewCell
         
        let order = SignedUser.user.orderHistory[indexPath.row]
        cell.OrderDrinkCountLbl.text = "\(order.products.count) adet"
        let format = Date.FormatStyle().day().month().year().hour().minute()
        cell.orderDateLbl.text = order.date.formatted(format)

        cell.orderTotalPriceLbl.text = "\(order.totalPrice) TL"
        if order.status == "Hazırlanıyor"{
            cell.orderStatusLbl.text! = "Sipariş Hazırlanıyor"
            cell.orderStatusLbl.textColor = .black
            cell.orderStatusLbl.backgroundColor = .white
        }else if order.status == "Sipariş Hazır"{
            cell.orderStatusLbl.text! = "Sipariş Hazır"
            cell.orderStatusLbl.textColor = .white
            cell.orderStatusLbl.backgroundColor = .systemGreen
        }else if order.status == "Sipariş İptal"{
            cell.orderStatusLbl.text! = "Sipariş İptal"
            cell.orderStatusLbl.textColor = .red
            cell.orderStatusLbl.backgroundColor = .black
            
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            tableView.reloadData()
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         // Tıklanan hücrenin verisini al
        let order = SignedUser.user.orderHistory[indexPath.row]
        SelectedOrderHistory.order = order
        performSegue(withIdentifier: "orderDetails", sender: nil)

         // Hücre seçimini kaldır (isteğe bağlı)
         tableView.deselectRow(at: indexPath, animated: true)
     }
    

    @IBOutlet weak var tableView: UITableView!
    private var userVM : UserVM!
    private var authVM : AuthVM!
    override func viewDidLoad() {
        super.viewDidLoad()
        userVM = myCoffeeShopApp.UserVM(user: SignedUser.user)
        authVM = myCoffeeShopApp.AuthVM(user: SignedUser.user)
        tableView.delegate = self
        tableView.dataSource = self

       
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        SignedUser.user.orderHistory.sort { $0.date > $1.date }
        tableView.reloadData()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.authVM.addUserInformations(user: SignedUser.user) { sccss in
            if sccss{
                self.tableView.reloadData()
            }
        }
    }
    
   



}
