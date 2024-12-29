

import Foundation
import Firebase
import NotificationCenter

class UserVM {
    private var user : User
    
    var firebaseDatabase = Firestore.firestore()
    var firestoreReference : DocumentReference? = nil

    func getFavoriteProductOnOrders() -> String {
        var productCount: [String: Int] = [:]
        
        // Her siparişi kontrol et
        for order in SignedUser.user.orderHistory {
            // Siparişteki her ürünü kontrol et
            for product in order.products {
                // Ürün ismini al ve sayısını artır
                productCount[product.productName, default: 0] += 1
            }
        }
        
        // En fazla tekrar eden ürünü bul
        var maxCount: Int = 0
        var mostFrequentProducts: [String] = []
        
        // En yüksek sayıyı ve bu sayıya sahip ürünleri belirle
        for (productName, count) in productCount {
            if count > maxCount {
                maxCount = count
                mostFrequentProducts = [productName] // Yeni en fazla tekrar eden ürünü sıfırla
            } else if count == maxCount {
                mostFrequentProducts.append(productName) // Aynı sayıya sahip ürünü listeye ekle
            }
        }
        
        // Eğer hiç ürün yoksa "Şimdilik boş" döndür
        if mostFrequentProducts.isEmpty {
            return "Şimdilik boş"
        }
        
        // Rastgele bir ürün seç
        if let randomProduct = mostFrequentProducts.randomElement() {
            return randomProduct
        }
        
        return "Şimdilik boş" // Herhangi bir sorun durumunda boş döndür
    }

    func getFavoriteBranchOnOrders() -> String {
        var branchCount: [String: Int] = [:]
        
        // Her siparişi kontrol et
        for order in SignedUser.user.orderHistory {
            // Bayi ismini al ve sayısını artır
            branchCount[order.branchName, default: 0] += 1
        }
        
        // En fazla tekrar eden bayi ismini bul
        var maxCount: Int = 0
        var mostFrequentBranches: [String] = []
        
        // En yüksek sayıyı ve bu sayıya sahip bayileri belirle
        for (branchName, count) in branchCount {
            if count > maxCount {
                maxCount = count
                mostFrequentBranches = [branchName] // Yeni en fazla tekrar eden bayiyi sıfırla
            } else if count == maxCount {
                mostFrequentBranches.append(branchName) // Aynı sayıya sahip bayiyi listeye ekle
            }
        }
        
        // Eğer hiç bayi yoksa "Şimdilik boş" döndür
        if mostFrequentBranches.isEmpty {
            return "Şimdilik boş"
        }
        
        // Rastgele bir bayi seç
        if let randomBranch = mostFrequentBranches.randomElement() {
            return randomBranch
        }
        
        return "Şimdilik boş" // Herhangi bir sorun durumunda boş döndür
    }


    
    func createDBCollectionsForNewUser (){
        
    }
    // Kullanıcıya özel profil fotoğrafını kaydetme
       func saveProfileImage(image: UIImage) {
           // Kullanıcı ID'sine göre anahtar oluşturun
           let key = "profileImage_\(SignedUser.user.userEmail)"
           
           if let imageData = image.jpegData(compressionQuality: 0.8) {
               let base64String = imageData.base64EncodedString()
               UserDefaults.standard.set(base64String, forKey: key)
           }
       }
       
       // Kullanıcıya özel profil fotoğrafını yükleme
       func loadProfileImage() -> UIImage? {
           // Kullanıcı ID'sine göre anahtar oluşturun
           let key = "profileImage_\(SignedUser.user.userEmail)"
           
           if let base64String = UserDefaults.standard.string(forKey: key),
              let imageData = Data(base64Encoded: base64String) {
               return UIImage(data: imageData)
           }
           return nil
       }
       
       func generateUUID() -> String {
           return UUID().uuidString
       }
    
