import UIKit

class detailsCoffeePhotoImageView: UIImageView {

    override func layoutSubviews() {
        super.layoutSubviews()
        
        
        let path = UIBezierPath(roundedRect: bounds,
                                byRoundingCorners: [.bottomLeft, .bottomRight],
                                cornerRadii: CGSize(width: 50, height: 50))
        
      
        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        layer.mask = maskLayer
    }
}
