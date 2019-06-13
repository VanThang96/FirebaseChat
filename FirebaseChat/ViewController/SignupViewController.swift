//
//  SignupViewController.swift
//  FirebaseChat
//
//  Created by win on 6/10/19.
//  Copyright © 2019 win. All rights reserved.
//

import UIKit
import SVProgressHUD

class SignupViewController: UIViewController {
    //MARK:- IBOutlet
    @IBOutlet weak var buttonSignupBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var btnSignup: UIButton!
    @IBOutlet weak var txtUsername: UITextField!
    @IBOutlet weak var txtEmailAddress: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var imvAvatar: UIImageView!
    @IBOutlet weak var lbAddPhoto: UILabel!
    
    var image : UIImage!
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
        txtUsername.resignFirstResponder()
        txtEmailAddress.resignFirstResponder()
        txtPassword.resignFirstResponder()
    }
    
    @IBAction func didTapBackHome(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func didTapLoginButtonAction(_ sender: Any) {
        userViewModel.infor(name: txtUsername.text, emailAddress: txtEmailAddress.text, password: txtPassword.text, image: image)
        if let checkImagePickered = userViewModel.checkAvatarImage(){
            showAlertNotiCheckEmpty(noti: checkImagePickered)
        }else if let userName = userViewModel.checkFullName() {
            showAlertNotiCheckEmpty(noti: userName)
        }else if let emailAddress = userViewModel.checkEmailAddress() {
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
            userViewModel.registerAccount(onSuccess: {[weak self] in
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
        btnSignup.makeButtonWaitingEndEditText()
        
        //text feild
        txtUsername.delegate = self
        txtEmailAddress.delegate = self
        txtPassword.delegate = self
        
        //image picker
        imvAvatar.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handlePickerImage))
        imvAvatar.addGestureRecognizer(tapGesture)
    }
    
    @objc func handlePickerImage(){
        let pickerVC = UIImagePickerController()
        pickerVC.delegate = self
        pickerVC.allowsEditing = true
        present(pickerVC, animated: true, completion: nil)
    }
    
    /// reconstraint layout of button when keyboard Show
    @objc func keyboardWillAppear(_ notification : NSNotification){
        let info = notification.userInfo!
        let keyboardFrame: CGRect = (info[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        
        buttonSignupBottomConstraint.constant = keyboardFrame.height
    }
    
    /// reconstraint layout of button when keyboard Hidden
    @objc func keyboardDidAppear(_ notification : NSNotification){
        buttonSignupBottomConstraint.constant = 16
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    deinit {
        print("Deinit SignupViewController")
    }
}
//MARK:- TextFieldDelegate
extension SignupViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        switch textField {
        case txtUsername :
            txtUsername.resignFirstResponder()
            txtEmailAddress.becomeFirstResponder()
            break
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
//MARK:- ImagePicker
extension SignupViewController : UIImagePickerControllerDelegate , UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let imageEdited = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            image = imageEdited
            imvAvatar.image = imageEdited
            lbAddPhoto.isHidden = true
        }
        if let imageOriginal = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            image = imageOriginal
            imvAvatar.image = imageOriginal
            lbAddPhoto.isHidden = true
        }
        picker.dismiss(animated: true, completion: nil)
    }
}
