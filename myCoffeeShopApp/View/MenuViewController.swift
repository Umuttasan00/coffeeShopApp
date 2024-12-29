import UIKit
import SDWebImage


class MenuViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.collectionView {
            return SignedUser.user.allCoffees.count
        }else if collectionView == self.foodCollectionView {
            return SignedUser.user.allFoods.count
        }
      return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == self.collectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "horizontalCell", for: indexPath) as! horizontalProductListCollectionViewCell
            
            let product = SignedUser.user.allCoffees[indexPath.row]
            cell.productName.text = product.productName
            cell.productPrice.text = String(product.productPrice[0])
            // İlk iki elemanı al ve virgülle ayırarak birleştir
            let firstTwoContents = product.productContents.prefix(2).joined(separator: ", ")

            // Label'a yazdır
            cell.productContetnsLbl.text = firstTwoContents

            cell.imageView.image = UIImage(named: product.productPicture)
            
            // Eski recognizer'ları kaldır (önlem olarak)
            cell.imageView.gestureRecognizers?.forEach(cell.imageView.removeGestureRecognizer)
            
            // Yeni bir UITapGestureRecognizer ekle
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped(_:)))
            cell.imageView.isUserInteractionEnabled = true
            cell.imageView.addGestureRecognizer(tapGesture)
            tapGesture.view?.tag = indexPath.row // indexPath bilgisi olarak tag kullan
            
            return cell
        } else if collectionView == foodCollectionView {
            let foodCell = collectionView.dequeueReusableCell(withReuseIdentifier: "foodHorizontalCell", for: indexPath) as! FoodCollectionViewCell
            
            let product = SignedUser.user.allFoods[indexPath.row]
            foodCell.foodNameTxtLbl.text = product.productName
            foodCell.FoodPriceTxtLbl.text = String(product.productPrice[0])
            foodCell.foodImageView.image = UIImage(named: product.productPicture)
            // İlk iki elemanı al ve virgülle ayırarak birleştir
            let firstTwoContents = product.productContents.prefix(2).joined(separator: ", ")

            // Label'a yazdır
            foodCell.foodContentTxtLbl.text = firstTwoContents
            
            foodCell.foodImageView.gestureRecognizers?.forEach(foodCell.foodImageView.removeGestureRecognizer)
            
            // Yeni bir UITapGestureRecognizer ekle
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(foodImageTapped(_:)))
            foodCell.foodImageView.isUserInteractionEnabled = true
            foodCell.foodImageView.addGestureRecognizer(tapGesture)
            tapGesture.view?.tag = indexPath.row
            return foodCell
            
        }
        return UICollectionViewCell()
    }

    @objc func imageTapped(_ sender: UITapGestureRecognizer) {
        guard let row = sender.view?.tag else { return }
        selectedProduct.product = SignedUser.user.allCoffees[row]
        performSegue(withIdentifier: "goToDetailVC", sender: nil)
    }

    @objc func foodImageTapped(_ sender: UITapGestureRecognizer) {
        guard let row = sender.view?.tag else { return }
        selectedProduct.product = SignedUser.user.allFoods[row]
        performSegue(withIdentifier: "goToDetailVC", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "goToDetailVC" {
                // Tıklanan UIImageView'ın bulunduğu hücreyi buluyoruz
                if let tapGesture = sender as? UITapGestureRecognizer,
                   let tappedImageView = tapGesture.view as? UIImageView,
                   let cell = tappedImageView.superview?.superview as? horizontalProductListCollectionViewCell,
                   let indexPath = collectionView.indexPath(for: cell) {
                    
                    // Hedef ViewController'a veri gönder
                    if let destinationVC = segue.destination as? detailsVC {
                        // Örneğin, seçilen hücrenin indexPath'ine göre işlem yapabilirsiniz
                        destinationVC.selectedImageIndex = indexPath.row
                    }
                }
            }
        }

    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var foodCollectionView: UICollectionView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var dessertsTextLbl: UILabel!
    @IBOutlet weak var drinksTextLbl: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        foodCollectionView.dataSource = self
        foodCollectionView.delegate = self
        collectionView.decelerationRate = .fast
        collectionView.isPagingEnabled = true
        foodCollectionView.decelerationRate = .fast
        foodCollectionView.isPagingEnabled = true
        
        print("allcoffee count\(SignedUser.user.allCoffees.count)")
        print("allfood count\(SignedUser.user.allFoods.count)")
        print("favorite count\(SignedUser.user.userFavorites.count)")
        
        
    }
    
  
    @IBAction func dessertsFilterBtnClc(_ sender: Any) {
        self.foodCollectionView.alpha = 1.0
        self.dessertsTextLbl.alpha = 1.0
        // 1. ScrollView'in en altına in
           let bottomOffset = CGPoint(x: 0, y: scrollView.contentSize.height - scrollView.bounds.height)
           scrollView.setContentOffset(bottomOffset, animated: true)
           
           // 2. CollectionView'i saydam yap
           UIView.animate(withDuration: 0.3) {
               self.collectionView.alpha = 0.3 // CollectionView saydamlığı
               self.drinksTextLbl.alpha = 0.3
           }
           
           // 3. 3 saniye sonra eski haline getir
           DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
               UIView.animate(withDuration: 0.3) {
                   self.collectionView.alpha = 1.0 // CollectionView tekrar tamamen görünür
                   self.drinksTextLbl.alpha = 1.0
               }
           }
    }
    @IBAction func drinksFilterBntClc(_ sender: Any) {
        self.collectionView.alpha = 1.0
        self.drinksTextLbl.alpha = 1.0
        // 1. ScrollView'in en üstüne git
            let topOffset = CGPoint(x: 0, y: 0)
            scrollView.setContentOffset(topOffset, animated: true)
            
            // 2. foodCollectionView'i görünmez yap
            UIView.animate(withDuration: 0.3) {
                self.foodCollectionView.alpha = 0.3
                self.dessertsTextLbl.alpha = 0.3
            }
            
            // 3. 3 saniye sonra eski haline getir
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                UIView.animate(withDuration: 0.3) {
                    self.foodCollectionView.alpha = 1.0 // Görünür yap
                    self.dessertsTextLbl.alpha = 1.0
                }
            }
    }
    
    
    @IBAction func showAllProductFilterBtnClc(_ sender: Any) {
        self.collectionView.alpha = 1.0
        self.foodCollectionView.alpha = 1.0
        self.dessertsTextLbl.alpha = 1.0
        self.drinksTextLbl.alpha = 1.0
        let topOffset = CGPoint(x: 0, y: 0)
        scrollView.setContentOffset(topOffset, animated: true)
    }
    
    
}

