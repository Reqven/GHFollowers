//
//  GFRepoItemVC.swift
//  GHFollowers
//
//  Created by DevAndDeploy on 26/04/2020.
//  Copyright © 2020 Manu Marchand. All rights reserved.
//

import UIKit

class GFRepoItemVC: GFItemInfoVC {

    override func viewDidLoad() {
        super.viewDidLoad()
        configureItems()
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
