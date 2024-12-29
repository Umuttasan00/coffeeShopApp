import Foundation
import Firebase
import FirebaseAuth
import FirebaseFirestore

class AuthVM {
    private var user : User
    
    var fullName: String {
        return "\(user.userName) \(user.userSurname)"
        }
    
    var wellcomeUserNameText : String {
        return "Hoşgeldin \(user.userName) "
    }
    
    
    func updateUser(user_name: String, user_surname: String, user_email: String, user_phonenumber: String, user_address: String, user_gender : String, coffee_bean: Int) {
        self.user = User(userName: user_name, userSurname: user_surname, userEmail: user_email, userPhoneNumber: user_phonenumber, userAddress: user_address, userGender: user_gender,coffeeBean: coffee_bean)
        SignedUser.user.userName = user_name
        SignedUser.user.userSurname = user_surname
        SignedUser.user.userEmail = user_email
        SignedUser.user.userPhoneNumber = user_phonenumber
        SignedUser.user.userAddress = user_address
        SignedUser.user.userGender = user_gender
        SignedUser.user.coffeeBean = coffee_bean
        
       }
    
    func addUserInformations(user: User, completion: @escaping (Bool) -> Void) {
        // Firestore referansı
        let db = Firestore.firestore()
        
        let userData: [String: Any] = [
            "userName": user.userName,
            "userSurname": user.userSurname,
            "userEmail": user.userEmail,
            "userPhoneNumber": user.userPhoneNumber,
            "userAddress": user.userAddress,
            "userGender": user.userGender,
            "userCards": user.userCreditCards.map { CreditCard in
                [
                    "cardId": CreditCard.id,
                    "cardHolderName" : CreditCard.name,
                    "cardNumber": CreditCard.number,
                    "expiryDate": CreditCard.expirationDate,
                    "cvc" : CreditCard.cvc
                ]
            },
            "coffeeBeanCount": user.coffeeBean,
            "userFavorites": user.userFavorites.map { product in
                [
                    "productName": product.productName,
                    "productType": product.productType,
                    "productPrice": product.productPrice,
                    "productPicture": product.productPicture,
                    "productDesc": product.productDesc,
                    "productContents": product.productContents,
                    "productSize": product.productSize
                ]
            },
            "userOrders": user.userOrders.map { product in
                [
                    "productName": product.productName,
                    "productType": product.productType,
                    "productPrice": product.productPrice,
                    "productPicture": product.productPicture,
                    "productDesc": product.productDesc,
                    "productContents": product.productContents,
                    "productSize": product.productSize
                ]
            },
            "orderHistories": user.orderHistory.map { Orders in
                [
                    "id": Orders.id,
                    "date": Timestamp(date: Orders.date), 
                    "totalPrice": Orders.totalPrice,
                    "status": Orders.status,
                    "userNote": Orders.userNote,
                    "paymentType": Orders.paymentType,
                    "branchName": Orders.branchName,
                    "userFeedback": Orders.userFeedback,
                    "products": Orders.products.map { product in
                        [
                            "productName": product.productName,
                            "productType": product.productType,
                            "productPrice": product.productPrice,
                            "productPicture": product.productPicture,
                            "productDesc": product.productDesc,
                            "productContents": product.productContents,
                            "productSize": product.productSize
                        ]
                    }
                ]
            }

        ]

        
        // Firestore'a veri yazma veya güncelleme
           db.collection("Users").document(user.userEmail).setData(userData, merge: true) { error in
               if let error = error {
                   print("Error writing user data to Firestore: \(error.localizedDescription)")
                   completion(false) // İşlem başarısız
               } else {
                   print("User data successfully written or updated in Firestore")
                   completion(true)  // İşlem başarılı
               }
           }
    }
    
