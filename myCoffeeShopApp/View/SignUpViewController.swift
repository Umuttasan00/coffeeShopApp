import UIKit
import Drops
//import TextFieldEffects

class SignUpViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate {
 
    
    //textField lar
    @IBOutlet weak var userNameTxtField: UITextField!
    @IBOutlet weak var userSurnameTxtField: UITextField!
    @IBOutlet weak var userEmailTxtField: UITextField!
    @IBOutlet weak var userPhonenumberTxtField: UITextField!
    @IBOutlet weak var userPasswordTxtField: UITextField!
    @IBOutlet weak var userConfirmPasswordTxtField: UITextField!	
    @IBOutlet weak var userAddressTxtField: UITextField!
    @IBOutlet weak var genderTextField: UITextField!
    
    // tick cross images
    @IBOutlet weak var nameCheckImg: UIImageView!
    @IBOutlet weak var surnameCheckImg: UIImageView!
    @IBOutlet weak var emailCheckImg: UIImageView!
    @IBOutlet weak var phoneCheckImg: UIImageView!
    @IBOutlet weak var passwordCheckImg: UIImageView!
    @IBOutlet weak var passwordConfirmCheckImg: UIImageView!
    @IBOutlet weak var addressCheckImg: UIImageView!
    @IBOutlet weak var genderCheckImg: UIImageView!
    
    
    
    let genders = ["Erkek" , "Kadın", "Belirtmek İstemiyorum"]
    var genderPickerView = UIPickerView()
    private var authVM: AuthVM!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userNameTxtField.delegate = self
        userSurnameTxtField.delegate = self
        userEmailTxtField.delegate = self
        userPhonenumberTxtField.delegate = self
        userPasswordTxtField.delegate = self
        userConfirmPasswordTxtField.delegate = self
        userAddressTxtField.delegate = self
        genderTextField.delegate = self
        
        genderTextField.inputView = genderPickerView
        genderPickerView.delegate = self
        genderPickerView.dataSource = self
        genderPickerView.tag = 1
        
        let user = User(userName: "",
                         userSurname: "",
                        userEmail: "",
                        userPhoneNumber: "",
                        userAddress: "",
                        userGender: "",
                        coffeeBean: 0)
        
