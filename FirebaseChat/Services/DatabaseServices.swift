//
//  StorageService.swift
//  FirebaseChat
//
//  Created by win on 6/10/19.
//  Copyright © 2019 win. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseStorage

class DatabaseServices {
    
    static var shareInstance = DatabaseServices()
    
    func registerAccount(userLocal : UserLocal , onSuccess : @escaping ()->(),onError : @escaping (_ errorMessage: String)->()) {
        //register FirebaseAuth
        Auth.auth().createUser(withEmail: userLocal.emailAddress!, password: userLocal.password!) { (authDataResult, error) in
            
            if error != nil {
                onError(error!.localizedDescription)
                return
            }
            
            guard let uid = authDataResult?.user.uid else {
                return
            }
            
            // After authentication successful -> upload image data to server
            guard let imageData = userLocal.image?.jpegData(compressionQuality: 0.1) else {
                print("Error : Not convert image to data")
                return
            }
            
            let storageRef = Ref.sharedInstance.storageSpecificProfile(uid: uid)
            
            let metaDataImage = StorageMetadata()
            metaDataImage.contentType = "image/jpg"
            
            StorageService.shareInstance.savePhoto(imageData: imageData, metadata: metaDataImage, storageRef: storageRef, onSuccess: { (imageURL) in
                
                // upload account to firebase RealtimeDatabase
                let user = [
                    "uid" : uid,
                    "userName" : userLocal.userName,
                    "emailAddress" : userLocal.emailAddress,
                    "password" : userLocal.password,
                    "image" : imageURL
                ]
                //successfully auth user
                Ref.sharedInstance.databaseSpecificUser(uid: uid).setValue(user, withCompletionBlock: { (error, dataRef) in
                    if error != nil {
                        onError((error?.localizedDescription)!)
                        return
                    }
                    onSuccess()
                })
            }, onError: { (error) in
                onError(error)
            })
            
        }
    }
    func login(userLocal : UserLocal,onSuccess : @escaping (_ user : User)->(),onError : @escaping (_ errorMessage: String) -> ()){
        // login
        Auth.auth().signIn(withEmail: userLocal.emailAddress!, password: userLocal.password!) { (authDataResult, error) in
            if error != nil {
                onError(error!.localizedDescription)
            }
            
            guard let uid = authDataResult?.user.uid else {
                return
            }
            
            Ref.sharedInstance.databaseSpecificUser(uid: uid).observeSingleEvent(of: .value, with: { (dataSnapshot) in
                guard let value = dataSnapshot.value as? [String  : AnyObject] else {
                    return
                }
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: value, options: .prettyPrinted)
                    let user = try JSONDecoder().decode(User.self, from: jsonData)
                    onSuccess(user)
                }catch let error {
                    print("JSONDecoder: \(error.localizedDescription)")
                }
            })
        }
    }
    func fetchAllUsers(onSuccess : @escaping (_ user : [User]) -> () , onError : @escaping (_ errorMessage : String) -> ()){
        Ref.sharedInstance.databaseUser.observe(.value) { (datasnapshot) in
            guard let object = datasnapshot.children.allObjects as? [DataSnapshot] else { return }
            let dataObject = object.compactMap { $0.value as? [String: Any] }
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: dataObject, options: [])
                let users = try JSONDecoder().decode([User].self, from: jsonData)
                onSuccess(users)
            } catch let error {
                onError(error.localizedDescription)
            }
        }
    }
    func fetchUserById(with Id : String, onSucess : @escaping (_ user : User) -> (), onError : @escaping (_ errorMessage : String) -> ()){
        Ref.sharedInstance.databaseSpecificUser(uid: Id).observeSingleEvent(of: .value) { (dataSnapshot) in
            guard let value = dataSnapshot.value as? [String : AnyObject] else {
                print("Error_Firebase_Get_User_With_Id  : can't downcast dataSnapshot to Dictionanry ")
                return
            }
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: value, options: .prettyPrinted)
                let user = try JSONDecoder().decode(User.self, from: jsonData)
                onSucess(user)
            }catch let error{
                onError(error.localizedDescription)
            }
        }
    }
    func fetchMessage(onSucess : @escaping (_ message : Message) -> (), onError : @escaping (_ errorMessage : String) -> ()){
        Ref.sharedInstance.databaseMessage.observe(.childAdded) { (dataSnapshot) in
            guard let value = dataSnapshot.value as? [String : AnyObject] else {
                print("Error_Firebase_Message : can't downcast dataSnapshot to Dictionanry ")
                return
            }
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: value, options: .prettyPrinted)
                let message = try JSONDecoder().decode(Message.self, from: jsonData)
                onSucess(message)
            }catch let error{
                onError(error.localizedDescription)
            }
        }
    }
    /*func resetPassword(onSuccess : @escaping ()->(),onError : @escaping (_ errorMessage: String) -> ()){
     Auth.auth().sendPasswordReset(withEmail: user.emailAddress) { (error) in
     if error != nil{
     onError(error!.localizedDescription)
     }
     onSuccess()
     }
     }*/
    func sendMessageToFirebase(text : String, fromUID : String, toUID: String,timeStamp: Int, onSuccess : @escaping () -> (), onError : @escaping (_ errorMessage : String) -> ()){
        let message = [
            "fromUID" : fromUID,
            "toUID" : toUID,
            "message" : text,
            "timeStamp": timeStamp
            ] as [String : Any]
        Ref.sharedInstance.databaseMessage.childByAutoId().updateChildValues(message) { (error, dataRef) in
            if error != nil {
                onError((error?.localizedDescription)!)
                return
            }
            onSuccess()
        }
    }
}
