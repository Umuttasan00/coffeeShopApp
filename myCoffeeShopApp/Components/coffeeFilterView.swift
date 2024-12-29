
import UIKit

class coffeeFilterView: UIView {

    override func layoutSubviews() {
        super.layoutSubviews()

        // Sağ üst köşe için radius ayarı
        let path = UIBezierPath(roundedRect: self.bounds,
                                byRoundingCorners: [.topRight], // Sadece sağ üst köşe
                                cornerRadii: CGSize(width: 20, height: 20)) // Köşe yarıçapı
        
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
        
        // Gölge ayarları
        self.layer.shadowColor = UIColor.black.cgColor // Siyah gölge rengi
        self.layer.shadowOpacity = 0.5 // Gölgenin opaklığı (0.0 ile 1.0 arasında)
        self.layer.shadowOffset = CGSize(width: 5, height: 5) // Gölgenin pozisyonu
        self.layer.shadowRadius = 10 // Gölgenin yayılma alanı (blur etkisi)
        
        // Performans için gölge alanını optimize etmek için shadowPath
        self.layer.shadowPath = path.cgPath
    }
}

