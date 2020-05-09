//
//  UITableView+Ext.swift
//  GHFollowers
//
//  Created by DevAndDeploy on 09/05/2020.
//  Copyright © 2020 Manu Marchand. All rights reserved.
//

import UIKit

extension UITableView {
    
    func reloadDataOnMainThread() {
        DispatchQueue.main.async { self.reloadData() }
    }
    
    func removeExcessCells() {
        tableFooterView = UIView(frame: .zero)
    }
}
