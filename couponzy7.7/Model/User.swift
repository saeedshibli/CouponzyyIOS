//
//  User.swift
//  couponzy7.7
//
//  Created by מאיס on 23/07/2021.
//

import Foundation
class User{
    var firstName:String="";
    var lastName:String="";
    var shopName:String="";
    var email:String="";
    var phoneNumber:String="";
    var shopImageURL:String="";
    
    func toJson()->[String:Any]{
        var json = [String:Any]();
        json["firstName"] =  firstName;
        json["lastName"] =  lastName;
        json["shopName"] =  shopName;
        json["email"] =  email;
        json["phoneNumber"] =  phoneNumber;
        json["shopImageURL"] =  shopImageURL;
        return json;
    }
}
extension User{
    static func create(json:[String:Any])->User?{
        let user = User();
        user.firstName=json["firstName"] as! String;
        user.lastName=json["lastName"] as! String;
        user.shopName=json["shopName"] as! String;
        user.email=json["email"] as! String;
        user.phoneNumber=json["phoneNumber"] as! String;
        user.shopImageURL=json["shopImageURL"] as! String;
        return user;
    }
}
