import UIKit
import SwiftUI

class ResetPasswordViewController: UIViewController {

    
    
 
    @IBOutlet weak var passwordResetEmailTextField: UITextField!
    
    private var authVM: AuthVM!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.authVM = AuthVM(user: User(userName: "",
                                        userSurname: "",
                                        userEmail: "",
                                        userPhoneNumber: "",
                                        userAddress: "",
                                        userGender: "",
                                        coffeeBean: 0))
        
    }
    
  
    @IBAction func resetPasswordBtnClc(_ sender: Any) {
        if passwordResetEmailTextField.text == "" && passwordResetEmailTextField.text?.isEmpty == true{
            let alert = UIAlertController(title: "Hata", message: "Lütfen email girin !", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }else{
            authVM.sendPasswordResetLinkToUserEmail(Email: passwordResetEmailTextField.text!) { sccss in
                if sccss{
                    let alert = UIAlertController(title: "Başarılı", message: "Lütfen emailinizi kontrol edin !", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                        self.navigationController?.popViewController(animated: true)
                    }))
                    self.present(alert, animated: true, completion: nil)
                }else{
                    
                }
            }
        }
       
    }
    
   

}
