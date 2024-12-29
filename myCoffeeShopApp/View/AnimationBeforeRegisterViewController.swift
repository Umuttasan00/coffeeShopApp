import UIKit
import Lottie

class AnimationBeforeRegisterViewController: UIViewController {
    @IBOutlet weak var animationView: LottieAnimationView!
    
    private var productVM: ProductVM!
    override func viewDidLoad() {
        super.viewDidLoad()

        let animation = LottieAnimation.named("coffeeLoadingAnim")
        animationView.animation = animation
        animationView.loopMode = .playOnce
        
        productVM = myCoffeeShopApp.ProductVM()
        productVM.getProductsOnDB { sccss in
            if sccss{
                self.performSegue(withIdentifier: "goRegisterAfterAnimation", sender: nil)
            }
        }
        
        
        animationView.play { (finished) in
            if finished {
               
            }
        }
    }
    
}
