//
//  StorageService.swift
//  FirebaseChat
//
//  Created by win on 6/12/19.
//  Copyright © 2019 win. All rights reserved.
//

import Foundation
import FirebaseStorage
import FirebaseAuth

class StorageService {
    
    static var shareInstance = StorageService()
    
    func savePhoto(imageData:Data, metadata :StorageMetadata, storageRef: StorageReference, onSuccess : @escaping (_ urlImage : String) -> (), onError : @escaping (_ errorMessage : String) -> ()){
        
        storageRef.putData(imageData, metadata: metadata, completion: { (storageMetadata, error) in
            if error != nil {
                onError(error!.localizedDescription)
                return
            }
            storageRef.downloadURL(completion: { (url, error) in
                guard let imageUrl = url?.absoluteString else{
                    return
                }
                onSuccess(imageUrl)
            })
        })
    }
}
