//
//  ChatViewModel.swift
//  FirebaseChat
//
//  Created by win on 6/12/19.
//  Copyright © 2019 win. All rights reserved.
//

import Foundation

class MessageViewModel {
    var messages = [Message]()
    var messagesDictionary = [String  : Message]()
    func getMessageCount() -> Int{
        return messages.count
    }
    func getMessage(at index : Int) -> Message{
        return messages.sorted(by: {$0 > $1})[index]
    }
    func fetchMessage(onCompletion : @escaping () -> ()){
        DatabaseServices.shareInstance.fetchMessage(onSucess: { [weak self](message) in
            if let toUID = message.toUID {
                self?.messagesDictionary[toUID] = message
                self?.messages = Array((self?.messagesDictionary.values)!)
            }
            onCompletion()
        }) { (error) in
            print(error)
        }
    }
    func fetchUserById(with Id : String,onCompletion : @escaping (_ user : User) -> ()){
        DatabaseServices.shareInstance.fetchUserById(with: Id, onSucess: { (user) in
            onCompletion(user)
        }) { (error) in
            print(error)
        }
    }
}
