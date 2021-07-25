//
//  UITabBarViewController.swift
//  couponzy7.7
//
//  Created by מאיס on 24/07/2021.
//

import UIKit

class UITabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
            Model.instance.getCurrentUser { user in
                if(user.shopName == ""){
                    let index = 1
                    if (self.viewControllers!.count > 2){
                        self.viewControllers?.remove(at: index)
                    }
                }
        }
        
    }

}
