//
//  Message.swift
//  FirebaseChat
//
//  Created by win on 6/12/19.
//  Copyright © 2019 win. All rights reserved.
//

import Foundation


protocol Comp {
    static func < (lhs : Self , rhs : Self) -> Bool
}
struct Message : Comp {
    var fromUID : String?
    var message : String?
    var timeStamp : Int?
    var toUID  : String?
    
    static func < (lhs: Message, rhs: Message) -> Bool {
        return lhs.timeStamp! < rhs.timeStamp!
    }
}
extension Message : Decodable {
    enum CodingKeys : String , CodingKey {
        case fromUID
        case message
        case timeStamp
        case toUID
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let fromUID = try container.decode(String.self, forKey: .fromUID)
        let message = try container.decode(String.self, forKey: .message)
        let timeStamp = try container.decode(Int.self, forKey: .timeStamp)
        let toUID = try container.decode(String.self, forKey: .toUID)
        
        self.init(fromUID: fromUID, message: message, timeStamp: timeStamp, toUID: toUID)
    }
}
