//
//  MainViewController.swift
//  EatWell
//
//  Created by Timothy Van Ness on 12/6/16.
//  Copyright © 2016 Timothy Van Ness. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    let items = ["Plan", "Recipe", "Food"]
    var addView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let segControl = UISegmentedControl(items: items)
        segControl.selectedSegmentIndex = 0
        segControl.addTarget(self, action: #selector(action), for: .valueChanged)
        
        self.navigationController?.navigationBar.isHidden = false
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Profile", style: UIBarButtonItemStyle.plain,target: self, action: #selector(profileTapped))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(searchTapped))
        navigationItem.titleView = segControl

        self.view.backgroundColor = UIColor.white
        
        self.view.frame = CGRect(x: 0, y: self.view.bounds.height * 0.1, width: self.view.bounds.width, height: self.view.bounds.height * 0.95)
        
        MainTableViewController.segCont_index = 0
        let vc = MainTableViewController()
        self.addChildViewController(vc)
        self.view.addSubview(vc.view)
        vc.didMove(toParentViewController: self)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func searchTapped () {
        
    }
    
    func action(_ sender: UISegmentedControl!) {
        
        var vc: UIViewController? = nil
        
        switch sender.selectedSegmentIndex {
        case 0:
            MainTableViewController.segCont_index = 0
            break
        case 1:
            MainTableViewController.segCont_index = 1
            break
        case 2:
            MainTableViewController.segCont_index = 2
            break
        default:
            break
        }
        
        vc = MainTableViewController()
        if (vc != nil) {
            if let viewWithTag = self.view.viewWithTag(1) {
                viewWithTag.removeFromSuperview()
            }
            self.addChildViewController(vc!)
            self.view.addSubview((vc?.view)!)
            vc?.didMove(toParentViewController: self)
        }
    }
    
    func profileTapped() {
        
    }

}
