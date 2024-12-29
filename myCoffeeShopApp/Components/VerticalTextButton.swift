import UIKit

class VerticalTextButton: UIButton {
    override func layoutSubviews() {
        super.layoutSubviews()

        // Metni dikey olarak döndür (90 derece)
        self.titleLabel?.transform = CGAffineTransform(rotationAngle: -(CGFloat.pi / 2))
        
    }
}
