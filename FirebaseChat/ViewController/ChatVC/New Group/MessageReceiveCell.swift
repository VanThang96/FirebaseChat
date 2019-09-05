//
//  MessageReceiveCell.swift
//  FirebaseChat
//
//  Created by win on 6/16/19.
//  Copyright © 2019 win. All rights reserved.
//

import UIKit

class MessageReceiveCell: UICollectionViewCell {
    
    var user : User? {
        didSet{
            DispatchQueue.main.async {[weak self] in
                self?.profileImageView.sd_setImage(with: URL(string: (self?.user?.image)!), completed: nil)
            }
        }
    }
    var message : Message? {
        didSet{
            textView.text = message?.message
        }
    }
    lazy var textView : UITextView = {
        let tv = UITextView()
        tv.font = UIFont.systemFont(ofSize: 16)
        tv.textColor = .black
        tv.backgroundColor = .clear
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    lazy var bubleView : UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.layer.cornerRadius = 18
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var profileImageView : UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "tony")
        image.layer.cornerRadius = 16
        image.layer.masksToBounds = true
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    var bubbleWidthAnchor : NSLayoutConstraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(profileImageView)
        addSubview(bubleView)
        addSubview(textView)
        
        //imageView Profile
        profileImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8).isActive = true
        profileImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 32).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 32).isActive = true
        
        // bubleView constaint
        bubleView.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 8).isActive = true
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
