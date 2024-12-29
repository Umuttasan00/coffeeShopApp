import UIKit

class GradientBackgroundView: UIView {

    private var gradientLayer: CAGradientLayer!

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupGradient()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupGradient()
    }

    func setupGradient() {
        gradientLayer = CAGradientLayer()

        
        gradientLayer.colors = [
            UIColor.brown.cgColor,
            UIColor.white.cgColor
        ]

        
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)

        
        self.layer.insertSublayer(gradientLayer, at: 0)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        gradientLayer.frame = self.bounds
    }
}