        authVM = myCoffeeShopApp.AuthVM(user: user)
        
    }
   
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if userNameTxtField.text != "" {
            nameCheckImg.isHidden = false
            nameCheckImg.image = UIImage(named: "tickIcon")
        } else {
            nameCheckImg.image = UIImage(named: "crossIcon")
        }

        if userSurnameTxtField.text != "" {
            surnameCheckImg.isHidden = false
            surnameCheckImg.image = UIImage(named: "tickIcon")
        } else {
            surnameCheckImg.image = UIImage(named: "crossIcon")
        }

        if userEmailTxtField.text != "" {
            emailCheckImg.isHidden = false
            emailCheckImg.image = UIImage(named: "tickIcon")
        } else {
            emailCheckImg.image = UIImage(named: "crossIcon")
        }

        if userPhonenumberTxtField.text != "" {
            phoneCheckImg.isHidden = false
            phoneCheckImg.image = UIImage(named: "tickIcon")
        } else {
            phoneCheckImg.image = UIImage(named: "crossIcon")
        }

        if userPasswordTxtField.text != "" {
            passwordCheckImg.isHidden = false
            passwordCheckImg.image = UIImage(named: "tickIcon")
        } else {
            passwordCheckImg.image = UIImage(named: "crossIcon")
        }

        if userConfirmPasswordTxtField.text != "" {
            passwordConfirmCheckImg.isHidden = false
            passwordConfirmCheckImg.image = UIImage(named: "tickIcon")
        } else {
            passwordConfirmCheckImg.image = UIImage(named: "crossIcon")
        }

        if userAddressTxtField.text != "" {
            addressCheckImg.isHidden = false
            addressCheckImg.image = UIImage(named: "tickIcon")
        } else {
            addressCheckImg.image = UIImage(named: "crossIcon")
        }

        if genderTextField.text != "" {
            genderCheckImg.isHidden = false
            genderCheckImg.image = UIImage(named: "tickIcon")
        } else {
            genderCheckImg.image = UIImage(named: "crossIcon")
        }

    }

    
    
    @IBAction func signUpBtnClc(_ sender: Any) {

        
        if filledBoxCheck() {
            guard let password = userPasswordTxtField.text, !password.isEmpty,
                  let confirmPassword = userConfirmPasswordTxtField.text, !confirmPassword.isEmpty else {
                showDropNotification(title: "Eksik Bilgi", subtitle: "Şifre ve Şifre Tekrarı boş bırakılamaz.", icon: "exclamationmark.triangle")
                return
            }
            
            if validatePassword(password, confirmPassword: confirmPassword) {
                authVM.userSignUp(userEmail: userEmailTxtField.text!, userPassword: password) { success in
                    if success { // Kayıt başarılı
                        self.authVM.addUserInformations(user: User.init(
                            userName: self.userNameTxtField.text!,
                            userSurname: self.userSurnameTxtField.text!,
                            userEmail: self.userEmailTxtField.text!,
                            userPhoneNumber: self.userPhonenumberTxtField.text!,
                            userAddress: self.userAddressTxtField.text!,
                            userGender: self.genderTextField.text!,
                            coffeeBean: 0)) { sccss in
                                if sccss { // Bilgiler başarıyla eklendi
                                    self.showDropNotification(title: "Kayıt Başarılı", subtitle: "Hesabınız başarıyla oluşturuldu!", icon: "checkmark.circle")
                                    self.navigationController?.popViewController(animated: true)
                                } else {
                                    self.showDropNotification(title: "Hata", subtitle: "Kullanıcı bilgileri eklenirken bir hata oluştu.", icon: "xmark.octagon")
                                }
                            }
                    } else {
                        self.showDropNotification(title: "Kayıt Başarısız", subtitle: "Kayıt sırasında bir hata oluştu.", icon: "xmark.octagon")
                    }
                }
            }
        } else {
            showDropNotification(title: "Eksik Bilgi", subtitle: "Tüm kutuları doldurduğunuzdan emin olun.", icon: "exclamationmark.triangle")
        }

        
        
       
       
    }
    
    func filledBoxCheck() -> Bool {
        return !(userNameTxtField.text?.isEmpty ?? true) &&
               !(userSurnameTxtField.text?.isEmpty ?? true) &&
               !(userEmailTxtField.text?.isEmpty ?? true) &&
               !(userPhonenumberTxtField.text?.isEmpty ?? true) &&
               !(userPasswordTxtField.text?.isEmpty ?? true) &&
               !(userConfirmPasswordTxtField.text?.isEmpty ?? true) &&
               !(userAddressTxtField.text?.isEmpty ?? true) &&
               !(genderTextField.text?.isEmpty ?? true)
    }

    func validatePassword(_ password: String, confirmPassword: String) -> Bool {
        let minLength = 6
        let uppercasePattern = ".*[A-Z]+.*"
        let lowercasePattern = ".*[a-z]+.*"
        let digitPattern = ".*[0-9]+.*"
        let specialCharPattern = ".*[!&^%$#@()/]+.*"
        
        if password != confirmPassword {
            showDropNotification(title: "Şifreler Eşleşmiyor", subtitle: "Şifre ve Şifre Tekrarı aynı olmalı.", icon: "xmark.octagon")
            return false
        }
        
        if password.count < minLength {
            showDropNotification(title: "Şifre Çok Kısa", subtitle: "Şifre en az \(minLength) karakter olmalı.", icon: "xmark.octagon")
            return false
        }
        
        if !NSPredicate(format: "SELF MATCHES %@", uppercasePattern).evaluate(with: password) {
            showDropNotification(title: "Büyük Harf Eksik", subtitle: "Şifre en az bir büyük harf içermeli.", icon: "xmark.octagon")
            return false
        }
        
        if !NSPredicate(format: "SELF MATCHES %@", lowercasePattern).evaluate(with: password) {
            showDropNotification(title: "Küçük Harf Eksik", subtitle: "Şifre en az bir küçük harf içermeli.", icon: "xmark.octagon")
            return false
        }
        
        if !NSPredicate(format: "SELF MATCHES %@", digitPattern).evaluate(with: password) {
            showDropNotification(title: "Rakam Eksik", subtitle: "Şifre en az bir rakam içermeli.", icon: "xmark.octagon")
            return false
        }
        
        if !NSPredicate(format: "SELF MATCHES %@", specialCharPattern).evaluate(with: password) {
            showDropNotification(title: "Özel Karakter Eksik", subtitle: "Şifre en az bir özel karakter içermeli (!&^%$#@()/ vb.).", icon: "xmark.octagon")
            return false
        }
        
        showDropNotification(title: "Şifre Geçerli", subtitle: "Şifre güçlü ve eşleşiyor.", icon: "checkmark.circle")
        return true
    }
   
    
    
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView.tag {
                case 1:
                    return genders.count
                default:
                    return 1
                }
    };    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView.tag {
        case 1:
            return genders[row]
        default:
            return "veri bulunamadı"
        }
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView.tag {
        case 1:
            genderTextField.text=genders[row]
            genderTextField.resignFirstResponder()
        default:
            return         }}
    
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
