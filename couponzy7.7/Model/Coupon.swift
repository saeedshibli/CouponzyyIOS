//
//  Coupon.swift
//  couponzy7.7
//
//  Created by מאיס on 10/07/2021.
//

import Foundation
import Firebase

//class Coupon{
//    var couponCode:String?
//    var description:String?
//    var discountPrice:Double=0.0;
//    var orginalPrice:Double=0.0;
//    var expireDate:String="";
//    var lastUpdated:String?
//    var couponImage:String?
//    var publishedDate:Date?
//    var title:String?
//    var shopId:String?
//    var shopImage:String?
//    var isDeleted:Bool?;
//
//    func create(description:String?,discountPrice:Double,orignalPrice:Double,expireDate:String,couponImage:String?,title:String?,shopId:String?,shopImage:String?){
//        self.description=description;
//        self.discountPrice=discountPrice;
//        self.orginalPrice=orignalPrice;
//        self.expireDate=expireDate;
//        self.couponImage=couponImage;
//        self.title=title;
//        self.shopId=shopId;
//        self.shopImage=shopImage;
//        self.isDeleted = false;
//    }
//
//    func toJson()->[String:Any]{
//        var json = [String:Any]();
//        json["couponCode"] =  couponCode!;
//        json["description"] =  nullableJson(any: description as Any) ? "" : description;
//        json["discountPrice"] =  nullableJson(any: discountPrice as Any) ? 0.0 : discountPrice;
//        json["orginalPrice"] =  nullableJson(any: orginalPrice as Any) ? 0.0 : orginalPrice;
//        //timestamp to date to string
//        let dateFormatterPrint = DateFormatter()
//        dateFormatterPrint.dateFormat = "MMM dd,yyyy"
//        dateFormatterPrint.string(from: Date())
//        json["expireDate"] = nullableJson(any: expireDate as Any) ? "" : expireDate;
//        //timestamp to date to string
//        json["lastUpdated"] =  "";//nullableJson(any: orginalPrice as Any) ? "" : orginalPrice;
//        json["publishedDate"] =  Date()//nullableJson(any: orginalPrice as Any) ? "" : orginalPrice;
//        json["couponImage"] =  nullableJson(any: couponImage as Any) ? "" : couponImage;
//        json["title"] =  nullableJson(any: title as Any) ? "" : title;
//        json["shopId"] =  nullableJson(any: shopId as Any) ? "" : shopId;
//        json["shopImage"] =  nullableJson(any: shopImage as Any) ? "" : shopImage;
//        json["isDeleted"] = nullableJson(any: isDeleted as Any) ? false : isDeleted;
//        return json;
//    }
//    func nullableJson(any:Any)->Bool{
//        if case Optional<Any>.none = any {
//            return true;
//        } else {
//            return false;
//        }
//    }
//}
//extension Coupon{
//    static func create(json:[String:Any])->Coupon?{
//        let coupon = Coupon();
//        coupon.couponCode=json["couponCode"] as? String;
//        coupon.couponImage=json["couponImage"] as? String;
//        coupon.description=json["description"] as? String;
//        coupon.discountPrice=json["discountPrice"] as! Double;
//        coupon.expireDate = json["expireDate"] as! String;
//        coupon.lastUpdated=json["lastUpdated"] as? String;
//        coupon.orginalPrice=json["orginalPrice"] as! Double;
//        coupon.publishedDate=json["publishedDate"] as? Date;
//        coupon.shopId=json["shopId"] as? String;
//        coupon.shopImage=json["shopImage"] as? String;
//        coupon.title=json["title"] as? String;
//        coupon.isDeleted = json["isDeleted"] as? Bool;
//        return coupon;
//    }
//}
