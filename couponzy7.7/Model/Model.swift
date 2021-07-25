//
//  Model.swift
//  couponzy7.7
//
//  Created by מאיס on 10/07/2021.
//

import Foundation
import UIKit

class Model{
    static let instance = Model()
    let modelFirebase = ModelFirebase();
    private init(){}
    
    func getAllCoupons(callback:@escaping (([Coupon])->Void)){
        //get last update date
        let lastUpdateDate = Coupon.getLastUpdate()
        //get all updated records from firebase
        modelFirebase.getAllCoupons(since: lastUpdateDate) { coupons in
            var lastUpdate: Int64 = 0;
            for coupon in coupons{
                if(lastUpdate < coupon.lastUpdated){
                    lastUpdate = coupon.lastUpdated;
                }
            }
            //update local last update date
            Coupon.saveLastUpdate(time: lastUpdate)
            //save context in local db
            if coupons.count > 0 {
                coupons[0].save()
            }
            //read the complete students list from local db
            Coupon.getAll(callback: callback)
        }
        
        //modelFirebase.getAllCoupons(callback: callback);
    }
    func getMyAllCoupons(callback:@escaping (([Coupon])->Void)){
        getCurrentUser { user in
        let lastUpdateDate = Coupon.getLastUpdate()
            self.modelFirebase.getMyAllCoupons(email:user.email,since: lastUpdateDate){ coupons in
            
            var lastUpdate: Int64 = 0;
            for coupon in coupons{
                if(lastUpdate < coupon.lastUpdated){
                    lastUpdate = coupon.lastUpdated;
                }
            }
            
            //update local last update date
            Coupon.saveLastUpdate(time: lastUpdate)
            
            //save context in local db
            if coupons.count > 0 {
                coupons[0].save()
            }
            
            //read the complete students list from local db
            Coupon.getMyAllCoupons(email: user.email, callback: callback)
        }
    }
    }
    func getAllOtherCoupons(callback:@escaping (([Coupon])->Void)){
        let lastUpdateDate = Coupon.getLastUpdate()
        getCurrentUser { user in
            self.modelFirebase.getAllOtherCoupons(email:user.email,since: lastUpdateDate){ coupons in
            
            var lastUpdate: Int64 = 0;
            for coupon in coupons{
                if(lastUpdate < coupon.lastUpdated){
                    lastUpdate = coupon.lastUpdated;
                }
            }
            
            //update local last update date
            Coupon.saveLastUpdate(time: lastUpdate)
            
            //save context in local db
            if coupons.count > 0 {
                coupons[0].save()
            }
            
            //read the complete students list from local db
                Coupon.getAllOtherCoupons(email:user.email,callback: callback)
        }
    }
    }
    func addCoupon(coupon:Coupon,callback:@escaping (()->Void) ){
        modelFirebase.addCoupon(coupon: coupon){
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext;
            do{
                try context.save()
                callback()
                return;
            }catch{
                callback()
                return;
            }
        };
    }
    func getCoupon(couponCode:String,callback:@escaping ((Coupon)->Void)){
        modelFirebase.getCoupon(couponCode: couponCode,callback: callback);
    }
    func deleteCoupon(coupon:Coupon,callback:@escaping (()->Void)){
        modelFirebase.deleteCoupon(coupon: coupon,callback: callback)
    }
    func uploadCouponImage(fileURL : URL,pathString: String ,callback:@escaping ((String)->Void)){
        modelFirebase.uploadCouponImage(fileURL: fileURL,pathString: pathString,callback: callback);
    }
    func signUp(email:String,password:String,firstname: String,lastName: String,
                phoneNumber:String,shopName:String,shopImageUrl:String,
                callback:@escaping ((String)->Void)){
        modelFirebase.signUp(email: email, password: password, firstname: firstname, lastName: lastName, phoneNumber: phoneNumber, shopName: shopName, shopImageUrl: shopImageUrl, callback: callback)
    }
    func addUserDetails(user:User,callback:@escaping ((String)->Void)){
        modelFirebase.addUserDetails(user: user, callback: callback)
    }
    func changeShopImageInAllCoupons(email:String,shopImageUrl:String,callback:@escaping (()->Void)){
        modelFirebase.changeShopImageInAllCoupons(email: email, shopImageUrl: shopImageUrl, callback: callback);
    }
    func signIn(email:String,password:String,callback:@escaping ((String)->Void)){
        modelFirebase.signIn(email: email, password: password, callback: callback)
    }
    func checkUserInfo()->Bool{
        return modelFirebase.checkUserInfo();
    }
    func logout(){
        modelFirebase.logout()
    }
    func getCurrentUser(callback:@escaping ((User)->Void)){
        modelFirebase.getCurrentUser(callback: callback)
    }
    func resetUserPassword(email:String,password:String,newPassword:String,callback:@escaping ((String)->Void)){
        modelFirebase.resetUserPassword(email: email,password: password,newPassword: newPassword, callback: callback);
    }
}
