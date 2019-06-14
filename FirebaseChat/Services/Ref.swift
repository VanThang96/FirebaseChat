//
//  Ref.swift
//  FirebaseChat
//
//  Created by win on 6/10/19.
//  Copyright © 2019 win. All rights reserved.
//

import Foundation
import Firebase

let REF_USER = "users"
let REF_MESSAGE = "messages"
let REF_USERMESSAGE = "user_message"
let REF_LATESTMESSAGE = "latest_message"
let URL_STORAGE = "gs://wchat-eaba7.appspot.com/"
let STORAGE_PROFILE = "profile"

protocol Reference : class{
    var databaseUser : DatabaseReference { get }
    func databaseSpecificUser (uid :String) -> DatabaseReference
    
    var databaseMessage : DatabaseReference { get }
    func databaseSpecificMessage (uid :String) -> DatabaseReference
    
    var databaseUserMessage : DatabaseReference { get }
    func databaseSpecificUserMessage (fromUID: String , toUID : String) -> DatabaseReference
    func databaseSpecificLatestMessage (fromUID: String , toUID : String) -> DatabaseReference
    
    var storageProfile : StorageReference { get }
    func storageSpecificProfile (uid : String) -> StorageReference
}
class Ref : Reference {
   
    static let sharedInstance = Ref()
    
    let databaseRoot = Database.database().reference()
    
    // user
    var databaseUser: DatabaseReference {
        return databaseRoot.child(REF_USER)
    }
    func databaseSpecificUser(uid: String) -> DatabaseReference {
        return databaseUser.child(uid)
    }
    
    // message
    var databaseMessage: DatabaseReference {
        return databaseRoot.child(REF_MESSAGE)
    }
    func databaseSpecificMessage(uid: String) -> DatabaseReference {
        return databaseUser.child(uid)
    }
    
    // user_message
    var databaseUserMessage: DatabaseReference {
        return databaseRoot.child(REF_USERMESSAGE)
    }
    func databaseSpecificUserMessage(fromUID: String , toUID : String) -> DatabaseReference {
        return databaseRoot.child("\(REF_USERMESSAGE)/\(fromUID)/\(toUID)")
    }
    
    // latest_message
    func databaseSpecificLatestMessage(fromUID: String, toUID: String) -> DatabaseReference {
        return databaseRoot.child("\(REF_LATESTMESSAGE)/\(fromUID)/\(toUID)")
    }
    func fetchLatestMessage(withUID : String) -> DatabaseReference {
        return databaseRoot.child("\(REF_LATESTMESSAGE)/\(withUID)")
    }
    
    //storage Reference
    let storageRoot = Storage.storage().reference(forURL: URL_STORAGE)
    var storageProfile: StorageReference {
        return storageRoot.child(STORAGE_PROFILE)
    }
    func storageSpecificProfile(uid: String) -> StorageReference {
        return storageProfile.child(uid)
    }
}
