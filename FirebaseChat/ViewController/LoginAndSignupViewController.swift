//
//  LoginAndSignupViewController.swift
//  FirebaseChat
//
//  Created by win on 6/10/19.
//  Copyright © 2019 win. All rights reserved.
//

import UIKit

class LoginAndSignupViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
    }
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    override func viewWillLayoutSubviews() {
        setupUI()
    }
    fileprivate func setupUI(){
        view.makeGradientForViewBackground(topColor: UIColor(named: "topColor")!, bottomColor: UIColor(named: "bottomColor")!)
    }
    deinit {
        print("Deinit login and sign up ViewController")
    }
}
