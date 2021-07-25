//
//  ViewController.swift
//  couponzy7.7
//
//  Created by מאיס on 07/07/2021.
//

import UIKit
import FirebaseUI
import FirebaseStorage
import Firebase

class ViewController: UIViewController, UITableViewDelegate,UITableViewDataSource {

    @IBOutlet var tableView:UITableView!
    @IBOutlet weak var addBtn: UIBarButtonItem!
    @IBOutlet weak var addCouponButton1: UIBarButtonItem!
    var coupons = [Coupon]()
    let coupons2 = ["first","second"]
    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        // Do any additional setup after loading the view.
//        coupons = Model.instance.getAllCoupons();
//        let nib = UINib(nibName: "CouponsTableViewCell", bundle: nil)
//        tableView.register(nib, forCellReuseIdentifier: "CouponsTableViewCell")
//        tableView.backgroundColor = hexStringToUIColor(hex: "#BED9F4");
//        tableView.delegate = self;
//        tableView.dataSource = self;
//    }
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.backgroundColor = hexStringToUIColor(hex: "#BED9F4");
    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Indicator.sharedInstance.showIndicator()
        Model.instance.getMyAllCoupons(){ coupons in
            self.coupons = coupons
            let nib = UINib(nibName: "CouponsTableViewCell", bundle: nil)
            self.tableView.register(nib, forCellReuseIdentifier: "CouponsTableViewCell")
            self.tableView.backgroundColor = self.hexStringToUIColor(hex: "#BED9F4");
            self.tableView.delegate = self;
            self.tableView.dataSource = self;
            self.tableView.reloadData()
            Indicator.sharedInstance.hideIndicator()
        }
    }
    //tableview functions
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return coupons.count;
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CouponsTableViewCell",                                          for: indexPath) as! CouponsTableViewCell;
        cell.backgroundColor = hexStringToUIColor(hex: "#BED9F4");
        let testView: UIView = UIView(frame: CGRect(x:0, y:0, width:tableView.frame.size.width,
            height:(cell.contentView.frame.size.height) - 10 ))
        testView.tintColor = UIColor.white;
        testView.backgroundColor = UIColor.white;
        testView.alpha = 5
        testView.isUserInteractionEnabled = true
        testView.layer.cornerRadius = 10
        testView.layer.masksToBounds = true
        cell.contentView.addSubview(testView)
        cell.contentView.sendSubviewToBack(testView)
        //cell.myLabel.text = coupons2[indexPath.row]
        cell.myImageView.backgroundColor = .lightGray;
        //cell.textLabel?.text = myData[indexPath.row];
        let coupon = coupons[indexPath.row]
        
        cell.myLabel.text = coupon.title;
        cell.couponDescription.text = coupon.couponDescription;
        cell.codeCoupon.text = coupon.couponCode;
         //make sure your image in this url does exist, otherwise
        if (!coupon.couponImage!.isEmpty){
        let url = URL(string: coupon.couponImage ?? "")
            let data = try? Data(contentsOf: url!)
            if(data != nil){
                cell.myImageView.image = UIImage(data: data!)
                //cell.myImageView.frame.size = CGSize(width: 100, height: 100);
                cell.myImageView.sizeToFit();
            }
        }
        if (!coupon.shopImage!.isEmpty){
        let url = URL(string: coupon.shopImage ?? "")
            let data = try? Data(contentsOf: url!)
            if(data != nil){
                cell.companyImageView.image = UIImage(data: data!)
                //cell.myImageView.frame.size = CGSize(width: 100, height: 100);
                cell.companyImageView.sizeToFit();
            }
        }
        cell.validTill?.text = String(describing: coupon.expireDate!);
        cell.orginalPrice.attributedText = String(describing: coupon.orginalPrice).strikeThrough();
        cell.finalPrice.text = String(describing: coupon.discountPrice);
        //cell.CompanyImage
        return cell;
       
    }
    func pullImageTapped(couponCode : String) -> Any?{
        if(couponCode != ""){
        let storage = Storage.storage();
        let storageRef = storage.reference();
        
        let ref = storageRef.child("ImageOf\(couponCode)");
            return ref;
        }
        return nil
    }
    
    
    
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "MainToDetails", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "MainToDetails") {
            let vc = segue.destination as! CouponEditViewController
            vc.titles = coupons[(tableView.indexPathForSelectedRow?.row)!].title ?? "";
            vc.descriptions = coupons[(tableView.indexPathForSelectedRow?.row)!].couponDescription ?? "";
            vc.orginalPrice = coupons[(tableView.indexPathForSelectedRow?.row)!].orginalPrice;
            vc.finalPrice = coupons[(tableView.indexPathForSelectedRow?.row)!].discountPrice;
            vc.couponImage = coupons[(tableView.indexPathForSelectedRow?.row)!].couponImage!;
            vc.expireDate = coupons[(tableView.indexPathForSelectedRow?.row)!].expireDate!;
            vc.couponCode = coupons[(tableView.indexPathForSelectedRow?.row)!].couponCode!;
        }
    }
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }

        if ((cString.count) != 6) {
            return UIColor.gray
        }

        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)

        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}

