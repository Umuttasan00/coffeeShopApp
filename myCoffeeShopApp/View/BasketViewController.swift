
import UIKit
import Drops
class BasketViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        SignedUser.user.userOrders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! BasketTableViewCell
        
        let product = SignedUser.user.userOrders[indexPath.row]
        
        cell.productNameOnBasket.text = product.productName
        cell.productSizeOnBasket.text = product.productSize[0]
        cell.productPriceOnBasket.text = "\(product.productPrice[0]) ₺"
        cell.productImageOnBasket.image = UIImage(named: product.productPicture)
        
        cell.removeProductOnBasketBtnClcted = { [weak self] in
            self?.removeProductOnBasketBtnClc(indexPath: indexPath)
        }
        
        return cell
    }
    

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var confirmBasketBtn: UIButton!
    @IBOutlet weak var totalPriceOfBasketLbl: UILabel!
    let userVM = UserVM(user : SignedUser.user)
    let basketIsEmpty = Drop(title: "⚠️", subtitle: "Sepetiniz boş.", duration: 2.00)
  var totalPriceOfBasket: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        startUpdatingBasketData()
        print("kahve çekirdeği: \(SignedUser.user.coffeeBean)")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
        for product in SignedUser.user.userOrders {
            totalPriceOfBasket += product.productPrice[0]
        }
        totalPriceOfBasketLbl.text = "\(totalPriceOfBasket) ₺"
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
    }
    override func viewWillDisappear(_ animated: Bool) {
        totalPriceOfBasket = 0
    }
    
    func startUpdatingBasketData() {
        Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateBasketData), userInfo: nil, repeats: true)
    }
    @objc func updateBasketData() {
        totalPriceOfBasket = 0
        // Sepetteki tüm ürünlerin fiyatlarını topla
        for product in SignedUser.user.userOrders {
            totalPriceOfBasket += product.productPrice[0]
        }
        
        // Toplam fiyatı güncelle
        totalPriceOfBasketLbl.text = "\(totalPriceOfBasket) ₺"
        
        // TableView'ı güncelle
        tableView.reloadData()
    }


    
    func removeProductOnBasketBtnClc(indexPath: IndexPath){
        
        print("\(SignedUser.user.userOrders[indexPath.row].productPrice[0])")
        userVM.removeProductOnBasket(userEmail: SignedUser.user.userEmail,
                                     product: SignedUser.user.userOrders[indexPath.row]) { sccss in
            if sccss{
                print("success")
                self.totalPriceOfBasket = 0
                for product in SignedUser.user.userOrders {
                    self.totalPriceOfBasket += product.productPrice[0]
                }
                self.totalPriceOfBasketLbl.text = "\(self.totalPriceOfBasket) ₺"
            }else{
                print("error")
            }
            
        }
        self.tableView.deleteRows(at: [indexPath], with: .fade)
        self.tableView.reloadData()
    }
    
    @IBAction func confirmBasketBtnClc(_ sender: Any) {
        if SignedUser.user.userOrders.isEmpty{
            Drops.show(basketIsEmpty)
        }else{
            self.performSegue(withIdentifier: "confirmBasketBtnClc", sender: totalPriceOfBasket)
        }
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "confirmBasketBtnClc", let totalPrice = sender as? Int {
            let destinationVC = segue.destination as? ConfirmBasketViewController
            destinationVC?.receivedTotalPrice = totalPrice
        }
    }

    

}
