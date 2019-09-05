//
//  User.swift
//  FirebaseChat
//
//  Created by win on 6/10/19.
//  Copyright © 2019 win. All rights reserved.
//

import Foundation
import UIKit

struct User : Equatable {
    var uid : String?
    var userName : String?
    var emailAddress : String?
    var password : String?
    var image : String?
}
extension User : Codable {
    enum CodingKeys : String , CodingKey {
        case uid
        case userName
        case emailAddress
        case password
        case image
    }
    init(decoder  :Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let uid = try container.decode(String.self, forKey: .uid)
        let userName = try container.decode(String.self, forKey: .userName)
        let emailAddress = try container.decode(String.self, forKey: .emailAddress)
        let password = try container.decode(String.self, forKey: .password)
        let image = try container.decode(String.self, forKey: .image)
        
        self.init(uid : uid, userName: userName, emailAddress: emailAddress, password: password, image : image)
    }
}
struct UserLocal {
    var userName : String?
    var emailAddress : String?
    var password : String?
    var image : UIImage?
}
