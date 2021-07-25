//
//  Coupon+CoreDataClass.swift
//  
//
//  Created by מאיס on 25/07/2021.
//
//

import Foundation
import CoreData
import Firebase

@objc(Coupon)
public class Coupon: NSManagedObject {

    static func create(cp:Coupon) -> Coupon{
        return create(description: cp.couponDescription, discountPrice: cp.discountPrice, orignalPrice: cp.orginalPrice, expireDate: cp.expireDate!, couponImage: cp.couponImage, title: cp.title, shopId: cp.shopId, shopImage: cp.shopImage,lastUpdated: cp.lastUpdated)
    }
    static func create(description:String?,discountPrice:Double,orignalPrice:Double,expireDate:String,
                       couponImage:String?,title:String?,shopId:String?,shopImage:String?,lastUpdated:Int64)->Coupon{
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext;
        let coupon = Coupon(context: context);
        coupon.couponDescription=description;
        coupon.discountPrice=discountPrice;
        coupon.orginalPrice=orignalPrice;
        coupon.expireDate=expireDate;
        coupon.couponImage=couponImage;
        coupon.title=title;
        coupon.shopId=shopId;
        coupon.shopImage=shopImage;
        coupon.couponIsDeleted = false;
        coupon.couponIsHidden = false;
        coupon.lastUpdated = lastUpdated;
        return coupon
    }
    
    func toJson()->[String:Any]{
        var json = [String:Any]();
        json["couponCode"] =  nullableJson(any: couponCode as Any) ? 0.0 : couponCode;
        json["couponDescription"] =  nullableJson(any: couponDescription as Any) ? "" : couponDescription;
        json["discountPrice"] =  nullableJson(any: discountPrice as Any) ? 0.0 : discountPrice;
        json["orginalPrice"] =  nullableJson(any: orginalPrice as Any) ? 0.0 : orginalPrice;
        //timestamp to date to string
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "MMM dd,yyyy"
        dateFormatterPrint.string(from: Date())
        json["expireDate"] = nullableJson(any: expireDate as Any) ? "" : expireDate;
        //timestamp to date to string
        
        json["lastUpdated"] =  FieldValue.serverTimestamp();//nullableJson(any: orginalPrice as Any) ? "" : orginalPrice;
        json["publishedDate"] =  Date()//nullableJson(any: orginalPrice as Any) ? "" : orginalPrice;
        json["couponImage"] =  nullableJson(any: couponImage as Any) ? "" : couponImage;
        json["title"] =  nullableJson(any: title as Any) ? "" : title;
        json["shopId"] =  nullableJson(any: shopId as Any) ? "" : shopId;
        json["shopImage"] =  nullableJson(any: shopImage as Any) ? "" : shopImage;
        json["couponIsDeleted"] = nullableJson(any: couponIsDeleted as Any) ? false : couponIsDeleted;
        json["couponIsHidden"] = nullableJson(any: couponIsHidden as Any) ? false : couponIsHidden;
        return json;
    }
    func nullableJson(any:Any)->Bool{
        if case Optional<Any>.none = any {
            return true;
        } else {
            return false;
        }
    }
    
    static func saveLastUpdate(time:Int64){
        UserDefaults.standard.set(time,forKey: "lastUpdate")
    }
    static func getLastUpdate()->Int64{
        return Int64(UserDefaults.standard.integer(forKey: "lastUpdate"))
    }
}
extension Coupon{
    static func create(json:[String:Any])->Coupon?{
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext;
        let coupon = Coupon(context: context);
        coupon.couponCode=json["couponCode"] as? String;
        coupon.couponImage=json["couponImage"] as? String;
        coupon.couponDescription=json["couponDescription"] as? String;
        coupon.discountPrice=json["discountPrice"] as! Double;
        coupon.expireDate = json["expireDate"] as! String;
        coupon.orginalPrice=json["orginalPrice"] as! Double;
        coupon.publishedDate=json["publishedDate"] as? Date;
        coupon.shopId=json["shopId"] as? String;
        coupon.shopImage=json["shopImage"] as? String;
        coupon.title=json["title"] as? String;
        coupon.couponIsDeleted = json["couponIsDeleted"] as! Bool;
        coupon.couponIsHidden = json["couponIsHidden"] as? Bool ?? false;
        if let timestamp = json["lastUpdated"] as? Timestamp {
            coupon.lastUpdated = timestamp.seconds
        }
        return coupon;
    }
}
extension Coupon{
    static func getAll(callback:@escaping (([Coupon])->Void)){
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext;
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        let request = Coupon.fetchRequest() as NSFetchRequest<Coupon>
        DispatchQueue.global().async {
            var data = [Coupon]()
            do{
                data = try context.fetch(request)
            }catch{}
            DispatchQueue.main.async {
                callback(data)
            }
        }
    }
    static func getMyAllCoupons(email:String,callback:@escaping (([Coupon])->Void)){
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext;
        
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        let request = Coupon.fetchRequest() as NSFetchRequest<Coupon>
        //request.predicate = NSPredicate(format: "shopId == %@",email)
        let shopId = NSPredicate(format: "shopId == %@",email)
        let isDeleted = NSPredicate(format: "couponIsDeleted == false")
        let andPredicate = NSCompoundPredicate(type: NSCompoundPredicate.LogicalType.and, subpredicates: [shopId, isDeleted])
        request.predicate = andPredicate
        DispatchQueue.global().async {
            var data = [Coupon]()
            do{
                data = try context.fetch(request)
            }catch{}
            DispatchQueue.main.async {
                callback(data)
            }
        }
    }
    static func getAllOtherCoupons(email:String,callback:@escaping (([Coupon])->Void)){
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext;
        
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        let request = Coupon.fetchRequest() as NSFetchRequest<Coupon>
        //request.predicate = NSPredicate(format: "shopId != %@",email)
        let shopId = NSPredicate(format: "shopId != %@",email)
        let isDeleted = NSPredicate(format: "couponIsDeleted == false")
        let isHidden = NSPredicate(format: "couponIsHidden == false")
        let andPredicate = NSCompoundPredicate(type: NSCompoundPredicate.LogicalType.and, subpredicates: [shopId, isDeleted, isHidden])
        request.predicate = andPredicate
//        request.predicate = [NSPredicate predicateWithFormat:@"shopId != %@", email];
        DispatchQueue.global().async {
            var data = [Coupon]()
            do{
                data = try context.fetch(request)
            }catch{}
            DispatchQueue.main.async {
                callback(data)
            }
        }
    }
    func save(){
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext;
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        do{
            try context.save()
        }catch{}
    }
    func addCouponToLocalDb(){
        let cp = Coupon.create(cp: self)
        cp.save()
    }
    func delete(){
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext;
        print("Coupon deleted : \(self)")
        context.delete(self)
        do{
            try context.save()
        }catch{}
    }
}
