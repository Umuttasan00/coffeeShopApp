
import UIKit

class greyBgNonShadowView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    private func setupView() {
        
        layer.cornerRadius = frame.size.width / 8
        layer.masksToBounds = true
      
        layer.masksToBounds = false

    }
    

}

