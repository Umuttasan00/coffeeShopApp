import UIKit
import Drops

class detailsVC: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    
    
    @IBOutlet weak var productImageView: detailsCoffeePhotoImageView!
    @IBOutlet weak var productNameLbl: UILabel!
    @IBOutlet weak var productTypeLbl: UILabel!
    @IBOutlet weak var productDescLbl: UILabel!
    @IBOutlet weak var productPriceLbl: UILabel!
    @IBOutlet weak var coffeeContentView: basicRadiusView!
    @IBOutlet weak var MilkContentView: basicRadiusView!
    @IBOutlet weak var hotColdView: basicRadiusView!
    @IBOutlet weak var chocolateContentView: basicRadiusView!
    @IBOutlet weak var favoriteBtn: UIButton!
    @IBOutlet weak var hotColdLabel: UILabel!
    
    
    
    @IBOutlet weak var chooseSizeTextField: UITextField!
    @IBOutlet weak var sizeSelectCheckImageBtn: UIImageView!
    
    var sizes : [String] = []
    var sizePickerView = UIPickerView()
    var selectedImageIndex: Int?
    var userVM : UserVM!
    let productIsAddedToBasket = Drop(title: "👍", subtitle: "Ürün sepetine eklendi.", duration: 2.00)
    let chooseSizeAlert = Drop(title: "⚠️", subtitle: "Lütfen boy Seçiniz", duration: 2.00 )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.userVM = UserVM(user: SignedUser.user)
        if let index = selectedImageIndex {
                   print("Seçilen Resim Index'i: \(index)")
               }
        sizes = selectedProduct.product.productSize
        chooseSizeTextField.inputView = sizePickerView
        sizePickerView.delegate = self
        sizePickerView.dataSource = self
        sizePickerView.tag = 1
       
        sizeSelectCheckImageBtn.isHidden = true
        
        
        changeFavoriteBtnColor()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        sizeIsSelectCheck()
      
        changeFavoriteBtnColor()
        productNameLbl.text = selectedProduct.product.productName
        productDescLbl.text = selectedProduct.product.productDesc
        productTypeLbl.text = selectedProduct.product.productType[0]
        productImageView.image = UIImage(named: selectedProduct.product.productPicture)
        
        if selectedProduct.product.productType.contains("Cold"){
            hotColdLabel.text = "Soğuk"
            hotColdView.backgroundColor = .blue.withAlphaComponent(0.15)
        }else if selectedProduct.product.productType.contains("Hot"){
            hotColdLabel.text = "Sıcak"
            hotColdView.backgroundColor = .red.withAlphaComponent(0.15)
        }
        
        if selectedProduct.product.productContents.contains("Süt"){
            MilkContentView.isHidden = false
        }else{
            MilkContentView.isHidden = true
        }
        if selectedProduct.product.productContents.contains("Kahve"){
            coffeeContentView.isHidden = false
        }else{
            coffeeContentView.isHidden = true
        }
        if selectedProduct.product.productContents.contains("Çikolata"){
            chocolateContentView.isHidden = false
        }else{
            chocolateContentView.isHidden = true
        }
        
        
        
     
    }
    
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView.tag {
        case 1:
          
            return sizes.count
        default:
            return 1
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView.tag {
        case 1:
            return sizes[row]
        default:
            return "veri bulunamadı"
        }
    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView.tag {
        case 1:
            let selectedSize = sizes[row]
            chooseSizeTextField.text = selectedSize
            sizeIsSelectCheck()
            DispatchQueue.main.async {
                self.chooseSizeTextField.resignFirstResponder()
                if self.chooseSizeTextField.text == "Tall" || self.chooseSizeTextField.text == "One Size"{
                    self.productPriceLbl.text = "\(String(selectedProduct.product.productPrice[0]))₺"
                }else if self.chooseSizeTextField.text == "Grande" {
                    self.productPriceLbl.text = "\(String(selectedProduct.product.productPrice[1]))₺"
                }else if self.chooseSizeTextField.text == "Venti" {
                    self.productPriceLbl.text = "\(String(selectedProduct.product.productPrice[2]))₺"
                }
            }
        default:
            return
        }
    }
    
    func changeFavoriteBtnColor() {

        if SignedUser.user.userFavorites.contains(where: { $0.productName == selectedProduct.product.productName }) {
            favoriteBtn.tintColor = .red
        } else{
            favoriteBtn.tintColor = .white
        }
    }
    
    
    
    func sizeIsSelectCheck() {
        
        if let selectedSize = chooseSizeTextField.text, sizes.contains(selectedSize) {
            sizeSelectCheckImageBtn.isHidden = false
        } else {
            sizeSelectCheckImageBtn.isHidden = true
        }
    }
    
    
    @IBAction func favoriteBtnClc(_ sender: Any) {
        if let userVM = self.userVM {
            
            if SignedUser.user.userFavorites.contains(where: { $0.productName == selectedProduct.product.productName }) {
             
                userVM.removeFavoriteProduct(userEmail:SignedUser.user.userEmail, productName: selectedProduct.product.productName) { success in
                    if success{
                        DispatchQueue.main.async {
                            self.changeFavoriteBtnColor()
                        }
                    }else{
                        
                    }
                }
            }else{
                userVM.addFavoriteProduct(userEmail: SignedUser.user.userEmail,
                                          productName: selectedProduct.product.productName) { sccss in
                    if sccss {
                        DispatchQueue.main.async {
                            self.changeFavoriteBtnColor()
                        }
                    } else {
                        
                       
                    }
                }
            }
             
            } else {
                print("userVM nil")
            }

    }
    
    @IBAction func backBtnClc(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func addBasketBtnClc(_ sender: Any) {
        if chooseSizeTextField.text != "Tall" && chooseSizeTextField.text != "Grande" && chooseSizeTextField.text != "Venti" && chooseSizeTextField.text != "One Size"{
            Drops.show(chooseSizeAlert)
        }
        else{
            
            let productWillAppendOrderArray = Product(
                productType: selectedProduct.product.productType,
                productName: selectedProduct.product.productName,
                productPrice: [priceDefine()],
                productPicture : selectedProduct.product.productPicture,
                productDesc : selectedProduct.product.productDesc ,
                productContents : selectedProduct.product.productContents,
                productSize: [chooseSizeTextField.text!])
            
            SignedUser.user.userOrders.append(productWillAppendOrderArray)
            
            
            userVM.addBasketProduct(userEmail: SignedUser.user.userEmail,
                                    product: productWillAppendOrderArray) { sccss in
                if sccss{
                    print("ürün epete eklendi detailsVC")
                    Drops.show(self.productIsAddedToBasket)
                    self.dismiss(animated: true, completion: nil)
                }else{
                    print("ürün sepete eklenemedi detailsVC")
                }
            }
            
       
        }
    }
    
    func makeAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Tamam", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func priceDefine() -> Int {
        guard let selectedSize = chooseSizeTextField.text else { return 0 }
        switch selectedSize {
        case "Tall":
            return selectedProduct.product.productPrice[0]
        case "Grande":
            return selectedProduct.product.productPrice[1]
        case "Venti":
            return selectedProduct.product.productPrice[2]
        case "One Size":
            return selectedProduct.product.productPrice[0]
        default:
            return 0
        }
    }


}
