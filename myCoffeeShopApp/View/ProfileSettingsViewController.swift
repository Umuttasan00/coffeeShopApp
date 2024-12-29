//
//  ProfileSettingsViewController.swift
//  myCoffeeShopApp
//
//  Created by Muhammet Umut Taşan on 5.12.2024.
//

import UIKit

class ProfileSettingsViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        SignedUser.user.userCreditCards.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // Hücreyi tanımlayıcı ile dequeuing yapın
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "horizontalCardsCell", for: indexPath) as! creditCardsCollectionViewCell
        let cart = SignedUser.user.userCreditCards[indexPath.row]
        cell.cartNoLbl.text = cart.number
        cell.ownerNameLbl.text = cart.name
        cell.cvcLbl.text = cart.cvc
        cell.dateLbl.text = cart.expirationDate
        cell.removeCardBtnClc = { [weak self] in
            self?.removeBtnClc(indexPath: indexPath)
        }
        
        
        return cell
    }

    
    
    ///labels
    @IBOutlet weak var nameSurnameLbl: UILabel!
    @IBOutlet weak var phoneNumberLbl: UILabel!
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var genderLbl: UILabel!
    @IBOutlet weak var addressLbl: UILabel!
    
    @IBOutlet weak var horizontalCardsCollectionView: UICollectionView!
    
    let userVM = UserVM(user : SignedUser.user)
    override func viewDidLoad() {
        super.viewDidLoad()
        
        horizontalCardsCollectionView.dataSource = self
        horizontalCardsCollectionView.delegate = self
        horizontalCardsCollectionView.decelerationRate = .fast 
        horizontalCardsCollectionView.isPagingEnabled = true
        let user = SignedUser.user
        nameSurnameLbl.text = user.userName + " " + user.userSurname
        phoneNumberLbl.text = user.userPhoneNumber
        emailLbl.text = user.userEmail
        genderLbl.text = user.userGender
        addressLbl.text = user.userAddress
        
      
        
    }
    
    func removeBtnClc(indexPath: IndexPath){
        userVM.deleteCardOnDatabase(userEmail: SignedUser.user.userEmail, cardId: SignedUser.user.userCreditCards[indexPath.row].id) { sccss in
            if sccss{
                print("card deleted")
                SignedUser.user.userCreditCards.remove(at: indexPath.row)
                self.horizontalCardsCollectionView.reloadData()
            }else{
                print("error")
            }
        }
    }
    


}
