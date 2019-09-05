//
//  UserCollectionViewCell.swift
//  FirebaseChat
//
//  Created by win on 6/13/19.
//  Copyright © 2019 win. All rights reserved.
//

import UIKit
import SDWebImage

class UserCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imvAvatar: UIImageView!
    @IBOutlet weak var lbUserName: UILabel!
    @IBOutlet weak var lbUserEmail: UILabel!
    
    lazy var indicator : UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .white)
        indicator.center = imvAvatar.center
        indicator.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        indicator.hidesWhenStopped = true
        indicator.color = .white
        return indicator
    }()
    var user : User? {
        didSet{
            DispatchQueue.main.async{[weak self] in
                self?.lbUserName.text = self?.user?.userName
                self?.lbUserEmail.text = self?.user?.emailAddress
                self?.imvAvatar.sd_setImage(with: URL(string: (self?.user?.image)!), placeholderImage: nil, options: SDWebImageOptions.fromCacheOnly) { [weak self](image, error, SDImageCache, url) in
                    self?.indicator.removeFromSuperview()
                }
            }
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        imvAvatar.layer.cornerRadius = imvAvatar.frame.height / 2
        imvAvatar.backgroundColor = .gray
        imvAvatar.clipsToBounds = true
        
        indicator.center = imvAvatar.center
        indicator.startAnimating()
        addSubview(indicator)
    }

}
