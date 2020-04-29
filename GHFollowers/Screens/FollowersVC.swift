//
//  FollowersVC.swift
//  GHFollowers
//
//  Created by Manu on 24/02/2020.
//  Copyright © 2020 Manu Marchand. All rights reserved.
//

import UIKit

protocol FollowersVCDelegate: class {
    func didRequestFollowers(for username: String)
}

class FollowersVC: UIViewController {
    
    enum Section { case main }
    
    var page: Int = 1
    var username: String!
    var hasMoreFollowers = true
    var isSearching = false
    var followers: [Follower] = []
    var filteredFollowers: [Follower] = []
    
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, Follower>!
    
    init(username: String) {
        super.init(nibName: nil, bundle: nil)
        self.username = username
        title = username
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureSearchController()
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
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        navigationItem.rightBarButtonItem = addButton
    }
    
    func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UIHelper.createThreeColumnsLayout(in: view))
        
        collectionView.delegate = self
        view.addSubview(collectionView)
        collectionView.backgroundColor = .systemBackground
        collectionView.register(FollowerCell.self, forCellWithReuseIdentifier: FollowerCell.reuseID)
    }
    
    func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, follower -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FollowerCell.reuseID, for: indexPath) as! FollowerCell
            cell.set(follower: follower)
            
            return cell
        })
    }
    
    func configureSearchController() {
        let searchController = UISearchController()
        searchController.searchResultsUpdater                   = self
        searchController.searchBar.delegate                     = self
        searchController.obscuresBackgroundDuringPresentation   = false
        searchController.searchBar.placeholder                  = "Search.."
        navigationItem.searchController                         = searchController
    }
     
    func getFollowers(page: Int) {
        showLoadingView()
        NetworkManager.shared.getFollowers(for: username, page: page) { [weak self] result in
            guard let self = self else { return }
            self.dismissLoadingView()
            
            switch(result) {
                case .success(let followers):
                    if followers.count < 100 { self.hasMoreFollowers = false }
                    self.followers.append(contentsOf: followers)
                    
                    if self.followers.isEmpty {
                        let message = "This user doesn't have any follower 😔"
                        DispatchQueue.main.async { self.showEmptyStateView(with: message, view: self.view) }
                        return
                    }
                    self.updateData(followers: self.followers)

                case .failure(let error):
                    self.presentGFAlertOnMainThread(title: "Error", message: error.rawValue, buttonTitle: "😔")
            }
        }
    }
    
    func updateData(followers: [Follower]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Follower>()
        snapshot.appendSections([.main])
        snapshot.appendItems(followers)
        
        DispatchQueue.main.async {
            self.dataSource.apply(snapshot, animatingDifferences: true)
        }
    }
    
    @objc func addButtonTapped() {
        showLoadingView()
        NetworkManager.shared.getUser(for: username) { [weak self] result in
            guard let self = self else { return }
            self.dismissLoadingView()
            
            switch result {
            case .success(let user):
                let favorite = Follower(login: user.login, avatarUrl: user.avatarUrl)
                PersistenceManager.updateWith(favorite: favorite, actionType: .add) { [weak self] error in
                    guard let self = self else { return }
                    guard let error = error else { return }
                    self.presentGFAlertOnMainThread(title: "Something went wrong", message: error.rawValue, buttonTitle: "OK")
                }
                break
            case .failure(let error):
                self.presentGFAlertOnMainThread(title: "Something went wrong", message: error.rawValue, buttonTitle: "OK")
                break
            }
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

extension FollowersVC: UISearchResultsUpdating, UISearchBarDelegate {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let filter = searchController.searchBar.text, !filter.isEmpty else { return }
        isSearching = true
        
        filteredFollowers = followers.filter { $0.login.lowercased().contains(filter.lowercased()) }
        updateData(followers: filteredFollowers)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearching = false
        updateData(followers: followers)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let activeArray = isSearching ? filteredFollowers : followers
        let follower    = activeArray[indexPath.item]
        
        let destinationVC = UserInfoVC()
        destinationVC.username = follower.login
        destinationVC.delegate = self
        let navController = UINavigationController(rootViewController: destinationVC)
        
        present(navController, animated: true)
    } 
}


extension FollowersVC: FollowersVCDelegate {
    
    func didRequestFollowers(for username: String) {
        self.username   = username
        title           = username
        page            = 1
        
        followers.removeAll()
        filteredFollowers.removeAll()
        collectionView.setContentOffset(.zero, animated: true)
        getFollowers(page: page)
    }
}