    func getUserInformations(userEmail: String, completion: @escaping (Bool) -> Void) {
        let db = Firestore.firestore()
        
        // Kullanıcı belgesini al
        db.collection("Users").document(userEmail).getDocument { (document, error) in
            if let error = error {
                print("Error getting user data from Firestore: \(error.localizedDescription)")
                completion(false)
                return
            }
            
            guard let document = document, document.exists, let data = document.data() else {
                print("Kullanıcı belgesi bulunamadı veya eksik.")
                completion(false)
                return
            }
            
            // Kullanıcı verilerini ayrıştırma
            let userName = data["userName"] as? String ?? ""
            let userSurname = data["userSurname"] as? String ?? ""
            let userEmail = data["userEmail"] as? String ?? ""
            let userPhoneNumber = data["userPhoneNumber"] as? String ?? ""
            let userAddress = data["userAddress"] as? String ?? ""
            let userGender = data["userGender"] as? String ?? ""
            let coffeeBean = data["coffeeBeanCount"] as? Int ?? 0
            
            // userFavorites alanını dönüştür
            let userFavorites = (data["userFavorites"] as? [[String: Any]])?.compactMap { favorite -> Product? in
                guard let productName = favorite["productName"] as? String,
                      let productType = favorite["productType"] as? [String],
                      let productPrice = favorite["productPrice"] as? [Int],
                      let productPicture = favorite["productPicture"] as? String,
                      let productDesc = favorite["productDesc"] as? String,
                      let productContents = favorite["productContents"] as? [String],
                      let productSize = favorite["productSize"] as? [String] else {
                    return nil
                }
                return Product(productType: productType,
                               productName: productName,
                               productPrice: productPrice,
                               productPicture: productPicture,
                               productDesc: productDesc,
                               productContents: productContents,
                               productSize: productSize)
            } ?? []
            
            // userOrders alanını dönüştür
            let userOrders = (data["userOrders"] as? [[String: Any]])?.compactMap { order -> Product? in
                guard let productName = order["productName"] as? String,
                      let productType = order["productType"] as? [String],
                      let productPrice = order["productPrice"] as? [Int],
                      let productPicture = order["productPicture"] as? String,
                      let productDesc = order["productDesc"] as? String,
                      let productContents = order["productContents"] as? [String],
                      let productSize = order["productSize"] as? [String] else {
                    return nil
                }
                return Product(productType: productType,
                               productName: productName,
                               productPrice: productPrice,
                               productPicture: productPicture,
                               productDesc: productDesc,
                               productContents: productContents,
                               productSize: productSize)
            } ?? []
            
            // userCards alanını dönüştür
            let userCards = (data["userCards"] as? [[String: Any]])?.compactMap { cardData -> CreditCard? in
                guard let cardNumber = cardData["cardNumber"] as? String,
                      let cardId = cardData["cardId"] as? Int,
                      let cardHolderName = cardData["cardHolderName"] as? String,
                      let expiryDate = cardData["expiryDate"] as? String,
                      let cvc = cardData["cvc"] as? String else {
                    return nil
                }
                return CreditCard(id: cardId, name: cardHolderName, number: cardNumber, expirationDate: expiryDate, cvc: cvc)
            } ?? []
            
            // Orders alanını dönüştür
            let userOrdersHistory = (data["orderHistories"] as? [[String: Any]])?.compactMap { orderData -> Orders? in
                guard let id = orderData["id"] as? Int,
                      let dateTimestamp = orderData["date"] as? Timestamp,
                      let totalPrice = orderData["totalPrice"] as? Int,
                      let status = orderData["status"] as? String,
                      let paymentType = orderData["paymentType"] as? String,
                      let branchName = orderData["branchName"] as? String,
                      let userNote = orderData["userNote"] as? String,
                      let userFeedback = orderData["userFeedback"] as? String,
                      let productsData = orderData["products"] as? [[String: Any]] else {
                    return nil
                }
                
                let products = productsData.compactMap { productData -> Product? in
                    guard let productName = productData["productName"] as? String,
                          let productType = productData["productType"] as? [String],
                          let productPrice = productData["productPrice"] as? [Int],
                          let productPicture = productData["productPicture"] as? String,
                          let productDesc = productData["productDesc"] as? String,
                          let productContents = productData["productContents"] as? [String],
                          let productSize = productData["productSize"] as? [String] else {
                        return nil
                    }
                    return Product(productType: productType,
                                   productName: productName,
                                   productPrice: productPrice,
                                   productPicture: productPicture,
                                   productDesc: productDesc,
                                   productContents: productContents,
                                   productSize: productSize)
                }
                
                return Orders(id: id, date: dateTimestamp.dateValue(), totalPrice: totalPrice, status: status, branchName: branchName, userNote: userNote, paymentType: paymentType,userFeedback: userFeedback, products: products)
            }.sorted(by: {
                // Tarihe göre sıralama (en yeni tarihler üste gelecek şekilde)
                $0.date > $1.date
            }) ?? []

            
            // SignedUser nesnesini güncelle
            SignedUser.user.userName = userName
            SignedUser.user.userSurname = userSurname
            SignedUser.user.userEmail = userEmail
            SignedUser.user.userPhoneNumber = userPhoneNumber
            SignedUser.user.userAddress = userAddress
            SignedUser.user.userGender = userGender
            SignedUser.user.userFavorites = userFavorites
            SignedUser.user.userOrders = userOrders
            SignedUser.user.userCreditCards = userCards
            SignedUser.user.coffeeBean = coffeeBean
            SignedUser.user.orderHistory = userOrdersHistory
            
            // Başarılı işlem sonucu
            print("Tüm kullanıcı bilgileri başarıyla alındı.")
            completion(true)
        }
    }

    
    func userLogin (userEmail: String, userPassword: String, completion: @escaping (Bool) -> Void) {
        Auth.auth().signIn(withEmail: userEmail, password: userPassword) { authResult, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                completion(false)
            } else {
                print("userLogin başarılı")
                completion(true)
            }
        }
    }
    func userSignUp (userEmail: String, userPassword: String, completion: @escaping (Bool) -> Void) {
        
        Auth.auth().createUser(withEmail: userEmail, password: userPassword) { authResult, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                print("UserSignUp başarısız. ")
                completion(false)
            } else {
                print("UserSignUp başarılı. ")
                completion(true)
            }
        }
    }
    func userLogOut() {
        do {
            try Auth.auth().signOut()
            print("Çıkış yapıldı")
        } catch let signOutError as NSError {
            print("Error signing out: \(signOutError.localizedDescription)")
        }
    }
    
    func sendPasswordResetLinkToUserEmail (Email : String , completion: @escaping (Bool) -> Void){
        Auth.auth().sendPasswordReset(withEmail: Email) { (error ) in
            if error != nil{
                completion(false)
            } else {
                completion(true)
            }
        }
    }
    
 
    
    init(user : User) {
            self.user = user
        }
        
}
