//
//  GFRepoItemVC.swift
//  GHFollowers
//
//  Created by DevAndDeploy on 26/04/2020.
//  Copyright © 2020 Manu Marchand. All rights reserved.
//

import UIKit

protocol GFRepoItemVCDelegate: class {
    func didTapGitHubProfile(for user: User)
}

class GFRepoItemVC: GFItemInfoVC {
    
    weak var delegate : GFRepoItemVCDelegate!

    override func viewDidLoad() {
        super.viewDidLoad()
        configureItems()
    }
    
    init(user: User, delegate: GFRepoItemVCDelegate) {
        super.init(user: user)
        self.delegate = delegate
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func actionButtonTap() {
        delegate.didTapGitHubProfile(for: user)
    }
    
    private func configureItems() {
        itemInfoViewOne.setItemInfoType(type: .repos, withCount: user.publicRepos)
        itemInfoViewTwo.setItemInfoType(type: .gists, withCount: user.publicGists)
        actionButton.set(backgroundColor: .systemPurple, title: "GitHub Profile")
    }
}
