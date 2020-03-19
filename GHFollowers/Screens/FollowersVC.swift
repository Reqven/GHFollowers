//
//  FollowersVC.swift
//  GHFollowers
//
//  Created by Manu on 24/02/2020.
//  Copyright © 2020 Manu Marchand. All rights reserved.
//

import UIKit

class FollowersVC: UIViewController {
    
    enum Section { case main }
    
    var page: Int = 1
    var username: String!
    var followers: [Follower] = []
    var hasMoreFollowers = true
    
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, Follower>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureCollectionView()
        getFollowers(page: page)
        configureDataSource()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    func configureViewController() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UIHelper.createThreeColumnsLayout(in: view))
        
        collectionView.delegate = self
        view.addSubview(collectionView)
        collectionView.backgroundColor = .systemBackground
        collectionView.register(FollowerCell.self, forCellWithReuseIdentifier: FollowerCell.reuseID)
    }
    
    func getFollowers(page: Int) {
        NetworkManager.shared.getFollowers(for: username, page: page) { [weak self] result in
            guard let self = self else { return }
            
            switch(result) {
                case .success(let followers):
                    if followers.count < 100 { self.hasMoreFollowers = false }
                    self.followers.append(contentsOf: followers)
                    self.updateData()

                case .failure(let error):
                    self.presentGFAlertOnMainThread(title: "Error", message: error.rawValue, buttonTitle: "😔")
            }
        }
    }
    
    func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, follower -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FollowerCell.reuseID, for: indexPath) as! FollowerCell
            cell.set(follower: follower)
            
            return cell
        })
    }
    
    func updateData() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Follower>()
        snapshot.appendSections([.main])
        snapshot.appendItems(followers)
        
        DispatchQueue.main.async {
            self.dataSource.apply(snapshot, animatingDifferences: true)
        }
    }
}


extension FollowersVC: UICollectionViewDelegate {
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        guard hasMoreFollowers else { return }
        
        let offsetY         = scrollView.contentOffset.y
        let contentHeight   = scrollView.contentSize.height
        let height          = scrollView.frame.size.height
        
        if offsetY > (contentHeight - height) {
            page += 1
            getFollowers(page: page)
        }
    }
}
