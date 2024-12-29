//
//  ConfirmBasketViewController.swift
//  myCoffeeShopApp
//
//  Created by Muhammet Umut Taşan on 4.12.2024.
//

import UIKit
import Drops
import UserNotifications


class ConfirmBasketViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
       1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView.tag{
        case 1:
            authVM.getUserInformations(userEmail: SignedUser.user.userEmail) { sccss in
                if sccss{
                    print("error")
                }
            }
            return paymentTypes.count
        case 2:
            return branchNames.count
        default:
            return 1
        }
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
         switch pickerView.tag {
         case 1:
             return paymentTypes[row]
        case 2:
             return branchNames[row]
         default:
             return "veri bulunamadı"
         }
     }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            switch pickerView.tag {
            case 1:
                payTypeTxtField.text=paymentTypes[row]
                payTypeTxtField.resignFirstResponder()
            case 2:
                branchTxtField.text=branchNames[row]
                branchTxtField.resignFirstResponder()
            default:
                return         }
        }
    
    
    //attributes
    
    ///labels
    @IBOutlet weak var totalPriceOfOrders: UILabel!
    @IBOutlet weak var youWillEarnCoffeePointText: UILabel!
    
    ///textFields
    @IBOutlet weak var branchTxtField: UITextField!
    @IBOutlet weak var payTypeTxtField: UITextField!
    @IBOutlet weak var orderNoteTxtField: UITextField!
    
    
    var paymentTypes = ["Nakit" ]
    let branchNames = ["Büyükşehir" , "İstanbul" , "Ankara" , "İzmir" , "Konya"]
    var paymentPickerView = UIPickerView()
    var branchPickerView = UIPickerView()
    var receivedTotalPrice: Int?
    let orderIsSuccess = Drop(title: "👍", subtitle: "Siparişiniz alınmıştır.", duration: 2.00)
    let orderIsReady = Drop(title: "🥳", subtitle: "Siparişiniz hazır.", duration: 2.00)
    let emptyFieldError = Drop(title: "⚠️", subtitle: "Lütfen bayi ve ödeme tipi doldurunuz.", position: .bottom, duration: 2.00)
    
    
    
    private var authVM: AuthVM!
    private var userVM: UserVM!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        authVM = myCoffeeShopApp.AuthVM(user: SignedUser.user)
        userVM = myCoffeeShopApp.UserVM(user: SignedUser.user)
        for cards in SignedUser.user.userCreditCards {
            paymentTypes.append("Son 4 hanesi \(cards.number.suffix(4)) olan kart")
        }
        if SignedUser.user.coffeeBean >= 10 {
            paymentTypes.append("Kahve Puanı")
        }
        
        payTypeTxtField.inputView = paymentPickerView
        paymentPickerView.delegate = self
        paymentPickerView.dataSource = self
        paymentPickerView.tag = 1
        
        branchTxtField.inputView = branchPickerView
        branchPickerView.delegate = self
        branchPickerView.dataSource = self
        branchPickerView.tag = 2
      
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        totalPriceOfOrders.text = "Toplam Tutar : \(receivedTotalPrice ?? 0) TL"
        youWillEarnCoffeePointText.text = "Bu siparişiniz ile \(SignedUser.user.userOrders.count) Kahve Puanı kazanacaksınız."
            
    }
    
    
    @IBAction func addCreditCardBtnClc(_ sender: Any) {
        self.performSegue(withIdentifier: "addCreditCard", sender: nil)
    }
    
    @IBAction func payBtnClc(_ sender: Any) {
        if checkTxtxFields(){
            if SignedUser.user.userOrders.count == 0 {
                
            }else {
                let now = Date()
                let order = Orders(id: SignedUser.user.orderHistory.count + 1,
                                   date: now,
                                   totalPrice: receivedTotalPrice ?? 0,
                                   status: "Hazırlanıyor",
                                   branchName: branchTxtField.text!,
                                   userNote: orderNoteTxtField.text ?? "Not bulunmamaktadır.",
                                   paymentType: payTypeTxtField.text!,
                                   userFeedback:  "",
                                   products: SignedUser.user.userOrders)
                
                SignedUser.user.orderHistory.append(order)
                Drops.show(self.orderIsSuccess)
                SignedUser.user.userOrders.removeAll()
                if order.paymentType == "Kahve Puanı"{
                    SignedUser.user.coffeeBean = SignedUser.user.coffeeBean - 10
                }
                authVM.addUserInformations(user: SignedUser.user) { sccss in
                    if sccss{
                            self.dismiss(animated: true, completion: nil)
                        print("güncellendi")
                        // 15 sn
                        DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
                            //sipariş iptal edilmiş mi kontrolu için güncel veri çekme
                            self.authVM.getUserInformations(userEmail: SignedUser.user.userEmail) { success in
                                if success {
                                    //aynı id deki orderı bulma
                                    guard var order = SignedUser.user.orderHistory.first(where: { $0.id == order.id }) else {
                                        print("Order bulunamadı.")
                                        return
                                    }
                                    // sipariş iptal mı kontrolü
                                    guard order.status != "Sipariş İptal" else {
                                        print("Sipariş iptal edilmiş, işlem yapılmadı.")
                                        return
                                    }
                                    var orderIdToFind = order.id
                                    if let index = SignedUser.user.orderHistory.firstIndex(where: { $0.id == orderIdToFind }) {
                                        // Nesneye erişim
                                        SignedUser.user.orderHistory[index].status = "Sipariş Hazır"
                                    }
                                    
                                    // Sipariş durumu ve kahve çekirdek sayısı güncellenir
                                    order.status = "Sipariş Hazır"
                                    self.sendNotification(title: "Sipariş hazır", body: "Sipariş hazır. Afiyetler!")
                                    Drops.show(self.orderIsReady)
                                    print("önce : \(SignedUser.user.coffeeBean)")
                                    SignedUser.user.coffeeBean += order.products.count
                                    print("sonra : \(SignedUser.user.coffeeBean)")
                                    // Sipariş güncellenir
                                    self.userVM.updateOrder(user: SignedUser.user, order: order) { success in
                                        if success{
                                            self.authVM.addUserInformations(user: SignedUser.user) { sccss in
                                                if sccss {
                                                    print("Kullanıcı bilgileri yeniden eklendi.")
                                                    print("Güncel :\(SignedUser.user.coffeeBean)")
                                                }
                                            }
                                        
                                        }
                                        
                                        print("Sipariş Güncellendi")
                                            print("Kullanıcı bilgileri başarıyla güncellendi.")
                                            
                                            // Son olarak kullanıcı bilgileri yeniden çekilir
                                            self.authVM.getUserInformations(userEmail: SignedUser.user.userEmail) { success in
                                                if success {
                                                    print("Kullanıcı bilgileri yeniden güncellendi.")
                                                } else {
                                                    print("Kullanıcı bilgileri tekrar güncellenemedi.")
                                                }
                                            }
                                    }
                                }
                              
                            }
                        }

                    }
                }
            }
        }else{
            Drops.show(emptyFieldError)
        }
    }
    func sendNotification(title: String, body: String) {
           let content = UNMutableNotificationContent()
           content.title = title
           content.body = body
           content.sound = .default
           content.badge = NSNumber(value: 1)

           let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)

           let request = UNNotificationRequest(identifier: "coffeePointNotification", content: content, trigger: trigger)

           UNUserNotificationCenter.current().add(request) { error in
               if let error = error {
                   print("Bildirim gönderilemedi: \(error.localizedDescription)")
               } else {
                   print("Bildirim başarıyla gönderildi!")
               }
           }
       }
    
    func checkTxtxFields() -> Bool {
        if branchTxtField.text == "" ||
            payTypeTxtField.text == "" ||
            branchTxtField.text == nil ||
            payTypeTxtField.text == nil {
            return false
        }
        return true
    }
    
    

}
