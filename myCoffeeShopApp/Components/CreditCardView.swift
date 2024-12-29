import UIKit

class CreditCardView: UIView {
    
    // Kart üzerindeki bilgiler
    private let cardNumberLabel = UILabel()
    private let cardHolderLabel = UILabel()
    private let expiryDateLabel = UILabel()
    private let cvvLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCardView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupCardView()
    }
    
    private func setupCardView() {
        // View tasarımı
        self.backgroundColor = .systemBlue
        self.layer.cornerRadius = 15
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.2
        self.layer.shadowOffset = CGSize(width: 0, height: 5)
        self.layer.shadowRadius = 10
        
       
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
       
    }
    
   
}
