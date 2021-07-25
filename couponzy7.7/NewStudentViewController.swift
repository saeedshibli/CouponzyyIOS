//
//  NewStudentViewController.swift
//  couponzy7.7
//
//  Created by מאיס on 10/07/2021.
//

import UIKit
import Foundation
import Photos

class NewStudentViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    @IBOutlet weak var CouponCodeViewer: UILabel!
    @IBOutlet weak var couponImage: UIImageView!
    @IBOutlet weak var titleText: UITextField!
    @IBOutlet weak var descriptionText: UITextField!
    @IBOutlet weak var orignalPriceText: UITextField!
    @IBOutlet weak var finalPriceText: UITextField!
    @IBOutlet weak var expireDatePicker: UITextField!
    
    let datePicker = UIDatePicker()
    var imagePickerController = UIImagePickerController();
    var imageUrlFireBaseStorge : String = "";
    var couponCodeGenerator : String = String(Int.random(in: 90000..<100000));
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePickerController.delegate = self;
        checkPermistions();
        createDatePicker()
        CouponCodeViewer.text = couponCodeGenerator;
        // Do any additional setup after loading the view.
    }
    
    @IBAction func save(_ sender: Any) {
        if(CheckIfEmptyFeilds()==false){
            return;
        }
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext;
        let coupon = Coupon(context: context);
        //let number = Int.random(in: 90000..<100000)
        coupon.couponCode=couponCodeGenerator;
        coupon.couponDescription = descriptionText.text!;
        coupon.discountPrice=Double(finalPriceText.text!)!;
        coupon.orginalPrice=Double(orignalPriceText.text!)!;
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "MMM dd,yyyy"
        dateFormatterPrint.string(from: Date())
        coupon.expireDate = expireDatePicker.text!//expireDate;
        coupon.couponImage = imageUrlFireBaseStorge//couponImage;
        coupon.title=titleText.text;
        Indicator.sharedInstance.showIndicator()
        Model.instance.getCurrentUser { user in
            coupon.shopId = user.email//shopId;
            coupon.shopImage=user.shopImageURL//ShopName;
            //let coupon = Coupon.create(xx);
            Model.instance.addCoupon(coupon: coupon) {
                Indicator.sharedInstance.hideIndicator()
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    func showAlert(text:String) {
       let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.light)
       let blurEffectView = UIVisualEffectView(effect: blurEffect)
         blurEffectView.frame = view.bounds
         blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
         self.view.addSubview(blurEffectView)
       let previewController = UIAlertController(title: "Alert", message: text, preferredStyle: .alert)


           let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: { (UIAlertAction) in
               blurEffectView.removeFromSuperview()
           })

           previewController.addAction(cancelAction)

           present(previewController, animated: true, completion: nil)
     }
    func CheckIfEmptyFeilds()->Bool{
        if(titleText.text!.isEmpty){
            showAlert(text: "Please Include Title TEXT")
            return false
        }
        else if((descriptionText.text!.isEmpty)){
            showAlert(text: "Please Include Description TEXT")
            return false
        }
        else if((finalPriceText.text!.isEmpty) && (orignalPriceText.text!.isEmpty)){
            showAlert(text: "FinalPrice / OriginalPrice Are Empty")
            return false
        }
        else if(orignalPriceText.text!.isNumeric != true ||
                finalPriceText.text!.isNumeric != true){
            showAlert(text: "FinalPrice/OriginalPrice must be only numbers")
            return false
        }
        else if(Double(orignalPriceText.text!)! <= Double(finalPriceText.text!)!){
            showAlert(text: "FinalPrice should be Lower than OriginalPrice")
            return false
        }
        else if(imageUrlFireBaseStorge==""){
            showAlert(text: "Please select a picture for the coupon")
            return false
        }
        else if(!expireDatePicker.hasText){
            showAlert(text: "Please select a Expire Date for the Coupon")
            return false
        }
//        else if((titleText.text?.isEmpty) != nil){
//            showAlert(text: "Please Include Title TEXT")
//            return false
//        }
//        else if((couponImage.text?.isEmpty) != nil){
//            return false
//        }
//        else if((datePicker.text?.isEmpty) != nil){
//            return false
//        }
        return true;
    }
    
    

    @IBAction func uploadImageButton(_ sender: Any) {
        self.imagePickerController.sourceType = .photoLibrary
        self.present(self.imagePickerController, animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        //Displaying the image and uploading it to FireBase]
        //imageUrlFireBaseStorge="x";
        if let url = info[UIImagePickerController.InfoKey.imageURL] as? URL{
            print(url)
            //couponImage.image = load(fileName: url);
            Indicator.sharedInstance.showIndicator()
            Model.instance.uploadCouponImage(fileURL: url, pathString: "ImageOf\(self.couponCodeGenerator)"){ urlImage in
                print("urlImage is Ready")
                self.imageUrlFireBaseStorge = urlImage;
                self.couponImage.image = self.load(fileName: url);
                Indicator.sharedInstance.hideIndicator()
            };
            
        }
        imagePickerController.dismiss(animated: true, completion: nil)
    }
    
    private func load(fileName: URL) -> UIImage? {
        let fileURL = fileName;
        do {
            let imageData = try Data(contentsOf: fileURL)
            return UIImage(data: imageData)
        } catch {
            print("Error loading image : \(error)")
        }
        return nil
    }
    
    func checkPermistions(){
        if(PHPhotoLibrary.authorizationStatus() != PHAuthorizationStatus.authorized){
            PHPhotoLibrary.requestAuthorization({(status: PHAuthorizationStatus)-> Void in
                ()
            })
        }
        if(PHPhotoLibrary.authorizationStatus() == PHAuthorizationStatus.authorized){
            
        }else{
            PHPhotoLibrary.requestAuthorization(requestAuthorizationHandler)
        }
    }
    func requestAuthorizationHandler(status: PHAuthorizationStatus){
        if(PHPhotoLibrary.authorizationStatus() == PHAuthorizationStatus.authorized){
            print("we have access to photos")
        }
        else{
            print("we don't have access to photos");
        }
    }
    //Date Picker for valid till Coupon
    
    func createDatePicker(){
        
        datePicker.frame.size = CGSize(width: 0, height: 250)
        datePicker.minimumDate = Date()
        expireDatePicker.textAlignment = .center;
        //toolbar
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        //bar button
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed));
        toolbar.setItems([doneBtn], animated: true)
        
        //assign toolbar
        expireDatePicker.inputAccessoryView = toolbar
        
        //assign date picker to the text field
        expireDatePicker.inputView = datePicker;
    }
    @objc func donePressed(){
        //formatter
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        
        expireDatePicker.text = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
}
extension String {
   var isNumeric: Bool {
     //return !(self.isEmpty) && self.allSatisfy { $0.isNumber }
    return Int(self) != nil || Double(self) != nil
   }
}
