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
let URL_STORAGE = "gs://wchat-eaba7.appspot.com/"
let STORAGE_PROFILE = "profile"

protocol Reference : class{
    var databaseUser : DatabaseReference { get }
    func databaseSpecificUser (uid :String) -> DatabaseReference
    
    var databaseMessage : DatabaseReference { get }
    func databaseSpecificMessage (uid :String) -> DatabaseReference
    
    var storageProfile : StorageReference { get }
    func storageSpecificProfile (uid : String) -> StorageReference
}
class Ref : Reference {
    static let sharedInstance = Ref()
    
    let databaseRoot = Database.database().reference()
    
    var databaseUser: DatabaseReference {
        return databaseRoot.child(REF_USER)
    }
    func databaseSpecificUser(uid: String) -> DatabaseReference {
        return databaseUser.child(uid)
    }
    
    var databaseMessage: DatabaseReference {
        return databaseRoot.child(REF_MESSAGE)
    }
    func databaseSpecificMessage(uid: String) -> DatabaseReference {
        return databaseUser.child(uid)
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
