//
//  FeedbackViewController.swift
//  myCoffeeShopApp
//
//  Created by Muhammet Umut Taşan on 28.12.2024.
//

import UIKit
import Drops

class FeedbackViewController: UIViewController {

    @IBOutlet weak var feedbackTextView: UITextView!
    
    
    private var userVM : UserVM!
    private var authVM : AuthVM!
    var successDrop = Drop(title: "🥳", subtitle: "Bizi değerlendirdiğiniz için teşekkürler.", duration: 3.0)
    var failDrop = Drop(title: "❌", subtitle: "Lütfen bir şeyler yazın.", duration: 3.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userVM = myCoffeeShopApp.UserVM(user: SignedUser.user)
        authVM = myCoffeeShopApp.AuthVM(user: SignedUser.user)
        
    }
    

    @IBAction func sendFeedbackBtnClc(_ sender: Any) {
        print("id : \(SelectedOrderHistory.order.id)")  // Seçilen sipariş ID'sini yazdır
           SelectedOrderHistory.order.userFeedback = feedbackTextView.text
           if feedbackTextView.text != "" {
               self.userVM.updateOrder(user: SignedUser.user, order: SelectedOrderHistory.order) { success in
                   if success {
                       print("Order successfully updated.")  // Başarılı güncelleme mesajı
                       Drops.show(self.successDrop)
                       self.authVM.getUserInformations(userEmail: SignedUser.user.userEmail) { sccss in
                           if sccss {
                               print("User information successfully updated.")
                           }
                       }
                       // Modal olarak gösterildiyse, bir önceki view controller'a dönmek için
                       self.dismiss(animated: true, completion: nil)
                   } else {
                       print("Failed to update the order.")  // Güncelleme başarısızsa mesaj
                       Drops.show(self.failDrop)
                   }
               }
           } else {
               print("Feedback is empty.")  // Eğer geri bildirim girilmemişse
               Drops.show(self.failDrop)
           }
    }
    
}
