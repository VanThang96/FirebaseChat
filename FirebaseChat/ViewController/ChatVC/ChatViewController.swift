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
    
    @IBOutlet weak var collectionViewChat: UICollectionView!
    @IBOutlet weak var cardViewChatBox: UIView!
    @IBOutlet weak var txtChatBox: UITextField!
    @IBOutlet weak var btnSendMessage: UIButton!
    
    let cellIdSend = "cellIdSend"
    let cellIdReceive = "cellIdReceive"
    let padding  : CGFloat = 16 //(16 is padding of witdh message with bubbleView)
    
    var userDestination : User!
    var fromUID : String!
    var messageViewModel = MessageViewModel()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupUI()
        setupCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        //observerable keyboard showed or keyboard hidden
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidAppear(_:)), name: UIResponder.keyboardDidHideNotification, object: nil)
        
        print("view will appear run")
        //load list message
        print(userDestination)
        print(fromUID)
        messageViewModel.fetchAllMess(fromUID: fromUID, toUID: userDestination.uid!) {
            self.collectionViewChat.layoutIfNeeded()
            print("load chat")
            self.collectionViewChat.insertItems(at: [IndexPath(item: self.messageViewModel.getMessageCount() - 1, section: 0)])
        }
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
            DatabaseServices.shareInstance.sendMessageToFirebaseUserMessage(text: txtChatBox.text!, fromUID: uid!, toUID: userDestination.uid!, timeStamp: timeStamp, onSuccess: {[weak self] in
                self?.configurationButtonSend(false)
                self?.txtChatBox.text = nil
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
    func setupCollectionView(){
        collectionViewChat.showsVerticalScrollIndicator = false
        collectionViewChat.scrollIndicatorInsets = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        collectionViewChat.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 0, right: 0)
        collectionViewChat.alwaysBounceVertical = true
        collectionViewChat.register(MessageSendCell.self, forCellWithReuseIdentifier: cellIdSend)
        collectionViewChat.register(MessageReceiveCell.self, forCellWithReuseIdentifier: cellIdReceive)
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
        
        self.collectionViewChat.scrollsToTop = false
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
        let timeStamp = Int(NSDate().timeIntervalSince1970)
        DatabaseServices.shareInstance.sendMessageToFirebaseUserMessage(text: txtChatBox.text!, fromUID: fromUID, toUID: userDestination.uid!, timeStamp: timeStamp, onSuccess: {[weak self] in
            self?.configurationButtonSend(false)
            self?.txtChatBox.text = nil
        }) { [weak self](error) in
            self?.showAlertNotiCheckEmpty(noti: error)
        }
        return true
    }
}

extension ChatViewController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messageViewModel.getMessageCount()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch messageViewModel.getMessage(at: indexPath.item).fromUID  {
        case fromUID:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdSend, for: indexPath) as! MessageSendCell
            cell.message = messageViewModel.getMessage(at: indexPath.item)
            cell.bubbleWidthAnchor?.constant = messageViewModel.estimateFrameForText(text: messageViewModel.getMessage(at: indexPath.item).message!).width + 2 * padding
            return cell
        case userDestination.uid:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdReceive, for: indexPath) as! MessageReceiveCell
            cell.message = messageViewModel.getMessage(at: indexPath.item)
            cell.bubbleWidthAnchor?.constant = messageViewModel.estimateFrameForText(text: messageViewModel.getMessage(at: indexPath.item).message!).width + 2 * padding
            messageViewModel.fetchUserById(with: userDestination.uid!) { (user) in
                cell.user = user
            }
            return cell
        default:
            break
        }
        return UICollectionViewCell()
    }
    
}
extension ChatViewController : UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var height : CGFloat = 80
        
        //estimated height for each message
        if let message = messageViewModel.getMessage(at: indexPath.item).message {
            height = messageViewModel.estimateFrameForText(text: message).height + padding
        }
        return CGSize(width: view.frame.width, height: height)
    }
}
