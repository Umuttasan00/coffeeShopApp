//
//  ProfileViewController.swift
//  myCoffeeShopApp
//
//  Created by Muhammet Umut Taşan on 10.09.2024.
//

import UIKit
import Lottie
import PhotosUI

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var userSurnameLbl: UILabel!
    @IBOutlet weak var orderIsBeingPreparedAnimationView: LottieAnimationView!
    @IBOutlet weak var userProfilePhoto: ProfilePhotoImageView!
    @IBOutlet weak var favoriteOrderTextLbl: UILabel!
    @IBOutlet weak var favoriteBranchTextLbl: UILabel!
    @IBOutlet weak var coffeePointTextLbl: UILabel!
    
    
    
    private var authVM: AuthVM!
    private var userVM: UserVM!
    private let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("kart sayısı :\(SignedUser.user.userCreditCards.count)")
        userVM = myCoffeeShopApp.UserVM(user: SignedUser.user)
        favoriteOrderTextLbl.text = userVM.getFavoriteProductOnOrders()
        favoriteBranchTextLbl.text = userVM.getFavoriteBranchOnOrders()
        coffeePointTextLbl.text = "\(SignedUser.user.coffeeBean)/10"
        let animation = LottieAnimation.named("orderIsBeingPrepared")
        orderIsBeingPreparedAnimationView.animation = animation
        orderIsBeingPreparedAnimationView.loopMode = .autoReverse
        
        if !orderIsBeingPreparedAnimationView.isAnimationPlaying{
            orderIsBeingPreparedAnimationView.play()
        }
        
        userNameLbl.text = SignedUser.user.userName
        userSurnameLbl.text = SignedUser.user.userSurname
        
        authVM = myCoffeeShopApp.AuthVM(user: SignedUser.user)

        for cards in SignedUser.user.userCreditCards{
            print(cards.id)
            print(cards.name)
            print(cards.number)
        }
        // Add tap gesture to userProfilePhoto
          let tapGesture = UITapGestureRecognizer(target: self, action: #selector(selectProfilePhoto))
          userProfilePhoto.isUserInteractionEnabled = true
          userProfilePhoto.addGestureRecognizer(tapGesture)
          
          imagePicker.delegate = self
          imagePicker.sourceType = .photoLibrary
        
        // Mevcut profil fotoğrafını yükleyin
        if let profileImage = userVM.loadProfileImage() {
            userProfilePhoto.image = profileImage
        }
    }
    @objc func selectProfilePhoto() {
         present(imagePicker, animated: true, completion: nil)
     }
    // MARK: - UIImagePickerControllerDelegate
       func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
           picker.dismiss(animated: true, completion: nil)
           
           guard let selectedImage = info[.originalImage] as? UIImage else {
               print("No image selected")
               return
           }
           
           // Display the selected image
           userProfilePhoto.image = selectedImage
           userVM.saveProfileImage(image: selectedImage)
                  
           // Generate UUID for the image
           if let imageData = selectedImage.jpegData(compressionQuality: 0.8) {
               let uuid = UUID().uuidString
               let imageString = imageData.base64EncodedString()
               print("UUID: \(uuid)")
               print("Base64 Image String: \(imageString)")
               
               // You can send uuid and imageString to your backend here
           }
       }
       
       func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
           picker.dismiss(animated: true, completion: nil)
       }
    

    @IBAction func profileSettingsBtnClc(_ sender: Any) {
        self.performSegue(withIdentifier: "showSettings", sender: nil)
    }
    
    @IBAction func logoutBtnClc(_ sender: Any) {
        self.authVM.userLogOut()
        self.performSegue(withIdentifier: "logoutSegue", sender: nil)
    }
    
    
    @IBAction func addCardBtnClc(_ sender: Any) {
        self.performSegue(withIdentifier: "goAddCardSegue", sender: nil)
    }
    
}
