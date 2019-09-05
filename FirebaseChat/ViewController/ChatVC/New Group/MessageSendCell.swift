//
//  ChatMessageCell.swift
//  FirebaseChat
//
//  Created by win on 6/15/19.
//  Copyright © 2019 win. All rights reserved.
//
    
import UIKit

class MessageSendCell: UICollectionViewCell {
    
    var message : Message? {
        didSet{
            textView.text = message?.message
        }
    }
    
    lazy var textView : UITextView = {
       let tv = UITextView()
        tv.text = "text view buble"
        tv.font = UIFont.systemFont(ofSize: 16)
        tv.textColor = .white
        tv.backgroundColor = .clear
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    lazy var bubleView : UIView = {
        let view = UIView()
        view.backgroundColor = .blue
        view.layer.cornerRadius = 18
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var bubbleWidthAnchor : NSLayoutConstraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(bubleView)
        addSubview(textView)
        
        // bubleView constaint
        bubleView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16).isActive = true
        bubleView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        bubbleWidthAnchor = bubleView.widthAnchor.constraint(equalToConstant: 250)
        bubbleWidthAnchor?.isActive = true
        bubleView.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
        
        // textView constaint
        textView.trailingAnchor.constraint(equalTo: bubleView.trailingAnchor, constant: -8).isActive = true
        textView.leadingAnchor.constraint(equalTo: bubleView.leadingAnchor, constant: 8).isActive = true
        textView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        textView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
