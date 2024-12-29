import Foundation
import Firebase
import FirebaseFirestore
import FirebaseCore
import FirebaseStorage

class ProductVM {
    
   
    var firestoreDatabase = Firestore.firestore()
    
    init() {
        return
    }
    
    func removeSpaces(from string: String) -> String {
        return string.replacingOccurrences(of: " ", with: "")
    }

    

    func getProductsOnDB(completion: @escaping (Bool) -> Void) {
        let db = Firestore.firestore()
        
        db.collection("Products").getDocuments { snapshot, error in
            if let error = error {
                print("Veri çekme hatası: \(error.localizedDescription)")
                completion(false) // Hata durumunda false döndür
            } else {
                guard let documents = snapshot?.documents else {
                    print("Belge bulunamadı")
                    completion(false) // Belge bulunamazsa false döndür
                    return
                }

                // Her belgeyi Product modeline çevir ve SignedUser.user.AllCoffees'e ekle
                for document in documents {
                    let data = document.data()
                    
                    // Verileri tek tek al ve Product modeline ata
                    if let productName = data["productName"] as? String,
                       let productDesc = data["productDesc"] as? String,
                       let productContents = data["productContents"] as? [String],
                       let productPrice = data["productPrice"] as? [Int],
                       let productSize = data["productSize"] as? [String],
                       let productPicture = data["productPicture"] as? String,
                       let productType = data["productType"] as? [String]{
                        // Product nesnesi oluştur
                        let product = Product(
                            productType: productType,
                            productName: productName,
                            productPrice: productPrice,
                            productPicture: self.removeSpaces(from: productName),
                            productDesc: productDesc,
                            productContents: productContents,
                            productSize: productSize
                            )
                        
                        if productType.contains("Drink"){
                            SignedUser.user.allCoffees.append(product)
                            print("içecek sayısı \(SignedUser.user.allCoffees.count)")
                        }else if productType.contains("Food"){
                            SignedUser.user.allFoods.append(product)
                            print("yiyecek sayısı \(SignedUser.user.allFoods.count)")
                        }
                        
                        
                        
                        
                    }
                }
                
                print("Ürünler başarıyla çekildi ve SignedUser.user.AllCoffees dizisine eklendi.")
                completion(true) // Başarılı işlemde true döndür
            }
        }
    }

    
    func getProductByDocId(documentId: String, completion: @escaping (Bool) -> Void){
        firestoreDatabase.collection("Products").document(documentId).getDocument { (document, error) in
            if let document = document, document.exists {
                let data = document.data()
                var prodcut = Product(productType: [""], productName: "", productPrice: [0], productPicture: "", productDesc: "", productContents: [""], productSize: [""])
                // Veriyi işleme (örneğin, bir model objesine dönüştürme)
                if let productName = data?["productName"] as? String,
                   let productPrice = data?["productPrice"] as? [Int],
                   let productDesc = data?["productDesc"] as? String,
                   let productType = data?["deliverType"] as? [String],
                   let productPicture = data?["productPicture"] as? String,
                   let productContents = data?["productContents"] as? [String],
                   let productSize = data?["productSize"] as? [String]{
                    
                    prodcut.productName = productName
                    prodcut.productPrice = productPrice
                    prodcut.productDesc = productDesc
                    prodcut.productType = productType
                    prodcut.productPicture = productPicture
                    prodcut.productContents = productContents
                    prodcut.productSize = productSize
                  
                    SignedUser.user.allCoffees.append(prodcut)
                    print("Ürün Adı: \(productName), Ürün Fiyatı: \(productPrice)")
                    completion(true)
                }
            } else {
                print("Belge bulunamadı veya hata oluştu: \(error?.localizedDescription ?? "Bilinmeyen hata")")
                completion(false)
            }
        }
    }
}
