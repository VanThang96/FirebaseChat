//
//  ListUserViewController.swift
//  FirebaseChat
//
//  Created by win on 6/12/19.
//  Copyright © 2019 win. All rights reserved.
//

import UIKit

class ListUserViewController: UIViewController {
    @IBOutlet weak var collectionViewListUser: UICollectionView!
    
    var userViewModel = UserViewModel()
    var homeViewController : HomeViewController?
    let cellId = "cellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
        loadAllUser()
    }
    @IBAction func didTapCancelButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    fileprivate func loadAllUser(){
        userViewModel.fetchUsers {[weak self] in
            DispatchQueue.main.async {
                self?.collectionViewListUser.reloadData()
            }
        }
    }
    fileprivate func setupCollectionView(){
        collectionViewListUser.register(UINib(nibName: String(describing: UserCollectionViewCell.self), bundle: nil), forCellWithReuseIdentifier: cellId)
    }
}
extension ListUserViewController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return userViewModel.getUserCount()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! UserCollectionViewCell
        cell.user = userViewModel.getUser(at: indexPath.item)
        return cell
    }
}
extension ListUserViewController : UICollectionViewDelegate , UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 100)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        dismiss(animated: true) {
            if let userData = UserDefaults.standard.data(forKey: "userInfo"), let user = try? PropertyListDecoder().decode(User.self, from: userData){
                self.homeViewController?.showChatViewController(fromUID: user.uid! , with: self.userViewModel.getUser(at: indexPath.item))
            }
        }
    }
}
