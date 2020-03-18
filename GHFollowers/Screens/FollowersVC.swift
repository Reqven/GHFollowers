//
//  FollowersVC.swift
//  GHFollowers
//
//  Created by Manu on 24/02/2020.
//  Copyright © 2020 Manu Marchand. All rights reserved.
//

import UIKit

class FollowersVC: UIViewController {

    var username: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.prefersLargeTitles = true
    }
}
