import UIKit

class SwipeImageCell: UICollectionViewCell {
    static let identifier = "SwipeImageCell"
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        
        // Hücre ve içeriğin köşe yuvarlama ayarları
        contentView.layer.cornerRadius = 12
        contentView.layer.masksToBounds = true
        contentView.backgroundColor = .clear // İçerik görünümü şeffaf
        
        // Gölge efektleri için dış katman
        layer.cornerRadius = 12
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.1
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 4
        layer.masksToBounds = false
        backgroundColor = .clear // Hücre arkaplanı şeffaf
        
        // Adding tap gesture recognizer to imageView
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tapGesture)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = contentView.bounds
    }
    
    func configure(with image: UIImage) {
        imageView.image = image
    }
    
    // Tap gesture handler
    @objc private func handleTapGesture() {
        print("Image tapped!")
        if imageView.image == UIImage(named: "reklam2") {
            print("go instagram abijimm")
            openInstagramProfile(with: "espressolabtr")
        }
        // You can add any action here when the image is tapped
    }
    
    
    func openInstagramProfile(with nickname: String) {
        let instagramURL = URL(string: "https://www.instagram.com/\(nickname)/")!
        
        if UIApplication.shared.canOpenURL(instagramURL) {
            UIApplication.shared.open(instagramURL, options: [:], completionHandler: nil)
        } else {
            print("Instagram is not installed or the URL is invalid.")
        }
    }

}
