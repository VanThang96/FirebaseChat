//
//  UserViewModel.swift
//  FirebaseChat
//
//  Created by win on 6/10/19.
//  Copyright © 2019 win. All rights reserved.
//

import Foundation
import UIKit

class UserViewModel {
    var userLocal = UserLocal()
    var users = [User]()
    
    func infor(name : String?, emailAddress : String?, password : String?, image : UIImage?){
        self.userLocal.userName = name
        self.userLocal.emailAddress = emailAddress
        self.userLocal.password = password
        self.userLocal.image = image
    }
    func getUserCount() -> Int {
        return users.count
    }
    func getUser(at Index : Int) -> User {
        return users[Index]
    }
    func checkAvatarImage() -> String? {
        if userLocal.image == nil {
            return "Avatar must be not empty!"
        }
        return nil
    }
    func checkEmailAddress() -> String? {
        if userLocal.emailAddress!.count == 0 {
            return "Email must be not empty!"
        }
        if !isValidEmail(testStr: userLocal.emailAddress!) {
            return "Email is invalid!"
        }
        return nil
    }
    func checkFullName() -> String? {
        if userLocal.userName!.count == 0 {
            return "Fullname must be not empty!"
        }
        return nil
    }
    func checkPassword() -> String? {
        if userLocal.password!.count >= 0 && userLocal.password!.count < 8 {
            return "Password must be least 8 characters!"
        }
        return nil
    }
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    func registerAccount(onSuccess : @escaping () -> () , onError : @escaping (_ errorMessage : String) -> ()){
        DatabaseServices.shareInstance.registerAccount(userLocal: userLocal, onSuccess: {
            onSuccess()
        }) { (error) in
            onError(error)
        }
    }
    func login(onSuccess : @escaping () -> () , onError : @escaping (_ errorMessage : String) -> ()){
        DatabaseServices.shareInstance.login(userLocal: userLocal, onSuccess: { (user) in
            // save user data
            UserDefaults.standard.set(try? PropertyListEncoder().encode(user), forKey: "userInfo")
            onSuccess()
        }) { (error) in
            onError(error)
        }
    }
    func fetchUsers(onCompletion : @escaping () -> ()){
        DatabaseServices.shareInstance.fetchAllUsers(onSuccess: { [weak self](users) in
            self?.users = users
            onCompletion()
        }) { (error) in
            print(error)
        }
    }
    
}
