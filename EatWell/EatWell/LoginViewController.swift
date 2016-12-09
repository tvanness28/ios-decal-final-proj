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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let _ = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(exitSplash), userInfo: nil, repeats: false)
        
        self.navigationController?.navigationBar.isHidden = true

        let splashImage = UIImageView(image: #imageLiteral(resourceName: "SplashScreen"))
        splashImage.frame = CGRect(x: 0, y: 0, width: screen.width, height: screen.height)
        
        self.view.addSubview(splashImage)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func exitSplash() {
        self.navigationController?.pushViewController(MainViewController(), animated: true)
    }


}

