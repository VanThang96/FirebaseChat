//
//  HomeViewController.swift
//  FirebaseChat
//
//  Created by win on 6/11/19.
//  Copyright © 2019 win. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var collectionViewUsers: UICollectionView!
    
    var messageViewModel = MessageViewModel()
    let cellId = "cellId"
    
    lazy var imvProfile : UIImageView = {
        let imvProfile = UIImageView(image: UIImage(named: "user_male"))
        imvProfile.frame = CGRect(x: 0, y: 0, width: 36, height: 36)
        imvProfile.contentMode = .scaleAspectFit
        imvProfile.backgroundColor = .red
        imvProfile.layer.cornerRadius = 18
        imvProfile.clipsToBounds = true
        return imvProfile
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationTitle()
        setupCollectionView()
        
        observeMessage()
    }
    fileprivate func observeMessage(){
        messageViewModel.fetchMessage {
            DispatchQueue.main.async {[weak self] in
                self?.collectionViewUsers.reloadData()
            }
        }
    }
    override func viewWillLayoutSubviews() {
        let leftImageItem = UIBarButtonItem(customView: imvProfile)
        navigationItem.leftBarButtonItem = leftImageItem
    }
    
    @IBAction func didTapAllUser(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let listAllUser = storyboard.instantiateViewController(withIdentifier: "ListUserViewController") as! ListUserViewController
        listAllUser.homeViewController = self
        present(listAllUser, animated: true, completion: nil)
    }
    fileprivate func setupNavigationTitle(){
        if let userData = UserDefaults.standard.data(forKey: "userInfo"), let user = try? PropertyListDecoder().decode(User.self, from: userData){
            navigationItem.title = user.userName
        }
    }
    fileprivate func setupCollectionView(){
        collectionViewUsers.register(UINib(nibName: String(describing: HomeCollectionViewCell.self), bundle: nil), forCellWithReuseIdentifier: cellId)
    }
    func showChatViewController(with user : User){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let chatVC = storyboard.instantiateViewController(withIdentifier: "ChatViewController") as! ChatViewController
        chatVC.userDestination = user
        self.navigationController?.pushViewController(chatVC, animated: true)
    }
}
extension HomeViewController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messageViewModel.getMessageCount()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! HomeCollectionViewCell
        cell.message = messageViewModel.getMessage(at: indexPath.item)
        messageViewModel.fetchUserById(with: messageViewModel.getMessage(at: indexPath.item).toUID!, onCompletion: { (user) in
            cell.user = user
        })
        return cell
    }
}
extension HomeViewController : UICollectionViewDelegate , UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 100)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//       showChatViewController(at: indexPath.item)
    }
}
