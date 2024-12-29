import UIKit

class ProductListingView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    private func setupView() {
        layer.backgroundColor = UIColor.white.withAlphaComponent(0.3).cgColor

        let screenBounds = UIScreen.main.bounds

        layer.frame.size.height = screenBounds.height / 4
        layer.frame.size.width = screenBounds.width / 3
        
        layer.cornerRadius = frame.size.width / 8
        layer.masksToBounds = true
        
        layer.masksToBounds = false

    }
    
   
}
