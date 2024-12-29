import UIKit
import Drops


class AddCreditCartViewController: UIViewController, UITextFieldDelegate {

    
    //Attributes
    
    // labellar
    @IBOutlet weak var cardNoLblOnCard: UILabel!
    @IBOutlet weak var cardDateLblOnCard: UILabel!
    @IBOutlet weak var cardCvcLblOnCard: UILabel!
    @IBOutlet weak var cardUserNameLblOnCard: UILabel!
    
    //textFieldlar
    @IBOutlet weak var cardUserNameTextField: UITextField!
    @IBOutlet weak var cardNoTextField: UITextField!
    @IBOutlet weak var cardCvcTextField: UITextField!
    @IBOutlet weak var cardDateTextField: UITextField!
    
    
    private var userVM : UserVM!
    private var authVM : AuthVM!
    
    let cardAddSuccess = Drop(title: "👍", subtitle: "Kart başarıyla eklendi.", duration: 2.00)
    let cardAddFail = Drop(title: "❌", subtitle: "Eksik veya yanlış girdi.", duration: 2.00)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        authVM = myCoffeeShopApp.AuthVM(user: SignedUser.user)
        cardUserNameTextField.delegate = self
        cardNoTextField.delegate = self
        cardCvcTextField.delegate = self
        cardDateTextField.delegate = self
        
        
        cardUserNameTextField.addTarget(self, action: #selector(updateCardLabels), for: .editingChanged)
           cardNoTextField.addTarget(self, action: #selector(updateCardLabels), for: .editingChanged)
           cardCvcTextField.addTarget(self, action: #selector(updateCardLabels), for: .editingChanged)
           cardDateTextField.addTarget(self, action: #selector(updateCardLabels), for: .editingChanged)
        userVM = myCoffeeShopApp.UserVM(user: SignedUser.user)

    }
    
    @objc func updateCardLabels() {
        // Kullanıcı adı
        cardUserNameLblOnCard.text = cardUserNameTextField.text?.uppercased() ?? "İSİM SOYİSİM"
        
        // Kart numarası: Dinamik yıldızlama
        if let cardNumber = cardNoTextField.text {
            let sanitizedNumber = cardNumber.replacingOccurrences(of: " ", with: "") // Boşlukları kaldır
            let paddedNumber = sanitizedNumber.padding(toLength: 16, withPad: "*", startingAt: 0) // Eksik yerleri yıldızla doldur
            let formattedNumber = paddedNumber.enumerated().map { index, char in
                (index % 4 == 0 && index != 0) ? " \(char)" : String(char) // 4'er gruplar halinde boşluk ekle
            }.joined()
            cardNoLblOnCard.text = formattedNumber
        } else {
            cardNoLblOnCard.text = "**** **** **** ****"
        }
        
        // CVC: Dinamik yıldızlama
        if let cvc = cardCvcTextField.text {
            let paddedCVC = cvc.padding(toLength: 3, withPad: "*", startingAt: 0) // Eksik yerleri yıldızla doldur
            cardCvcLblOnCard.text = paddedCVC
        } else {
            cardCvcLblOnCard.text = "***"
        }
        
        // Tarih: Dinamik yıldızlama
        if let expiryDate = cardDateTextField.text {
            let sanitizedDate = expiryDate.replacingOccurrences(of: "/", with: "") // Slash kaldır
            let paddedDate = sanitizedDate.padding(toLength: 4, withPad: "*", startingAt: 0) // Eksik yerleri yıldızla doldur
            let formattedDate = paddedDate.prefix(4).enumerated().map { index, char in
                index == 2 ? "/\(char)" : String(char) // 2. karakterden sonra "/" ekle
            }.joined()
            cardDateLblOnCard.text = formattedDate
        } else {
            cardDateLblOnCard.text = "MM/YY"
        }
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
           // Mevcut metni alın
           guard let currentText = textField.text else { return true }
           let updatedText = (currentText as NSString).replacingCharacters(in: range, with: string)
           
           // Kart Numarası (16 hane sınırı, sadece sayılar)
           if textField == cardNoTextField {
               return updatedText.count <= 16 && string.rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil
           }
           
           // CVC (3 hane sınırı, sadece sayılar)
           if textField == cardCvcTextField {
               return updatedText.count <= 3 && string.rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil
           }
           
           // Son Kullanma Tarihi (4 karakter sınırı, MM/YY formatı)
           if textField == cardDateTextField {
               return updatedText.count <= 4 && string.rangeOfCharacter(from: CharacterSet.decimalDigits.union(CharacterSet(charactersIn: "/")).inverted) == nil
           }
           
           // Kullanıcı Adı (25 karakter sınırı, tüm karakterlere izin)
           if textField == cardUserNameTextField {
               return updatedText.count <= 25
           }
           
           return true
       }
    


    @IBAction func addCardBtnClc(_ sender: Any) {
        print(cardNoTextField.text as Any)
        if isTextFieldsRight() {
            let cardId = (SignedUser.user.userCreditCards.last?.id ?? 0) + 1
            let card = CreditCard(id: cardId,
                                  name: cardUserNameLblOnCard.text!,
                                  number: cardNoLblOnCard.text!,
                                  expirationDate: cardDateLblOnCard.text!,
                                  cvc: cardCvcLblOnCard.text!)
            SignedUser.user.userCreditCards.append(card)
            userVM.addCardDatabase(userEmail: SignedUser.user.userEmail) { sccss in
                if sccss{
                    self.authVM.getUserInformations(userEmail: SignedUser.user.userEmail) { sccss in
                        if sccss{
                            Drops.show(self.cardAddSuccess)
                            // Modal olarak gösterildiyse, bir önceki view controller'a dönmek için
                            self.dismiss(animated: true, completion: nil)
                        }
                    }
                }
            }
            
        }else {
            Drops.show(self.cardAddFail)
        }
    }
    
    func isTextFieldsRight() -> Bool {
        // Kart numarası kontrolü: 16 hane ve sadece sayılar
        if let cardNumber = cardNoTextField.text?.replacingOccurrences(of: " ", with: ""), cardNumber.count != 16 || Int(cardNumber) == nil {
            print("Kart numarası geçersiz.")
            return false
        }
        
        // Son kullanma tarihi kontrolü: MM/YY formatında ve 5 karakter
        if let expiryDate = cardDateTextField.text, expiryDate.count != 4 {
            print("Son kullanma tarihi geçersiz.")
            return false
        }
        
        // CVC kontrolü: 3 hane ve sadece sayılar
        if let cvc = cardCvcTextField.text, cvc.count != 3 || Int(cvc) == nil {
            print("CVC geçersiz.")
            return false
        }
        
        // Kullanıcı adı kontrolü: Boş olmamalı
        if let cardHolderName = cardUserNameTextField.text, cardHolderName.isEmpty {
            print("Kullanıcı adı boş olamaz.")
            return false
        }
        
        // Tüm kontrollerden geçti
        return true
    }


}
