//
//  ModelFirebase.swift
//  couponzy7.7
//
//  Created by מאיס on 10/07/2021.
//

import Foundation
import FirebaseStorage
import FirebaseAuth
import Firebase
class ModelFirebase{
    init() {
        FirebaseApp.configure();
    }
    func getAllCoupons(since:Int64,callback:@escaping (([Coupon])->Void)){
        let db = Firestore.firestore();
        db.collection("coupons")
            .order(by: "lastUpdated")
            .start(at: [Timestamp(seconds: since, nanoseconds: 0)])
            .getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                var coupons = [Coupon]();
                for document in querySnapshot!.documents {
                    
                    if let st = Coupon.create(json: document.data()){
                        coupons.append(st);
                    }
                    print("\(document.documentID) => \(document.data())")
                }
                callback(coupons);
                return
            }
            callback([Coupon]());
        }

    }
    func getMyAllCoupons(email:String,since:Int64,callback:@escaping (([Coupon])->Void)){
        let db = Firestore.firestore();
//        getCurrentUser { user in
            db.collection("coupons")
                .order(by: "lastUpdated")
                .start(at: [Timestamp(seconds: since, nanoseconds: 0)])
                .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                    callback([Coupon]());
                    return
                } else {
                    var coupons = [Coupon]();
                    for document in querySnapshot!.documents {
                        if let st = Coupon.create(json: document.data()){
//                            if(!ModelFirebase.checkIfExpiredDateHasPassed(expireDate: st.expireDate!)){
//                                st.couponIsHidden = false;
//                                self.addCoupon(coupon: st){}
//                            }
//                            if(st.shopId == email && st.couponIsDeleted == false){
                                coupons.append(st);
//                            }
                        }
                        print("\(document.documentID) => \(document.data())")
                    }
                    callback(coupons);
                    return
                }
                callback([Coupon]());
                    return
            }
//        }
    }
    static func checkIfExpiredDateHasPassed(expireDate:String)->Bool{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd,yyyy"
        let checkExpireDate = dateFormatter.date(from: expireDate)
        let currentDate = Date();
        if(checkExpireDate! >= currentDate){
            return false;
        }
        return true;
    }
    func getAllOtherCoupons(email:String,since:Int64,callback:@escaping (([Coupon])->Void)){
        let db = Firestore.firestore();
//        getCurrentUser { user in
            db.collection("coupons")
                .order(by: "lastUpdated")
                .start(at: [Timestamp(seconds: since, nanoseconds: 0)])
                .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                    callback([Coupon]());
                    return
                } else {
                    var coupons = [Coupon]();
                    for document in querySnapshot!.documents {
                        if let st = Coupon.create(json: document.data()){
                            if(st.shopId != email && st.couponIsDeleted == false ){
//                                if(ModelFirebase.checkIfExpiredDateHasPassed(expireDate: st.expireDate!)){
//                                    st.couponIsHidden = true;
//                                    self.addCoupon(coupon: st){ st.delete()}
//                                }
//                                else{
                                    
                                    coupons.append(st);
//                                }
////
                            }
                        }
                        print("\(document.documentID) => \(document.data())")
                    }
                    callback(coupons);
                    return
                }
                callback([Coupon]());
                return;
            }
