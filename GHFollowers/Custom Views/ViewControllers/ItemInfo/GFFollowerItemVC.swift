//
//  GFFollowerItemVC.swift
//  GHFollowers
//
//  Created by DevAndDeploy on 26/04/2020.
//  Copyright © 2020 Manu Marchand. All rights reserved.
//

import UIKit

protocol GFFollowerItemVCDelegate: class {
    func didTapGetFollowers(for user: User)
}

class GFFollowerItemVC: GFItemInfoVC {

    weak var delegate : GFFollowerItemVCDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureItems()
    }
    
    init(user: User, delegate: GFFollowerItemVCDelegate) {
        super.init(user: user)
        self.delegate = delegate
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
