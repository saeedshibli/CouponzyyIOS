//
//  CouponDetailsViewController.swift
//  couponzy7.7
//
//  Created by מאיס on 16/07/2021.
//

import UIKit

class CouponDetailsViewController: UIViewController {
    
    @IBOutlet weak var expireDateViewer: UITextField!
    @IBOutlet weak var CouponCodeViewer: UILabel!
    @IBOutlet weak var couponImageViewer: UIImageView!
    @IBOutlet weak var finalPriceViewer: UITextField!
    @IBOutlet weak var orginalPriceViewer: UITextField!
    @IBOutlet weak var descriptionViewer: UITextField!
    @IBOutlet weak var titleViewer: UITextField!
    
    var orginalPrice = Double()
    var finalPrice = Double()
    var descriptions = String()
    var titles = String()
    var couponImage = String();
    var couponCode = String();
    var expireDate = String();
    
//    var lb:UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        finalPriceViewer.isUserInteractionEnabled = false;
        orginalPriceViewer.isUserInteractionEnabled = false;
        descriptionViewer.isUserInteractionEnabled = false;
        titleViewer.isUserInteractionEnabled = false;
        expireDateViewer.text = expireDate;
        CouponCodeViewer.text = couponCode;
        titleViewer.text = titles;
        descriptionViewer.text = descriptions;
        orginalPriceViewer.text = String(orginalPrice);
        finalPriceViewer.text = String(finalPrice);
        if (couponImage != ""){
        let url = URL(string: couponImage ?? "")
        let data = try? Data(contentsOf: url!)
        couponImageViewer.image = UIImage(data: data!)
        }
    }
    
}