    func addFavoriteProduct(userEmail: String, productName: String, completion: @escaping (Bool) -> Void) {
        // Kullanıcının dokümanını belirle
        let userDocRef = firebaseDatabase.collection("Users").document(userEmail)
        
        userDocRef.getDocument { (document, error) in
            if let error = error {
                print("Kullanıcıyı getirirken hata: \(error.localizedDescription)")
                completion(false)
                return
            }
            
            guard let document = document, document.exists else {
                print("Kullanıcı belgesi bulunamadı. E-posta: \(userEmail)")
                completion(false)
                return
            }
            
            // Favori ürün kontrolü
            if SignedUser.user.userFavorites.contains(where: { $0.productName == productName }) {
                print("Ürün zaten favorilerde.")
               
                completion(false)
                return
            }
            
            
            // Favori ürün bulma
            guard let favoriteProduct = self.allProducts().first(where: { $0.productName == productName }) else {
                print("Favori ürün bulunamadı.")
                completion(false)
                return
            }
           
            
            // Favori ürünü yerel listeye ekle
            SignedUser.user.userFavorites.append(favoriteProduct)
            
            // Firestore'a uygun veri hazırlama
            let userFavorites = SignedUser.user.userFavorites.map { product in
                return [
                    "productName": product.productName,
                    "productType": product.productType,
                    "productPrice": product.productPrice,
                    "productPicture": product.productPicture,
                    "productDesc": product.productDesc,
                    "productContents": product.productContents,
                    "productSize": product.productSize
                ] as [String: Any]
            }
            
            // Firestore'a güncelleme yaz
            userDocRef.updateData(["userFavorites": userFavorites]) { error in
                if let error = error {
                    print("Favorileri güncellerken hata: \(error.localizedDescription)")
                    completion(false)
                    return
                }
                
                print("Ürün başarıyla favorilere eklendi.")
                completion(true)
            }
        }
    }
    

    func removeFavoriteProduct(userEmail: String, productName: String, completion: @escaping (Bool) -> Void) {
        // Kullanıcının dokümanını belirle
        let userDocRef = firebaseDatabase.collection("Users").document(userEmail)
        
        userDocRef.getDocument { (document, error) in
            if let error = error {
                print("Kullanıcıyı getirirken hata: \(error.localizedDescription)")
                completion(false)
                return
            }
            
            guard let document = document, document.exists else {
                print("Kullanıcı belgesi bulunamadı. E-posta: \(userEmail)")
                completion(false)
                return
            }
            
            // Favori ürün kontrolü
            guard let index = SignedUser.user.userFavorites.firstIndex(where: { $0.productName == productName }) else {
                print("Ürün favorilerde bulunamadı.")
                completion(false)
                return
            }
            
            // Favori ürünü yerel listeye çıkar
            SignedUser.user.userFavorites.remove(at: index)
            
            // Firestore'a uygun veri hazırlama
            let userFavorites = SignedUser.user.userFavorites.map { product in
                return [
                    "productName": product.productName,
                    "productType": product.productType,
                    "productPrice": product.productPrice,
                    "productPicture": product.productPicture,
                    "productDesc": product.productDesc,
                    "productContents": product.productContents,
                    "productSize": product.productSize
                ] as [String: Any]
            }
            
            // Firestore'dan ürünü kaldırarak güncelleme yap
            userDocRef.updateData(["userFavorites": userFavorites]) { error in
                if let error = error {
                    print("Favorileri güncellerken hata: \(error.localizedDescription)")
                    completion(false)
                    return
                }
                
                print("Ürün favorilerden başarıyla kaldırıldı.")
                completion(true)
            }
        }
    }

    
    func addBasketProduct(userEmail: String, product: Product, completion: @escaping (Bool) -> Void) {
        // Firestore referansı
        let userDocRef = firebaseDatabase.collection("Users").document(userEmail)
        
        // Kullanıcı belgesini al
        userDocRef.getDocument { (document, error) in
            if let error = error {
                print("Kullanıcıyı getirirken hata: \(error.localizedDescription)")
                completion(false)
                return
            }
            
            guard let document = document, document.exists else {
                print("Kullanıcı belgesi bulunamadı. E-posta: \(userEmail)")
                completion(false)
                return
            }
            
            // Mevcut userOrders listesini al
            var currentOrders: [[String: Any]] = document.data()?["userOrders"] as? [[String: Any]] ?? []
            
            // Yeni ürün verisini hazırlama
            let newOrder: [String: Any] = [
                "productName": product.productName,
                "productType": product.productType,
                "productPrice": product.productPrice,
                "productPicture": product.productPicture,
                "productDesc": product.productDesc,
                "productContents": product.productContents,
                "productSize": product.productSize
            ]
            
            // Yeni ürünü listeye ekle
            currentOrders.append(newOrder)
            
            // Firestore'da userOrders'ı güncelle
            userDocRef.updateData(["userOrders": currentOrders]) { error in
                if let error = error {
                    print("Sepet güncellenirken hata: \(error.localizedDescription)")
                    completion(false)
                    return
                }
                
                print("Ürün başarıyla sepete eklendi.")
                completion(true)
            }
        }
    }

    
   
