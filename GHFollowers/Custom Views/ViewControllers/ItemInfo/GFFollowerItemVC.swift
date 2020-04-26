//
//  GFFollowerItemVC.swift
//  GHFollowers
//
//  Created by DevAndDeploy on 26/04/2020.
//  Copyright © 2020 Manu Marchand. All rights reserved.
//

import UIKit

class GFFollowerItemVC: GFItemInfoVC {

    override func viewDidLoad() {
        super.viewDidLoad()
        configureItems()
    }
    
    override func actionButtonTap() {
        delegate.didTapGetFollowers(for: user)
    }
    
    private func configureItems() {
        itemInfoViewOne.setItemInfoType(type: .followers, withCount: user.followers)
        itemInfoViewTwo.setItemInfoType(type: .following, withCount: user.following)
        actionButton.set(backgroundColor: .systemGreen, title: "Get Followers")
    }
}
