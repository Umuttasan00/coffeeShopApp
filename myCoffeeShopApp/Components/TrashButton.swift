import UIKit

class TrashButton: UIButton {
    
    // Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupButton()
    }
    
    // Buton ayarları
    private func setupButton() {
        // Arka plan rengi ve yuvarlak görünüm
        self.backgroundColor = .systemRed
        self.layer.cornerRadius = self.frame.size.width / 2
        self.clipsToBounds = true
        
        // Çöp kutusu simgesi
        let trashImage = UIImage(systemName: "trash") // SF Symbol kullanımı
        self.setImage(trashImage, for: .normal)
        self.tintColor = .white // Simge rengi
    }
    
    // Çerçeve ayarlandığında yuvarlak görünüm güncellenir
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = self.frame.size.width / 2
    }
}
