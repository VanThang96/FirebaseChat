//
//  ChatViewModel.swift
//  FirebaseChat
//
//  Created by win on 6/12/19.
//  Copyright © 2019 win. All rights reserved.
//

import Foundation
import UIKit

class MessageViewModel {
    var messages = [Message]()
    var messagesDictionary = [String  : Message]()
    func getMessageCount() -> Int{
        return messages.count
    }
    func getMessage(at index : Int) -> Message{
        return messages.sorted(by: {$0 < $1})[index]
    }
    
    func fetchAllMess(fromUID : String , toUID : String , onCompletion  : @escaping () -> ()){
        DatabaseServices.shareInstance.fetchMessage(fromUID: fromUID, toUID: toUID, onSucess: { [weak self](message) in
            self?.messages.append(message)
            onCompletion()
        }) { (error) in
            print(error)
        }
    }
    
    func fetchMessageWhenCreate(uid : String, onCompletion : @escaping () -> ()){
        DatabaseServices.shareInstance.fetchLatestMessageWhenCreate(uid: uid, onSuccess: { [weak self](message) in
            self?.messages.append(message)
            onCompletion()
        }) { (error) in
            print(error)
        }
    }
    func fetchMessageWhenChange(uid : String, onCompletion : @escaping () -> ()){
        DatabaseServices.shareInstance.fetchLatestMessageWhenChange(uid: uid, onSuccess: { [weak self](messageChange) in
            for (index,element) in (self?.messages.enumerated())!{
                if element.toUID == messageChange.toUID {
                    self?.messages[index] = messageChange
                }
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
    func estimateFrameForText(text : String) -> CGRect {
        let size = CGSize(width: 250, height: 1000)
        let option = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        let atributes = [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16)]
        return NSString(string: text).boundingRect(with: size, options: option, attributes: atributes, context: nil)
    }
}
