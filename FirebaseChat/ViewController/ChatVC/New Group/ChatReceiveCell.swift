//
//  ChatReceiveCell.swift
//  FirebaseChat
//
//  Created by win on 6/14/19.
//  Copyright © 2019 win. All rights reserved.
//

import UIKit

class ChatReceiveCell: UITableViewCell {

    @IBOutlet weak var lbContentChatReceive: UILabel!
    
    var message : Message? {
        didSet{
            lbContentChatReceive.text = message?.message
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
