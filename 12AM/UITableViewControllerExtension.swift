//
//  AnimationHelper.swift
//  12AM
//
//  Created by Michael Castillo on 4/27/17.
//  Copyright © 2017 Michael Castillo. All rights reserved.
//

import UIKit
import SpriteKit


extension UITableViewController {
    
    
    func animateTableFromBottom() {
        tableView.reloadData()
    
        let visibleTableViewCells = tableView.visibleCells
        let tableViewHeight =  tableView.bounds.size.height
        var incrementTimeDelay = 0.01
        
        for cell in visibleTableViewCells {
            cell.transform = CGAffineTransform(translationX: 0, y: tableViewHeight)
        }
        
        for cell in visibleTableViewCells {
            UIView.animate(withDuration: 1.75, delay: incrementTimeDelay, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.01, options: .curveEaseInOut, animations: {
                cell.transform = CGAffineTransform.identity
            }, completion: nil)
            incrementTimeDelay += 0.5
        }
    }
    
    
    
}



