//
//  ChatViewController.swift
//  FirebaseChat
//
//  Created by win on 6/12/19.
//  Copyright © 2019 win. All rights reserved.
//

import UIKit

class ChatViewController: UIViewController {

    @IBOutlet weak var cardViewChatBoxBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var tbViewChat: UITableView!
    @IBOutlet weak var cardViewChatBox: UIView!
    @IBOutlet weak var txtChatBox: UITextField!
    @IBOutlet weak var btnSendMessage: UIButton!
    
    var userDestination : User!
    var fromUID : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidAppear(_:)), name: UIResponder.keyboardDidHideNotification, object: nil)
    }
    override func viewWillLayoutSubviews() {
        // setup txtChatbox
        txtChatBox.layer.borderWidth = 0.5
        txtChatBox.layer.borderColor = UIColor.gray.cgColor
        txtChatBox.backgroundColor = UIColor(white: 0, alpha: 0.1)

    }
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
        txtChatBox.resignFirstResponder()
    }
    @IBAction func didTapSendMessage(_ sender: Any) {
        if let userData = UserDefaults.standard.data(forKey: "userInfo"), let user = try? PropertyListDecoder().decode(User.self, from: userData){
            let uid = user.uid
            let timeStamp = Int(NSDate().timeIntervalSince1970)
            DatabaseServices.shareInstance.sendMessageToFirebase(text: txtChatBox.text!, fromUID: uid!, toUID: userDestination.uid!, timeStamp: timeStamp, onSuccess: {[weak self] in
                print("success")
                self?.txtChatBox.text = nil
                self?.configurationButtonSend(false)
            }) { [weak self](error) in
                self?.showAlertNotiCheckEmpty(noti: error)
            }
        }
    }
    func setupUI(){
        if let userData = userDestination {
            navigationItem.title = userData.userName
        }
        configurationButtonSend(false)
        
        txtChatBox.delegate = self
        txtChatBox.addTarget(self, action: #selector(handleButtonSend(_:)), for: .editingChanged)
    }
    func configurationButtonSend(_ enable : Bool){
        if enable {
            btnSendMessage.tintColor = .red
            btnSendMessage.isEnabled = true
        } else {
            btnSendMessage.tintColor = .gray
            btnSendMessage.isEnabled = false
        }
    }
    @objc func handleButtonSend(_ textField : UITextField){
        if (textField.text?.count)! > 0 {
            configurationButtonSend(true)
        }else{
            configurationButtonSend(false)
        }
    }
    /// reconstraint layout of button when keyboard Show
    @objc func keyboardWillAppear(_ notification : NSNotification){
        let info = notification.userInfo!
        let keyboardFrame: CGRect = (info[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        
        cardViewChatBoxBottomConstraint.constant = keyboardFrame.height - 34
    }
    /// reconstraint layout of button when keyboard Hidden
    @objc func keyboardDidAppear(_ notification : NSNotification){
        cardViewChatBoxBottomConstraint.constant = 0
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
extension ChatViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let userData = UserDefaults.standard.data(forKey: "userInfo"), let user = try? PropertyListDecoder().decode(User.self, from: userData){
            let uid = user.uid
            let timeStamp = Int(NSDate().timeIntervalSince1970)
            DatabaseServices.shareInstance.sendMessageToFirebase(text: txtChatBox.text!, fromUID: uid!, toUID: userDestination.uid!, timeStamp: timeStamp, onSuccess: {[weak self] in
                print("success")
                self?.txtChatBox.text = nil
                self?.configurationButtonSend(false)
            }) { [weak self](error) in
                self?.showAlertNotiCheckEmpty(noti: error)
            }
        }
        return true
    }
}
