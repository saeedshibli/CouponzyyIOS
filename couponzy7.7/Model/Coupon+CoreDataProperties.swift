//
//  Coupon+CoreDataProperties.swift
//  
//
//  Created by מאיס on 25/07/2021.
//
//

import Foundation
import CoreData


extension Coupon {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Coupon> {
        return NSFetchRequest<Coupon>(entityName: "Coupon")
    }

    @NSManaged public var couponCode: String?
    @NSManaged public var couponDescription: String?
    @NSManaged public var discountPrice: Double
    @NSManaged public var orginalPrice: Double
    @NSManaged public var expireDate: String?
    @NSManaged public var lastUpdated: Int64
    @NSManaged public var couponImage: String?
    @NSManaged public var publishedDate: Date?
    @NSManaged public var title: String?
    @NSManaged public var shopId: String?
    @NSManaged public var shopImage: String?
    @NSManaged public var couponIsDeleted: Bool
    @NSManaged public var couponIsHidden: Bool

}
