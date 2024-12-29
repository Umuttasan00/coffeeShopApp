import UIKit
import SwiftUI
import Drops
import Lottie
import UserNotifications

class MainViewController: UIViewController, UNUserNotificationCenterDelegate, UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SwipeImageCell.identifier, for: indexPath) as? SwipeImageCell else {
                  return UICollectionViewCell()
              }
              cell.configure(with: images[indexPath.item])
              return cell
    }
    
    // Resmi güncelleme fonksiyonu
    

    private var collectionView: UICollectionView!
      private var timer: Timer?
      private var currentIndex = 0
      
      private let images: [UIImage] = [
          UIImage(named: "reklam1")!,
          UIImage(named: "reklam6")!,
          UIImage(named: "reklam3")!,
          UIImage(named: "reklam4")!,
          UIImage(named: "reklam5")!,
          UIImage(named: "reklam2")!
      ]
    
    
    private var authVM: AuthVM!
    private var userVM: UserVM!
    @IBOutlet weak var coffeePointView: coffeePointBarView!
    @IBOutlet weak var freeCoffeeBar: UIProgressView!
    @IBOutlet weak var freeCoffeePointCounterTextLbl: UILabel!
    @IBOutlet weak var carouselView: UIView!
    
    
    
    let freeCoffeePoint = 9
    var freeCoffeePointFloat :Float = 0.0
    let imagesArray = ["reklam1", "reklam2", "reklam3", "reklam4", "reklam5", "reklam6"]  // assets klasöründeki resim isimlerini burada belirtin.
        
       

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userVM = myCoffeeShopApp.UserVM(user: SignedUser.user)
        checkNotificationSettings()

        requestNotificationPermission()
            setupCollectionView()
            startAutoScrollTimer()
        

        UNUserNotificationCenter.current().delegate = self
        
        func userNotificationCenter(_ center: UNUserNotificationCenter,
                                         willPresent notification: UNNotification,
                                         withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
                completionHandler([.banner, .sound])
            }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        coffeePointView.addGestureRecognizer(tapGesture)
        coffeePointView.isUserInteractionEnabled = true
     
       
        
        freeCoffeePointCounterTextLbl.text = "\(SignedUser.user.coffeeBean)/10"
        freeCoffeeBar.progress = Float(SignedUser.user.coffeeBean)/10
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.freeCoffeePointCounterTextLbl.text = "\(SignedUser.user.coffeeBean)/10"
            self.freeCoffeeBar.progress = Float(SignedUser.user.coffeeBean)/10
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.itemSize = CGSize(width: carouselView.frame.width, height: carouselView.frame.height)
            layout.invalidateLayout()
        }
    }

    
    @objc func handleTap() {
        performSegue(withIdentifier: "coffeePointView", sender: nil)
        userVM.sendNotification(title: "asdsa", body: "adasdadqeqwe")
    }
    
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.itemSize = CGSize(width: carouselView.frame.width, height: carouselView.frame.height)
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(SwipeImageCell.self, forCellWithReuseIdentifier: SwipeImageCell.identifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.isPagingEnabled = true
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        
        carouselView.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: carouselView.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: carouselView.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: carouselView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: carouselView.trailingAnchor)
        ])
    }

     
     private func startAutoScrollTimer() {
         // Reklam Süresi ayarla şu an 10
         timer = Timer.scheduledTimer(timeInterval: 10.0, target: self, selector: #selector(scrollToNextCell), userInfo: nil, repeats: true)
     }
     
    @objc private func scrollToNextCell() {
        guard !images.isEmpty else { return }
        currentIndex = (currentIndex + 1) % images.count
        let indexPath = IndexPath(item: currentIndex, section: 0)
        
        // Animasyonlu geçiş
        UIView.animate(withDuration: 0.5, animations: {
            self.collectionView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        }) { _ in
            self.collectionView.scrollToItem(at: indexPath, at: .centeredVertically, animated: false)
            UIView.animate(withDuration: 0.5) {
                self.collectionView.transform = .identity
            }
        }

    }
    // MARK: - UIScrollViewDelegate
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        guard let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        
        let cellHeight = layout.itemSize.height + layout.minimumLineSpacing
        let estimatedIndex = round(targetContentOffset.pointee.y / cellHeight)
        let indexPath = IndexPath(item: Int(estimatedIndex), section: 0)
        
        // Animasyonlu geçiş
        UIView.animate(withDuration: 0.5, animations: {
            self.collectionView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        }) { _ in
            self.collectionView.scrollToItem(at: indexPath, at: .centeredVertically, animated: false)
            UIView.animate(withDuration: 0.5) {
                self.collectionView.transform = .identity
            }
        }
    }



     
     deinit {
         timer?.invalidate()
     }
    

    
   

    func requestNotificationPermission() {
        // Bildirim izinlerini istemek
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            DispatchQueue.main.async {
                if granted {
                    print("Bildirim izni verildi.")
                } else {
                    if let error = error {
                        print("Bildirim izni istenirken hata oluştu: \(error.localizedDescription)")
                    } else {
                        print("Bildirim izni verilmedi.")
                    }
                }
            }
        }
    }
    func checkNotificationSettings() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            if settings.authorizationStatus == .authorized {
                print("Bildirimler izinli.")
            } else {
                print("Bildirim izni verilmedi.")
                // Kullanıcıyı ayarlara yönlendirmek için
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Bildirim İzni", message: "Bildirimleri almak için izin vermelisiniz. Lütfen ayarlara gidin.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ayarlara Git", style: .default, handler: { _ in
                        if let appSettings = URL(string: UIApplication.openSettingsURLString) {
                            UIApplication.shared.open(appSettings)
                        }
                    }))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
    }


    

  
    
}
