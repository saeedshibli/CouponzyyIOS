//
//  Indicator.swift
//  couponzy7.7
//
//  Created by מאיס on 25/07/2021.
//

import Foundation
import UIKit

public class Indicator {

    public static let sharedInstance = Indicator()
    var blurImg = UIImageView()
    var indicator = UIActivityIndicatorView()

    private init()
    {
        blurImg.frame = UIScreen.main.bounds
        blurImg.backgroundColor = UIColor.gray
        blurImg.isUserInteractionEnabled = true
        blurImg.alpha = 0.5
        indicator.style = .whiteLarge
        indicator.center = blurImg.center
        indicator.startAnimating()
        indicator.color = .black
    }

    func showIndicator(){
        DispatchQueue.main.async( execute: {

            UIApplication.shared.keyWindow?.addSubview(self.blurImg)
            UIApplication.shared.keyWindow?.addSubview(self.indicator)
        })
    }
    func hideIndicator(){

        DispatchQueue.main.async( execute:
            {
                self.blurImg.removeFromSuperview()
                self.indicator.removeFromSuperview()
        })
    }
}
//    var alert:UIAlertController = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)
//
//    internal func startLoader(){
//        alert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)
//
//        indicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
//        indicator.hidesWhenStopped = true
//        indicator.style = UIActivityIndicatorView.Style.gray
//        indicator.startAnimating();
//
//        alert.view.addSubview(indicator)
//        present(alert, animated: true, completion: nil)
//    }
//    internal func stopLoader(){
//        if let vc = self.presentedViewController, vc is UIAlertController {                 vc.dismiss(animated: false, completion: nil)
//               }
//    }
    
