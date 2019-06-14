//
//  HomeCollectionViewCell.swift
//  FirebaseChat
//
//  Created by win on 6/11/19.
//  Copyright © 2019 win. All rights reserved.
//

import UIKit
import SDWebImage

class HomeCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imvAvatar: UIImageView!
    @IBOutlet weak var lbUserName: UILabel!
    @IBOutlet weak var lbNewText: UILabel!
    @IBOutlet weak var lbtimeStamp: UILabel!
    
    lazy var indicator : UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .white)
        indicator.center = imvAvatar.center
        indicator.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        indicator.hidesWhenStopped = true
        indicator.color = .white
        return indicator
    }()
    var user : User?{
        didSet{
            DispatchQueue.main.async{[weak self] in
                self?.lbUserName.text = self?.user?.userName
                self?.imvAvatar.sd_setImage(with: URL(string: (self?.user?.image)!), placeholderImage: nil, options: SDWebImageOptions.progressiveDownload) { [weak self](image, error, SDImageCache, url) in
                    self?.indicator.removeFromSuperview()
                }
            }
        }
    }
    var message : Message?{
        didSet{
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "hh:mm a"
            lbtimeStamp.text = dateFormatter.string(from: Date(timeIntervalSince1970: TimeInterval((message?.timeStamp)!)))
            lbNewText.text = message?.message
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        
        imvAvatar.layer.cornerRadius = imvAvatar.frame.height / 2
        imvAvatar.backgroundColor = .gray
        imvAvatar.clipsToBounds = true
        
        indicator.center = CGPoint(x: imvAvatar.center.x, y: imvAvatar.center.y - 35)
        indicator.startAnimating()
        addSubview(indicator)
        
    }
}

