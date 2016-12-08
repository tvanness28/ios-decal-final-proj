//
//  LoginViewController.swift
//  EatWell
//
//  Created by Timothy Van Ness on 12/6/16.
//  Copyright © 2016 Timothy Van Ness. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    var screen = UIScreen.main.bounds.size
    
    var titleBlock = UIView()
    var loginBlock = UIView()
    var eatWellLabel = UILabel()
    var tempButton = UIButton(type: UIButtonType.system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isHidden = true

        let splashImage = UIImageView(image: #imageLiteral(resourceName: "SplashScreen"))
        splashImage.frame = CGRect(x: 0, y: 0, width: screen.width, height: screen.height)
        
        self.view.addSubview(splashImage)
        
        tempButton.setTitle("Start", for: UIControlState.normal)
        tempButton.addTarget(self, action: #selector(startPressed), for: .touchUpInside)
        self.view.addSubview(tempButton)
        tempButton.translatesAutoresizingMaskIntoConstraints = false
        
        tempButton.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        tempButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func startPressed() {
        self.navigationController?.pushViewController(MainViewController(), animated: true)
    }


}

