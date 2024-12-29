import UIKit

class customGreyButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupButton()
    }

    private func setupButton() {
        
        // Köşe yuvarlama
        layer.cornerRadius = 15
        layer.masksToBounds = true
        
        // Gölge ekleme
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.4
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 4
        layer.masksToBounds = false
        
        // Kenarlık ekleme
        layer.borderWidth = 1.0
        layer.borderColor = UIColor.black.cgColor
        
        // Buton yazı tipi ve rengi
        setTitleColor(.darkGray, for: .normal)
        titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        tintColor = UIColor.black
    }
}
