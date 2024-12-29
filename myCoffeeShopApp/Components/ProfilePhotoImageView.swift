import UIKit

class ProfilePhotoImageView: UIImageView {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Make the image view circular
        layer.cornerRadius = self.frame.size.width / 2
        layer.masksToBounds = true
        
        // Add a white border
        layer.borderWidth = 2
        layer.borderColor = UIColor.white.cgColor
        
        // Ensure the image fills the view properly
        contentMode = .scaleAspectFill
    }
}
