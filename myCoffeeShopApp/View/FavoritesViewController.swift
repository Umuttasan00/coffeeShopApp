
import UIKit

class FavoritesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        SignedUser.user.userFavorites.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavoritesCell", for: indexPath) as! FavoritesTableViewCell
        cell.favoriteProductName.text = SignedUser.user.userFavorites[indexPath.row].productName
        cell.favoriteProductDesc.text = SignedUser.user.userFavorites[indexPath.row].productDesc
        cell.favoriteProductImage.image = UIImage(named: SignedUser.user.userFavorites[indexPath.row].productPicture)
        
        cell.removeFavoritesButtonClc = { [weak self] in
            self?.addBasketBtnClc(indexPath: indexPath)
        }
        
        return cell
    }
    
    func addBasketBtnClc(indexPath: IndexPath){
        self.userVM.removeFavoriteProduct(userEmail: SignedUser.user.userEmail,
                                          productName: SignedUser.user.userFavorites[indexPath.row].productName) { sccss in
            if sccss{
                print("ürün favorilerden silindi favScreen")
                self.favoritesTableView.deleteRows(at: [indexPath], with: .fade)
                self.favoritesTableView.reloadData()
                self.showFavoritesIsEmptyLabel()
               
                
            }else{
                    print("Ürün silinirken hata favScreen")
                }
            
        }
    }
    
    

    
    @IBOutlet weak var favoritesIsEmptyLabel: UILabel!
    @IBOutlet weak var favoritesTableView: UITableView!
    
    let userVM = UserVM(user : SignedUser.user)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        favoritesTableView.delegate = self
        favoritesTableView.dataSource = self
        showFavoritesIsEmptyLabel()
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
    }
    


    @IBAction func backBtnClc(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func showFavoritesIsEmptyLabel() {
        if SignedUser.user.userFavorites.isEmpty {
            UIView.animate(withDuration: 0.3) {
                self.favoritesIsEmptyLabel.alpha = 1.0
                self.favoritesTableView.alpha = 0.0
            } completion: { _ in
                self.favoritesIsEmptyLabel.isHidden = false
                self.favoritesTableView.isHidden = true
            }
        } else {
            UIView.animate(withDuration: 0.3) {
                self.favoritesIsEmptyLabel.alpha = 0.0
                self.favoritesTableView.alpha = 1.0
            } completion: { _ in
                self.favoritesIsEmptyLabel.isHidden = true
                self.favoritesTableView.isHidden = false
            }
        }
    }
}