//        }
    }
    func addCoupon(coupon:Coupon,callback:@escaping (()->Void)){
        let db = Firestore.firestore();
        db.collection("coupons").document(coupon.couponCode!)
            .setData(coupon.toJson())
            { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added Succesfully")
            }
                callback()
        }
    }
    func getCoupon(couponCode:String,callback:@escaping ((Coupon)->Void)){
        let db = Firestore.firestore();
        db.collection("coupons").document(couponCode).addSnapshotListener { document, err in
            if let err = err{
                print("Error adding document: \(err.localizedDescription)")
                return;
            }
            if let st = Coupon.create(json: document!.data()!){
                print("user:\(st)");
               callback(st)
            }
        }
    }
    func deleteCoupon(coupon:Coupon,callback:@escaping (()->Void)){
        let db = Firestore.firestore();
        coupon.couponIsDeleted = true;
        var json = [String:Any]();
        json["couponIsDeleted"] = true;
        db.collection("coupons").document(coupon.couponCode!)
          .setData(json, merge: true){
                                err in
                                if let err = err {
                                    print("Error adding document: \(err)")
                                } else {
                                    print("Document deleted Succesfully")
                                }
                                callback()
            }
    }
    func uploadCouponImage(fileURL : URL,pathString : String,
                           callback:@escaping ((String)->Void)){
        let storage = FirebaseStorage.Storage.storage()
        var UrlString:String="";
        let data = Data();
        
        let storageRef = storage.reference();
        
        
        let localFile = fileURL;
        let photoRef  = storageRef.child(pathString);
//        let photoRef  = storageRef.child(pathString);
//        photoRef.downloadURL{ (URL, error) -> Void in
//            if (error != nil) {
//              // Handle any errors
//            } else {
//              // Get the download URL for 'images/stars.jpg'
//
//                UrlString = URL?.absoluteString ?? ""
//                print("url of the image : \(UrlString)")
//                callback(UrlString);
//             // you will get the String of Url
//            }
//          }
        let uploadTask = photoRef.putFile(from: localFile, metadata: nil) {
            (metadata,err) in
        guard let metadata = metadata else{
            print(err?.localizedDescription)
            callback(err?.localizedDescription ?? "")
            return
        }
            photoRef.downloadURL{ (URL, error) -> Void in
                if (error != nil) {
                    callback(error?.localizedDescription ?? "")
                  // Handle any errors
                } else {
                  // Get the download URL for 'images/stars.jpg'

                    UrlString = URL?.absoluteString ?? ""
                    print("url of the image : \(UrlString)")
                    callback(UrlString);
                 // you will get the String of Url
                }
              }
            print("Photo Uploaded")
        }
        
    }
    func signUp(email:String,password:String,firstname: String,lastName: String,
                phoneNumber:String,shopName:String,shopImageUrl:String,
                callback:@escaping ((String)->Void)){
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            guard let user2 = authResult?.user, error == nil else{
                print("Error\(error?.localizedDescription)")
                callback(error?.localizedDescription ?? "")
                return
            }
            var user:User = User();
            user.email = email;
            user.firstName = firstname;
            user.lastName = lastName;
            user.phoneNumber = phoneNumber;
            user.shopName = shopName;
            user.shopImageURL = shopImageUrl;
            self.addUserDetails(user: user, callback: callback)
        }
    }
    func addUserDetails(user:User,callback:@escaping ((String)->Void)){
        let db = Firestore.firestore();
        db.collection("users").document(user.email)
            .setData(user.toJson())
            { err in
            if let err = err {
                print("Error adding document: \(err)")
                callback(err.localizedDescription)
                return
            } else {
                print("Document added Succesfully")
                
            }
                callback("");
        }
    }
    func changeShopImageInAllCoupons(email:String,shopImageUrl:String,callback:@escaping (()->Void)){
        let db = Firestore.firestore();
            db.collection("coupons").getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    var coupons = [Coupon]();
                    for document in querySnapshot!.documents {
                        if let st = Coupon.create(json: document.data()){
                            if(st.shopId == email){
                                coupons.append(st);
                            }
                        }
                        print("\(document.documentID) => \(document.data())")
                    }
                    for coupon in coupons{
                        db.collection("coupons").document(coupon.couponCode!)
                                                .updateData(["shopImage": shopImageUrl])
                        { err in
                            if let err = err {
                                print("Error updating document: \(err)")
                            } else {
                                print("Document successfully updated")
                            }
                        }
                    }
                    callback()
                    return;
                }
        }
    }
    func signIn(email:String,password:String,callback:@escaping ((String)->Void)){
        Auth.auth().signIn(withEmail: email, password: password) { [weak self]authResult, err in
            guard let strongSelf = self else{return;}
            if let err = err{
                print(err.localizedDescription);
                callback(err.localizedDescription)
            }
            callback("")
        }
    }
    func checkUserInfo()->Bool{
        if Auth.auth().currentUser != nil{
            print(Auth.auth().currentUser?.uid)
            return true;
        }
        return false;
    }
    func logout(){
            do { try Auth.auth().signOut() }
            catch { print("already logged out") }
    }
    func getCurrentUser(callback:@escaping ((User)->Void)){
        if(checkUserInfo() == false){
            return;
        }
        var userEmail:String = Auth.auth().currentUser!.email!;
        print("email:\(userEmail)");
        let db = Firestore.firestore();
        db.collection("users").document(userEmail).addSnapshotListener { document, err in
            if let st = User.create(json: document!.data()!){
                print("user:\(st)");
               callback(st)
            }
        }
    }
    func resetUserPassword(email:String,password:String,newPassword:String,callback:@escaping ((String)->Void)){
        let user = Auth.auth().currentUser
        var credential: AuthCredential = EmailAuthProvider.credential(withEmail: email, password: password)

        // Prompt the user to re-provide their sign-in credentials

        user?.reauthenticate(with: credential, completion: { AuthData, error in
            if let error = error {
                print(error.localizedDescription);
                callback(error.localizedDescription)
            } else {
                Auth.auth().currentUser?.updatePassword(to: newPassword) { err in
                    if let err = err{
                        print(err.localizedDescription);
                        callback(err.localizedDescription)
                        return
                    }
                    callback("");
                }
            }
        })
         
        
        
    }
}
