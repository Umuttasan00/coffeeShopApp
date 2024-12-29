import UIKit

class tabbar: UITabBar {

    override func awakeFromNib() {
        super.awakeFromNib()

        // Tab bar arka planı - parlak yarı saydam
        self.barTintColor = UIColor.white.withAlphaComponent(0.0) // Yarı saydam beyaz
        self.tintColor = .systemGreen // Aktif sekme rengi yeşil
        self.unselectedItemTintColor = .gray // Seçili olmayan sekmelerin rengi gri

        // Tab bar'ı şeffaf yap
        self.isTranslucent = true

        // Köşe yuvarlama işlemi
        self.layer.cornerRadius = 30
        self.layer.masksToBounds = true

        // Tab bar'ın safe area'ya değmemesi için kenar boşluğu ayarları
        if let superview = self.superview {
            // Safe area inset'leri al ve tab bar'ı uyumlu hale getir
            let safeAreaInsets = superview.safeAreaInsets
            self.frame = CGRect(x: self.frame.origin.x + safeAreaInsets.left,
                                y: self.frame.origin.y,
                                width: self.frame.size.width - safeAreaInsets.left - safeAreaInsets.right,
                                height: self.frame.size.height)
        }
    }

    // Özelleştirilmiş ikonları ve metinleri değiştirebilirsiniz
    func customizeTabBarItems() {
        for item in items ?? [] {
            item.setTitleTextAttributes([.font: UIFont.systemFont(ofSize: 14, weight: .medium)], for: .normal)
            item.setTitleTextAttributes([.font: UIFont.systemFont(ofSize: 14, weight: .bold)], for: .selected)
        }
    }
}
