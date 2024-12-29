import UIKit
import FirebaseFirestore
import Drops

class ViewController: UIViewController {
    
    @IBOutlet weak var userEmailTxtField: UITextField!
    @IBOutlet weak var userPasswordTxtField: UITextField!
    
    
    private var authVM: AuthVM!
    // Firestore referansını al
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let user = User(userName: SignedUser.user.userName,
                        userSurname: SignedUser.user.userSurname,
                        userEmail: SignedUser.user.userEmail,
                        userPhoneNumber: SignedUser.user.userPhoneNumber,
                        userAddress: SignedUser.user.userAddress,
                        userGender: SignedUser.user.userGender,
                        coffeeBean: SignedUser.user.coffeeBean )
        authVM = myCoffeeShopApp.AuthVM(user: user)
    }
    
    @IBAction func loginBtnClc(_ sender: Any) {
        guard checkBoxes() else { return }
           
           guard let email = userEmailTxtField.text, isValidEmail(email) else {
               showDropNotification(title: "Geçersiz E-posta", subtitle: "Lütfen geçerli bir e-posta adresi girin.", icon: "xmark.octagon")
               return
           }
           
           guard let password = userPasswordTxtField.text, isValidPassword(password) else {
               showDropNotification(title: "Geçersiz Şifre", subtitle: "Şifre en az 6 karakter olmalı.", icon: "xmark.octagon")
               return
           }
           
           authVM.userLogin(userEmail: email, userPassword: password) { success in
               if success {
                   print("Login başarılı")
                   self.authVM.getUserInformations(userEmail: email) { success in
                       if success {
                           let drop = Drop(title: "👋", subtitle: "Hoşgeldin \(SignedUser.user.userName)", duration: 1.25)
                           Drops.show(drop)
                           self.performSegue(withIdentifier: "signinSuccess", sender: nil)
                       } else {
                           self.showDropNotification(title: "Veri Hatası", subtitle: "Kullanıcı bilgileri getirilemedi.", icon: "xmark.octagon")
                       }
                   }
               } else {
                   self.showDropNotification(title: "Giriş Başarısız", subtitle: "E-posta veya şifre hatalı.", icon: "xmark.octagon")
               }
           }
        
        
    }
    
    /// Boş Alan Kontrolü
    func checkBoxes() -> Bool {
        guard let email = userEmailTxtField.text, !email.isEmpty,
              let password = userPasswordTxtField.text, !password.isEmpty else {
            showDropNotification(title: "Eksik Bilgi", subtitle: "E-posta ve şifre boş bırakılamaz.", icon: "exclamationmark.triangle")
            return false
        }
        return true
    }
    /// Şifre Uzunluk Kontrolü
    func isValidPassword(_ password: String) -> Bool {
        return password.count >= 6
    }

    
    /// E-posta Format Kontrolü
    func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: email)
    }

    
    
    func showDropNotification(title: String, subtitle: String, icon: String) {
        let drop = Drop(
            title: title,
            subtitle: subtitle,
            icon: UIImage(systemName: icon),
            position: .top,
            duration: 3.0
        )
        Drops.show(drop)
    }
    
}

