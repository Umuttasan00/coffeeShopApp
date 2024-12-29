//
//  OrderDetailsViewController.swift
//  myCoffeeShopApp
//
//  Created by Muhammet Umut Taşan on 10.12.2024.
//

import UIKit
import Drops

class OrderDetailsViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        SelectedOrderHistory.order.products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OrderDetailsCollectionViewCell", for: indexPath) as! DetailOrdersCollectionViewCell
        let order = SelectedOrderHistory.order.products[indexPath.row]
        cell.orderNameLbl.text = order.productName
        cell.orderPhotoImgLbl.image = UIImage(named: order.productPicture)
        cell.orderPriceLbl.text = "\(order.productPrice[0]) ₺"
        cell.orderSizeLbl.text = order.productSize[0]
        
        return cell
    }
    

    /// collectionView
    @IBOutlet weak var ordersCollectionView: UICollectionView!
    ///attributes
  
    @IBOutlet weak var EvaluateOrderBtn: UIButton!
    @IBOutlet weak var orderDateLbl: UILabel!
    @IBOutlet weak var orderCountLbl: UILabel!
    @IBOutlet weak var paymentTypeLbl: UILabel!
    @IBOutlet weak var totalPriceLbl: UILabel!
    @IBOutlet weak var orderStatusLbl: UILabel!
    @IBOutlet weak var userNoteLbl: UILabel!
    @IBOutlet weak var branchNameLbl: UILabel!
    
    let orderIsReady = Drop(title: "⚠️", subtitle: "Siparişiniz hazır. Artık iptal edilemez.", duration: 2.00)
    let orderIsDrop = Drop(title: "👍", subtitle: "Siparişiniz iptal edildi.", duration: 2.00)
    
    private var authVM: AuthVM!
    private var userVM: UserVM!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        authVM = myCoffeeShopApp.AuthVM(user: SignedUser.user)
        userVM = myCoffeeShopApp.UserVM(user: SignedUser.user)
        
        if SelectedOrderHistory.order.status == "Sipariş İptal" {
            EvaluateOrderBtn.isHidden = true
        }
        if SelectedOrderHistory.order.userFeedback != ""{
            self.EvaluateOrderBtn.isEnabled = false
            self.EvaluateOrderBtn.backgroundColor = .systemGreen.withAlphaComponent(0.3) // Hafif şeffaf yeşil
            self.EvaluateOrderBtn.setTitle("Değerlendirme Yapıldı", for: .normal)
            self.EvaluateOrderBtn.setTitleColor(.white, for: .normal)

            // Butonun tintColor özelliğini ayarlayarak daha "tinted" bir görünüm elde edebilirsiniz
            self.EvaluateOrderBtn.tintColor = .systemGreen


        }
        
        ordersCollectionView.delegate = self
        ordersCollectionView.dataSource = self
        let order = SelectedOrderHistory.order
        let format = Date.FormatStyle().day().month().year().hour().minute()
        orderDateLbl.text = order.date.formatted(format)
        orderCountLbl.text = "\(order.products.count) adet"
        totalPriceLbl.text = "\(order.totalPrice) ₺"
        orderStatusLbl.text = order.status
        paymentTypeLbl.text = order.paymentType
        userNoteLbl.text = order.userNote
        branchNameLbl.text = order.branchName
      
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            if SelectedOrderHistory.order.userFeedback != ""{
                self.EvaluateOrderBtn.isEnabled = false
                self.EvaluateOrderBtn.backgroundColor = .systemGreen.withAlphaComponent(0.3) // Hafif şeffaf yeşil
                self.EvaluateOrderBtn.setTitle("Değerlendirme Yapıldı", for: .normal)
                self.EvaluateOrderBtn.setTitleColor(.white, for: .normal)

                // Butonun tintColor özelliğini ayarlayarak daha "tinted" bir görünüm elde edebilirsiniz
                self.EvaluateOrderBtn.tintColor = .systemGreen

            }
          
        }
        authVM.addUserInformations(user: SignedUser.user) { sccss in
            if sccss{
                self.authVM.getUserInformations(userEmail: SignedUser.user.userEmail) { sccss in
                    if sccss{
                        
                    }
                }
            }
        }
    }
    

    @IBAction func removeOrderBtnClc(_ sender: Any) {
        if SelectedOrderHistory.order.status == "Hazırlanıyor"{
            SelectedOrderHistory.order.status = "Sipariş İptal"
          
            userVM.updateOrder(user: SignedUser.user, order: SelectedOrderHistory.order) { sccss in
                if sccss{
                    print("sipariş iptal edildi")
                    if SelectedOrderHistory.order.paymentType == "Kahve Puanı"{
                        SignedUser.user.coffeeBean = SignedUser.user.coffeeBean - SelectedOrderHistory.order.products.count - 1
                    }
                 
                    
                            self.authVM.getUserInformations(userEmail: SignedUser.user.userEmail) { sccss in
                                if sccss{
                                    print("bilgiler güncellendi!!")
                                    print("coffee point : \(SignedUser.user.coffeeBean)")
                                }
                        
                    }
                    
                    Drops.show(self.orderIsDrop)
                    
                }
            }
        } else {
            Drops.show(orderIsReady)
        }
        
    }
    
    
    @IBAction func EvaluateOrderBtnClc(_ sender: Any) {
        self.performSegue(withIdentifier: "feedbackSegue", sender: nil)
    }
    

}