    func removeProductOnBasket(userEmail: String, product: Product, completion: @escaping (Bool) -> Void) {
        let userDocRef = firebaseDatabase.collection("Users").document(userEmail)
        
        // Mevcut userOrders dizisinden ürünü kaldır
        var currentOrder = SignedUser.user.userOrders

        if let index = currentOrder.firstIndex(where: { $0.productName == product.productName }) {
            currentOrder.remove(at: index)
        }

        // SignedUser.user.userOrders dizisini güncelle
        SignedUser.user.userOrders = currentOrder
        
        // Firestore'a uygun formata dönüştür
        let updatedOrders = currentOrder.map { product -> [String: Any] in
            return [
                "productName": product.productName,
                "productType": product.productType,
                "productPrice": product.productPrice,
                "productPicture": product.productPicture,
                "productDesc": product.productDesc,
                "productContents": product.productContents,
                "productSize": product.productSize
            ]
        }
        
        // Firestore'daki userOrders dizisini güncelle
        userDocRef.updateData(["userOrders": updatedOrders]) { error in
            if let error = error {
                print("Sepetten ürün silinirken hata: \(error.localizedDescription)")
                completion(false)
                return
            }
            
            print("Ürün başarıyla Firestore'dan silindi.")
            completion(true)
        }
    }
    
    
    func addCardDatabase(userEmail: String, completion: @escaping (Bool) -> Void) {
        let userDocRef = firebaseDatabase.collection("Users").document(userEmail)
        
        // `userCards` dizisini Firestore formatına dönüştür
        let cardsData = SignedUser.user.userCreditCards.map { card -> [String: Any] in
            return [
                "cardId" : card.id,
                "cardHolderName": card.name,
                "cardNumber": card.number,
                "expiryDate": card.expirationDate,
                "cvc": card.cvc
            ]
        }
        
        // Firestore'da userCards alanını güncelle
        userDocRef.updateData(["userCards": cardsData]) { error in
            if let error = error {
                print("Kart bilgileri kaydedilirken hata: \(error.localizedDescription)")
                completion(false)
                return
            }
            
            print("Kart bilgileri başarıyla kaydedildi.")
            completion(true)
        }
    }
   
    func deleteCardOnDatabase(userEmail: String, cardId: Int, completion: @escaping (Bool) -> Void) {
        let userDocRef = firebaseDatabase.collection("Users").document(userEmail)
        
        // Kullanıcının mevcut kartlarını al
        userDocRef.getDocument { document, error in
            if let error = error {
                print("Kart bilgilerini çekerken hata: \(error.localizedDescription)")
                completion(false)
                return
            }
            
            guard let document = document, document.exists,
                  var userCards = document.data()?["userCards"] as? [[String: Any]] else {
                print("Kullanıcı veya userCards alanı bulunamadı.")
                completion(false)
                return
            }
            
            // Belirli kartı bul ve sil
            if let index = userCards.firstIndex(where: { $0["cardId"] as? Int == cardId }) {
                userCards.remove(at: index)
                
                // Güncellenmiş userCards dizisini Firestore'a kaydet
                userDocRef.updateData(["userCards": userCards]) { error in
                    if let error = error {
                        print("Kart silinirken hata: \(error.localizedDescription)")
                        completion(false)
                        return
                    }
                    
                    print("Kart başarıyla silindi.")
                    completion(true)
                }
            } else {
                print("Belirtilen kart bulunamadı.")
                completion(false)
            }
        }
    }
   
