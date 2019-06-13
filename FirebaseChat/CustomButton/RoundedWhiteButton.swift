//
//  RoundedWhiteButton.swift
//  FirebaseChat
//
//  Created by win on 6/10/19.
//  Copyright © 2019 win. All rights reserved.
//

import Foundation
import UIKit

class RoundedWhiteButton : UIButton {
    
    override var isHighlighted: Bool {
        didSet {
            backgroundColor = isHighlighted ? .white : .clear
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override func awakeFromNib() {
        setup()
    }
    func setup(){
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.borderWidth = 2.0
        self.layer.cornerRadius = self.frame.height / 2
        self.clipsToBounds = true
    }
}
