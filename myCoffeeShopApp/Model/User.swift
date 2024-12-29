
import Foundation

struct User {
    
    var userName : String
    var userSurname : String
    var userEmail : String
    var userPhoneNumber : String
    var userAddress : String
    var userGender : String
    var coffeeBean : Int
    
    var userCreditCards : [CreditCard] = []
    var userFavorites : [Product] = []
    var userOrders : [Product] = []
    var allCoffees : [Product] = []
    var allFoods : [Product] = []
    var orderHistory : [Orders] = []
    
    }