    func updateOrder(user: User, order: Orders, completion: @escaping (Bool) -> Void) {
        // Perform Firestore operation in the background
        DispatchQueue.global(qos: .background).async {
            let db = Firestore.firestore()
            
            // Kullanıcının koleksiyonunda belgesini al
            let userDocumentRef = db.collection("Users").document(user.userEmail)
            
            userDocumentRef.getDocument { documentSnapshot, error in
                if let error = error {
                    print("Error fetching user document: \(error.localizedDescription)")
                    DispatchQueue.main.async {
                        completion(false)
                    }
                    return
                }
                
                guard let document = documentSnapshot, document.exists,
                      var orderHistories = document.data()?["orderHistories"] as? [[String: Any]] else {
                    print("Order histories not found or user document is missing.")
                    DispatchQueue.main.async {
                        completion(false)
                    }
                    return
                }
                
                // Belirli bir `id`ye sahip siparişi bul ve güncelle
                if let index = orderHistories.firstIndex(where: { ($0["id"] as? Int) == order.id }) {
                    // Güncellenmiş veriyi oluştur
                    let updatedOrder: [String: Any] = [
                        "id": order.id,
                        "date": Timestamp(date: order.date),
                        "totalPrice": order.totalPrice,
                        "status": order.status,
                        "paymentType": order.paymentType,
                        "branchName": order.branchName,
                        "userNote": order.userNote,
                        "userFeedback": order.userFeedback,
                        "products": order.products.map { product in
                            return [
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
                    
                    // Eski veriyi değiştir
                    orderHistories[index] = updatedOrder
                    
                    // `orderHistories` alanını güncelle
                    userDocumentRef.updateData(["orderHistories": orderHistories]) { error in
                        if let error = error {
                            print("Error updating order histories: \(error.localizedDescription)")  // Hata mesajı yazdır
                            DispatchQueue.main.async {
                                completion(false)
                            }
                        } else {
                            print("Order updated successfully in orderHistories.")  // Güncelleme başarılı mesajı
                            DispatchQueue.main.async {
                                completion(true)
                            }
                        }
                    }
                } else {
                    print("Order with ID \(order.id) not found in orderHistories.")
                    DispatchQueue.main.async {
                        completion(false)
                    }
                }
            }
        }
    }


    
    func sendNotification(title : String, body : String){
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        content.badge = NSNumber(value: 1) // Uygulama ikonuna bir işaret ekler

        // Bildirim tetikleyicisi (örneğin, 5 saniye sonra)
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)

        // Bildirim isteği oluştur
        let request = UNNotificationRequest(identifier: "coffeePointNotification", content: content, trigger: trigger)

        // Bildirim merkezi üzerinden bildirimi ekle
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Bildirim gönderilemedi: \(error.localizedDescription)")
            } else {
                print("Bildirim başarıyla gönderildi!")
            }
        }
    }

    func allProducts() -> [Product]{
        
        var allProducts : [Product] = []
        allProducts = SignedUser.user.allCoffees + SignedUser.user.allFoods
        return allProducts
    }
    
    func updateCoffeePointOnDB(userEmail: String, coffeeBeanCount: Int, completed: @escaping (Bool) -> Void) {
        let db = Firestore.firestore()
        
        // Referans oluşturma
        let userRef = db.collection("User").whereField("email", isEqualTo: userEmail)
        
        userRef.getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
                completed(false)
            } else {
                if let document = querySnapshot?.documents.first {
                    document.reference.updateData([
                        "coffeeBeanCount": coffeeBeanCount
                    ]) { err in
                        if let err = err {
                            print("Error updating document: \(err)")
                            completed(false)
                        } else {
                            print("Document successfully updated")
                            completed(true)
                        }
                    }
                } else {
                    print("No document found with the given email")
                    completed(false)
                }
            }
        }
    }

   


    
    
    
    init(user: User) {
        self.user = user
    }
    
    }
