import UIKit

class AnimatedButton: UIButton {
    
    // Başlangıç konumunu ayarlamak için initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupButton()
    }
    
    // Butonun başlangıç ayarları
    private func setupButton() {
        self.setTitle("Tap Me", for: .normal)
        self.backgroundColor = .systemBlue
        self.setTitleColor(.white, for: .normal)
        self.layer.cornerRadius = 10
        self.alpha = 0 // Başlangıçta görünmez
    }
    
    // Animasyon fonksiyonu
    func animateFromTop(to position: CGPoint, duration: TimeInterval = 1.0) {
        // Başlangıç pozisyonunu ekranın üst kısmına ayarla
        self.transform = CGAffineTransform(translationX: 0, y: -UIScreen.main.bounds.height)
        
        // Animasyon
        UIView.animate(withDuration: duration,
                       delay: 0,
                       usingSpringWithDamping: 0.6,
                       initialSpringVelocity: 1.0,
                       options: [.curveEaseInOut]) {
            // Butonu hedef pozisyona taşı
            self.transform = .identity
            self.alpha = 1 // Görünür yap
            self.center = position
        }
    }
}
