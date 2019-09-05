//
//  Extensions.swift
//  FirebaseChat
//
//  Created by win on 6/10/19.
//  Copyright © 2019 win. All rights reserved.
//

import Foundation
import UIKit

extension UIButton {
    func makeButtonWaitingEndEditText(){
        self.layer.cornerRadius = self.frame.height / 2
        self.clipsToBounds = true
        
        
    }
}
extension UIView {
    func makeGradientForViewBackground(topColor : UIColor , bottomColor : UIColor){
        let gradient = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = [
            topColor.cgColor,
            bottomColor.cgColor
        ]
        gradient.locations = [0.0, 1.0]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 0, y: 1)
        self.layer.insertSublayer(gradient, at: 0)
    }
}
extension UIViewController {
    func showAlertNotiCheckEmpty(noti :String){
        let alert = UIAlertController(title: "Alert", message: noti, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
}
