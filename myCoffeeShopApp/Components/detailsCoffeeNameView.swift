import UIKit

class detailsCoffeeNameView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    

    private func setupView() {
        
        backgroundColor = UIColor.white.withAlphaComponent(0.84)

       
        layer.cornerRadius = 50

    
    }
}
