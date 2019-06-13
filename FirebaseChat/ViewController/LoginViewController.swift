//
//  ViewController.swift
//  FirebaseChat
//
//  Created by win on 6/10/19.
//  Copyright © 2019 win. All rights reserved.
//
import Foundation
import UIKit
import SVProgressHUD

class LoginViewController: UIViewController {
    
    //MARK:- IBOutlet
    @IBOutlet weak var buttonLoginBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var txtEmailAddress: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    
    var userViewModel = UserViewModel()
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidAppear(_:)), name: UIResponder.keyboardDidHideNotification, object: nil)
    }
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
        txtEmailAddress.resignFirstResponder()
        txtPassword.resignFirstResponder()
    }
    
    @IBAction func didTapBackHome(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func didTapLoginButtonAction(_ sender: Any) {
        // check email address and password at here
        userViewModel.infor(name: nil, emailAddress: txtEmailAddress.text, password: txtPassword.text, image: nil)
        if let emailAddress = userViewModel.checkEmailAddress() {
            showAlertNotiCheckEmpty(noti: emailAddress)
        }else if let password = userViewModel.checkPassword() {
            showAlertNotiCheckEmpty(noti: password)
        }else {
            // SVProgressHUB waiting
            SVProgressHUD.setDefaultStyle(.custom)
            SVProgressHUD.setDefaultMaskType(.custom)
            SVProgressHUD.setBackgroundColor(UIColor.white)
            SVProgressHUD.setForegroundColor(UIColor(red: 52/255, green: 152/255, blue: 219/255, alpha: 1))
            SVProgressHUD.setBackgroundLayerColor(UIColor(white: 0, alpha: 0.6))
            SVProgressHUD.show()
            userViewModel.login(onSuccess: {[weak self] in
                SVProgressHUD.dismiss()
                // start HomeViewController
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.window?.rootViewController = UINavigationController(rootViewController:UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController)
                self?.navigationController?.popToRootViewController(animated: true)
            }) { [weak self](error) in
                SVProgressHUD.dismiss()
                self?.showAlertNotiCheckEmpty(noti: error)
            }
        }
    }
    
    fileprivate func setupUI(){
        //view background
        view.makeGradientForViewBackground(topColor: UIColor(named: "topColor")!, bottomColor: UIColor(named: "bottomColor")!)
        
        // button
        btnLogin.makeButtonWaitingEndEditText()
        
        //text feild
        txtEmailAddress.delegate = self
        txtPassword.delegate = self
        
    }
    
    
    /// reconstraint layout of button when keyboard Show
    @objc func keyboardWillAppear(_ notification : NSNotification){
        let info = notification.userInfo!
        let keyboardFrame: CGRect = (info[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        
        buttonLoginBottomConstraint.constant = keyboardFrame.height
    }
    /// reconstraint layout of button when keyboard Hidden
    @objc func keyboardDidAppear(_ notification : NSNotification){
        buttonLoginBottomConstraint.constant = 16
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    deinit {
        print("Deinit loginViewController")
    }
}
//MARK:- TextFieldDelegate
extension LoginViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        switch textField {
        case txtEmailAddress:
            txtEmailAddress.resignFirstResponder()
            txtPassword.becomeFirstResponder()
            break
        case txtPassword:
            txtPassword.resignFirstResponder()
            break
        default:
            break
        }
        return true
    }
}
